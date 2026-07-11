import 'package:flutter/material.dart';

/// Coordinates spotlight videos so only one autoplays at a time.
class ActivityVideoPlaybackHub {
  static const double autoplayThreshold = 0.55;
  static const double pauseThreshold = 0.35;

  final Map<String, double> _visibility = {};
  final Map<String, ActivityVideoPlaybackDelegate> _delegates = {};
  String? _activeId;

  void register(String id, ActivityVideoPlaybackDelegate delegate) {
    _delegates[id] = delegate;
  }

  void unregister(String id) {
    _delegates.remove(id);
    _visibility.remove(id);
    if (_activeId == id) {
      _activeId = null;
    }
  }

  void reportVisibility(String id, double visibleFraction) {
    _visibility[id] = visibleFraction;
    _syncActivePlayer();
  }

  void requestUserPlay(String id) {
    _pauseDelegate(_activeId);
    _activeId = id;
    _delegates[id]?.playMuted();
  }

  void _syncActivePlayer() {
    String? bestId;
    var bestFraction = 0.0;

    for (final entry in _visibility.entries) {
      if (entry.value >= autoplayThreshold && entry.value > bestFraction) {
        bestId = entry.key;
        bestFraction = entry.value;
      }
    }

    if (bestId == null) {
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
      _delegates[bestId]?.playMuted();
    }
  }

  void _pauseDelegate(String? id) {
    if (id == null) return;
    _delegates[id]?.pause();
  }
}

abstract class ActivityVideoPlaybackDelegate {
  Future<void> playMuted();
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
