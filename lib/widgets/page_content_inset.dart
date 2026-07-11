import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

/// Vertical stack height of logo + nav bar in [AppHeader].
const double kAppHeaderStackHeight = 240;

/// Top padding applied to the header overlay inside [AppShell].
const double kAppShellHeaderTopPadding = 12;

/// Content top inset below the safe area on desktop (nav bar band).
const double kPageHeaderOverlayHeightDesktop = 120;

/// Content top inset below the safe area on mobile (shell padding + header stack).
const double kPageHeaderOverlayHeightMobile =
    kAppShellHeaderTopPadding + kAppHeaderStackHeight;

/// @deprecated Use [pageHeaderTopPadding] instead. Kept for tests referencing the old constant.
const double kPageHeaderOverlayHeight = kPageHeaderOverlayHeightDesktop;

/// Total top padding so page content clears the fixed header overlay.
double pageHeaderTopPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final safeTop = MediaQuery.paddingOf(context).top;
  if (Breakpoints.isMobile(width)) {
    return safeTop + kPageHeaderOverlayHeightMobile;
  }
  return safeTop + kPageHeaderOverlayHeightDesktop;
}

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
  return EdgeInsets.only(
    top: pageHeaderTopPadding(context) + vertical,
    bottom: bottom + vertical,
    left: includeHorizontal ? pageContentHorizontalPadding(width) : 0,
    right: includeHorizontal ? pageContentHorizontalPadding(width) : 0,
  );
}
