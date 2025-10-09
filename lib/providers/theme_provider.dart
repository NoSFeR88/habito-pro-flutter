import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n/app_localizations.dart';
import 'premium_provider.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

enum AppColorScheme {
  // Free themes
  blue,
  green,
  purple,

  // PREMIUM themes - $2.99/month
  executiveMinimalist,    // For professionals
  neonCyber,             // For Gen Z
  auroraInspiration,     // For creatives
  zenGarden,             // For wellness focus
  glassmorphism,         // 2025 trend
  neumorphism,           // Soft 3D UI
}

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  AppColorScheme _colorScheme = AppColorScheme.blue;
  bool _useSystemAccentColor = false;
  PremiumProvider? _premiumProvider;

  AppThemeMode get themeMode => _themeMode;
  AppColorScheme get colorScheme => _colorScheme;
  bool get useSystemAccentColor => _useSystemAccentColor;
  bool get isPremiumUser => _premiumProvider?.isPremium ?? false;

  void setPremiumProvider(PremiumProvider premiumProvider) {
    _premiumProvider = premiumProvider;
    _premiumProvider!.addListener(_onPremiumChanged);
    notifyListeners();
  }

  void _onPremiumChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _premiumProvider?.removeListener(_onPremiumChanged);
    super.dispose();
  }

  // Check if a color scheme requires premium
  bool isThemePremium(AppColorScheme scheme) {
    return [
      AppColorScheme.executiveMinimalist,
      AppColorScheme.neonCyber,
      AppColorScheme.auroraInspiration,
      AppColorScheme.zenGarden,
      AppColorScheme.glassmorphism,
      AppColorScheme.neumorphism,
    ].contains(scheme);
  }

  // Get available themes based on premium status
  List<AppColorScheme> get availableThemes {
    if (isPremiumUser) {
      return AppColorScheme.values;
    } else {
      return [AppColorScheme.blue, AppColorScheme.green, AppColorScheme.purple];
    }
  }

  static const String _themeModeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';
  static const String _useSystemAccentColorKey = 'use_system_accent_color';

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_themeModeKey) ?? AppThemeMode.system.index;
    _themeMode = AppThemeMode.values[themeModeIndex];

    final colorSchemeIndex = prefs.getInt(_colorSchemeKey) ?? AppColorScheme.blue.index;
    _colorScheme = AppColorScheme.values[colorSchemeIndex];

    _useSystemAccentColor = prefs.getBool(_useSystemAccentColorKey) ?? false;

    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setColorScheme(AppColorScheme scheme) async {
    // Check if theme requires premium and user doesn't have it
    if (isThemePremium(scheme) && !isPremiumUser) {
      // TODO: Show premium upgrade dialog
      return;
    }

    _colorScheme = scheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorSchemeKey, scheme.index);
    notifyListeners();
  }

  // Removed: enablePremiumForTesting() - Use PremiumProvider.togglePremiumForTesting() instead

  Future<void> setUseSystemAccentColor(bool value) async {
    _useSystemAccentColor = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useSystemAccentColorKey, value);
    notifyListeners();
  }

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ColorScheme getColorScheme(Brightness brightness) {
    return _getCustomColorScheme(_colorScheme, brightness);
  }

  ColorScheme _getCustomColorScheme(AppColorScheme scheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    switch (scheme) {
      // FREE THEMES
      case AppColorScheme.blue:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF1976D2),
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF03DAC6),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFFF5F5F5),
                onSurface: Color(0xFF1C1B1F),


              )
            : const ColorScheme.dark(
                primary: Color(0xFF2196F3),
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFF03DAC6),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFF1E1E1E),
                onSurface: Color(0xFFE6E1E5),


              );

      case AppColorScheme.green:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF388E3C),
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF66BB6A),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFFF1F8E9),
                onSurface: Color(0xFF1B5E20),


              )
            : const ColorScheme.dark(
                primary: Color(0xFF4CAF50),
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFF81C784),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFF1B2A1B),
                onSurface: Color(0xFFE8F5E8),


              );

      case AppColorScheme.purple:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF7B1FA2),
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFFBA68C8),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFFF3E5F5),
                onSurface: Color(0xFF4A148C),


              )
            : const ColorScheme.dark(
                primary: Color(0xFF9C27B0),
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFCE93D8),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFF2A1B2A),
                onSurface: Color(0xFFF5E8F5),


              );

      // PREMIUM THEMES - Dramatically different designs worth $2.99/month
      case AppColorScheme.executiveMinimalist:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF3498db), // Professional Blue
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF2ecc71), // Emerald Green
                onSecondary: Color(0xFFFFFFFF),
                // Sophisticated grayscale backgrounds for professional look
                surface: Color(0xFFFFFFFF), // Pure white cards
                surfaceContainerLowest: Color(0xFFF8F9FA), // Lightest gray
                surfaceContainerLow: Color(0xFFF1F3F5), // Light gray
                surfaceContainer: Color(0xFFE9ECEF), // Medium-light gray
                surfaceContainerHigh: Color(0xFFDEE2E6), // Medium gray
                surfaceContainerHighest: Color(0xFFCED4DA), // Elevated gray
                onSurface: Color(0xFF2c3e50), // Charcoal text
                error: Color(0xFFe74c3c),
                onError: Color(0xFFFFFFFF),
              )
            : const ColorScheme.dark(
                primary: Color(0xFF3498db),
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFF2ecc71),
                onSecondary: Color(0xFF000000),
                // Professional dark backgrounds with subtle gradation
                surface: Color(0xFF2c3e50), // Charcoal base
                surfaceContainerLowest: Color(0xFF34495e), // Slightly lighter
                surfaceContainerLow: Color(0xFF3d566e), // Mid-dark
                surfaceContainer: Color(0xFF475f7b), // Medium elevated
                surfaceContainerHigh: Color(0xFF516888), // High elevation
                surfaceContainerHighest: Color(0xFF5a7395), // Highest elevation
                onSurface: Color(0xFFF8F9FA),
                error: Color(0xFFe74c3c),
                onError: Color(0xFFFFFFFF),
              );

      case AppColorScheme.neonCyber:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF00ffff), // Electric Cyan
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFff1493), // Neon Pink
                onSecondary: Color(0xFF000000),
                // Cyberpunk dark backgrounds with neon glow layers
                surface: Color(0xFF1a1a1a), // Dark for contrast
                surfaceContainerLowest: Color(0xFF0f0f0f), // Deep shadow
                surfaceContainerLow: Color(0xFF1f1f1f), // Dark layer
                surfaceContainer: Color(0xFF2a2a2a), // Medium dark
                surfaceContainerHigh: Color(0xFF353535), // Elevated
                surfaceContainerHighest: Color(0xFF404040), // High contrast
                onSurface: Color(0xFF00ffff),
                error: Color(0xFFff073a),
                onError: Color(0xFFFFFFFF),
              )
            : const ColorScheme.dark(
                primary: Color(0xFF00ffff), // Electric Cyan
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFff1493), // Neon Pink
                onSecondary: Color(0xFF000000),
                // Deep space black with layered neon atmosphere
                surface: Color(0xFF0a0a0a), // Deep Space Black
                surfaceContainerLowest: Color(0xFF000000), // Pure black void
                surfaceContainerLow: Color(0xFF141414), // Shadow layer
                surfaceContainer: Color(0xFF1e1e1e), // Medium elevation
                surfaceContainerHigh: Color(0xFF282828), // High elevation
                surfaceContainerHighest: Color(0xFF323232), // Maximum elevation
                onSurface: Color(0xFF00ffff),
                error: Color(0xFFff073a),
                onError: Color(0xFFFFFFFF),
              );

      case AppColorScheme.auroraInspiration:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF8a2be2), // Cosmic Purple
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFFff69b4), // Aurora Pink
                onSecondary: Color(0xFF000000),
                // Ethereal purple-pink gradient backgrounds
                surface: Color(0xFFf8f4ff), // Soft Purple Tint
                surfaceContainerLowest: Color(0xFFfefbff), // Almost white with purple hint
                surfaceContainerLow: Color(0xFFf5f0ff), // Light lavender
                surfaceContainer: Color(0xFFede6ff), // Medium lavender
                surfaceContainerHigh: Color(0xFFe4d9ff), // Rich lavender
                surfaceContainerHighest: Color(0xFFdaccff), // Deep lavender
                onSurface: Color(0xFF2e1a4a), // Deep Indigo
                error: Color(0xFFdc143c),
                onError: Color(0xFFFFFFFF),
              )
            : const ColorScheme.dark(
                primary: Color(0xFFff69b4), // Aurora Pink
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFffd700), // Stellar Gold
                onSecondary: Color(0xFF000000),
                // Cosmic night sky with aurora layers
                surface: Color(0xFF2e1a4a), // Deep Indigo
                surfaceContainerLowest: Color(0xFF1f0f35), // Darkest void
                surfaceContainerLow: Color(0xFF3a2558), // Dark purple
                surfaceContainer: Color(0xFF462f66), // Medium purple
                surfaceContainerHigh: Color(0xFF533a74), // Elevated purple
                surfaceContainerHighest: Color(0xFF5f4582), // Bright aurora
                onSurface: Color(0xFFff69b4),
                error: Color(0xFFdc143c),
                onError: Color(0xFFFFFFFF),
              );

      case AppColorScheme.zenGarden:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF87ceeb), // Sage Green
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFff7f50), // Sunset Orange
                onSecondary: Color(0xFF000000),
                surface: Color(0xFFF5F5DC), // Warm Stone
                onSurface: Color(0xFF8b4513), // Earth Brown
                error: Color(0xFFcd5c5c),
                onError: Color(0xFFFFFFFF),
              )
            : const ColorScheme.dark(
                primary: Color(0xFF87ceeb),
                onPrimary: Color(0xFF000000),
                secondary: Color(0xFFff7f50),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFF2f2f1f), // Dark Earth
                onSurface: Color(0xFF87ceeb),
                error: Color(0xFFcd5c5c),
                onError: Color(0xFFFFFFFF),
              );

      case AppColorScheme.glassmorphism:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF4c83ff), // Vivid Blue
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF00d4aa), // Vibrant Green
                onSecondary: Color(0xFF000000),
                surface: Color(0xFFffffff), // White
                onSurface: Color(0xFF1a1a1a),
                error: Color(0xFFff4757),
                onError: Color(0xFFFFFFFF),
              )
            : const ColorScheme.dark(
                primary: Color(0xFF4c83ff),
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF00d4aa),
                onSecondary: Color(0xFF000000),
                surface: Color(0xFF1a1a1a), // Dark
                onSurface: Color(0xFFffffff),
                error: Color(0xFFff4757),
                onError: Color(0xFFFFFFFF),
              );

      case AppColorScheme.neumorphism:
        return isLight
            ? const ColorScheme.light(
                primary: Color(0xFF667eea), // Soft Blue
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF764ba2), // Soft Purple
                onSecondary: Color(0xFFFFFFFF),
                surface: Color(0xFFe0e5ec), // Neumorphic Base
                onSurface: Color(0xFF3d4852),
                error: Color(0xFFf093fb),
                onError: Color(0xFF000000),
              )
            : const ColorScheme.dark(
                primary: Color(0xFF667eea),
                onPrimary: Color(0xFFFFFFFF),
                secondary: Color(0xFF764ba2),
                onSecondary: Color(0xFFFFFFFF),
                surface: Color(0xFF2c2c2c), // Dark Neumorphic
                onSurface: Color(0xFFffffff),


                error: Color(0xFFf093fb),
                onError: Color(0xFF000000),
              );
    }
  }

  String getColorSchemeName(AppColorScheme scheme, BuildContext context) {
    switch (scheme) {
      // Free themes
      case AppColorScheme.blue:
        return AppLocalizations.of(context)!.themeBasicBlue;
      case AppColorScheme.green:
        return AppLocalizations.of(context)!.themeBasicGreen;
      case AppColorScheme.purple:
        return AppLocalizations.of(context)!.themeBasicPurple;

      // Premium themes
      case AppColorScheme.executiveMinimalist:
        return AppLocalizations.of(context)!.themeExecutiveMinimalist;
      case AppColorScheme.neonCyber:
        return AppLocalizations.of(context)!.themeCyberNeon;
      case AppColorScheme.auroraInspiration:
        return AppLocalizations.of(context)!.themeAuroraInspiration;
      case AppColorScheme.zenGarden:
        return AppLocalizations.of(context)!.themeZenGarden;
      case AppColorScheme.glassmorphism:
        return AppLocalizations.of(context)!.themeGlassmorphism;
      case AppColorScheme.neumorphism:
        return AppLocalizations.of(context)!.themeNeumorphism;
    }
  }

  String getThemeModeName(AppThemeMode mode, BuildContext context) {
    switch (mode) {
      case AppThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case AppThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
      case AppThemeMode.system:
        return AppLocalizations.of(context)!.system;
    }
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: getColorScheme(Brightness.light),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: getColorScheme(Brightness.light).surface,
        foregroundColor: getColorScheme(Brightness.light).onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: getColorScheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: getColorScheme(Brightness.dark).surface,
        foregroundColor: getColorScheme(Brightness.dark).onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
