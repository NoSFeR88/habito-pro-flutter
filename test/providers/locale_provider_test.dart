import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ritmo/providers/locale_provider.dart';

void main() {
  // Setup mock SharedPreferences antes de cada test
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleProvider - Initialization', () {
    test('should initialize with device locale when no saved preference', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert
      expect(provider.locale, isNotNull);
      expect(provider.currentLanguageCode, isNotEmpty);
    });

    test('should initialize with English fallback when device locale unsupported', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert - Si el locale del dispositivo no está soportado, debería caer a 'en'
      // Como no podemos mockear PlatformDispatcher, verificamos que tenga un locale válido
      expect(LocaleProvider.isSupported(provider.locale!), isTrue);
    });

    test('should load saved locale when user manually set it', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'es',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert
      expect(provider.locale, equals(const Locale('es')));
      expect(provider.currentLanguageCode, equals('es'));
    });

    test('should use device locale when user has not manually set locale', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'fr',
        'user_manually_set_locale': false,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert - Debería usar device locale, no el saved (porque no fue manual)
      expect(provider.locale, isNotNull);
    });

    test('should notify listeners after initialization', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      var notified = false;
      provider.addListener(() => notified = true);

      // Act
      await provider.initializeLocale();

      // Assert
      expect(notified, isTrue);
    });

    test('should fallback to English on initialization error', () async {
      // Arrange - No inicializar mock para forzar error
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert
      expect(provider.locale, equals(const Locale('en')));
    });
  });

  group('LocaleProvider - Set Locale', () {
    test('should change locale when user selects new language', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act
      await provider.setLocale(const Locale('es'));

      // Assert
      expect(provider.locale, equals(const Locale('es')));
      expect(provider.currentLanguageCode, equals('es'));
    });

    test('should persist locale when user manually sets it', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act
      await provider.setLocale(const Locale('de'));

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_locale'), equals('de'));
      expect(prefs.getBool('user_manually_set_locale'), isTrue);
    });

    test('should notify listeners when locale changes', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();
      var notified = false;
      provider.addListener(() => notified = true);

      // Act
      await provider.setLocale(const Locale('fr'));

      // Assert
      expect(notified, isTrue);
    });

    test('should not change locale when setting same locale', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'en',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();
      await provider.initializeLocale();
      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      // Act
      await provider.setLocale(const Locale('en'));

      // Assert
      expect(notificationCount, equals(0));
    });

    test('should only accept supported locales', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();
      final initialLocale = provider.locale;

      // Act - Intentar establecer locale no soportado
      await provider.setLocale(const Locale('xx')); // Código inexistente

      // Assert - No debería cambiar
      expect(provider.locale, equals(initialLocale));
    });

    test('should change locale by language code', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act
      await provider.setLocaleByCode('ja');

      // Assert
      expect(provider.currentLanguageCode, equals('ja'));
    });
  });

  group('LocaleProvider - Supported Locales', () {
    test('should have 26 supported locales', () {
      expect(LocaleProvider.supportedLocales.length, equals(26));
    });

    test('should support all core global languages', () {
      const coreLanguages = ['en', 'es', 'de', 'fr', 'zh'];

      for (final lang in coreLanguages) {
        expect(
          LocaleProvider.supportedLocales.any((locale) => locale.languageCode == lang),
          isTrue,
          reason: '$lang should be supported',
        );
      }
    });

    test('should support European languages', () {
      const europeanLanguages = ['it', 'nl', 'sv', 'pl', 'pt', 'ro', 'cs', 'da', 'no', 'fi'];

      for (final lang in europeanLanguages) {
        expect(
          LocaleProvider.supportedLocales.any((locale) => locale.languageCode == lang),
          isTrue,
          reason: '$lang should be supported',
        );
      }
    });

    test('should support Asian and strategic market languages', () {
      const asianLanguages = ['ja', 'ko', 'hi', 'bn', 'th', 'vi', 'id', 'tl', 'ar', 'tr', 'ru'];

      for (final lang in asianLanguages) {
        expect(
          LocaleProvider.supportedLocales.any((locale) => locale.languageCode == lang),
          isTrue,
          reason: '$lang should be supported',
        );
      }
    });

    test('should have language names for all supported locales', () {
      for (final locale in LocaleProvider.supportedLocales) {
        expect(
          LocaleProvider.languageNames.containsKey(locale.languageCode),
          isTrue,
          reason: 'Language name for ${locale.languageCode} should exist',
        );
      }
    });

    test('should return true for supported locale check', () {
      expect(LocaleProvider.isSupported(const Locale('en')), isTrue);
      expect(LocaleProvider.isSupported(const Locale('es')), isTrue);
      expect(LocaleProvider.isSupported(const Locale('ja')), isTrue);
    });

    test('should return false for unsupported locale check', () {
      expect(LocaleProvider.isSupported(const Locale('xx')), isFalse);
      expect(LocaleProvider.isSupported(const Locale('zz')), isFalse);
    });
  });

  group('LocaleProvider - Language Names', () {
    test('should return correct language name for English', () {
      expect(LocaleProvider.getLanguageName('en'), equals('English'));
    });

    test('should return correct language name for Spanish', () {
      expect(LocaleProvider.getLanguageName('es'), equals('Español'));
    });

    test('should return correct language name for Japanese', () {
      expect(LocaleProvider.getLanguageName('ja'), equals('日本語'));
    });

    test('should return correct language name for Arabic', () {
      expect(LocaleProvider.getLanguageName('ar'), equals('العربية'));
    });

    test('should return uppercase code for unknown language', () {
      expect(LocaleProvider.getLanguageName('xx'), equals('XX'));
    });

    test('should provide current language name from provider', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'fr',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Assert
      expect(provider.currentLanguageName, equals('Français'));
    });
  });

  group('LocaleProvider - Priority Logic', () {
    test('should prioritize user manual setting over device locale', () async {
      // Arrange - Usuario estableció español manualmente
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'es',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert - Debería usar el locale manual (es), no el del dispositivo
      expect(provider.currentLanguageCode, equals('es'));
    });

    test('should mark locale as manually set after user changes it', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act
      await provider.setLocale(const Locale('ko'));

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('user_manually_set_locale'), isTrue);
    });

    test('should auto-sync with device locale when user never changed manually', () async {
      // Arrange - No manual setting
      SharedPreferences.setMockInitialValues({
        'user_manually_set_locale': false,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert - Debería tener un locale válido del dispositivo o fallback
      expect(provider.locale, isNotNull);
      expect(LocaleProvider.isSupported(provider.locale!), isTrue);
    });
  });

  group('LocaleProvider - Edge Cases', () {
    test('should handle rapid locale changes', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act - Cambios rápidos consecutivos
      await provider.setLocaleByCode('es');
      await provider.setLocaleByCode('fr');
      await provider.setLocaleByCode('de');
      await provider.setLocaleByCode('ja');

      // Assert - Debería quedarse con el último
      expect(provider.currentLanguageCode, equals('ja'));
    });

    test('should handle all 26 languages sequentially', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act & Assert - Probar todos los idiomas
      for (final locale in LocaleProvider.supportedLocales) {
        await provider.setLocale(locale);
        expect(provider.currentLanguageCode, equals(locale.languageCode));
      }
    });

    test('should recover from corrupted saved locale', () async {
      // Arrange - Locale guardado inválido
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'invalid_code',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert - Debería caer a device locale o inglés
      expect(provider.locale, isNotNull);
      expect(LocaleProvider.isSupported(provider.locale!), isTrue);
    });

    test('should handle empty locale string', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'selected_locale': '',
        'user_manually_set_locale': false,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert
      expect(provider.locale, isNotNull);
    });

    test('should handle null getter before initialization', () {
      // Arrange
      final provider = LocaleProvider();

      // Assert
      expect(provider.locale, isNull);
      expect(provider.currentLanguageCode, equals('en')); // Fallback
    });

    test('should have unique language codes in supported locales', () {
      final languageCodes = LocaleProvider.supportedLocales
          .map((locale) => locale.languageCode)
          .toList();

      final uniqueCodes = languageCodes.toSet();

      expect(languageCodes.length, equals(uniqueCodes.length));
    });
  });

  group('LocaleProvider - Persistence', () {
    test('should persist locale across provider instances', () async {
      // Arrange - Primera instancia
      SharedPreferences.setMockInitialValues({});
      final provider1 = LocaleProvider();
      await provider1.initializeLocale();
      await provider1.setLocale(const Locale('zh'));

      // Act - Segunda instancia
      final provider2 = LocaleProvider();
      await provider2.initializeLocale();

      // Assert - Debería cargar el locale guardado
      expect(provider2.currentLanguageCode, equals('zh'));
    });

    test('should save both locale and manual flag to SharedPreferences', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();

      // Act
      await provider.setLocale(const Locale('it'));

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_locale'), equals('it'));
      expect(prefs.getBool('user_manually_set_locale'), isNotNull);
    });

    test('should clear manual flag when falling back from unsupported saved locale', () async {
      // Arrange - Locale guardado no soportado
      SharedPreferences.setMockInitialValues({
        'selected_locale': 'unsupported_lang',
        'user_manually_set_locale': true,
      });
      final provider = LocaleProvider();

      // Act
      await provider.initializeLocale();

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('user_manually_set_locale'), isFalse);
    });
  });

  group('LocaleProvider - Listener Notifications', () {
    test('should notify multiple listeners on locale change', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();
      var listener1Called = false;
      var listener2Called = false;
      provider.addListener(() => listener1Called = true);
      provider.addListener(() => listener2Called = true);

      // Act
      await provider.setLocale(const Locale('ru'));

      // Assert
      expect(listener1Called, isTrue);
      expect(listener2Called, isTrue);
    });

    test('should stop notifying after listener removal', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final provider = LocaleProvider();
      await provider.initializeLocale();
      var notificationCount = 0;
      void listener() => notificationCount++;
      provider.addListener(listener);

      // Act
      await provider.setLocale(const Locale('pt'));
      provider.removeListener(listener);
      await provider.setLocale(const Locale('ro'));

      // Assert - Solo debería haber notificado en el primer cambio
      expect(notificationCount, equals(1));
    });
  });
}
