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

  /// Obtener padding responsivo basado en tamaño de pantalla
  /// Aumenta spacing en tablets y desktop para mejor uso del espacio
  static double getResponsivePadding(BuildContext context,
      {double base = 16.0}) {
    if (isDesktop(context)) {
      return base * 2.0; // 32px en desktop
    } else if (isTablet(context)) {
      return base * 1.5; // 24px en tablet
    } else {
      return base; // 16px en mobile
    }
  }

  /// Obtener spacing entre secciones responsivo
  static double getResponsiveSpacing(BuildContext context,
      {double base = 24.0}) {
    if (isDesktop(context)) {
      return base * 1.5; // 36px en desktop
    } else if (isTablet(context)) {
      return base * 1.25; // 30px en tablet
    } else {
      return base; // 24px en mobile
    }
  }

  /// Obtener font size responsivo
  static double getResponsiveFontSize(BuildContext context,
      {double base = 16.0}) {
    if (isDesktop(context)) {
      return base * 1.125; // +12.5% en desktop
    } else if (isTablet(context)) {
      return base * 1.0625; // +6.25% en tablet
    } else {
      return base;
    }
  }
}
