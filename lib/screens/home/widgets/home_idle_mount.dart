import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_bootstrap.dart';
import '../../../utils/app_asset_preloader.dart';
import '../../../utils/scroll_activity_gate.dart';

/// Mounts [child] after the homepage critical gate completes and scroll is
/// idle (or a post-reveal timeout elapses without active scrolling).
class HomeIdleMount extends StatefulWidget {
  const HomeIdleMount({
    super.key,
    required this.child,
    this.minDelayAfterReady = const Duration(milliseconds: 800),
    this.maxWaitAfterReady = const Duration(milliseconds: 1500),
  });

  final Widget child;

  /// Minimum wait after [HomeReadiness.ready] before the first mount attempt.
  final Duration minDelayAfterReady;

  /// Maximum time to wait after [HomeReadiness.ready] before mounting, if the
  /// user is not actively scrolling.
  final Duration maxWaitAfterReady;

  @override
  State<HomeIdleMount> createState() => _HomeIdleMountState();
}

class _HomeIdleMountState extends State<HomeIdleMount> {
  bool _childMounted = false;
  int _generation = 0;
  Timer? _minDelayTimer;
  Timer? _maxWaitTimer;

  @override
  void initState() {
    super.initState();
    ScrollActivityGate.addIdleListener(_onScrollActivity);
    ScrollActivityGate.addActivityListener(_onScrollActivity);
    unawaited(_scheduleMount());
  }

  Future<void> _scheduleMount() async {
    final generation = ++_generation;
    if (!HomeReadiness.isReady) {
      await HomeReadiness.ready;
    }
    if (!mounted || generation != _generation || _childMounted) return;

    _minDelayTimer?.cancel();
    _minDelayTimer = Timer(widget.minDelayAfterReady, () {
      if (!mounted || generation != _generation || _childMounted) return;

      final remaining = widget.maxWaitAfterReady - widget.minDelayAfterReady;
      _maxWaitTimer?.cancel();
      if (remaining > Duration.zero) {
        _maxWaitTimer = Timer(remaining, _tryMount);
      }
      _tryMount();
    });
  }

  void _onScrollActivity() => _tryMount();

  void _tryMount() {
    if (!mounted || _childMounted) return;
    if (ScrollActivityGate.isUserScrolling) return;

    _childMounted = true;
    _maxWaitTimer?.cancel();
    _maxWaitTimer = null;
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(AppAssetPreloader.preloadMidPageHomeAssets());
      });
    });
  }

  @override
  void dispose() {
    _generation++;
    _minDelayTimer?.cancel();
    _maxWaitTimer?.cancel();
    ScrollActivityGate.removeIdleListener(_onScrollActivity);
    ScrollActivityGate.removeActivityListener(_onScrollActivity);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_childMounted) return const SizedBox.shrink();
    return widget.child;
  }
}
