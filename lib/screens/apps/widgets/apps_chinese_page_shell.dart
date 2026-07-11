import 'package:flutter/material.dart';

import '../../home/widgets/field_work_chinese_design.dart';

/// Ink-wash background wrapper for the Apps page body below the hero.
class AppsChinesePageShell extends StatelessWidget {
  const AppsChinesePageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        const Positioned.fill(child: ChineseInkWashGlow()),
        child,
      ],
    );
  }
}
