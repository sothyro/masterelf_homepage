import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../config/app_content.dart';
import 'error_logging_service.dart';
import 'error_service.dart';

/// Shared hero video controller, pre-warmed during bootstrap so the homepage
/// hero attaches an already-initialized video instead of cold-starting after
/// reveal. The controller survives visibility and lifecycle changes (pause/resume
/// only), which prevents the video from restarting when the user scrolls or
/// switches tabs.
class HeroVideoController {
  HeroVideoController._();

  static VideoPlayerController? _controller;
  static Future<bool>? _prewarmFuture;
  static bool _initialized = false;

  /// When set, [prewarm] returns this future instead of touching the platform
  /// (widget / unit tests have no video_player implementation).
  @visibleForTesting
  static Future<bool>? prewarmOverrideForTesting;

  /// The shared controller once [initialize] has completed, even if [play] is
  /// still pending (e.g. browser autoplay deferred until after the loader).
  static VideoPlayerController? get controller =>
      (_controller != null && _initialized) ? _controller : null;

  static bool get isReady => controller != null;

  /// Initializes and starts the hero video (muted, looping). Idempotent:
  /// concurrent and repeat calls share the same future, so only one
  /// controller is ever created.
  static Future<bool> prewarm() {
    if (prewarmOverrideForTesting != null) return prewarmOverrideForTesting!;
    return _prewarmFuture ??= _prewarmInternal();
  }

  /// Clears a failed prewarm attempt so [prewarm] can be retried (e.g. after
  /// the loading overlay dismisses and autoplay restrictions may be lifted).
  static void resetPrewarmAttempt() {
    if (_initialized) return;
    _prewarmFuture = null;
  }

  static Duration get _initTimeout {
    if (kDebugMode) return const Duration(seconds: 3);
    return const Duration(seconds: 12);
  }

  static Future<bool> _prewarmInternal() async {
    VideoPlayerController? c;
    try {
      c = VideoPlayerController.asset(
        AppContent.assetHeroVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await c.initialize().timeout(_initTimeout);
      _controller = c;
      _initialized = true;

      await c.setLooping(true);
      await c.setVolume(0);
      try {
        await c.play();
      } catch (e) {
        // Init succeeded but autoplay was blocked (common under a loading
        // overlay). Keep the controller; [resume] will retry after reveal.
        ErrorLoggingService.logError(
          AppError(
            category: ErrorCategory.unknown,
            userMessage: 'Hero video autoplay deferred.',
            technicalMessage: e.toString(),
            originalError: e,
          ),
          additionalData: {
            'asset': AppContent.assetHeroVideo,
            'stage': 'hero_video_autoplay',
          },
        );
      }
      return true;
    } catch (e) {
      _initialized = false;
      _controller = null;
      _prewarmFuture = null;
      ErrorLoggingService.logError(
        AppError(
          category: ErrorCategory.unknown,
          userMessage: 'Hero video failed to load.',
          technicalMessage: e.toString(),
          originalError: e,
        ),
        additionalData: {
          'asset': AppContent.assetHeroVideo,
          'stage': 'hero_video_prewarm',
        },
      );
      await c?.dispose();
      return false;
    }
  }

  /// Pauses playback without disposing, so resuming continues from the same
  /// position instead of restarting.
  static Future<void> pause() async {
    final c = controller;
    if (c != null && c.value.isPlaying) await c.pause();
  }

  static Future<void> resume() async {
    final c = controller;
    if (c == null) return;
    if (!c.value.isPlaying) {
      try {
        await c.play();
      } catch (_) {}
    }
  }

  /// Full teardown; only for app shutdown or tests.
  static Future<void> dispose() async {
    final c = _controller;
    _controller = null;
    _initialized = false;
    _prewarmFuture = null;
    await c?.dispose();
  }

  @visibleForTesting
  static void resetForTesting() {
    _controller?.dispose();
    _controller = null;
    _initialized = false;
    _prewarmFuture = null;
    prewarmOverrideForTesting = null;
  }
}
