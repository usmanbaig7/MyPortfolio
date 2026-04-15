import 'package:flutter/widgets.dart';

import '../constants/app_sizes.dart';

/// Utility methods for making layout decisions based on screen width.
///
/// Prefer [LayoutBuilder] for widget-level responsiveness when the available
/// width (not the full screen width) is what matters.
class ResponsiveHelper {
  const ResponsiveHelper._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppSizes.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppSizes.mobileBreakpoint &&
        width < AppSizes.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppSizes.tabletBreakpoint;

  /// Returns the number of grid columns appropriate for the current screen.
  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  /// Returns the horizontal content padding appropriate for the screen size.
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return AppSizes.paddingXXL;
    if (isTablet(context)) return AppSizes.paddingXL;
    return AppSizes.paddingL;
  }
}
