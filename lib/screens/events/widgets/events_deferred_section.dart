import 'package:flutter/material.dart';

import '../../../widgets/viewport_deferred_section.dart';

/// Defers mounting [child] until the section nears the viewport on `/events`.
class EventsDeferredSection extends StatelessWidget {
  const EventsDeferredSection({
    super.key,
    required this.sectionKey,
    required this.placeholderHeight,
    required this.child,
    this.eager = false,
    this.visibilityThreshold = 0.06,
  });

  final String sectionKey;
  final double placeholderHeight;
  final Widget child;
  final bool eager;
  final double visibilityThreshold;

  @override
  Widget build(BuildContext context) {
    return ViewportDeferredSection(
      sectionKey: 'events-$sectionKey',
      placeholderHeight: placeholderHeight,
      eager: eager,
      visibilityThreshold: visibilityThreshold,
      child: child,
    );
  }
}
