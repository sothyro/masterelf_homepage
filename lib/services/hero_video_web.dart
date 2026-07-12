import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../config/app_content.dart';
import '../utils/breakpoints.dart';
import 'error_logging_service.dart';
import 'error_service.dart';

/// Web hero video via a native [web.HTMLVideoElement] (no video_player indirection).
class HeroVideoPlatform {
  HeroVideoPlatform._();

  static const String _viewType = 'hero-background-video';

  static web.HTMLVideoElement? _element;
  static bool _viewFactoryRegistered = false;
  static bool _ready = false;
  static bool _failed = false;
  static Future<bool>? _prewarmFuture;
  static final List<VoidCallback> _listeners = <VoidCallback>[];

  static bool get isReady => _ready;

  static bool get failed => _failed;

  static String videoPathForWidth(double width) =>
      Breakpoints.isMobile(width)
          ? AppContent.webHeroVideo480
          : AppContent.webHeroVideo720;

  static String videoUrlForWidth(double width) =>
      Uri.base.resolve(videoPathForWidth(width)).toString();

  static double _defaultViewportWidth() {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return Breakpoints.mobile + 1;
    return view.physicalSize.width / view.devicePixelRatio;
  }

  static Future<bool> prewarm({double? layoutWidth}) {
    return _prewarmFuture ??= _prewarmInternal(layoutWidth ?? _defaultViewportWidth());
  }

  static Future<bool> _prewarmInternal(double layoutWidth) async {
    if (_ready) return true;
    if (_failed) return false;

    try {
      final src = videoUrlForWidth(layoutWidth);
      final element = web.HTMLVideoElement()
        ..id = _viewType
        ..muted = true
        ..loop = true
        ..autoplay = false
        ..playsInline = true
        ..preload = 'auto';
      element.setAttribute('playsinline', '');
      element.style.border = 'none';
      element.style.width = '100%';
      element.style.height = '100%';
      element.style.setProperty('object-fit', 'cover');

      _element = element;

      if (!_viewFactoryRegistered) {
        ui_web.platformViewRegistry.registerViewFactory(
          _viewType,
          (int viewId) => _element!,
        );
        _viewFactoryRegistered = true;
      }

      final completer = Completer<bool>();

      void onReady() {
        if (_ready || completer.isCompleted) return;
        _ready = true;
        _notifyListeners();
        if (!completer.isCompleted) completer.complete(true);
        unawaited(_tryPlay());
      }

      void onError(Object? _) {
        if (completer.isCompleted) return;
        _failed = true;
        _prewarmFuture = null;
        final mediaError = element.error;
        ErrorLoggingService.logError(
          AppError(
            category: ErrorCategory.unknown,
            userMessage: 'Hero video failed to load.',
            technicalMessage: mediaError?.message ?? 'HTMLMediaElement error',
          ),
          additionalData: {
            'src': src,
            'stage': 'hero_video_web',
            'code': mediaError?.code.toString(),
          },
        );
        completer.complete(false);
      }

      element.onCanPlayThrough.listen((_) => onReady());
      element.onError.listen(onError);

      element.src = src;
      element.load();

      return completer.future.timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          onError('timeout');
          return false;
        },
      );
    } catch (e) {
      _failed = true;
      _prewarmFuture = null;
      ErrorLoggingService.logError(
        AppError(
          category: ErrorCategory.unknown,
          userMessage: 'Hero video failed to load.',
          technicalMessage: e.toString(),
          originalError: e,
        ),
        additionalData: {'stage': 'hero_video_web_prewarm'},
      );
      return false;
    }
  }

  static Future<void> _tryPlay() async {
    final element = _element;
    if (element == null || _failed) return;
    try {
      await element.play().toDart;
    } catch (e) {
      ErrorLoggingService.logError(
        AppError(
          category: ErrorCategory.unknown,
          userMessage: 'Hero video autoplay deferred.',
          technicalMessage: e.toString(),
          originalError: e,
        ),
        additionalData: {'stage': 'hero_video_web_autoplay'},
      );
    }
  }

  static void addReadyListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) _listeners.add(listener);
    if (_ready) listener();
  }

  static void removeReadyListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in List<VoidCallback>.of(_listeners)) {
      listener();
    }
  }

  static Future<void> pause() async {
    _element?.pause();
  }

  static Future<void> resume() async {
    await _tryPlay();
  }

  static Widget? buildVideoLayer() {
    if (!_ready || _element == null) return null;
    return const SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }

  static void resetForTesting() {
    _element?.pause();
    _element?.removeAttribute('src');
    _element?.load();
    _element = null;
    _ready = false;
    _failed = false;
    _prewarmFuture = null;
    _viewFactoryRegistered = false;
    _listeners.clear();
  }
}
