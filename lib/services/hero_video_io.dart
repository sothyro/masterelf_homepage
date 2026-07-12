import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'hero_video_controller.dart';

/// Native (Android, iOS, desktop app) hero video via [video_player].
class HeroVideoPlatform {
  HeroVideoPlatform._();

  static final List<VoidCallback> _listeners = <VoidCallback>[];

  static VideoPlayerController? get controller => HeroVideoController.controller;

  static bool get isReady => HeroVideoController.isReady;

  static bool get failed => _failed;
  static bool _failed = false;

  @visibleForTesting
  static Future<bool>? prewarmOverrideForTesting;

  static Future<bool> prewarm({double? layoutWidth}) {
    if (prewarmOverrideForTesting != null) return prewarmOverrideForTesting!;
    return HeroVideoController.prewarm().then((ok) {
      _failed = !ok;
      if (ok) _notifyListeners();
      return ok;
    });
  }

  static void addReadyListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) _listeners.add(listener);
  }

  static void removeReadyListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in List<VoidCallback>.of(_listeners)) {
      listener();
    }
  }

  static Future<void> pause() => HeroVideoController.pause();

  static Future<void> resume() => HeroVideoController.resume();

  /// Full-bleed background video layer for native platforms.
  static Widget? buildVideoLayer() {
    final c = controller;
    if (c == null) return null;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: c.value.size.width > 0 ? c.value.size.width : 16,
        height: c.value.size.height > 0 ? c.value.size.height : 9,
        child: VideoPlayer(c),
      ),
    );
  }

  @visibleForTesting
  static void resetForTesting() {
    _failed = false;
    _listeners.clear();
    prewarmOverrideForTesting = null;
    unawaited(HeroVideoController.dispose());
  }
}
