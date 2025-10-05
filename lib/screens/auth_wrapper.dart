import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../generated/l10n/app_localizations.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Mostrar splash mientras carga
        if (authProvider.isLoading) {
          return const SplashScreen();
        }

        // Si hay usuario, inicializar hábitos y mostrar home
        if (authProvider.isSignedIn) {
          return Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              // Inicializar hábitos una vez que el usuario esté autenticado
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (habitProvider.habits.isEmpty && !habitProvider.isLoading) {
                  habitProvider.initializeHabits();
                }
              });

              return const HomeScreen();
            },
          );
        }

        // Si no hay usuario, mostrar login
        return const LoginScreen();
      },
    );
  }
}

// Versión extendida del AuthWrapper que incluye lógica de onboarding
class AuthWrapperWithOnboarding extends StatefulWidget {
  const AuthWrapperWithOnboarding({Key? key}) : super(key: key);

  @override
  State<AuthWrapperWithOnboarding> createState() => _AuthWrapperWithOnboardingState();
}

class _AuthWrapperWithOnboardingState extends State<AuthWrapperWithOnboarding> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  void _initializeSplash() async {
    // Mostrar splash por al menos 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isSignedIn) {
          return Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              return _UserAuthenticatedScreen(
                authProvider: authProvider,
                habitProvider: habitProvider,
              );
            },
          );
        }

        return const LoginScreen();
      },
    );
  }
}

class _UserAuthenticatedScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final HabitProvider habitProvider;

  const _UserAuthenticatedScreen({
    required this.authProvider,
    required this.habitProvider,
  });

  @override
  State<_UserAuthenticatedScreen> createState() => _UserAuthenticatedScreenState();
}

class _UserAuthenticatedScreenState extends State<_UserAuthenticatedScreen> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() async {
    if (_hasInitialized) return;
    
    try {
      // Inicializar hábitos del usuario
      await widget.habitProvider.initializeHabits();
      
      // Si es usuario anónimo y no tiene hábitos, crear ejemplos
      // if (widget.authProvider.isAnonymous && widget.habitProvider.habits.isEmpty) {
      //   widget.habitProvider.createSampleHabits();
      // }
      
      _hasInitialized = true;
    } catch (e) {
      print('User data initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar indicador de carga si los hábitos aún no se han cargado
    if (!_hasInitialized || widget.habitProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.loadingHabits),
            ],
          ),
        ),
      );
    }

    // Mostrar mensaje de bienvenida para usuarios anónimos
    if (widget.authProvider.isAnonymous) {
      return _AnonymousUserWrapper(
        child: const HomeScreen(),
      );
    }

    return const HomeScreen();
  }
}

class _AnonymousUserWrapper extends StatelessWidget {
  final Widget child;

  const _AnonymousUserWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Banner informativo para usuario anónimo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.orange.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.guestModeWarning,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showCreateAccountDialog(context),
                      child: Text(
                        AppLocalizations.of(context)!.createAccount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.saveYourProgressTitle),
          content: Text(
            AppLocalizations.of(context)!.createAccountDescription,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.later),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final success = await authProvider.linkAnonymousWithGoogle();
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.accountCreatedSuccess),
                        ),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.createAccount),
                );
              },
            ),
          ],
        );
      },
    );
  }
}