import '../../models/habit.dart';
import '../../models/ai/habit_pattern.dart';

/// Pattern Analyzer Service
/// 
/// Analyzes habit completion patterns using rule-based algorithms
class PatternAnalyzer {
  /// Analyze a single habit's completion patterns
  /// 
  /// [habit] - The habit to analyze
  /// [daysToAnalyze] - Number of days to look back (default: 90)
  HabitPattern analyzeHabit(Habit habit, {int daysToAnalyze = 90}) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: daysToAnalyze));
    
    // Get completions in analysis window
    final completionsInWindow = habit.completedDates
        .where((date) => date.isAfter(startDate) && date.isBefore(now))
        .toList();
    
    // Calculate hour frequency
    final hourFreq = _calculateHourFrequency(completionsInWindow);
    
    // Calculate day of week frequency
    final dayFreq = _calculateDayOfWeekFrequency(completionsInWindow);
    
    // Calculate success rate
    final successRate = _calculateSuccessRate(habit, completionsInWindow, daysToAnalyze);
    
    // Calculate streaks
    final currentStreak = _calculateCurrentStreak(habit);
    final longestStreak = _calculateLongestStreak(habit);
    
    // Calculate trend
    final trend = _calculateTrend(completionsInWindow, daysToAnalyze);
    
    // Detect patterns
    final patterns = _detectPatterns(hourFreq, dayFreq);
    
    return HabitPattern(
      habitId: habit.id,
      habitName: habit.name,
      hourFrequency: hourFreq,
      dayOfWeekFrequency: dayFreq,
      overallSuccessRate: successRate,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalCompletions: completionsInWindow.length,
      recentTrend: trend,
      lastCompletedAt: habit.completedDates.isNotEmpty 
          ? habit.completedDates.last 
          : null,
      daysAnalyzed: daysToAnalyze,
      detectedPatterns: patterns,
    );
  }
  
  /// Calculate frequency by hour of day
  Map<int, double> _calculateHourFrequency(List<DateTime> completions) {
    if (completions.isEmpty) return {};
    
    final hourCounts = <int, int>{};
    for (final completion in completions) {
      hourCounts[completion.hour] = (hourCounts[completion.hour] ?? 0) + 1;
    }
    
    final total = completions.length;
    return hourCounts.map((hour, count) => MapEntry(hour, count / total));
  }
  
  /// Calculate frequency by day of week (1=Monday, 7=Sunday)
  Map<int, double> _calculateDayOfWeekFrequency(List<DateTime> completions) {
    if (completions.isEmpty) return {};
    
    final dayCounts = <int, int>{};
    for (final completion in completions) {
      dayCounts[completion.weekday] = (dayCounts[completion.weekday] ?? 0) + 1;
    }
    
    final total = completions.length;
    return dayCounts.map((day, count) => MapEntry(day, count / total));
  }
  
  /// Calculate overall success rate
  double _calculateSuccessRate(Habit habit, List<DateTime> completions, int days) {
    final expectedCompletions = _calculateExpectedCompletions(habit, days);
    if (expectedCompletions == 0) return 0.0;
    
    return (completions.length / expectedCompletions).clamp(0.0, 1.0);
  }
  
  /// Calculate expected number of completions based on frequency
  int _calculateExpectedCompletions(Habit habit, int days) {
    final frequency = habit.frequency.toLowerCase();
    
    if (frequency == 'daily') {
      return days;
    } else if (frequency == 'weekly') {
      return (days / 7).ceil();
    } else if (frequency.contains('x')) {
      // e.g., "3x per week"
      final match = RegExp(r'(\d+)').firstMatch(frequency);
      if (match != null) {
        final timesPerWeek = int.parse(match.group(1)!);
        return ((days / 7) * timesPerWeek).ceil();
      }
    }
    
    // Custom days (e.g., Mon, Wed, Fri)
    final daysInFrequency = habit.selectedDays?.length ?? 7;
    return ((days / 7) * daysInFrequency).ceil();
  }
  
  /// Calculate current streak
  int _calculateCurrentStreak(Habit habit) {
    // Implementation depends on existing Habit model
    // For now, return 0 - implement based on your streak logic
    return 0;  // TODO: Integrate with existing streak calculation
  }
  
  /// Calculate longest streak
  int _calculateLongestStreak(Habit habit) {
    // Implementation depends on existing Habit model
    return 0;  // TODO: Integrate with existing streak calculation
  }
  
  /// Calculate recent trend (-1.0 to 1.0)
  double _calculateTrend(List<DateTime> completions, int totalDays) {
    if (completions.isEmpty) return 0.0;
    
    final halfPoint = totalDays ~/ 2;
    final midDate = DateTime.now().subtract(Duration(days: halfPoint));
    
    final recentCompletions = completions.where((d) => d.isAfter(midDate)).length;
    final olderCompletions = completions.where((d) => d.isBefore(midDate)).length;
    
    final recentRate = recentCompletions / halfPoint;
    final olderRate = olderCompletions / halfPoint;
    
    // Return difference as trend indicator
    return (recentRate - olderRate).clamp(-1.0, 1.0);
  }
  
  /// Detect behavioral patterns
  List<String> _detectPatterns(
    Map<int, double> hourFreq,
    Map<int, double> dayFreq,
  ) {
    final patterns = <String>[];
    
    // Morning person (6am-10am)
    final morningTotal = [6, 7, 8, 9, 10]
        .where((h) => hourFreq.containsKey(h))
        .fold(0.0, (sum, h) => sum + hourFreq[h]!);
    if (morningTotal > 0.5) patterns.add('Morning Person');
    
    // Evening person (6pm-10pm)
    final eveningTotal = [18, 19, 20, 21, 22]
        .where((h) => hourFreq.containsKey(h))
        .fold(0.0, (sum, h) => sum + hourFreq[h]!);
    if (eveningTotal > 0.5) patterns.add('Evening Person');
    
    // Weekend warrior
    final weekendTotal = [6, 7]
        .where((d) => dayFreq.containsKey(d))
        .fold(0.0, (sum, d) => sum + dayFreq[d]!);
    if (weekendTotal > 0.4) patterns.add('Weekend Warrior');
    
    // Weekday focused
    final weekdayTotal = [1, 2, 3, 4, 5]
        .where((d) => dayFreq.containsKey(d))
        .fold(0.0, (sum, d) => sum + dayFreq[d]!);
    if (weekdayTotal > 0.7) patterns.add('Weekday Focused');
    
    return patterns;
  }
}
