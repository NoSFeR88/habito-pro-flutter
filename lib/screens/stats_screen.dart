import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../generated/l10n/app_localizations.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLegendExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.statistics),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.today), text: AppLocalizations.of(context)!.today),
            Tab(icon: Icon(Icons.show_chart), text: AppLocalizations.of(context)!.week),
            Tab(icon: Icon(Icons.trending_up), text: AppLocalizations.of(context)!.trends),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildWeeklyTab(),
          _buildTrendsTab(),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final stats = habitProvider.getStats();
        final habitsToday = habitProvider.habitsForToday;
        final completedToday = habitsToday.where((h) => h.isCompletedToday).length;
        final totalToday = habitsToday.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCards(stats, completedToday, totalToday),
              const SizedBox(height: 24),
              _buildCompletionChart(completedToday, totalToday),
              const SizedBox(height: 24),
              _buildHabitsListToday(habitsToday),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards(Map<String, dynamic> stats, int completedToday, int totalToday) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.completedHabits,
            '$completedToday/$totalToday',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.maxStreak,
            '${stats['currentStreak']} días',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.percentage,
            '${(stats['completionRate'] * 100).toInt()}%',
            Icons.percent,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionChart(int completed, int total) {
    final pending = total - completed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.progressToday,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 140,
              child: total > 0 ? PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completed.toDouble(),
                      title: '$completed\n${AppLocalizations.of(context)!.completedCount}',
                      color: Colors.green,
                      radius: 55,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      titlePositionPercentageOffset: 0.55,
                    ),
                    PieChartSectionData(
                      value: pending.toDouble(),
                      title: '$pending\n${AppLocalizations.of(context)!.pendingCount}',
                      color: Colors.grey[400]!,
                      radius: 55,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      titlePositionPercentageOffset: 0.55,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ) : Center(
                child: Text(AppLocalizations.of(context)!.noHabitsToShow),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsListToday(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.todaysHabits,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (habits.isEmpty)
              Text(AppLocalizations.of(context)!.noHabitsScheduledToday)
            else
              ...habits.map((habit) => _buildHabitListItem(habit)),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitListItem(Habit habit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(habit.color).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              habit.icon,
              color: Color(habit.color),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (habit.description.isNotEmpty)
                  Text(
                    habit.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            habit.isCompletedToday ? Icons.check_circle : Icons.radio_button_unchecked,
            color: habit.isCompletedToday ? Colors.green : Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildWeeklyChart(habitProvider.habits),
              const SizedBox(height: 24),
              _buildWeeklyHeatmap(habitProvider.habits),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyChart(List<Habit> habits) {
    final weekData = _getWeekData(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weeklyProgress,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                          return Text(days[value.toInt() % 7]);
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weekData,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getWeekData(List<Habit> habits) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStr = day.toDateString();

      int completed = 0;
      int total = 0;

      for (final habit in habits) {
        if (habit.frequency.contains(day.weekday)) {
          total++;
          if (habit.completions[dayStr] ?? false) {
            completed++;
          }
        }
      }

      final percentage = total > 0 ? (completed / total) * 100 : 0.0;
      spots.add(FlSpot(i.toDouble(), percentage.toDouble()));
    }

    return spots;
  }

  Widget _buildWeeklyHeatmap(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weeklyHeatMap,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHeatmapGrid(habits),
            const SizedBox(height: 16),
            _buildExpandableLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableLegend() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header clickeable
          InkWell(
            onTap: () {
              setState(() {
                _isLegendExpanded = !_isLegendExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'Leyenda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isLegendExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          // Contenido expandible
          if (_isLegendExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildLegendItem(Colors.green, '✓', 'Completado'),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.red[200]!, '', 'Pendiente'),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.grey[400]!, '', 'No programado'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: icon.isNotEmpty
              ? Center(
                  child: Text(
                    icon,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapGrid(List<Habit> habits) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        // Header con días
        Row(
          children: [
            const SizedBox(width: 80),
            ...days.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: 8),
        // Filas de hábitos
        ...habits.map((habit) => _buildHeatmapRow(habit, weekStart)),
      ],
    );
  }

  Widget _buildHeatmapRow(Habit habit, DateTime weekStart) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              habit.name,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...List.generate(7, (index) {
            final day = weekStart.add(Duration(days: index));
            final dayStr = day.toDateString();
            final isScheduled = habit.frequency.contains(day.weekday);
            final isCompleted = habit.completions[dayStr] ?? false;

            Color color;
            if (!isScheduled) {
              color = Colors.grey[400]!;
            } else if (isCompleted) {
              color = Colors.green;
            } else {
              color = Colors.red[200]!;
            }

            return Expanded(
              child: Container(
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isScheduled && isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMonthlyProgressChart(habitProvider.habits),
              const SizedBox(height: 24),
              _buildHabitStreaksChart(habitProvider.habits),
              const SizedBox(height: 24),
              _buildMonthlyHeatmap(habitProvider.habits),
              const SizedBox(height: 24),
              _buildMonthlyStats(habitProvider.habits),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyProgressChart(List<Habit> habits) {
    final monthlyData = _getMonthlyData(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyProgress,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final weeks = ['S1', 'S2', 'S3', 'S4'];
                          final index = value.toInt();
                          return index < weeks.length ? Text(weeks[index]) : const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitStreaksChart(List<Habit> habits) {
    final streakData = _getStreakData(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.habitStreaks,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: streakData.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b) + 2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${habits[groupIndex].name}\n${rod.toY.round()} días',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index < habits.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                habits[index].name.length > 8
                                  ? '${habits[index].name.substring(0, 8)}...'
                                  : habits[index].name,
                                style: const TextStyle(
                                  color: Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    habits.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: streakData[index],
                          color: Color(habits[index].color),
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
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

  Widget _buildMonthlyHeatmap(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyCalendar,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalendarHeatmap(habits),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyStats(List<Habit> habits) {
    final stats = _getMonthlyStatistics(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyStats,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    AppLocalizations.of(context)!.activeDays,
                    '${stats['activeDays']}',
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    AppLocalizations.of(context)!.bestStreak,
                    '${stats['bestStreak']} días',
                    Icons.whatshot,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    AppLocalizations.of(context)!.averageCompletion,
                    '${stats['averageCompletion']}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getMonthlyData(List<Habit> habits) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final spots = <FlSpot>[];

    for (int week = 0; week < 4; week++) {
      final weekStart = monthStart.add(Duration(days: week * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      int completed = 0;
      int total = 0;

      for (int day = 0; day < 7; day++) {
        final currentDay = weekStart.add(Duration(days: day));
        if (currentDay.month != now.month || currentDay.isAfter(weekEnd)) continue;

        final dayStr = currentDay.toDateString();

        for (final habit in habits) {
          if (habit.frequency.contains(currentDay.weekday)) {
            total++;
            if (habit.completions[dayStr] ?? false) {
              completed++;
            }
          }
        }
      }

      final percentage = total > 0 ? (completed / total) * 100 : 0.0;
      spots.add(FlSpot(week.toDouble(), percentage.toDouble()));
    }

    return spots;
  }

  List<double> _getStreakData(List<Habit> habits) {
    return habits.map((habit) {
      return _calculateCurrentStreak(habit).toDouble();
    }).toList();
  }

  int _calculateCurrentStreak(Habit habit) {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final day = now.subtract(Duration(days: i));
      final dayStr = day.toDateString();

      if (habit.frequency.contains(day.weekday)) {
        if (habit.completions[dayStr] ?? false) {
          streak++;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  Widget _buildCalendarHeatmap(List<Habit> habits) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = monthEnd.day;

    return Column(
      children: [
        // Header con días de la semana
        Row(
          children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) =>
            Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ).toList(),
        ),
        const SizedBox(height: 8),
        // Grid del calendario
        ...List.generate((daysInMonth / 7).ceil(), (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex + 1 - (monthStart.weekday - 1);

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 32));
                }

                final day = DateTime(now.year, now.month, dayNumber);
                final dayStr = day.toDateString();
                final intensity = _getDayIntensity(habits, day, dayStr);

                return Expanded(
                  child: Container(
                    height: 32,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: _getIntensityColor(intensity),
                      borderRadius: BorderRadius.circular(4),
                      border: day.day == now.day ? Border.all(color: Colors.black, width: 2) : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: intensity > 0.5 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  double _getDayIntensity(List<Habit> habits, DateTime day, String dayStr) {
    int completed = 0;
    int total = 0;

    for (final habit in habits) {
      if (habit.frequency.contains(day.weekday)) {
        total++;
        if (habit.completions[dayStr] ?? false) {
          completed++;
        }
      }
    }

    return total > 0 ? completed / total : 0.0;
  }

  Color _getIntensityColor(double intensity) {
    if (intensity == 0) return Colors.grey[200]!;
    if (intensity <= 0.25) return Colors.green[100]!;
    if (intensity <= 0.5) return Colors.green[300]!;
    if (intensity <= 0.75) return Colors.green[500]!;
    return Colors.green[700]!;
  }

  Map<String, dynamic> _getMonthlyStatistics(List<Habit> habits) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    int activeDays = 0;
    int bestStreak = 0;
    int totalCompleted = 0;
    int totalExpected = 0;

    // Calcular días activos y total de completados
    for (int i = 0; i < now.day; i++) {
      final day = monthStart.add(Duration(days: i));
      final dayStr = day.toDateString();

      int dayCompleted = 0;
      int dayTotal = 0;

      for (final habit in habits) {
        if (habit.frequency.contains(day.weekday)) {
          dayTotal++;
          if (habit.completions[dayStr] ?? false) {
            dayCompleted++;
          }
        }
      }

      if (dayCompleted > 0) activeDays++;
      totalCompleted += dayCompleted;
      totalExpected += dayTotal;
    }

    // Calcular mejor racha
    for (final habit in habits) {
      final streak = _calculateCurrentStreak(habit);
      if (streak > bestStreak) bestStreak = streak;
    }

    final averageCompletion = totalExpected > 0 ? ((totalCompleted / totalExpected) * 100).round() : 0;

    return {
      'activeDays': activeDays,
      'bestStreak': bestStreak,
      'averageCompletion': averageCompletion,
    };
  }
}