import 'dart:async';

import 'package:flutter/foundation.dart';

/// Tracks whether the user is actively scrolling and notifies when scroll settles.
class ScrollActivityGate {
  ScrollActivityGate._();

  static const Duration idleDelay = Duration(milliseconds: 400);

  static bool _isUserScrolling = false;
  static double _lastOffset = 0;
  static Timer? _idleTimer;
  static int _generation = 0;
  static final List<VoidCallback> _idleListeners = <VoidCallback>[];
  static final List<VoidCallback> _activityListeners = <VoidCallback>[];

  /// True while scroll offset is changing or the idle timer has not yet fired.
  static bool get isUserScrolling => _isUserScrolling;

  /// Fires when scrolling starts or when scroll becomes idle.
  static void addActivityListener(VoidCallback listener) {
    if (!_activityListeners.contains(listener)) {
      _activityListeners.add(listener);
    }
  }

  static void removeActivityListener(VoidCallback listener) {
    _activityListeners.remove(listener);
  }

  /// Call from the shell scroll listener on every scroll tick.
  static void onScrollOffset(double offset) {
    if (offset != _lastOffset) {
      final wasIdle = !_isUserScrolling;
      _lastOffset = offset;
      _isUserScrolling = true;
      if (wasIdle) _notifyActivity();
      _idleTimer?.cancel();
      final generation = ++_generation;
      _idleTimer = Timer(idleDelay, () {
        if (generation != _generation) return;
        _isUserScrolling = false;
        _notifyActivity();
        _notifyIdle();
      });
    }
  }

  /// Register a one-shot or recurring callback for scroll-idle events.
  static void addIdleListener(VoidCallback listener) {
    if (!_idleListeners.contains(listener)) {
      _idleListeners.add(listener);
    }
  }

  static void removeIdleListener(VoidCallback listener) {
    _idleListeners.remove(listener);
  }

  static void _notifyIdle() {
    for (final listener in List<VoidCallback>.of(_idleListeners)) {
      listener();
    }
  }

  static void _notifyActivity() {
    for (final listener in List<VoidCallback>.of(_activityListeners)) {
      listener();
    }
  }

  @visibleForTesting
  static void resetForTesting() {
    _generation++;
    _idleTimer?.cancel();
    _idleTimer = null;
    _isUserScrolling = false;
    _lastOffset = 0;
    _idleListeners.clear();
    _activityListeners.clear();
  }
}
