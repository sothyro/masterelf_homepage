import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Defers mounting [child] until the section nears the viewport.
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
    this.onNearViewport,
  });

  final String sectionKey;
  final double placeholderHeight;
  final Widget child;
  final bool eager;
  final double visibilityThreshold;
  final VoidCallback? onNearViewport;

  @override
  State<ViewportDeferredSection> createState() => _ViewportDeferredSectionState();
}

class _ViewportDeferredSectionState extends State<ViewportDeferredSection> {
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    if (widget.eager) {
      _mounted = true;
      widget.onNearViewport?.call();
    }
  }

  @override
  void didUpdateWidget(covariant ViewportDeferredSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eager && !_mounted) {
      setState(() => _mounted = true);
      widget.onNearViewport?.call();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _mounted) return;
    if (info.visibleFraction >= widget.visibilityThreshold) {
      setState(() => _mounted = true);
      widget.onNearViewport?.call();
    }
  }

  @override
  void dispose() {
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
