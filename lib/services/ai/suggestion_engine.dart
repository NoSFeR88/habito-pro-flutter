import 'dart:math';
import '../../models/habit.dart';
import '../../models/ai/habit_pattern.dart';
import '../../models/ai/habit_suggestion.dart';
import 'pattern_analyzer.dart';

/// Suggestion Engine Service
class SuggestionEngine {
  final PatternAnalyzer _analyzer = PatternAnalyzer();
  
  List<HabitSuggestion> generateSuggestions(List<Habit> habits) {
    final suggestions = <HabitSuggestion>[];
    
    for (final habit in habits) {
      final pattern = _analyzer.analyzeHabit(habit);
      suggestions.addAll(_generateOptimizationSuggestions(habit, pattern));
    }
    
    suggestions.addAll(_generateNewHabitSuggestions(habits));
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    
    return suggestions.take(5).toList();
  }
  
  List<HabitSuggestion> _generateOptimizationSuggestions(
    Habit habit,
    HabitPattern pattern,
  ) {
    final suggestions = <HabitSuggestion>[];
    
    if (pattern.mostFrequentHour != null && pattern.overallSuccessRate > 0.6) {
      suggestions.add(_createTimingOptimization(habit, pattern));
    }
    
    if (pattern.overallSuccessRate < 0.5 && pattern.totalCompletions > 5) {
      suggestions.add(_createFrequencyAdjustment(habit, pattern));
    }
    
    return suggestions;
  }
  
  List<HabitSuggestion> _generateNewHabitSuggestions(List<Habit> habits) {
    final suggestions = <HabitSuggestion>[];
    
    if (habits.length < 3) {
      suggestions.add(_createNewHabitSuggestion(
        'Morning Exercise',
        'Physical activity boosts energy',
        'daily',
        7,
        0.8,
      ));
    }
    
    return suggestions;
  }
  
  HabitSuggestion _createTimingOptimization(Habit habit, HabitPattern pattern) {
    final optimalHour = pattern.mostFrequentHour!;
    return HabitSuggestion(
      id: _generateId(),
      type: SuggestionType.optimizeTiming,
      title: 'Optimize timing',
      description: 'Best time identified',
      reason: 'Pattern analysis',
      confidence: 0.8,
      createdAt: DateTime.now(),
      targetHabitId: habit.id,
      suggestedHour: optimalHour,
    );
  }
  
  HabitSuggestion _createFrequencyAdjustment(Habit habit, HabitPattern pattern) {
    return HabitSuggestion(
      id: _generateId(),
      type: SuggestionType.adjustFrequency,
      title: 'Reduce frequency',
      description: 'Start smaller for success',
      reason: 'Low success rate',
      confidence: 0.75,
      createdAt: DateTime.now(),
      targetHabitId: habit.id,
    );
  }
  
  HabitSuggestion _createNewHabitSuggestion(
    String name, String desc, String freq, int hour, double conf) {
    return HabitSuggestion(
      id: _generateId(),
      type: SuggestionType.newHabit,
      title: name,
      description: desc,
      reason: 'Popular complement',
      confidence: conf,
      createdAt: DateTime.now(),
      suggestedHabitName: name,
      suggestedFrequency: freq,
      suggestedHour: hour,
    );
  }
  
  String _generateId() => 'sug_${DateTime.now().millisecondsSinceEpoch}';
}
