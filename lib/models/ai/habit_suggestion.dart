/// Habit Suggestion Model
/// 
/// Represents an AI-generated suggestion for habit optimization or creation
class HabitSuggestion {
  final String id;
  final SuggestionType type;
  final String title;
  final String description;
  final String reason;
  final double confidence;  // 0.0 - 1.0
  final DateTime createdAt;
  
  // For new habit suggestions
  final String? suggestedHabitName;
  final String? suggestedFrequency;
  final int? suggestedHour;  // 0-23
  
  // For existing habit optimization
  final String? targetHabitId;
  final Map<String, dynamic>? proposedChanges;
  
  HabitSuggestion({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.reason,
    required this.confidence,
    required this.createdAt,
    this.suggestedHabitName,
    this.suggestedFrequency,
    this.suggestedHour,
    this.targetHabitId,
    this.proposedChanges,
  });
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'title': title,
    'description': description,
    'reason': reason,
    'confidence': confidence,
    'createdAt': createdAt.toIso8601String(),
    'suggestedHabitName': suggestedHabitName,
    'suggestedFrequency': suggestedFrequency,
    'suggestedHour': suggestedHour,
    'targetHabitId': targetHabitId,
    'proposedChanges': proposedChanges,
  };
  
  /// Create from JSON
  factory HabitSuggestion.fromJson(Map<String, dynamic> json) => HabitSuggestion(
    id: json['id'],
    type: SuggestionType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => SuggestionType.general,
    ),
    title: json['title'],
    description: json['description'],
    reason: json['reason'],
    confidence: json['confidence'],
    createdAt: DateTime.parse(json['createdAt']),
    suggestedHabitName: json['suggestedHabitName'],
    suggestedFrequency: json['suggestedFrequency'],
    suggestedHour: json['suggestedHour'],
    targetHabitId: json['targetHabitId'],
    proposedChanges: json['proposedChanges'],
  );
}

/// Types of suggestions
enum SuggestionType {
  newHabit,           // Suggest creating a new habit
  optimizeTiming,     // Suggest better time for existing habit
  adjustFrequency,    // Suggest frequency change
  combineHabits,      // Suggest habit stacking
  general,            // General suggestion
}
