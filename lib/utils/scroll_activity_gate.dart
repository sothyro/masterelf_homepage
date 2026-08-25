import 'dart:async';

import 'package:flutter/foundation.dart';

/// Tracks whether the user is actively scrolling and notifies when scroll settles.
class ScrollActivityGate {
  ScrollActivityGate._();

  static const Duration idleDelay = Duration(milliseconds: 400);

  /// Scroll offset past which the hero area is considered left (matches [AppShell]).
  static const double homeHeroScrollThreshold = 400;

  static bool _isUserScrolling = false;
  static bool _hasUserScrolled = false;
  static double _lastOffset = 0;
  static Timer? _idleTimer;
  static int _generation = 0;
  static final List<VoidCallback> _idleListeners = <VoidCallback>[];
  static final List<VoidCallback> _activityListeners = <VoidCallback>[];
  static final List<VoidCallback> _firstScrollListeners = <VoidCallback>[];

  /// True while scroll offset is changing or the idle timer has not yet fired.
  static bool get isUserScrolling => _isUserScrolling;

  /// Sticky true after the first non-zero scroll delta (homepage motion gate).
  static bool get hasUserScrolled => _hasUserScrolled;

  /// Latest scroll offset reported by the shell.
  static double get lastScrollOffset => _lastOffset;

  /// True once the user has scrolled past the hero band.
  static bool get isPastHomeHero => _lastOffset >= homeHeroScrollThreshold;

  /// Ink-wash / lattice backdrop for homepage Events after hero + scroll idle.
  static bool get showHomeEventsInkWash =>
      hasUserScrolled && !isUserScrolling && isPastHomeHero;

  /// Fires when scrolling starts or when scroll becomes idle.
  static void addActivityListener(VoidCallback listener) {
    if (!_activityListeners.contains(listener)) {
      _activityListeners.add(listener);
    }
  }

  static void removeActivityListener(VoidCallback listener) {
    _activityListeners.remove(listener);
  }

  /// Fires once when [hasUserScrolled] becomes true. If already scrolled,
  /// [listener] is invoked synchronously.
  static void addFirstScrollListener(VoidCallback listener) {
    if (_hasUserScrolled) {
      listener();
      return;
    }
    if (!_firstScrollListeners.contains(listener)) {
      _firstScrollListeners.add(listener);
    }
  }

  static void removeFirstScrollListener(VoidCallback listener) {
    _firstScrollListeners.remove(listener);
  }

  /// Call from the shell scroll listener on every scroll tick.
  static void onScrollOffset(double offset) {
    if (offset != _lastOffset) {
      final wasIdle = !_isUserScrolling;
      if (!_hasUserScrolled) {
        _hasUserScrolled = true;
        _notifyFirstScroll();
      }
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

  static void _notifyFirstScroll() {
    final listeners = List<VoidCallback>.of(_firstScrollListeners);
    _firstScrollListeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }

  @visibleForTesting
  static void resetForTesting() {
    _generation++;
    _idleTimer?.cancel();
    _idleTimer = null;
    _isUserScrolling = false;
    _hasUserScrolled = false;
    _lastOffset = 0;
    _idleListeners.clear();
    _activityListeners.clear();
    _firstScrollListeners.clear();
  }
}
