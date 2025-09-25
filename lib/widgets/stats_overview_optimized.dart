import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageIndicator(0, 'Hoy'),
                    _buildPageIndicator(1, 'Semana'),
                    _buildPageIndicator(2, 'Mes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
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
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.primary,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con fecha y saludo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.today_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTodayDateString(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getTimeGreeting(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // MENSAJE MOTIVACIONAL PROMINENTE (sin scroll necesario)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getProgressColor(percentage).withOpacity(0.15),
                      _getProgressColor(percentage).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getProgressColor(percentage).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getMotivationalIcon(percentage),
                      color: _getProgressColor(percentage),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMotivationalMessage(percentage),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _getProgressColor(percentage),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Barra de progreso compacta
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percentage% Completado',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '$completedToday/$totalToday',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                          borderRadius: BorderRadius.circular(4),
                          color: _getProgressColor(percentage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Estadísticas mejoradas
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Total Hábitos',
                      '${stats['totalHabits']}',
                      Icons.assignment_outlined,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Completados',
                      '$completedToday',
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Racha Actual',
                      '${stats['currentStreak']} días',
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
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header semanal
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_view_week_rounded,
                      color: AppColors.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semana ${_getWeekNumber()} del ${DateTime.now().year}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getWeekRange(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Mensaje motivacional semanal prominente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getProgressColor(percentage).withOpacity(0.15),
                      _getProgressColor(percentage).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getProgressColor(percentage).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getMotivationalIcon(percentage),
                      color: _getProgressColor(percentage),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getWeeklyMotivationalMessage(percentage),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _getProgressColor(percentage),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Barra de progreso semanal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percentage% Esta semana',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '$completedWeek/$totalWeek',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                          borderRadius: BorderRadius.circular(4),
                          color: _getProgressColor(percentage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Estadísticas semanales
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Programados',
                      '${weeklyProgress['total']}',
                      Icons.event_available_outlined,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Completados',
                      '${weeklyProgress['completed']}',
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Racha',
                      '2 sem.',
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
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header mensual
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getMonthName(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Día ${DateTime.now().day} de ${_getDaysInCurrentMonth()}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Mensaje motivacional mensual prominente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getProgressColor(percentage).withOpacity(0.15),
                      _getProgressColor(percentage).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getProgressColor(percentage).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getMotivationalIcon(percentage),
                      color: _getProgressColor(percentage),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMonthlyMotivationalMessage(percentage),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _getProgressColor(percentage),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Barra de progreso mensual
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percentage% Este mes',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '$completedMonth/$totalMonth',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                          borderRadius: BorderRadius.circular(4),
                          color: _getProgressColor(percentage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Estadísticas mensuales
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Programados',
                      '${monthlyProgress['total']}',
                      Icons.event_available_outlined,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Completados',
                      '${monthlyProgress['completed']}',
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedStatCard(
                      context,
                      'Racha',
                      '1 mes',
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
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
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    final months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final days = ['', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    return '${days[now.weekday]}, ${now.day} de ${months[now.month]}';
  }

  String _getWeekRange() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final months = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    return '${weekStart.day} ${months[weekStart.month]} - ${weekEnd.day} ${months[weekEnd.month]}';
  }

  int _getWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(firstDayOfYear).inDays + 1;
    return (dayOfYear / 7).ceil();
  }

  String _getMonthName() {
    final months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    final now = DateTime.now();
    return '${months[now.month]} ${now.year}';
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
      return '¡PERFECTO! 🎆\nHas completado TODO hoy.\n¡Eres imparable!';
    } else if (percentage >= 90) {
      return '¡Casi perfecto! 🌟\nSolo te falta un poquito.\n¡Tú puedes!';
    } else if (percentage >= 70) {
      return '¡Excelente día! 💪\nVas súper bien.\n¡Sigue así!';
    } else if (percentage >= 50) {
      return '¡Buen progreso! 🚀\nVas por buen camino.\n¡No pares!';
    } else if (percentage >= 30) {
      return '¡Ya empezaste! 🌱\nCada paso cuenta.\n¡Continúa!';
    } else if (percentage > 0) {
      return '¡Primer paso! ⭐\nLo más difícil ya pasó.\n¡Sigue!';
    } else {
      return '¡Tu momento! 🌅\nComienza ahora.\n¡Hazlo realidad!';
    }
  }

  String _getWeeklyMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return '¡SEMANA PERFECTA! 🏆\nDominaste todos tus hábitos.\n¡Eres increíble!';
    } else if (percentage >= 90) {
      return '¡Semana brutal! 🔥\nCasi perfecto.\n¡Eres un crack!';
    } else if (percentage >= 70) {
      return '¡Gran semana! 💪\nTu disciplina paga.\n¡Bien ahí!';
    } else if (percentage >= 50) {
      return '¡Buen ritmo! 📈\nVas construyendo.\n¡Sigue así!';
    } else if (percentage >= 30) {
      return '¡Progresando! 🌱\nCada semana cuenta.\n¡No pares!';
    } else if (percentage > 0) {
      return '¡Empezaste! ✨\nYa diste el primer paso.\n¡Mejoremos!';
    } else {
      return '¡Nueva semana! 🌟\nFresh start.\n¡Hazla épica!';
    }
  }

  String _getMonthlyMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return '¡MES LEGENDARIO! 👑\nPerfección total.\n¡Eres inspiración!';
    } else if (percentage >= 90) {
      return '¡Mes épico! 🎆\nResultados increíbles.\n¡Imparable!';
    } else if (percentage >= 70) {
      return '¡Sólido mes! 💪\nTu constancia paga.\n¡Genial trabajo!';
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
}