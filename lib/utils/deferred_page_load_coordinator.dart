import 'dart:async';

import 'package:flutter/material.dart';

/// Defers a one-shot callback until the user scrolls past a fraction of the page
/// or an idle timeout elapses after [arm].
class DeferredPageLoadCoordinator {
  DeferredPageLoadCoordinator({required VoidCallback onTrigger})
      : _onTrigger = onTrigger;

  static const double scrollFractionThreshold = 0.25;
  static const Duration idleFallback = Duration(seconds: 5);

  final VoidCallback _onTrigger;

  bool _armed = false;
  bool _triggered = false;
  Timer? _idleTimer;

  @visibleForTesting
  void resetForTesting() {
    _armed = false;
    _triggered = false;
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  /// Call once when the route is ready for deferred loading.
  void arm() {
    if (_armed) return;
    _armed = true;
    _idleTimer?.cancel();
    _idleTimer = Timer(idleFallback, _trigger);
  }

  /// Call from the shell scroll listener for this route.
  void onScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    if (!_armed || _triggered) return;
    if (maxScrollExtent <= 0) return;
    if (pixels / maxScrollExtent >= scrollFractionThreshold) {
      _trigger();
    }
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;
    _idleTimer?.cancel();
    _idleTimer = null;
    _onTrigger();
  }
}
