import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps a section and builds [child] only when it becomes visible in the viewport.
/// Uses a fixed-height [placeholderHeight] so scroll layout is correct before build.
/// Reduces initial work by deferring below-the-fold content.
class LazySection extends StatefulWidget {
  const LazySection({
    super.key,
    required this.child,
    required this.placeholderHeight,
    required this.detectorKey,
  });

  final Widget child;
  final double placeholderHeight;
  final Key detectorKey;

  @override
  State<LazySection> createState() => _LazySectionState();
}

class _LazySectionState extends State<LazySection> {
  bool _visible = false;

  static const double _visibilityThreshold = 0.05;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > _visibilityThreshold && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: _visible ? widget.child : SizedBox(height: widget.placeholderHeight),
    );
  }
}
