import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  static const String _manuallySetKey = 'user_manually_set_locale';

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

    // Phase 2B: Asian & Strategic Markets
    Locale('ja', ''), // Japanese - Premium Asia-Pacific
    Locale('ko', ''), // Korean - Tech early-adopters
    Locale('hi', ''), // Hindi - India massive market
    Locale('bn', ''), // Bengali - Bengal + Bangladesh
    Locale('th', ''), // Thai - Southeast Asia gateway
    Locale('vi', ''), // Vietnamese - Emerging economy
    Locale('id', ''), // Indonesian - #4 world market
    Locale('tl', ''), // Filipino/Tagalog - Philippines
    Locale('ar', ''), // Arabic - MENA + global diaspora
    Locale('tr', ''), // Turkish - Europe-Asia bridge
    Locale('ru', ''), // Russian - Russia + ex-USSR
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

    // Phase 2B: Asian & Strategic Markets
    'ja': '日本語',
    'ko': '한국어',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
    'tl': 'Filipino',
    'ar': 'العربية',
    'tr': 'Türkçe',
    'ru': 'Русский',
  };

  /// Initialize locale from device or saved preference
  /// Priority:
  /// 1. User manually set locale (via Settings) - ALWAYS wins
  /// 2. Device locale (auto-sync) - If user never changed manually
  Future<void> initializeLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);
      final userManuallySet = prefs.getBool(_manuallySetKey) ?? false;
      final deviceLocale = PlatformDispatcher.instance.locale;

      debugPrint('🌍 LOCALE DEBUG:');
      debugPrint('  - savedLocaleCode from SharedPrefs: $savedLocaleCode');
      debugPrint('  - userManuallySet: $userManuallySet');
      debugPrint('  - Device locale: ${deviceLocale.languageCode}');
      debugPrint('  - Device country: ${deviceLocale.countryCode}');
      debugPrint('  - Full device locale: $deviceLocale');

      if (userManuallySet && savedLocaleCode != null) {
        // Priority 1: User manually changed language in Settings
        if (supportedLocales.any((locale) => locale.languageCode == savedLocaleCode)) {
          _locale = Locale(savedLocaleCode);
          debugPrint('  - ✅ Using USER MANUALLY SET locale: $savedLocaleCode (highest priority)');
        } else {
          // Saved locale no longer supported, fallback to device
          _locale = _getDeviceOrDefaultLocale(deviceLocale);
          await _saveLocale(_locale!.languageCode, manuallySet: false);
          debugPrint('  - ⚠️ Saved locale not supported, using device/default: ${_locale!.languageCode}');
        }
      } else {
        // Priority 2: Auto-sync with device locale (user never changed manually)
        _locale = _getDeviceOrDefaultLocale(deviceLocale);
        await _saveLocale(_locale!.languageCode, manuallySet: false);
        debugPrint('  - 🔄 AUTO-SYNC with device locale: ${_locale!.languageCode}');
      }

      debugPrint('  - 🎯 FINAL locale selected: ${_locale!.languageCode}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error initializing locale: $e');
      _locale = const Locale('en'); // Fallback to English
      notifyListeners();
    }
  }

  /// Get device locale if supported, otherwise default to English
  Locale _getDeviceOrDefaultLocale(Locale deviceLocale) {
    if (supportedLocales.any((locale) => locale.languageCode == deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    } else {
      return const Locale('en');
    }
  }

  /// Change the app locale (called when user manually selects language in Settings)
  Future<void> setLocale(Locale newLocale) async {
    if (newLocale == _locale) return;

    if (supportedLocales.contains(newLocale)) {
      _locale = newLocale;
      await _saveLocale(newLocale.languageCode, manuallySet: true);
      debugPrint('🔧 User MANUALLY changed locale to: ${newLocale.languageCode}');

      // Actualizar idioma de notificaciones
      try {
        await NotificationService().updateLocale(newLocale.languageCode);
      } catch (e) {
        // Ignore notification update errors (e.g., in tests without plugin)
        debugPrint('⚠️ Notification locale update failed: $e');
      }

      notifyListeners();
    }
  }

  /// Change locale by language code
  Future<void> setLocaleByCode(String languageCode) async {
    final newLocale = Locale(languageCode);
    await setLocale(newLocale);
  }

  /// Save locale preference
  Future<void> _saveLocale(String languageCode, {required bool manuallySet}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      await prefs.setBool(_manuallySetKey, manuallySet);
      debugPrint('💾 Saved locale: $languageCode (manually set: $manuallySet)');
    } catch (e) {
      debugPrint('❌ Error saving locale preference: $e');
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

  /// Get saved locale code from SharedPreferences (static method for background use)
  static Future<String> getSavedLocaleCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_localeKey) ?? 'en'; // Default to English
    } catch (e) {
      debugPrint('❌ Error getting saved locale: $e');
      return 'en';
    }
  }
}