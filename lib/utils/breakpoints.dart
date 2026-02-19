/// Layout breakpoints (Joey Yap–style responsive plan).
class Breakpoints {
  Breakpoints._();

  /// Small: very narrow viewports (e.g. hero/min heights).
  static const double small = 600;

  /// Mobile: single column, drawer nav (< 768).
  static const double mobile = 768;

  /// Narrow: single-column forms / stacked content (e.g. < 800).
  static const double narrow = 800;

  /// Tablet: condensed or drawer (768–1024).
  static const double tablet = 1024;

  /// Desktop: full nav, multi-column (> 1024).

  static bool isSmall(double width) => width < small;
  static bool isMobile(double width) => width < mobile;
  static bool isNarrow(double width) => width < narrow;
  static bool isTabletOrLarger(double width) => width >= mobile;
  static bool isDesktop(double width) => width >= tablet;
}

/// Minimum touch target size for mobile (WCAG / accessibility).
const double kMinTouchTargetSize = 44.0;
