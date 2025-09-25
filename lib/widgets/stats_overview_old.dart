import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../core/theme.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final stats = habitProvider.getStats();
        final habitsToday = habitProvider.habitsForToday;
        final completedToday = habitsToday.where((h) => h.isCompletedToday).length;
        final totalToday = habitsToday.length;
        final completionRate = totalToday > 0 ? (completedToday / totalToday) : 0.0;
        final weeklyProgress = _getWeeklyProgress(habitProvider.habits);
        final monthlyProgress = _getMonthlyProgress(habitProvider.habits);
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insights,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tu progreso hoy',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Barra de progreso principal
                _buildProgressSection(context, completionRate, stats),
                const SizedBox(height: 20),
                
                // Estadísticas en grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total',
                        '${stats['totalHabits']}',
                        Icons.list_alt,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Completados',
                        '${stats['completedToday']}',
                        Icons.check_circle,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Racha',
                        '${stats['currentStreak']}',
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(BuildContext context, double completionRate, Map<String, dynamic> stats) {
    final percentage = (completionRate * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$percentage% completado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$completedToday/$totalToday',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Barra de progreso animada
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: completionRate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Progreso semanal y mensual
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                context,
                'Esta semana',
                weeklyProgress,
                Icons.calendar_view_week,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProgressCard(
                context,
                'Este mes',
                monthlyProgress,
                Icons.calendar_month,
                Colors.purple,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Mensaje motivacional
        Text(
          _getMotivationalMessage((completionRate * 100).round()),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    Map<String, dynamic> progress,
    IconData icon,
    Color color,
  ) {
    final percentage = progress['percentage'] as double;
    final completed = progress['completed'] as int;
    final total = progress['total'] as int;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.round()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$completed/$total',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
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
      if (day.isAfter(now)) break; // No contar días futuros

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

  String _getMotivationalMessage(int percentage) {
    if (percentage == 100) {
      return '¡Increíble! Has completado todos tus hábitos hoy 🎉';
    } else if (percentage >= 80) {
      return '¡Excelente progreso! Solo te falta un poco más 💪';
    } else if (percentage >= 60) {
      return '¡Buen trabajo! Vas por buen camino 👍';
    } else if (percentage >= 40) {
      return 'Sigue así, cada pequeño paso cuenta 🚶‍♂️';
    } else if (percentage > 0) {
      return 'Has empezado, eso ya es un gran paso 🌱';
    } else {
      return 'Es un nuevo día, ¡comienza con tu primer hábito! ⭐';
    }
  }
}