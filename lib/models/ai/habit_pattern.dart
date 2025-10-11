/// Habit Pattern Analysis Model
/// 
/// Represents analyzed patterns in habit completion behavior
class HabitPattern {
  final String habitId;
  final String habitName;
  
  // Time-based patterns
  final Map<int, double> hourFrequency;  // Hour (0-23) -> completion %
  final Map<int, double> dayOfWeekFrequency;  // Day (1-7) -> completion %
  
  // Performance metrics
  final double overallSuccessRate;  // 0.0 - 1.0
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;
  
  // Trend analysis
  final double recentTrend;  // -1.0 (declining) to 1.0 (improving)
  final DateTime? lastCompletedAt;
  final int daysAnalyzed;
  
  // Insights
  final List<String> detectedPatterns;  // e.g., "Morning person", "Weekend warrior"
  
  HabitPattern({
    required this.habitId,
    required this.habitName,
    required this.hourFrequency,
    required this.dayOfWeekFrequency,
    required this.overallSuccessRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletions,
    required this.recentTrend,
    this.lastCompletedAt,
    required this.daysAnalyzed,
    this.detectedPatterns = const [],
  });
  
  /// Get most frequent completion hour
  int? get mostFrequentHour {
    if (hourFrequency.isEmpty) return null;
    return hourFrequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// Get most frequent completion day
  int? get mostFrequentDay {
    if (dayOfWeekFrequency.isEmpty) return null;
    return dayOfWeekFrequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// Check if pattern shows morning preference
  bool get isMorningPerson {
    if (hourFrequency.isEmpty) return false;
    final morningTotal = [6, 7, 8, 9, 10]
        .where((h) => hourFrequency.containsKey(h))
        .fold(0.0, (sum, h) => sum + hourFrequency[h]!);
    return morningTotal > 0.5;  // >50% completions in morning
  }
  
  /// Check if pattern shows evening preference  
  bool get isEveningPerson {
    if (hourFrequency.isEmpty) return false;
    final eveningTotal = [18, 19, 20, 21, 22]
        .where((h) => hourFrequency.containsKey(h))
        .fold(0.0, (sum, h) => sum + hourFrequency[h]!);
    return eveningTotal > 0.5;  // >50% completions in evening
  }
  
  /// Check if pattern shows weekend preference
  bool get isWeekendWarrior {
    if (dayOfWeekFrequency.isEmpty) return false;
    final weekendTotal = [6, 7]  // Saturday, Sunday
        .where((d) => dayOfWeekFrequency.containsKey(d))
        .fold(0.0, (sum, d) => sum + dayOfWeekFrequency[d]!);
    return weekendTotal > 0.4;  // >40% completions on weekends
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'habitName': habitName,
    'hourFrequency': hourFrequency,
    'dayOfWeekFrequency': dayOfWeekFrequency,
    'overallSuccessRate': overallSuccessRate,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'totalCompletions': totalCompletions,
    'recentTrend': recentTrend,
    'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    'daysAnalyzed': daysAnalyzed,
    'detectedPatterns': detectedPatterns,
  };
  
  /// Create from JSON
  factory HabitPattern.fromJson(Map<String, dynamic> json) => HabitPattern(
    habitId: json['habitId'],
    habitName: json['habitName'],
    hourFrequency: Map<int, double>.from(json['hourFrequency']),
    dayOfWeekFrequency: Map<int, double>.from(json['dayOfWeekFrequency']),
    overallSuccessRate: json['overallSuccessRate'],
    currentStreak: json['currentStreak'],
    longestStreak: json['longestStreak'],
    totalCompletions: json['totalCompletions'],
    recentTrend: json['recentTrend'],
    lastCompletedAt: json['lastCompletedAt'] != null 
        ? DateTime.parse(json['lastCompletedAt']) 
        : null,
    daysAnalyzed: json['daysAnalyzed'],
    detectedPatterns: List<String>.from(json['detectedPatterns'] ?? []),
  );
}
