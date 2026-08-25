import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../utils/scroll_activity_gate.dart';

/// Defers mounting [child] until the section nears the viewport and scroll is idle.
///
/// When [eager] is true, [child] mounts immediately. Once mounted, the child
/// stays in the tree even if scrolled away.
class ViewportDeferredSection extends StatefulWidget {
  const ViewportDeferredSection({
    super.key,
    required this.sectionKey,
    required this.placeholderHeight,
    required this.child,
    this.eager = false,
    this.visibilityThreshold = 0.06,
    this.postIdleSettleDelay = const Duration(milliseconds: 250),
    this.onNearViewport,
  });

  final String sectionKey;
  final double placeholderHeight;
  final Widget child;
  final bool eager;
  final double visibilityThreshold;
  /// Extra settle time after scroll becomes idle before mounting, so an active
  /// flick is not followed by a layout/decode spike mid-gesture.
  final Duration postIdleSettleDelay;
  final VoidCallback? onNearViewport;

  @override
  State<ViewportDeferredSection> createState() => _ViewportDeferredSectionState();
}

class _ViewportDeferredSectionState extends State<ViewportDeferredSection> {
  bool _mounted = false;
  bool _nearViewport = false;
  Timer? _postIdleTimer;

  @override
  void initState() {
    super.initState();
    if (widget.eager) {
      _mounted = true;
      widget.onNearViewport?.call();
    } else {
      ScrollActivityGate.addIdleListener(_onScrollIdle);
      ScrollActivityGate.addActivityListener(_onScrollActivity);
    }
  }

  @override
  void didUpdateWidget(covariant ViewportDeferredSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eager && !_mounted) {
      _postIdleTimer?.cancel();
      setState(() => _mounted = true);
      widget.onNearViewport?.call();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _mounted) return;
    if (info.visibleFraction >= widget.visibilityThreshold) {
      _nearViewport = true;
      widget.onNearViewport?.call();
      _tryMount();
    }
  }

  void _onScrollActivity() {
    if (!_nearViewport || _mounted) return;
    if (ScrollActivityGate.isUserScrolling) {
      _postIdleTimer?.cancel();
      _postIdleTimer = null;
    }
  }

  void _onScrollIdle() {
    if (!_nearViewport || _mounted) return;
    _tryMount();
  }

  void _tryMount() {
    if (!mounted || _mounted || !_nearViewport) return;
    if (ScrollActivityGate.isUserScrolling) return;

    final settle = widget.postIdleSettleDelay;
    if (settle <= Duration.zero) {
      _mountChild();
      return;
    }

    // Keep an in-flight settle countdown; do not restart mid-wait.
    if (_postIdleTimer != null) return;

    _postIdleTimer = Timer(settle, () {
      if (!mounted || _mounted) return;
      if (ScrollActivityGate.isUserScrolling) return;
      _mountChild();
    });
  }

  void _mountChild() {
    if (!mounted || _mounted) return;
    _postIdleTimer?.cancel();
    _postIdleTimer = null;
    setState(() => _mounted = true);
  }

  @override
  void dispose() {
    _postIdleTimer?.cancel();
    ScrollActivityGate.removeIdleListener(_onScrollIdle);
    ScrollActivityGate.removeActivityListener(_onScrollActivity);
    VisibilityDetectorController.instance.forget(
      ValueKey<String>('viewport-deferred-${widget.sectionKey}'),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mounted) return widget.child;

    return VisibilityDetector(
      key: ValueKey<String>('viewport-deferred-${widget.sectionKey}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: SizedBox(
        width: double.infinity,
        height: widget.placeholderHeight,
      ),
    );
  }
}
