import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

/// Base top inset to clear the fixed [AppHeader] overlay (below logo/nav band).
const double kPageHeaderOverlayHeight = 148;

/// Horizontal page padding matching store/content containers.
double pageContentHorizontalPadding(double width) =>
    Breakpoints.isMobile(width) ? 16 : 24;

/// Content padding that clears the fixed header overlay.
EdgeInsets pageContentPadding(
  BuildContext context, {
  bool includeHorizontal = true,
  double vertical = 0,
  double bottom = 0,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final top = MediaQuery.paddingOf(context).top + kPageHeaderOverlayHeight;
  return EdgeInsets.only(
    top: top + vertical,
    bottom: bottom + vertical,
    left: includeHorizontal ? pageContentHorizontalPadding(width) : 0,
    right: includeHorizontal ? pageContentHorizontalPadding(width) : 0,
  );
}
