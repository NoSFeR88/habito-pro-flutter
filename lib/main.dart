import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'providers/habit_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación (opcional)
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

  runApp(HabitApp(localeProvider: localeProvider));
}

class HabitApp extends StatelessWidget {
  final LocaleProvider localeProvider;

  const HabitApp({Key? key, required this.localeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Habit Pro',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,

            // Internationalization setup
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            locale: localeProvider.locale,

            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}