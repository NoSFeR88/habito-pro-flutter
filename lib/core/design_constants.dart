/// Design system constants for consistent UI across the app
class DesignConstants {
  // Spacing
  static const double paddingScreen = 16.0;
  static const double spacingBetweenSections = 24.0;
  static const double spacingBetweenCards = 12.0;
  static const double cardPadding = 16.0;
  static const double cardBorderRadius = 12.0;

  // Chart dimensions
  static const double chartHeight = 200.0;
  static const double chartPaddingBottom = 16.0;
  static const double chartPaddingRight = 8.0;

  // Typography
  static const double titleFontSize = 20.0;
  static const double statValueFontSize = 20.0;
  static const double statLabelFontSize = 12.0;
  static const double chartLabelFontSize = 12.0;

  // Icons
  static const double statCardIconSize = 32.0;
  static const double habitIconSize = 24.0;

  // Touch Targets (WCAG AA compliance - Material 3)
  static const double minTouchTarget = 48.0;
  static const double iconButtonSize = 24.0;

  // Border Radius (Material 3 design tokens)
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;  // Same as cardBorderRadius
  static const double borderRadiusLarge = 16.0;

  // Spacing Scale (Material 3 - 4/8pt system)
  static const double space4 = 4.0;   // Micro
  static const double space8 = 8.0;   // Small
  static const double space12 = 12.0; // Medium
  static const double space16 = 16.0; // Default (same as paddingScreen)
  static const double space24 = 24.0; // Large (same as spacingBetweenSections)
  static const double space32 = 32.0; // XL
  static const double space48 = 48.0; // XXL / Touch targets

  // StatsOverview (Today/Week/Month tabs)
  static const double statsOverviewCardPadding = 8.0;
  static const double statsOverviewHeaderIconPadding = 8.0;
  static const double statsOverviewHeaderIconSize = 20.0;
  static const double statsOverviewTitleFontSize = 18.0;
  static const double statsOverviewSubtitleFontSize = 14.0;
  static const double statsOverviewMotivationIconSize = 20.0;
  static const double statsOverviewMotivationFontSize = 13.0;
  static const double statsOverviewMotivationPaddingH = 16.0;
  static const double statsOverviewMotivationPaddingV = 12.0;
  static const double statsOverviewStatCardIconSize = 16.0;
  static const double statsOverviewStatValueFontSize = 14.0;
  static const double statsOverviewStatLabelFontSize = 10.0;
  static const double statsOverviewStatCardPadding = 12.0;
  // Espaciados verticales unificados
  static const double statsOverviewSpacingAfterHeader = 12.0;
  static const double statsOverviewSpacingAfterMotivation = 16.0;
  static const double statsOverviewSpacingAfterProgress = 20.0;
  static const double statsOverviewProgressBarSpacing = 12.0;
}
