import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'providers/habit_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/gamification_provider.dart';
import 'services/ads_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación (solo vertical para una mejor experiencia)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase inicializado correctamente');
  } catch (e) {
    debugPrint('❌ Error inicializando Firebase: $e');
    // Continuar la ejecución aunque falle Firebase
  }

  // Inicializar servicios críticos
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    debugPrint('✅ Servicios de notificaciones inicializados correctamente');
  } catch (e) {
    debugPrint('⚠️ Error inicializando servicios de notificaciones: $e');
    // Continuar la ejecución aunque falle la inicialización
  }

  // Inicializar LocaleProvider
  final localeProvider = LocaleProvider();
  await localeProvider.initializeLocale();
  debugPrint('✅ Localización inicializada: ${localeProvider.currentLanguageCode}');

  // Inicializar OnboardingProvider
  final onboardingProvider = OnboardingProvider();
  await onboardingProvider.checkFirstTime();
  debugPrint('✅ Onboarding provider inicializado: primera vez = ${onboardingProvider.isFirstTime}');

  // Inicializar PremiumProvider
  final premiumProvider = PremiumProvider();
  await premiumProvider.initializePremiumStatus();
  debugPrint('✅ Premium provider inicializado: premium = ${premiumProvider.isPremium}');

  // Inicializar ThemeProvider
  final themeProvider = ThemeProvider();
  debugPrint('✅ Theme provider inicializado');

  // Inicializar GamificationProvider
  final gamificationProvider = GamificationProvider();
  debugPrint('✅ Gamification provider inicializado');

  // Inicializar AdsService solo si no es premium - TEMPORALMENTE DESHABILITADO
  /*if (!premiumProvider.isPremium) {
    try {
      await AdsService().initialize();
      debugPrint('✅ AdsService inicializado para usuario free');
    } catch (e) {
      debugPrint('⚠️ Error inicializando AdsService: $e');
    }
  }*/
  debugPrint('🚫 AdsService temporalmente deshabilitado para testing');

  runApp(HabitApp(
    localeProvider: localeProvider,
    onboardingProvider: onboardingProvider,
    premiumProvider: premiumProvider,
    themeProvider: themeProvider,
    gamificationProvider: gamificationProvider,
  ));
}

class HabitApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  final OnboardingProvider onboardingProvider;
  final PremiumProvider premiumProvider;
  final ThemeProvider themeProvider;
  final GamificationProvider gamificationProvider;

  const HabitApp({
    Key? key,
    required this.localeProvider,
    required this.onboardingProvider,
    required this.premiumProvider,
    required this.themeProvider,
    required this.gamificationProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: onboardingProvider),
        ChangeNotifierProvider.value(value: premiumProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: gamificationProvider),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Ritmo',
            theme: themeProvider.getLightTheme(),
            darkTheme: themeProvider.getDarkTheme(),
            themeMode: themeProvider.materialThemeMode,

            // Internationalization setup
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            locale: localeProvider.locale,

            home: Consumer<OnboardingProvider>(
              builder: (context, onboardingProvider, child) {
                if (onboardingProvider.isLoading) {
                  return const Scaffold(
                    backgroundColor: Color(0xFF2D2B42),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Iniciando Ritmo...',
                            style: TextStyle(
                              color: Color(0xFFF8FAFC),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return onboardingProvider.isFirstTime
                  ? const OnboardingScreen()
                  : const HomeScreen();
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}