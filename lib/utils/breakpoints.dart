/// Layout breakpoints for responsive design.
///
/// Three layout tiers:
/// - **Mobile** (< 768): single column, drawer nav, stacked actions
/// - **Tablet** (768–1023): condensed layouts, 1–2 columns for cards
/// - **Desktop** (>= 1024): full nav, multi-column grids
class Breakpoints {
  Breakpoints._();

  /// Small: very narrow viewports (e.g. hero/min heights, stacked CTAs).
  static const double small = 600;

  /// Mobile: single column, drawer nav (< 768).
  static const double mobile = 768;

  /// Narrow: single-column forms / stacked content (e.g. < 800).
  static const double narrow = 800;

  /// Compact: field-work hub and similar mid-width stacked layouts (< 960).
  static const double compact = 960;

  /// Tablet / desktop boundary (>= 1024).
  static const double tablet = 1024;

  static bool isSmall(double width) => width < small;
  static bool isMobile(double width) => width < mobile;
  static bool isNarrow(double width) => width < narrow;
  static bool isCompact(double width) => width < compact;
  static bool isTabletOnly(double width) => width >= mobile && width < tablet;
  static bool isTabletOrLarger(double width) => width >= mobile;
  static bool isDesktop(double width) => width >= tablet;
}

/// Minimum touch target size for mobile (WCAG / accessibility).
const double kMinTouchTargetSize = 44.0;
