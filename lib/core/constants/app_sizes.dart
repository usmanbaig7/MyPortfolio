/// Spacing, size, and breakpoint constants used throughout the application.
/// Using named constants prevents magic numbers and makes design changes easy.
class AppSizes {
  AppSizes._();

  // ── Padding / spacing ───────────────────────────────────────────────────────
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 62.0;
  static const double paddingXXL = 64.0;

  // ── Border radius ───────────────────────────────────────────────────────────
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 16.0;
  static const double borderRadiusL = 24.0;

  // ── Responsive breakpoints ──────────────────────────────────────────────────
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1000.0;

  // ── Section / widget sizes ──────────────────────────────────────────────────
  /// Fraction of screen height for the hero section minimum height.
  static const double heroMinHeightFraction = 0.55;

  static const double profileImageSize = 260.0;
  static const double profileImageSizeMobile = 160.0;

  static const double projectImageHeight = 200.0;
  static const double detailHeroHeight = 300.0;

  // ── Max content width on large screens ─────────────────────────────────────
  static const double maxContentWidth = 1280.0;
}
