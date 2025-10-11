/// AI-Generated Insight Model
/// 
/// Represents a personalized insight or observation about user habits
class AIInsight {
  final String id;
  final InsightType type;
  final String title;
  final String message;
  final String? recommendation;
  final double confidence;  // 0.0 - 1.0
  final DateTime generatedAt;
  final String? habitId;  // Optional: specific habit this relates to
  
  AIInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.recommendation,
    required this.confidence,
    required this.generatedAt,
    this.habitId,
  });
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'title': title,
    'message': message,
    'recommendation': recommendation,
    'confidence': confidence,
    'generatedAt': generatedAt.toIso8601String(),
    'habitId': habitId,
  };
  
  /// Create from JSON
  factory AIInsight.fromJson(Map<String, dynamic> json) => AIInsight(
    id: json['id'],
    type: InsightType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => InsightType.general,
    ),
    title: json['title'],
    message: json['message'],
    recommendation: json['recommendation'],
    confidence: json['confidence'],
    generatedAt: DateTime.parse(json['generatedAt']),
    habitId: json['habitId'],
  );
}

/// Types of insights that can be generated
enum InsightType {
  achievement,      // Positive milestone reached
  warning,          // Declining performance detected
  pattern,          // Interesting pattern detected
  suggestion,       // Optimization suggestion
  motivational,     // Encouragement message
  streak,           // Streak-related insight
  timing,           // Optimal timing insight
  general,          // General observation
}
