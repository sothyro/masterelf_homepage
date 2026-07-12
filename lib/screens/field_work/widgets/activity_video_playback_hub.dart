import 'dart:async';

import 'package:flutter/material.dart';

/// Coordinates spotlight videos so only one autoplays at a time.
class ActivityVideoPlaybackHub {
  static const double autoplayThreshold = 0.55;
  static const double pauseThreshold = 0.35;
  static const Duration playDebounce = Duration(milliseconds: 200);

  final Map<String, double> _visibility = {};
  final Map<String, ActivityVideoPlaybackDelegate> _delegates = {};
  final Map<String, Timer> _playDebouncers = {};
  String? _activeId;
  String? _initializingId;
  Future<void>? _initChain;

  void register(String id, ActivityVideoPlaybackDelegate delegate) {
    _delegates[id] = delegate;
  }

  void unregister(String id) {
    _delegates.remove(id);
    _visibility.remove(id);
    _playDebouncers.remove(id)?.cancel();
    if (_activeId == id) {
      _activeId = null;
    }
    if (_initializingId == id) {
      _initializingId = null;
    }
  }

  void reportVisibility(String id, double visibleFraction) {
    final previous = _visibility[id] ?? 0.0;
    _visibility[id] = visibleFraction;
    final reenteredAutoplay =
        previous < autoplayThreshold && visibleFraction >= autoplayThreshold;
    _syncActivePlayer(reenteredAutoplayId: reenteredAutoplay ? id : null);
  }

  void requestUserPlay(String id) {
    _playDebouncers.remove(id)?.cancel();
    _pauseDelegate(_activeId);
    _activeId = id;
    unawaited(_requestPlay(id, retryAfterFailure: true));
  }

  void _syncActivePlayer({String? reenteredAutoplayId}) {
    String? bestId;
    var bestFraction = 0.0;

    for (final entry in _visibility.entries) {
      if (entry.value >= autoplayThreshold && entry.value > bestFraction) {
        bestId = entry.key;
        bestFraction = entry.value;
      }
    }

    if (bestId == null) {
      for (final timer in _playDebouncers.values) {
        timer.cancel();
      }
      _playDebouncers.clear();
      if (_activeId != null) {
        final current = _visibility[_activeId] ?? 0;
        if (current < pauseThreshold) {
          _pauseDelegate(_activeId);
          _activeId = null;
        }
      }
      return;
    }

    if (bestId != _activeId) {
      _pauseDelegate(_activeId);
      _activeId = bestId;
      _schedulePlay(bestId, retryAfterFailure: reenteredAutoplayId == bestId);
      return;
    }

    if (reenteredAutoplayId == bestId) {
      _schedulePlay(bestId, retryAfterFailure: true);
    }
  }

  void _schedulePlay(String id, {required bool retryAfterFailure}) {
    _playDebouncers.remove(id)?.cancel();
    _playDebouncers[id] = Timer(playDebounce, () {
      _playDebouncers.remove(id);
      final fraction = _visibility[id] ?? 0;
      if (fraction < autoplayThreshold) return;
      unawaited(_requestPlay(id, retryAfterFailure: retryAfterFailure));
    });
  }

  Future<void> _requestPlay(String id, {required bool retryAfterFailure}) async {
    final delegate = _delegates[id];
    if (delegate == null) return;

    while (_initChain != null && _initializingId != id) {
      await _initChain;
    }
    if (_initializingId == id && _initChain != null) {
      return _initChain;
    }

    _initializingId = id;
    final future = delegate.playMuted(retryAfterFailure: retryAfterFailure);
    _initChain = future;
    try {
      await future;
    } finally {
      if (identical(_initChain, future)) {
        _initChain = null;
        if (_initializingId == id) {
          _initializingId = null;
        }
      }
    }
  }

  void _pauseDelegate(String? id) {
    if (id == null) return;
    _playDebouncers.remove(id)?.cancel();
    _delegates[id]?.pause();
  }
}

abstract class ActivityVideoPlaybackDelegate {
  Future<void> playMuted({bool retryAfterFailure = false});
  Future<void> pause();
}

class ActivityVideoPlaybackScope extends InheritedWidget {
  const ActivityVideoPlaybackScope({
    super.key,
    required this.hub,
    required super.child,
  });

  final ActivityVideoPlaybackHub hub;

  static ActivityVideoPlaybackHub? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivityVideoPlaybackScope>()
        ?.hub;
  }

  @override
  bool updateShouldNotify(ActivityVideoPlaybackScope oldWidget) => false;
}
