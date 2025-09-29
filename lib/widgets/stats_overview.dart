import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../core/theme.dart';
import 'dart:math' as math;

class StatsOverview extends StatefulWidget {
  const StatsOverview({super.key});

  @override
  State<StatsOverview> createState() => _StatsOverviewState();
}

class _StatsOverviewState extends State<StatsOverview> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return Column(
          children: [
            // Indicadores de página con diseño unificado
            Card(
              margin: const EdgeInsets.all(0),
              color: AppColors.surfaceDark,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageIndicator(0, AppLocalizations.of(context)!.statsToday),
                    _buildPageIndicator(1, AppLocalizations.of(context)!.statsWeek),
                    _buildPageIndicator(2, AppLocalizations.of(context)!.statsMonth),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Contenido de la página actual
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildTodayPage(habitProvider),
                  _buildWeeklyPage(habitProvider),
                  _buildMonthlyPage(habitProvider),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator(int page, String label) {
    final isActive = _currentPage == page;

    // Definir color específico para cada pestaña según su contenedor
    Color activeColor;
    switch (page) {
      case 0: // Hoy - morado
        activeColor = AppColors.primaryLight;
        break;
      case 1: // Semana - turquesa/cyan
        activeColor = AppColors.secondary;
        break;
      case 2: // Mes - rosa
        activeColor = AppColors.accent;
        break;
      default:
        activeColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayPage(HabitProvider habitProvider) {
    final stats = habitProvider.getStats();
    final habitsToday = habitProvider.habitsForToday;
    final completedToday = habitsToday.where((h) => h.isCompletedToday).length;
    final totalToday = habitsToday.length;
    final completionRate = totalToday > 0 ? (completedToday / totalToday) : 0.0;
    final percentage = (completionRate * 100).round();

    return Card(
      margin: const EdgeInsets.all(0),
      color: AppColors.surfaceDark,
      elevation: 6,
      shadowColor: AppColors.primaryLight.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceDark,
              AppColors.primaryLight.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con fecha y saludo
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.today_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTodayDateString(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              letterSpacing: -0.5,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _getTimeGreeting(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondaryDark,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // MENSAJE MOTIVACIONAL COMPACTO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getProgressColor(percentage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getMotivationalIcon(percentage),
                        color: _getProgressColor(percentage),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _getShortMotivationalMessage(context, percentage),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getProgressColor(percentage),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Barra de progreso compacta
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.percentCompleted(percentage),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getProgressColor(percentage),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$completedToday/$totalToday',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColors.backgroundDark.withOpacity(0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: completionRate,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _getProgressColor(percentage),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Estadísticas mejoradas
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedStatCard(
                        context,
                        AppLocalizations.of(context)!.totalHabits,
                        '${stats['totalHabits']}',
                        Icons.assignment_outlined,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildEnhancedStatCard(
                        context,
                        AppLocalizations.of(context)!.completed,
                        '$completedToday',
                        Icons.check_circle_outline,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildEnhancedStatCard(
                        context,
                        AppLocalizations.of(context)!.currentStreak,
                        AppLocalizations.of(context)!.streakFormat(stats['currentStreak']),
                        Icons.local_fire_department_outlined,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyPage(HabitProvider habitProvider) {
    final weeklyProgress = _getWeeklyProgress(habitProvider.habits);
    final completionRate = weeklyProgress['total'] > 0 ? (weeklyProgress['completed'] / weeklyProgress['total']) : 0.0;
    final percentage = (weeklyProgress['percentage'] as double).round();

    return Card(
      margin: const EdgeInsets.all(0),
      color: AppColors.surfaceDark,
      elevation: 6,
      shadowColor: AppColors.secondary.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceDark,
              AppColors.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header semanal
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_view_week_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.weekNumber(_getWeekNumber(), DateTime.now().year),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _getWeekRange(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mensaje motivacional semanal compacto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getProgressColor(percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getMotivationalIcon(percentage),
                      color: _getProgressColor(percentage),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _getShortMotivationalMessage(context, percentage),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getProgressColor(percentage),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Barra de progreso semanal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.percentThisWeek(percentage),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '${weeklyProgress['completed']}/${weeklyProgress['total']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.backgroundDark.withOpacity(0.3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: completionRate,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _getProgressColor(percentage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Estadísticas semanales
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.scheduled,
                      '${weeklyProgress['total']}',
                      Icons.event_available_outlined,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.completed,
                      '${weeklyProgress['completed']}',
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.streak,
                      AppLocalizations.of(context)!.twoWeeks,
                      Icons.local_fire_department_outlined,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyPage(HabitProvider habitProvider) {
    final monthlyProgress = _getMonthlyProgress(habitProvider.habits);
    final completionRate = monthlyProgress['total'] > 0 ? (monthlyProgress['completed'] / monthlyProgress['total']) : 0.0;
    final percentage = (monthlyProgress['percentage'] as double).round();

    return Card(
      margin: const EdgeInsets.all(0),
      color: AppColors.surfaceDark,
      elevation: 6,
      shadowColor: AppColors.accent.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceDark,
              AppColors.accent.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header mensual
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getMonthName(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          AppLocalizations.of(context)!.dayOfMonth(DateTime.now().day, _getDaysInCurrentMonth()),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mensaje motivacional mensual compacto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getProgressColor(percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getMotivationalIcon(percentage),
                      color: _getProgressColor(percentage),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _getShortMotivationalMessage(context, percentage),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getProgressColor(percentage),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Barra de progreso mensual
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.percentThisMonth(percentage),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '${monthlyProgress['completed']}/${monthlyProgress['total']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.backgroundDark.withOpacity(0.3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: completionRate,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _getProgressColor(percentage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Estadísticas mensuales
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.scheduled,
                      '${monthlyProgress['total']}',
                      Icons.event_available_outlined,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.completed,
                      '${monthlyProgress['completed']}',
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      AppLocalizations.of(context)!.streak,
                      AppLocalizations.of(context)!.oneMonth,
                      Icons.local_fire_department_outlined,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getWeeklyProgress(List<Habit> habits) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    int totalCompleted = 0;
    int totalScheduled = 0;

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStr = day.toDateString();

      for (final habit in habits) {
        if (habit.frequency.contains(day.weekday)) {
          totalScheduled++;
          if (habit.completions[dayStr] ?? false) {
            totalCompleted++;
          }
        }
      }
    }

    final percentage = totalScheduled > 0 ? (totalCompleted / totalScheduled) * 100 : 0.0;
    return {
      'completed': totalCompleted,
      'total': totalScheduled,
      'percentage': percentage,
    };
  }

  Map<String, dynamic> _getMonthlyProgress(List<Habit> habits) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    int totalCompleted = 0;
    int totalScheduled = 0;

    for (int i = 0; i < daysInMonth; i++) {
      final day = monthStart.add(Duration(days: i));
      if (day.isAfter(now)) break;

      final dayStr = day.toDateString();

      for (final habit in habits) {
        if (habit.frequency.contains(day.weekday)) {
          totalScheduled++;
          if (habit.completions[dayStr] ?? false) {
            totalCompleted++;
          }
        }
      }
    }

    final percentage = totalScheduled > 0 ? (totalCompleted / totalScheduled) * 100 : 0.0;
    return {
      'completed': totalCompleted,
      'total': totalScheduled,
      'percentage': percentage,
    };
  }

  // Métodos auxiliares mejorados
  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppLocalizations.of(context)!.goodMorning;
    if (hour < 18) return AppLocalizations.of(context)!.goodAfternoon;
    return AppLocalizations.of(context)!.goodEvening;
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    final months = [
      '', AppLocalizations.of(context)!.january, AppLocalizations.of(context)!.february, AppLocalizations.of(context)!.march, AppLocalizations.of(context)!.april, AppLocalizations.of(context)!.may, AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july, AppLocalizations.of(context)!.august, AppLocalizations.of(context)!.september, AppLocalizations.of(context)!.october, AppLocalizations.of(context)!.november, AppLocalizations.of(context)!.december
    ];
    final days = ['', AppLocalizations.of(context)!.mondayFull, AppLocalizations.of(context)!.tuesdayFull, AppLocalizations.of(context)!.wednesdayFull, AppLocalizations.of(context)!.thursdayFull, AppLocalizations.of(context)!.fridayFull, AppLocalizations.of(context)!.saturdayFull, AppLocalizations.of(context)!.sundayFull];

    return AppLocalizations.of(context)!.dateFormat(now.day, months[now.month]);
  }

  String _getWeekRange() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final months = [
      '', AppLocalizations.of(context)!.januaryShort, AppLocalizations.of(context)!.februaryShort, AppLocalizations.of(context)!.marchShort, AppLocalizations.of(context)!.aprilShort, AppLocalizations.of(context)!.mayShort, AppLocalizations.of(context)!.juneShort,
      AppLocalizations.of(context)!.julyShort, AppLocalizations.of(context)!.augustShort, AppLocalizations.of(context)!.septemberShort, AppLocalizations.of(context)!.octoberShort, AppLocalizations.of(context)!.novemberShort, AppLocalizations.of(context)!.decemberShort
    ];

    return AppLocalizations.of(context)!.dateRangeFormat(weekStart.day, months[weekStart.month], weekEnd.day, months[weekEnd.month]);
  }

  int _getWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(firstDayOfYear).inDays + 1;
    return (dayOfYear / 7).ceil();
  }

  String _getMonthName() {
    final months = [
      '', AppLocalizations.of(context)!.january, AppLocalizations.of(context)!.february, AppLocalizations.of(context)!.march, AppLocalizations.of(context)!.april, AppLocalizations.of(context)!.may, AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july, AppLocalizations.of(context)!.august, AppLocalizations.of(context)!.september, AppLocalizations.of(context)!.october, AppLocalizations.of(context)!.november, AppLocalizations.of(context)!.december
    ];

    final now = DateTime.now();
    return AppLocalizations.of(context)!.monthYear(months[now.month], now.year);
  }

  int _getDaysInCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  Color _getProgressColor(int percentage) {
    if (percentage >= 90) return AppColors.success;
    if (percentage >= 70) return AppColors.primary;
    if (percentage >= 50) return AppColors.secondary;
    if (percentage >= 30) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getMotivationalIcon(int percentage) {
    if (percentage >= 90) return Icons.celebration_rounded;
    if (percentage >= 70) return Icons.emoji_emotions_rounded;
    if (percentage >= 50) return Icons.thumb_up_rounded;
    if (percentage >= 30) return Icons.trending_up_rounded;
    return Icons.rocket_launch_rounded;
  }

  String _getMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return AppLocalizations.of(context)!.motivationPerfectDay;
    } else if (percentage >= 90) {
      return AppLocalizations.of(context)!.motivationAlmostPerfect;
    } else if (percentage >= 70) {
      return AppLocalizations.of(context)!.motivationExcellentDay;
    } else if (percentage >= 50) {
      return AppLocalizations.of(context)!.motivationGoodProgress;
    } else if (percentage >= 30) {
      return AppLocalizations.of(context)!.motivationStarted;
    } else if (percentage > 0) {
      return AppLocalizations.of(context)!.motivationFirstStep;
    } else {
      return AppLocalizations.of(context)!.motivationYourMoment;
    }
  }

  String _getWeeklyMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return AppLocalizations.of(context)!.motivationPerfectWeek;
    } else if (percentage >= 90) {
      return AppLocalizations.of(context)!.motivationBrutalWeek;
    } else if (percentage >= 70) {
      return AppLocalizations.of(context)!.motivationGreatWeek;
    } else if (percentage >= 50) {
      return AppLocalizations.of(context)!.motivationGoodRhythm;
    } else if (percentage >= 30) {
      return AppLocalizations.of(context)!.motivationProgressing;
    } else if (percentage > 0) {
      return AppLocalizations.of(context)!.motivationStartedWeek;
    } else {
      return AppLocalizations.of(context)!.motivationNewWeek;
    }
  }

  String _getMonthlyMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return AppLocalizations.of(context)!.motivationLegendaryMonth;
    } else if (percentage >= 90) {
      return AppLocalizations.of(context)!.motivationEpicMonth;
    } else if (percentage >= 70) {
      return AppLocalizations.of(context)!.motivationSolidMonth;
    } else if (percentage >= 50) {
      return '¡Buen mes! 📊\nVas progresando.\n¡Sigue mejorando!';
    } else if (percentage >= 30) {
      return '¡Construyendo! 🏗️\nCada mes cuenta.\n¡Pa\'lante!';
    } else if (percentage > 0) {
      return '¡Semillas plantadas! 🌱\nYa comenzaste.\n¡Crecerás!';
    } else {
      return '¡Nuevo mes! 🚀\nInfinitas posibilidades.\n¡Hazlo tuyo!';
    }
  }

  String _getShortMotivationalMessage(BuildContext context, int percentage) {
    if (percentage == 100) {
      return AppLocalizations.of(context)!.motivationPerfectShort;
    } else if (percentage >= 90) {
      return AppLocalizations.of(context)!.motivationAlmostPerfectShort;
    } else if (percentage >= 70) {
      return AppLocalizations.of(context)!.motivationExcellentShort;
    } else if (percentage >= 50) {
      return AppLocalizations.of(context)!.motivationGoodProgressShort;
    } else if (percentage >= 30) {
      return AppLocalizations.of(context)!.motivationStartedShort;
    } else if (percentage > 0) {
      return AppLocalizations.of(context)!.motivationFirstStepShort;
    } else {
      return AppLocalizations.of(context)!.motivationYourMomentShort;
    }
  }
}