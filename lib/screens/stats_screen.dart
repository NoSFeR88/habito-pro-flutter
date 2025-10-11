import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../generated/l10n/app_localizations.dart';
import '../core/design_constants.dart';

class StatsScreen extends StatefulWidget {
  final String? habitId; // Filtro opcional por hábito específico

  const StatsScreen({super.key, this.habitId});

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
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        // Obtener el nombre del hábito si se está filtrando
        String title = AppLocalizations.of(context)!.statistics;
        if (widget.habitId != null) {
          final habit = habitProvider.habits.firstWhere(
            (h) => h.id == widget.habitId,
            orElse: () => habitProvider.habits.first,
          );
          title = habit.name;
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (widget.habitId != null)
                  Text(
                    AppLocalizations.of(context)!.statistics,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: const Icon(Icons.today), text: AppLocalizations.of(context)!.today),
                Tab(icon: const Icon(Icons.show_chart), text: AppLocalizations.of(context)!.week),
                Tab(icon: const Icon(Icons.trending_up), text: AppLocalizations.of(context)!.trends),
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
      },
    );
  }

  Widget _buildTodayTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final stats = habitProvider.getStats();
        var habitsToday = habitProvider.habitsForToday;

        // Filtrar por habitId si está presente
        if (widget.habitId != null) {
          habitsToday = habitsToday.where((h) => h.id == widget.habitId).toList();
        }

        final completedToday = habitsToday.where((h) => h.isCompletedToday).length;
        final totalToday = habitsToday.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignConstants.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCards(stats, completedToday, totalToday),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildCompletionChart(completedToday, totalToday),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
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
            AppLocalizations.of(context)!.streakFormat(stats['currentStreak']),
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
      padding: const EdgeInsets.all(DesignConstants.cardPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: DesignConstants.statCardIconSize),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignConstants.statValueFontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: DesignConstants.statLabelFontSize,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionChart(int completed, int total) {
    final pending = total - completed;

    // Colores con mejor contraste y visibilidad
    const completedColor = Color(0xFF4CAF50); // Green 500 - más brillante
    const pendingColor = Color(0xFFFF9800); // Orange 500 - más visible que grey
    final shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.15);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
              height: 160,
              child: total > 0 ? PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completed.toDouble(),
                      title: '$completed\n${AppLocalizations.of(context)!.completedCount}',
                      color: completedColor,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                      titlePositionPercentageOffset: 0.6,
                      badgeWidget: completed > 0 ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: completedColor,
                          size: 20,
                        ),
                      ) : null,
                      badgePositionPercentageOffset: 0.95,
                    ),
                    PieChartSectionData(
                      value: pending.toDouble(),
                      title: '$pending\n${AppLocalizations.of(context)!.pendingCount}',
                      color: pendingColor,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                      titlePositionPercentageOffset: 0.6,
                      badgeWidget: pending > 0 ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pending,
                          color: pendingColor,
                          size: 20,
                        ),
                      ) : null,
                      badgePositionPercentageOffset: 0.95,
                    ),
                  ],
                  sectionsSpace: 3,
                  centerSpaceRadius: 35,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    enabled: true,
                  ),
                ),
              ) : Center(
                child: Text(AppLocalizations.of(context)!.noHabitsToShow),
              ),
            ),
            const SizedBox(height: 16),
            // Leyenda mejorada
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChartLegendItem(completedColor, AppLocalizations.of(context)!.completed),
                const SizedBox(width: 24),
                _buildChartLegendItem(pendingColor, AppLocalizations.of(context)!.pending),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsListToday(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
        // Filtrar hábitos si habitId está presente
        var habits = habitProvider.habits;

        if (widget.habitId != null) {
          habits = habits.where((h) => h.id == widget.habitId).toList();
        }

        // habitsForWeek es List<Map<String, dynamic>>, usado para la lista semanal
        // Si hay filtro por habitId, filtramos también habitsForWeek por el ID del habit
        var habitsForWeek = habitProvider.habitsForWeek;
        if (widget.habitId != null) {
          habitsForWeek = habitsForWeek.where((h) => h['id'] == widget.habitId).toList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignConstants.paddingScreen),
          child: Column(
            children: [
              _buildWeeklyChart(habits),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildWeeklyHeatmap(habits),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildWeeklyHabitsList(habitsForWeek),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyChart(List<Habit> habits) {
    final weekData = _getWeekData(habits);

    // Calcular minY y maxY dinámicamente para mejor visibilidad
    double minYValue = 0;
    double maxYValue = 100;

    if (weekData.isNotEmpty) {
      final values = weekData.map((spot) => spot.y).toList();
      final dataMin = values.reduce((a, b) => a < b ? a : b);
      final dataMax = values.reduce((a, b) => a > b ? a : b);

      // Si todos los valores están en un rango estrecho, ajustar para mejor visibilidad
      if (dataMax - dataMin < 30 && dataMax > 0) {
        // Dar margen de 10% arriba y abajo
        minYValue = (dataMin - 10).clamp(0, 100);
        maxYValue = (dataMax + 10).clamp(0, 100);
      }
    }

    // Calcular interval dinámico
    final intervalValue = maxYValue - minYValue > 0 ? (maxYValue - minYValue) / 5 : 20.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
              height: DesignConstants.chartHeight,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 25,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: intervalValue,
                        getTitlesWidget: (value, meta) {
                          if (value != value.toInt()) return const Text('');
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              fontSize: DesignConstants.chartLabelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value != value.toInt()) return const Text('');
                          final days = [
                            AppLocalizations.of(context)!.dayShortMon,
                            AppLocalizations.of(context)!.dayShortTue,
                            AppLocalizations.of(context)!.dayShortWed,
                            AppLocalizations.of(context)!.dayShortThu,
                            AppLocalizations.of(context)!.dayShortFri,
                            AppLocalizations.of(context)!.dayShortSat,
                            AppLocalizations.of(context)!.dayShortSun,
                          ];
                          return Text(
                            days[value.toInt() % 7],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          );
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  minY: minYValue,
                  maxY: maxYValue,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weekData,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: const Color(0xFF2196F3), // Blue 500 - consistente y vibrante
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF2196F3).withValues(alpha: 0.4),
                            const Color(0xFF2196F3).withValues(alpha: 0.1),
                            const Color(0xFF2196F3).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          // Color del dot basado en el valor
                          final isHigh = spot.y >= 75;
                          final isMedium = spot.y >= 50 && spot.y < 75;
                          Color dotColor = isHigh
                              ? const Color(0xFF4CAF50) // Verde
                              : isMedium
                                  ? const Color(0xFFFF9800) // Naranja
                                  : const Color(0xFFF44336); // Rojo

                          return FlDotCirclePainter(
                            radius: 5,
                            color: dotColor,
                            strokeWidth: 2.5,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final days = [
                            AppLocalizations.of(context)!.dayShortMon,
                            AppLocalizations.of(context)!.dayShortTue,
                            AppLocalizations.of(context)!.dayShortWed,
                            AppLocalizations.of(context)!.dayShortThu,
                            AppLocalizations.of(context)!.dayShortFri,
                            AppLocalizations.of(context)!.dayShortSat,
                            AppLocalizations.of(context)!.dayShortSun,
                          ];
                          return LineTooltipItem(
                            '${days[spot.x.toInt() % 7]}\n${spot.y.toInt()}%',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
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
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
                    AppLocalizations.of(context)!.legend,
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
                  _buildLegendItem(Colors.green, '✓', AppLocalizations.of(context)!.completed),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.red[200]!, '', AppLocalizations.of(context)!.pending),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.grey[400]!, '', AppLocalizations.of(context)!.notScheduled),
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
    final days = [
      AppLocalizations.of(context)!.dayShortMon,
      AppLocalizations.of(context)!.dayShortTue,
      AppLocalizations.of(context)!.dayShortWed,
      AppLocalizations.of(context)!.dayShortThu,
      AppLocalizations.of(context)!.dayShortFri,
      AppLocalizations.of(context)!.dayShortSat,
      AppLocalizations.of(context)!.dayShortSun,
    ];

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
        // Filtrar hábitos si habitId está presente
        var habits = habitProvider.habits;

        if (widget.habitId != null) {
          habits = habits.where((h) => h.id == widget.habitId).toList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignConstants.paddingScreen),
          child: Column(
            children: [
              _buildMonthlyProgressChart(habits),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildHabitStreaksChart(habits),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildMonthlyHeatmap(habits),
              const SizedBox(height: DesignConstants.spacingBetweenSections),
              _buildMonthlyStats(habits),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyProgressChart(List<Habit> habits) {
    final monthlyData = _getMonthlyData(habits);

    // Si no hay datos, mostrar mensaje vacío
    if (habits.isEmpty || monthlyData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
                height: DesignConstants.chartHeight,
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.noActiveHabits,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular minY y maxY dinámicamente para mejor visibilidad
    double minYValue = 0;
    double maxYValue = 100;

    if (monthlyData.isNotEmpty) {
      final values = monthlyData.map((spot) => spot.y).toList();
      final dataMin = values.reduce((a, b) => a < b ? a : b);
      final dataMax = values.reduce((a, b) => a > b ? a : b);

      // Si todos los valores están en un rango estrecho, ajustar para mejor visibilidad
      if (dataMax - dataMin < 30 && dataMax > 0) {
        // Dar margen de 10% arriba y abajo
        minYValue = (dataMin - 10).clamp(0, 100);
        maxYValue = (dataMax + 10).clamp(0, 100);
      }
    }

    // Calcular interval dinámico
    final intervalValue = maxYValue - minYValue > 0 ? (maxYValue - minYValue) / 5 : 20.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
              height: DesignConstants.chartHeight,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 25,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: intervalValue,
                        getTitlesWidget: (value, meta) {
                          if (value != value.toInt()) return const Text('');
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              fontSize: DesignConstants.chartLabelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final l10n = AppLocalizations.of(context)!;
                          final weeks = [l10n.week1, l10n.week2, l10n.week3, l10n.week4];
                          final index = value.toInt();
                          if (value != value.toInt()) return const Text('');
                          return index < weeks.length ? Text(
                            weeks[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ) : const Text('');
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  minY: minYValue,
                  maxY: maxYValue,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: const Color(0xFF9C27B0), // Purple 500 - distinto del weekly
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF9C27B0).withValues(alpha: 0.4),
                            const Color(0xFF9C27B0).withValues(alpha: 0.1),
                            const Color(0xFF9C27B0).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final isHigh = spot.y >= 75;
                          final isMedium = spot.y >= 50 && spot.y < 75;
                          Color dotColor = isHigh
                              ? const Color(0xFF4CAF50)
                              : isMedium
                                  ? const Color(0xFFFF9800)
                                  : const Color(0xFFF44336);

                          return FlDotCirclePainter(
                            radius: 5,
                            color: dotColor,
                            strokeWidth: 2.5,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final l10n = AppLocalizations.of(context)!;
                          final weeks = [l10n.week1, l10n.week2, l10n.week3, l10n.week4];
                          final index = spot.x.toInt();
                          return LineTooltipItem(
                            '${index < weeks.length ? weeks[index] : "W${index + 1}"}\n${spot.y.toInt()}%',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
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

  Widget _buildHabitStreaksChart(List<Habit> habits) {
    final streakData = _getStreakData(habits);

    // Si no hay hábitos, mostrar mensaje vacío
    if (habits.isEmpty || streakData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
                height: DesignConstants.chartHeight,
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.noActiveHabits,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
              height: DesignConstants.chartHeight,
              padding: const EdgeInsets.only(bottom: 16, right: 8),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: streakData.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b) + 2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${habits[groupIndex].name}\n${AppLocalizations.of(context)!.streakFormat(rod.toY.round())}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
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
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value != value.toInt()) return const Text('');
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: DesignConstants.chartLabelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  barGroups: List.generate(
                    habits.length,
                    (index) {
                      final streakValue = streakData[index];
                      final habitColor = Color(habits[index].color);

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: streakValue,
                            color: habitColor,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                habitColor.withValues(alpha: 0.7),
                                habitColor,
                              ],
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: streakData.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b) + 2,
                              color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      );
                    },
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
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
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
                    AppLocalizations.of(context)!.streakFormat(stats['bestStreak']),
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

    final dayLabels = [
      AppLocalizations.of(context)!.dayShortMon,
      AppLocalizations.of(context)!.dayShortTue,
      AppLocalizations.of(context)!.dayShortWed,
      AppLocalizations.of(context)!.dayShortThu,
      AppLocalizations.of(context)!.dayShortFri,
      AppLocalizations.of(context)!.dayShortSat,
      AppLocalizations.of(context)!.dayShortSun,
    ];

    return Column(
      children: [
        // Header con días de la semana
        Row(
          children: dayLabels.map((day) =>
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
                final isToday = day.day == now.day && day.month == now.month && day.year == now.year;

                return Expanded(
                  child: Container(
                    height: 32,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isToday ? Colors.amber : _getIntensityColor(intensity),
                      borderRadius: BorderRadius.circular(4),
                      border: isToday
                        ? Border.all(color: Colors.orange.shade700, width: 2)
                        : null,
                      boxShadow: isToday
                        ? [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            dayNumber.toString(),
                            style: TextStyle(
                              fontSize: isToday ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.black : (intensity > 0.5 ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        if (isToday)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildWeeklyHabitsList(List<Map<String, dynamic>> weekHabits) {
    if (weekHabits.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.cardPadding),
          child: Center(
            child: Text(AppLocalizations.of(context)!.noHabitsToShow),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weekHabits,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...weekHabits.map((habitData) {
              final habit = habitData['habit'] as Habit;
              final completedDays = habitData['completedDays'] as int;
              final scheduledDays = habitData['scheduledDays'] as int;
              final percentage = habitData['percentage'] as int;

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
                        size: DesignConstants.habitIconSize,
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
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.weekProgress(completedDays, scheduledDays),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPercentageColor(percentage).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          color: _getPercentageColor(percentage),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getPercentageColor(int percentage) {
    if (percentage == 100) return Colors.green;
    if (percentage >= 70) return Colors.lightGreen;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}