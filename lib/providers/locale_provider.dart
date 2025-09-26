import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';

  Locale? _locale;

  Locale? get locale => _locale;

  /// Supported locales for the app
  static const List<Locale> supportedLocales = [
    // Phase 1: Core Global Languages
    Locale('en', ''), // English
    Locale('es', ''), // Spanish
    Locale('de', ''), // German
    Locale('fr', ''), // French
    Locale('zh', ''), // Chinese Simplified

    // Phase 2A: European Expansion
    Locale('it', ''), // Italian
    Locale('nl', ''), // Dutch
    Locale('sv', ''), // Swedish
    Locale('pl', ''), // Polish
    Locale('pt', ''), // Portuguese
    Locale('ro', ''), // Romanian
    Locale('cs', ''), // Czech
    Locale('da', ''), // Danish
    Locale('no', ''), // Norwegian
    Locale('fi', ''), // Finnish
  ];

  /// Language names for display in UI
  static const Map<String, String> languageNames = {
    // Phase 1: Core Global Languages
    'en': 'English',
    'es': 'Español',
    'de': 'Deutsch',
    'fr': 'Français',
    'zh': '中文',

    // Phase 2A: European Expansion
    'it': 'Italiano',
    'nl': 'Nederlands',
    'sv': 'Svenska',
    'pl': 'Polski',
    'pt': 'Português',
    'ro': 'Română',
    'cs': 'Čeština',
    'da': 'Dansk',
    'no': 'Norsk',
    'fi': 'Suomi',
  };

  /// Initialize locale from device or saved preference
  Future<void> initializeLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);

      if (savedLocaleCode != null) {
        // Use saved locale
        _locale = Locale(savedLocaleCode);
      } else {
        // Use device locale if supported, otherwise default to English
        final deviceLocale = PlatformDispatcher.instance.locale;
        if (supportedLocales.any((locale) => locale.languageCode == deviceLocale.languageCode)) {
          _locale = Locale(deviceLocale.languageCode);
        } else {
          _locale = const Locale('en'); // Default to English
        }

        // Save the initial locale
        await _saveLocale(_locale!.languageCode);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing locale: $e');
      _locale = const Locale('en'); // Fallback to English
      notifyListeners();
    }
  }

  /// Change the app locale
  Future<void> setLocale(Locale newLocale) async {
    if (newLocale == _locale) return;

    if (supportedLocales.contains(newLocale)) {
      _locale = newLocale;
      await _saveLocale(newLocale.languageCode);
      notifyListeners();
    }
  }

  /// Change locale by language code
  Future<void> setLocaleByCode(String languageCode) async {
    final newLocale = Locale(languageCode);
    await setLocale(newLocale);
  }

  /// Save locale preference
  Future<void> _saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale preference: $e');
    }
  }

  /// Get display name for a language code
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }

  /// Check if a locale is supported
  static bool isSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  /// Get current language code
  String get currentLanguageCode => _locale?.languageCode ?? 'en';

  /// Get current language display name
  String get currentLanguageName => getLanguageName(currentLanguageCode);
}