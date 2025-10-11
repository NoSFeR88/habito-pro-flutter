import '../../models/habit.dart';
import '../../models/ai/habit_pattern.dart';
import '../../models/ai/ai_insight.dart';
import 'pattern_analyzer.dart';

/// Insight Generator Service - Generates personalized habit insights
class InsightGenerator {
  final PatternAnalyzer _analyzer = PatternAnalyzer();
  
  /// Generate weekly insights for all habits
  List<AIInsight> generateWeeklyInsights(List<Habit> habits) {
    final insights = <AIInsight>[];
    
    for (final habit in habits) {
      final pattern = _analyzer.analyzeHabit(habit, daysToAnalyze: 7);
      insights.addAll(_analyzeHabit(habit, pattern));
    }
    
    if (insights.isEmpty) {
      insights.add(_createMotivationalInsight(habits));
    }
    
    return insights.take(3).toList();
  }
  
  List<AIInsight> _analyzeHabit(Habit habit, HabitPattern pattern) {
    final insights = <AIInsight>[];
    
    // Achievement insights
    if (pattern.overallSuccessRate > 0.8) {
      insights.add(AIInsight(
        id: 'insight_${DateTime.now().millisecondsSinceEpoch}',
        type: InsightType.achievement,
        title: 'Excellent consistency',
        message: '${habit.name} success rate: ${(pattern.overallSuccessRate * 100).toInt()}%',
        recommendation: 'You have mastered this habit',
        confidence: 1.0,
        generatedAt: DateTime.now(),
        habitId: habit.id,
      ));
    }
    
    // Warning insights
    if (pattern.recentTrend < -0.3) {
      insights.add(AIInsight(
        id: 'insight_${DateTime.now().millisecondsSinceEpoch}',
        type: InsightType.warning,
        title: 'Needs attention',
        message: '${habit.name} completion declining',
        recommendation: 'Consider adjusting your approach',
        confidence: 0.8,
        generatedAt: DateTime.now(),
        habitId: habit.id,
      ));
    }
    
    return insights;
  }
  
  AIInsight _createMotivationalInsight(List<Habit> habits) {
    return AIInsight(
      id: 'insight_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.motivational,
      title: 'Keep going',
      message: 'Tracking ${habits.length} habits - every step counts!',
      confidence: 1.0,
      generatedAt: DateTime.now(),
    );
  }
}
