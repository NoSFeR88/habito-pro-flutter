import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/habit_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/gamification_provider.dart';
import 'providers/notification_settings_provider.dart';
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

  // Configurar modo immersive (ocultar botones de navegación Android)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  // Configurar estilo de la barra de estado (transparente)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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
  themeProvider.setPremiumProvider(premiumProvider); // Conectar premium provider
  debugPrint('✅ Theme provider inicializado con premium provider');

  // Inicializar GamificationProvider
  final gamificationProvider = GamificationProvider();
  debugPrint('✅ Gamification provider inicializado');

  // Inicializar NotificationSettingsProvider
  final notificationSettingsProvider = NotificationSettingsProvider();
  await notificationSettingsProvider.loadSettings();
  debugPrint('✅ Notification settings provider inicializado');

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
    notificationSettingsProvider: notificationSettingsProvider,
  ));
}

class HabitApp extends StatefulWidget {
  final LocaleProvider localeProvider;
  final OnboardingProvider onboardingProvider;
  final PremiumProvider premiumProvider;
  final ThemeProvider themeProvider;
  final GamificationProvider gamificationProvider;
  final NotificationSettingsProvider notificationSettingsProvider;

  const HabitApp({
    Key? key,
    required this.localeProvider,
    required this.onboardingProvider,
    required this.premiumProvider,
    required this.themeProvider,
    required this.gamificationProvider,
    required this.notificationSettingsProvider,
  }) : super(key: key);

  @override
  State<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends State<HabitApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-apply immersive mode when app resumes
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider.value(value: widget.localeProvider),
        ChangeNotifierProvider.value(value: widget.onboardingProvider),
        ChangeNotifierProvider.value(value: widget.premiumProvider),
        ChangeNotifierProvider.value(value: widget.themeProvider),
        ChangeNotifierProvider.value(value: widget.gamificationProvider),
        ChangeNotifierProvider.value(value: widget.notificationSettingsProvider),
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
                  return Scaffold(
                    backgroundColor: const Color(0xFF2D2B42),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.loadingApp,
                            style: const TextStyle(
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