import 'package:flutter/material.dart';

/// Wrapper that holds a [GlobalKey] for scroll-to-section.
class SectionAnchor extends StatelessWidget {
  const SectionAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
