import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 600;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 1200;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width <= 600;
  }

  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (isDesktop(context)) {
      return screenWidth * 0.4;
    } else if (isTablet(context)) {
      return isLandscape ? screenWidth * 0.45 : screenWidth * 0.85;
    } else {
      return isLandscape ? screenWidth * 0.48 : screenWidth * 0.9;
    }
  }

  static int getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth > 1200) {
      return 3;
    } else if (screenWidth > 600) {
      return isLandscape(context) ? 2 : 1;
    } else {
      return isLandscape(context) ? 2 : 1;
    }
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: isLandscape ? 24 : 20,
        vertical: isLandscape ? 16 : 20,
      );
    } else {
      return EdgeInsets.symmetric(
        horizontal: isLandscape ? 16 : 16,
        vertical: isLandscape ? 8 : 16,
      );
    }
  }

  static double getAppBarHeight(BuildContext context) {
    return isLandscape(context) && isMobile(context) ? 48.0 : 56.0;
  }

  static double getFabSize(BuildContext context) {
    return isLandscape(context) && isMobile(context) ? 48.0 : 56.0;
  }
}