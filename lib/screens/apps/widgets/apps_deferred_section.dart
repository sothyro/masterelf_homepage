import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_asset_preloader.dart';
import '../../../widgets/viewport_deferred_section.dart';

/// Defers mounting [child] until the section nears the viewport.
///
/// When [eager] is true (e.g. deep-link target), [child] mounts immediately.
/// Once mounted, the child stays in the tree even if scrolled away.
class AppsDeferredSection extends StatelessWidget {
  const AppsDeferredSection({
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
      sectionKey: 'apps-$sectionKey',
      placeholderHeight: placeholderHeight,
      eager: eager,
      visibilityThreshold: visibilityThreshold,
      onNearViewport: () => unawaited(AppAssetPreloader.preloadAppsDeferredAssets()),
      child: child,
    );
  }
}
