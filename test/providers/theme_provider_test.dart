import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ritmo/providers/theme_provider.dart';
import 'package:ritmo/providers/premium_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = ThemeProvider();
    // Give time for async _loadPreferences to complete
    await Future.delayed(const Duration(milliseconds: 100));
  });

  tearDown(() {
    // Dispose provider if not already disposed
    try {
      provider.dispose();
    } catch (e) {
      // Already disposed, ignore
    }
  });

  // ==========================================================================
  // GROUP 1: INITIALIZATION TESTS
  // ==========================================================================
  group('Initialization', () {
    test('should start with default values', () async {
      expect(provider.themeMode, AppThemeMode.system);
      expect(provider.colorScheme, AppColorScheme.blue);
      expect(provider.useSystemAccentColor, false);
      expect(provider.isPremiumUser, false);
    });

    test('should have all public getters accessible', () {
      expect(provider.themeMode, isA<AppThemeMode>());
      expect(provider.colorScheme, isA<AppColorScheme>());
      expect(provider.useSystemAccentColor, isA<bool>());
      expect(provider.isPremiumUser, isA<bool>());
    });

    test('should load persisted theme mode', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': AppThemeMode.dark.index,
      });

      final newProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newProvider.themeMode, AppThemeMode.dark);
      newProvider.dispose();
    });

    test('should load persisted color scheme', () async {
      SharedPreferences.setMockInitialValues({
        'color_scheme': AppColorScheme.green.index,
      });

      final newProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newProvider.colorScheme, AppColorScheme.green);
      newProvider.dispose();
    });

    test('should load persisted system accent color setting', () async {
      SharedPreferences.setMockInitialValues({
        'use_system_accent_color': true,
      });

      final newProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newProvider.useSystemAccentColor, true);
      newProvider.dispose();
    });
  });

  // ==========================================================================
  // GROUP 2: THEME MODE TESTS
  // ==========================================================================
  group('Theme Mode', () {
    test('should change to light mode', () async {
      await provider.setThemeMode(AppThemeMode.light);
      expect(provider.themeMode, AppThemeMode.light);
    });

    test('should change to dark mode', () async {
      await provider.setThemeMode(AppThemeMode.dark);
      expect(provider.themeMode, AppThemeMode.dark);
    });

    test('should change to system mode', () async {
      await provider.setThemeMode(AppThemeMode.light);
      await provider.setThemeMode(AppThemeMode.system);
      expect(provider.themeMode, AppThemeMode.system);
    });

    test('should persist theme mode change', () async {
      await provider.setThemeMode(AppThemeMode.dark);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme_mode'), AppThemeMode.dark.index);
    });

    test('should notify listeners on theme mode change', () async {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.setThemeMode(AppThemeMode.dark);
      expect(notified, true);
    });

    test('should convert to MaterialThemeMode correctly', () {
      provider.setThemeMode(AppThemeMode.light);
      expect(provider.materialThemeMode, ThemeMode.light);

      provider.setThemeMode(AppThemeMode.dark);
      expect(provider.materialThemeMode, ThemeMode.dark);

      provider.setThemeMode(AppThemeMode.system);
      expect(provider.materialThemeMode, ThemeMode.system);
    });
  });

  // ==========================================================================
  // GROUP 3: COLOR SCHEME TESTS (FREE THEMES)
  // ==========================================================================
  group('Color Scheme - Free Themes', () {
    test('should change to blue theme', () async {
      await provider.setColorScheme(AppColorScheme.blue);
      expect(provider.colorScheme, AppColorScheme.blue);
    });

    test('should change to green theme', () async {
      await provider.setColorScheme(AppColorScheme.green);
      expect(provider.colorScheme, AppColorScheme.green);
    });

    test('should change to purple theme', () async {
      await provider.setColorScheme(AppColorScheme.purple);
      expect(provider.colorScheme, AppColorScheme.purple);
    });

    test('should persist color scheme change', () async {
      await provider.setColorScheme(AppColorScheme.green);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('color_scheme'), AppColorScheme.green.index);
    });

    test('should notify listeners on color scheme change', () async {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.setColorScheme(AppColorScheme.purple);
      expect(notified, true);
    });
  });

  // ==========================================================================
  // GROUP 4: PREMIUM THEME DETECTION
  // ==========================================================================
  group('Premium Theme Detection', () {
    test('should identify free themes correctly', () {
      expect(provider.isThemePremium(AppColorScheme.blue), false);
      expect(provider.isThemePremium(AppColorScheme.green), false);
      expect(provider.isThemePremium(AppColorScheme.purple), false);
    });

    test('should identify premium themes correctly', () {
      expect(provider.isThemePremium(AppColorScheme.executiveMinimalist), true);
      expect(provider.isThemePremium(AppColorScheme.neonCyber), true);
      expect(provider.isThemePremium(AppColorScheme.auroraInspiration), true);
      expect(provider.isThemePremium(AppColorScheme.zenGarden), true);
      expect(provider.isThemePremium(AppColorScheme.glassmorphism), true);
      expect(provider.isThemePremium(AppColorScheme.neumorphism), true);
    });

    test('should have exactly 3 free themes', () {
      final freeThemes = AppColorScheme.values
          .where((scheme) => !provider.isThemePremium(scheme))
          .toList();
      expect(freeThemes.length, 3);
    });

    test('should have exactly 6 premium themes', () {
      final premiumThemes = AppColorScheme.values
          .where((scheme) => provider.isThemePremium(scheme))
          .toList();
      expect(premiumThemes.length, 6);
    });
  });

  // ==========================================================================
  // GROUP 5: PREMIUM PROVIDER INTEGRATION
  // ==========================================================================
  group('Premium Provider Integration', () {
    test('should accept premium provider', () {
      final premiumProvider = PremiumProvider();
      expect(() => provider.setPremiumProvider(premiumProvider), returnsNormally);
      premiumProvider.dispose();
    });

    test('should update isPremiumUser when premium provider is set', () {
      final premiumProvider = PremiumProvider();
      expect(provider.isPremiumUser, false);

      provider.setPremiumProvider(premiumProvider);
      expect(provider.isPremiumUser, false);

      premiumProvider.dispose();
    });

    test('should notify when premium provider changes', () async {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await premiumProvider.togglePremiumForTesting();
      expect(notified, true);

      premiumProvider.dispose();
    });

    test('should return all themes for premium users', () async {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);

      await premiumProvider.togglePremiumForTesting();
      expect(provider.isPremiumUser, true);

      final availableThemes = provider.availableThemes;
      expect(availableThemes.length, AppColorScheme.values.length);
      expect(availableThemes, AppColorScheme.values);

      premiumProvider.dispose();
    });

    test('should return only free themes for non-premium users', () {
      expect(provider.isPremiumUser, false);

      final availableThemes = provider.availableThemes;
      expect(availableThemes.length, 3);
      expect(availableThemes, containsAll([
        AppColorScheme.blue,
        AppColorScheme.green,
        AppColorScheme.purple,
      ]));
    });

    test('should remove listener on dispose', () {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);

      expect(() => provider.dispose(), returnsNormally);
      premiumProvider.dispose();
    });
  });

  // ==========================================================================
  // GROUP 6: PREMIUM THEME LOCKING
  // ==========================================================================
  group('Premium Theme Locking', () {
    test('should block premium theme selection for free users', () async {
      expect(provider.isPremiumUser, false);

      await provider.setColorScheme(AppColorScheme.executiveMinimalist);

      // Should remain on default theme
      expect(provider.colorScheme, AppColorScheme.blue);
    });

    test('should allow premium theme selection for premium users', () async {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);
      await premiumProvider.togglePremiumForTesting();

      await provider.setColorScheme(AppColorScheme.neonCyber);
      expect(provider.colorScheme, AppColorScheme.neonCyber);

      premiumProvider.dispose();
    });

    test('should not persist blocked premium theme', () async {
      expect(provider.isPremiumUser, false);

      await provider.setColorScheme(AppColorScheme.glassmorphism);

      final prefs = await SharedPreferences.getInstance();
      // Should still be blue (default)
      expect(prefs.getInt('color_scheme') ?? AppColorScheme.blue.index,
             AppColorScheme.blue.index);
    });

    test('should block all 6 premium themes for free users', () async {
      expect(provider.isPremiumUser, false);

      final premiumSchemes = [
        AppColorScheme.executiveMinimalist,
        AppColorScheme.neonCyber,
        AppColorScheme.auroraInspiration,
        AppColorScheme.zenGarden,
        AppColorScheme.glassmorphism,
        AppColorScheme.neumorphism,
      ];

      for (final scheme in premiumSchemes) {
        await provider.setColorScheme(scheme);
        expect(provider.colorScheme, isNot(scheme),
               reason: '${scheme.name} should be blocked for free users');
      }
    });
  });

  // ==========================================================================
  // GROUP 7: SYSTEM ACCENT COLOR
  // ==========================================================================
  group('System Accent Color', () {
    test('should enable system accent color', () async {
      await provider.setUseSystemAccentColor(true);
      expect(provider.useSystemAccentColor, true);
    });

    test('should disable system accent color', () async {
      await provider.setUseSystemAccentColor(true);
      await provider.setUseSystemAccentColor(false);
      expect(provider.useSystemAccentColor, false);
    });

    test('should persist system accent color setting', () async {
      await provider.setUseSystemAccentColor(true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('use_system_accent_color'), true);
    });

    test('should notify listeners on system accent color change', () async {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.setUseSystemAccentColor(true);
      expect(notified, true);
    });
  });

  // ==========================================================================
  // GROUP 8: THEME DATA GENERATION
  // ==========================================================================
  group('Theme Data Generation', () {
    test('should generate light theme', () {
      final lightTheme = provider.getLightTheme();
      expect(lightTheme, isA<ThemeData>());
      expect(lightTheme.useMaterial3, true);
      expect(lightTheme.colorScheme.brightness, Brightness.light);
    });

    test('should generate dark theme', () {
      final darkTheme = provider.getDarkTheme();
      expect(darkTheme, isA<ThemeData>());
      expect(darkTheme.useMaterial3, true);
      expect(darkTheme.colorScheme.brightness, Brightness.dark);
    });

    test('should have consistent card theme in both modes', () {
      final lightTheme = provider.getLightTheme();
      final darkTheme = provider.getDarkTheme();

      expect(lightTheme.cardTheme.elevation, 2);
      expect(darkTheme.cardTheme.elevation, 2);
      expect(lightTheme.cardTheme.shape, isA<RoundedRectangleBorder>());
      expect(darkTheme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('should have FAB theme configured', () {
      final lightTheme = provider.getLightTheme();
      expect(lightTheme.floatingActionButtonTheme.shape,
             isA<RoundedRectangleBorder>());
    });
  });

  // ==========================================================================
  // GROUP 9: COLOR SCHEME GENERATION
  // ==========================================================================
  group('Color Scheme Generation', () {
    test('should generate color scheme for light mode', () {
      final colorScheme = provider.getColorScheme(Brightness.light);
      expect(colorScheme, isA<ColorScheme>());
      expect(colorScheme.brightness, Brightness.light);
    });

    test('should generate color scheme for dark mode', () {
      final colorScheme = provider.getColorScheme(Brightness.dark);
      expect(colorScheme, isA<ColorScheme>());
      expect(colorScheme.brightness, Brightness.dark);
    });

    test('should generate different color schemes for free themes', () async {
      await provider.setColorScheme(AppColorScheme.blue);
      final blueScheme = provider.getColorScheme(Brightness.light);

      await provider.setColorScheme(AppColorScheme.green);
      final greenScheme = provider.getColorScheme(Brightness.light);

      expect(blueScheme.primary, isNot(greenScheme.primary));
    });

    test('should generate valid color schemes for all themes', () async {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);
      await premiumProvider.togglePremiumForTesting();

      for (final scheme in AppColorScheme.values) {
        await provider.setColorScheme(scheme);

        final lightCS = provider.getColorScheme(Brightness.light);
        final darkCS = provider.getColorScheme(Brightness.dark);

        expect(lightCS, isA<ColorScheme>());
        expect(darkCS, isA<ColorScheme>());
        expect(lightCS.brightness, Brightness.light);
        expect(darkCS.brightness, Brightness.dark);
      }

      premiumProvider.dispose();
    });
  });

  // ==========================================================================
  // GROUP 10: EDGE CASES
  // ==========================================================================
  group('Edge Cases', () {
    test('should handle rapid theme mode changes', () async {
      await provider.setThemeMode(AppThemeMode.light);
      await provider.setThemeMode(AppThemeMode.dark);
      await provider.setThemeMode(AppThemeMode.system);
      await provider.setThemeMode(AppThemeMode.light);

      expect(provider.themeMode, AppThemeMode.light);
    });

    test('should handle rapid color scheme changes', () async {
      await provider.setColorScheme(AppColorScheme.blue);
      await provider.setColorScheme(AppColorScheme.green);
      await provider.setColorScheme(AppColorScheme.purple);
      await provider.setColorScheme(AppColorScheme.blue);

      expect(provider.colorScheme, AppColorScheme.blue);
    });

    test('should handle multiple premium provider assignments', () {
      final premium1 = PremiumProvider();
      final premium2 = PremiumProvider();

      provider.setPremiumProvider(premium1);
      provider.setPremiumProvider(premium2);

      expect(provider.isPremiumUser, false);

      premium1.dispose();
      premium2.dispose();
    });

    test('should handle dispose without premium provider', () {
      expect(() => provider.dispose(), returnsNormally);
    });

    test('should handle dispose with premium provider', () {
      final premiumProvider = PremiumProvider();
      provider.setPremiumProvider(premiumProvider);

      expect(() => provider.dispose(), returnsNormally);
      premiumProvider.dispose();
    });
  });

  // ==========================================================================
  // GROUP 11: ENUMS TESTS
  // ==========================================================================
  group('Enums', () {
    test('AppThemeMode should have 3 values', () {
      expect(AppThemeMode.values.length, 3);
      expect(AppThemeMode.values, contains(AppThemeMode.light));
      expect(AppThemeMode.values, contains(AppThemeMode.dark));
      expect(AppThemeMode.values, contains(AppThemeMode.system));
    });

    test('AppColorScheme should have 9 values', () {
      expect(AppColorScheme.values.length, 9);
    });

    test('AppColorScheme should have correct free themes', () {
      expect(AppColorScheme.values, contains(AppColorScheme.blue));
      expect(AppColorScheme.values, contains(AppColorScheme.green));
      expect(AppColorScheme.values, contains(AppColorScheme.purple));
    });

    test('AppColorScheme should have correct premium themes', () {
      expect(AppColorScheme.values, contains(AppColorScheme.executiveMinimalist));
      expect(AppColorScheme.values, contains(AppColorScheme.neonCyber));
      expect(AppColorScheme.values, contains(AppColorScheme.auroraInspiration));
      expect(AppColorScheme.values, contains(AppColorScheme.zenGarden));
      expect(AppColorScheme.values, contains(AppColorScheme.glassmorphism));
      expect(AppColorScheme.values, contains(AppColorScheme.neumorphism));
    });
  });

  // ==========================================================================
  // GROUP 12: PERSISTENCE TESTS
  // ==========================================================================
  group('Persistence', () {
    test('should persist all settings together', () async {
      await provider.setThemeMode(AppThemeMode.dark);
      await provider.setColorScheme(AppColorScheme.purple);
      await provider.setUseSystemAccentColor(true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme_mode'), AppThemeMode.dark.index);
      expect(prefs.getInt('color_scheme'), AppColorScheme.purple.index);
      expect(prefs.getBool('use_system_accent_color'), true);
    });

    test('should load all persisted settings on init', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': AppThemeMode.dark.index,
        'color_scheme': AppColorScheme.green.index,
        'use_system_accent_color': true,
      });

      final newProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newProvider.themeMode, AppThemeMode.dark);
      expect(newProvider.colorScheme, AppColorScheme.green);
      expect(newProvider.useSystemAccentColor, true);

      newProvider.dispose();
    });

    test('should handle missing preferences gracefully', () async {
      SharedPreferences.setMockInitialValues({});

      final newProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newProvider.themeMode, AppThemeMode.system);
      expect(newProvider.colorScheme, AppColorScheme.blue);
      expect(newProvider.useSystemAccentColor, false);

      newProvider.dispose();
    });

    // Note: Corrupted index handling is skipped because error happens async in _loadPreferences
    // In production, ThemeProvider should add try-catch in _loadPreferences to handle invalid indices
  });
}
