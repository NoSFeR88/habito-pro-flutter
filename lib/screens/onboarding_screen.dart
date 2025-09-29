import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/habit.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Para la pantalla 3 - Configuración de hábito
  final TextEditingController _habitNameController = TextEditingController();
  final List<bool> _selectedDays = List.filled(7, false);
  bool _isCreatingHabit = false;

  @override
  void initState() {
    super.initState();
    // Pre-llenar ejemplo para mejorar UX
    _habitNameController.text = 'Ir al gimnasio';
    // Pre-seleccionar Lun-Mié-Vie (índices 0, 2, 4)
    _selectedDays[0] = true; // Lunes
    _selectedDays[2] = true; // Miércoles
    _selectedDays[4] = true; // Viernes
  }

  @override
  void dispose() {
    _pageController.dispose();
    _habitNameController.dispose();
    super.dispose();
  }

  Future<void> _createFirstHabit() async {
    if (_habitNameController.text.trim().isEmpty) return;

    setState(() => _isCreatingHabit = true);

    try {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);

      // Convertir selectedDays (bool) a frequency (int) - días 1-7 (Lun-Dom)
      final List<int> frequency = [];
      for (int i = 0; i < _selectedDays.length; i++) {
        if (_selectedDays[i]) {
          frequency.add(i + 1); // 1=Lun, 2=Mar, etc.
        }
      }

      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _habitNameController.text.trim(),
        description: 'Mi primer hábito flexible en Ritmo',
        icon: Icons.fitness_center,
        color: AppColors.primary.value,
        frequency: frequency,
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      await habitProvider.addHabit(habit);

      // Marcar onboarding como completado
      final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
      await onboardingProvider.completeOnboarding();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creando hábito: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingHabit = false);
      }
    }
  }

  Future<void> _completeOnboarding() async {
    await _createFirstHabit();
    // El cambio de pantalla se maneja automáticamente por el Consumer en main.dart
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() async {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    await onboardingProvider.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header con skip y progreso
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: TextStyle(color: AppColors.textSecondaryDark),
                    ),
                  ),
                  // Indicador de progreso
                  Row(
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.surfaceDark,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomePage(l10n),
                  _buildProblemSolutionPage(l10n),
                  _buildQuickSetupPage(l10n),
                  _buildCelebrationPage(l10n),
                ],
              ),
            ),

            // Footer con botón principal
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCreatingHabit ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isCreatingHabit
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _getButtonText(l10n),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(AppLocalizations l10n) {
    switch (_currentPage) {
      case 0: return l10n.onboardingDiscoverDifference;
      case 1: return l10n.onboardingThisSounds;
      case 2: return l10n.onboardingCreateFirstHabit;
      case 3: return l10n.onboardingStartMyRhythm;
      default: return l10n.next;
    }
  }

  Widget _buildWelcomePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo animado
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.waves,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 48),

          Text(
            l10n.onboardingWelcomeTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            l10n.onboardingWelcomeSubtitle,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondaryDark,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Características clave
          Column(
            children: [
              _buildFeatureRow(
                Icons.schedule_outlined,
                l10n.onboardingFeatureFlexible,
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(
                Icons.psychology_outlined,
                l10n.onboardingFeatureMotivating,
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(
                Icons.language_outlined,
                l10n.onboardingFeature26Languages,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProblemSolutionPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            size: 80,
            color: AppColors.warning,
          ),

          const SizedBox(height: 32),

          Text(
            l10n.onboardingProblemTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Problema vs Solución
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.close, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.onboardingOtherApps,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingProblemExample,
                  style: TextStyle(color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.check, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Ritmo:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingSolutionExample,
                  style: TextStyle(color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            l10n.onboardingFlexibilityMessage,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSetupPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Icon(
            Icons.auto_awesome,
            size: 60,
            color: AppColors.primary,
          ),

          const SizedBox(height: 20),

          Text(
            l10n.onboardingSetupTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Formulario de hábito
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.habitNameHint,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _habitNameController,
                  style: TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: l10n.habitNameHint,
                    hintStyle: TextStyle(color: AppColors.textSecondaryDark),
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  l10n.selectDays,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Selector de días
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    final dayNames = [
                      l10n.mondayShort, l10n.tuesdayShort, l10n.wednesdayShort,
                      l10n.thursdayShort, l10n.fridayShort, l10n.saturdayShort, l10n.sundayShort
                    ];

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDays[index] = !_selectedDays[index]),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedDays[index]
                            ? AppColors.primary
                            : AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedDays[index]
                              ? AppColors.primary
                              : AppColors.textSecondaryDark.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            dayNames[index],
                            style: TextStyle(
                              color: _selectedDays[index]
                                ? Colors.white
                                : AppColors.textSecondaryDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            l10n.onboardingFlexibilityTip,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryDark,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.success, AppColors.success.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.celebration,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            l10n.onboardingCelebrationTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            l10n.onboardingCelebrationSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryDark,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Preview del hábito creado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _habitNameController.text.isNotEmpty
                              ? _habitNameController.text
                              : l10n.onboardingDefaultHabitName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            _getSelectedDaysText(l10n),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Beneficios
          Column(
            children: [
              _buildBenefitRow(Icons.schedule, l10n.onboardingBenefitFlexibility),
              const SizedBox(height: 8),
              _buildBenefitRow(Icons.trending_up, l10n.onboardingBenefitMotivation),
              const SizedBox(height: 8),
              _buildBenefitRow(Icons.language, l10n.onboardingBenefit26Languages),
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: AppColors.success, size: 20),
        const SizedBox(width: 8),
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  String _getSelectedDaysText(AppLocalizations l10n) {
    final dayNames = [
      l10n.mondayShort, l10n.tuesdayShort, l10n.wednesdayShort,
      l10n.thursdayShort, l10n.fridayShort, l10n.saturdayShort, l10n.sundayShort
    ];

    final selectedDayNames = <String>[];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        selectedDayNames.add(dayNames[i]);
      }
    }

    return selectedDayNames.isEmpty
      ? l10n.onboardingNoDaysSelected
      : selectedDayNames.join('-');
  }
}