import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/scroll_activity_gate.dart';

/// Progressive idle hydration for below-fold homepage sections.
///
/// After [armAfterCriticalReady], mounts at most one registered section per
/// settle window while scroll is idle. Near-viewport [requestBoost] promotes
/// a section to mount next so fast scrollers do not stare at empty slots.
class HomeSectionMountQueue extends ChangeNotifier {
  HomeSectionMountQueue._();

  static final HomeSectionMountQueue instance = HomeSectionMountQueue._();

  /// Document order for homepage below-fold sections.
  static const List<String> orderedKeys = [
    'home-academies',
    'home-consultations',
    'home-field-work-story',
    'home-featured-band',
    'home-activity-stories',
    'home-testimonials',
    'home-cta',
  ];

  static const Duration firstAdvanceDelay = Duration(milliseconds: 150);
  static const Duration betweenSectionsDelay = Duration(milliseconds: 200);

  final Set<String> _mounted = <String>{};
  final Set<String> _registered = <String>{};
  String? _boostedKey;
  bool _armed = false;
  bool _listening = false;
  Timer? _settleTimer;
  VoidCallback? _onAdvance;

  /// Optional hook for tests / diagnostics after each mount.
  @visibleForTesting
  set onAdvanceForTesting(VoidCallback? cb) => _onAdvance = cb;

  bool get isArmed => _armed;

  bool isSectionMounted(String sectionKey) => _mounted.contains(sectionKey);

  /// Register a section slot so the queue knows it exists in the tree.
  void register(String sectionKey) {
    _registered.add(sectionKey);
  }

  void unregister(String sectionKey) {
    _registered.remove(sectionKey);
  }

  /// Start idle advancement after Hero + Events are ready.
  void armAfterCriticalReady() {
    if (_armed) return;
    _armed = true;
    _ensureScrollListeners();
    // Warm near-fold assets before the first section mounts.
    unawaited(AppAssetPreloader.preloadHomeNearFoldAssets());
    _scheduleAdvance(delay: firstAdvanceDelay);
  }

  /// Promote [sectionKey] to mount next (viewport approaching).
  void requestBoost(String sectionKey) {
    if (_mounted.contains(sectionKey)) return;
    if (!_registered.contains(sectionKey) &&
        !orderedKeys.contains(sectionKey)) {
      return;
    }
    _boostedKey = sectionKey;
    // Mount on the next idle settle slice — not mid-frame with visibility.
    if (!_armed) return;
    if (ScrollActivityGate.isUserScrolling) return;
    _scheduleAdvance(delay: betweenSectionsDelay);
  }

  @visibleForTesting
  static void resetForTesting() {
    instance._reset();
  }

  void _reset() {
    _settleTimer?.cancel();
    _settleTimer = null;
    _mounted.clear();
    _registered.clear();
    _boostedKey = null;
    _armed = false;
    _onAdvance = null;
    if (_listening) {
      ScrollActivityGate.removeIdleListener(_onScrollIdle);
      ScrollActivityGate.removeActivityListener(_onScrollActivity);
      _listening = false;
    }
    notifyListeners();
  }

  void _ensureScrollListeners() {
    if (_listening) return;
    _listening = true;
    ScrollActivityGate.addIdleListener(_onScrollIdle);
    ScrollActivityGate.addActivityListener(_onScrollActivity);
  }

  void _onScrollActivity() {
    if (ScrollActivityGate.isUserScrolling) {
      _settleTimer?.cancel();
      _settleTimer = null;
    }
  }

  void _onScrollIdle() {
    if (!_armed) return;
    _tryAdvance();
  }

  void _scheduleAdvance({required Duration delay}) {
    if (!_armed) return;
    _settleTimer?.cancel();
    if (delay <= Duration.zero) {
      _tryAdvance();
      return;
    }
    _settleTimer = Timer(delay, () {
      _settleTimer = null;
      _tryAdvance();
    });
  }

  void _tryAdvance() {
    if (!_armed) return;
    if (ScrollActivityGate.isUserScrolling) return;
    if (_settleTimer != null) return;

    final next = _nextKeyToMount();
    if (next == null) return;

    _warmForUpcoming(next);
    _mount(next);
    _warmAssetsAhead(next);

    if (_nextKeyToMount() != null) {
      _scheduleAdvance(delay: betweenSectionsDelay);
    }
  }

  String? _nextKeyToMount() {
    final boost = _boostedKey;
    if (boost != null && !_mounted.contains(boost)) {
      return boost;
    }
    for (final key in orderedKeys) {
      if (_mounted.contains(key)) continue;
      // Prefer registered keys; still allow ordered keys before register races.
      if (_registered.isNotEmpty && !_registered.contains(key)) continue;
      return key;
    }
    return null;
  }

  void _mount(String sectionKey) {
    if (_mounted.contains(sectionKey)) return;
    _mounted.add(sectionKey);
    if (_boostedKey == sectionKey) {
      _boostedKey = null;
    }
    notifyListeners();
    _onAdvance?.call();
  }

  /// Warm assets for the section about to mount / next in line.
  void _warmAssetsAhead(String justMounted) {
    // Just mounted Academies/Consultations → mid-page is next.
    // Just mounted mid-page → below-fold is next.
    switch (justMounted) {
      case 'home-academies':
      case 'home-consultations':
        unawaited(AppAssetPreloader.preloadMidPageHomeAssets());
        break;
      case 'home-field-work-story':
      case 'home-featured-band':
        unawaited(AppAssetPreloader.preloadBelowFoldHomepage());
        break;
      default:
        break;
    }
  }

  void _warmForUpcoming(String upcoming) {
    switch (upcoming) {
      case 'home-academies':
      case 'home-consultations':
        unawaited(AppAssetPreloader.preloadHomeNearFoldAssets());
        break;
      case 'home-field-work-story':
        unawaited(AppAssetPreloader.preloadMidPageHomeAssets());
        break;
      case 'home-featured-band':
      case 'home-activity-stories':
      case 'home-testimonials':
      case 'home-cta':
        unawaited(AppAssetPreloader.preloadBelowFoldHomepage());
        break;
      default:
        break;
    }
  }
}
