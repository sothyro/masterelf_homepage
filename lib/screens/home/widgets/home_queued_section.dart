import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../theme/app_theme.dart';
import '../home_section_mount_queue.dart';

/// Homepage section that mounts via [HomeSectionMountQueue].
///
/// Reserves [placeholderHeight] until the idle queue (or a near-viewport boost)
/// mounts [child]. Once mounted, the child stays in the tree.
class HomeQueuedSection extends StatefulWidget {
  const HomeQueuedSection({
    super.key,
    required this.sectionKey,
    required this.placeholderHeight,
    required this.child,
    this.visibilityThreshold = 0.06,
    this.onMounted,
  });

  final String sectionKey;
  final double placeholderHeight;
  final Widget child;
  final double visibilityThreshold;
  final VoidCallback? onMounted;

  @override
  State<HomeQueuedSection> createState() => _HomeQueuedSectionState();
}

class _HomeQueuedSectionState extends State<HomeQueuedSection> {
  final HomeSectionMountQueue _queue = HomeSectionMountQueue.instance;
  bool _childMounted = false;
  bool _firedOnMounted = false;

  @override
  void initState() {
    super.initState();
    _queue.register(widget.sectionKey);
    _queue.addListener(_onQueueChanged);
    _childMounted = _queue.isSectionMounted(widget.sectionKey);
    if (_childMounted) {
      _fireOnMounted();
    }
  }

  @override
  void dispose() {
    _queue.removeListener(_onQueueChanged);
    _queue.unregister(widget.sectionKey);
    VisibilityDetectorController.instance.forget(
      ValueKey<String>('home-queued-${widget.sectionKey}'),
    );
    super.dispose();
  }

  void _onQueueChanged() {
    if (!mounted || _childMounted) return;
    if (_queue.isSectionMounted(widget.sectionKey)) {
      setState(() => _childMounted = true);
      _fireOnMounted();
    }
  }

  void _fireOnMounted() {
    if (_firedOnMounted) return;
    _firedOnMounted = true;
    widget.onMounted?.call();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _childMounted) return;
    if (info.visibleFraction >= widget.visibilityThreshold) {
      _queue.requestBoost(widget.sectionKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_childMounted) return widget.child;

    final bg = Theme.of(context).scaffoldBackgroundColor;
    return VisibilityDetector(
      key: ValueKey<String>('home-queued-${widget.sectionKey}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: ColoredBox(
        color: bg == Colors.transparent ? AppColors.backgroundDark : bg,
        child: SizedBox(
          width: double.infinity,
          height: widget.placeholderHeight,
        ),
      ),
    );
  }
}
