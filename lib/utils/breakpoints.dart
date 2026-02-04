/// Layout breakpoints (Joey Yap–style responsive plan).
class Breakpoints {
  Breakpoints._();

  /// Mobile: single column, drawer nav (< 768).
  static const double mobile = 768;

  /// Tablet: condensed or drawer (768–1024).
  static const double tablet = 1024;

  /// Desktop: full nav, multi-column (> 1024).

  static bool isMobile(double width) => width < mobile;
  static bool isTabletOrLarger(double width) => width >= mobile;
  static bool isDesktop(double width) => width >= tablet;
}
