import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

enum AchievementType {
  streak,
  completion,
  consistency,
  milestone,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementType type;
  final int targetValue;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    required this.targetValue,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    AchievementType? type,
    int? targetValue,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon.codePoint,
      'color': color.value,
      'type': type.index,
      'targetValue': targetValue,
      'points': points,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      type: AchievementType.values[json['type']],
      targetValue: json['targetValue'],
      points: json['points'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }
}

class GameStats {
  final int totalPoints;
  final int level;
  final int currentLevelPoints;
  final int pointsToNextLevel;
  final List<Achievement> unlockedAchievements;
  final int longestStreak;
  final int totalCompletions;
  final double averageCompletion;

  GameStats({
    required this.totalPoints,
    required this.level,
    required this.currentLevelPoints,
    required this.pointsToNextLevel,
    required this.unlockedAchievements,
    required this.longestStreak,
    required this.totalCompletions,
    required this.averageCompletion,
  });

  static int calculateLevel(int totalPoints) {
    if (totalPoints < 100) return 1;
    if (totalPoints < 300) return 2;
    if (totalPoints < 600) return 3;
    if (totalPoints < 1000) return 4;
    if (totalPoints < 1500) return 5;
    if (totalPoints < 2100) return 6;
    if (totalPoints < 2800) return 7;
    if (totalPoints < 3600) return 8;
    if (totalPoints < 4500) return 9;
    return 10;
  }

  static int pointsForLevel(int level) {
    switch (level) {
      case 1: return 0;
      case 2: return 100;
      case 3: return 300;
      case 4: return 600;
      case 5: return 1000;
      case 6: return 1500;
      case 7: return 2100;
      case 8: return 2800;
      case 9: return 3600;
      case 10: return 4500;
      default: return 4500;
    }
  }

  static String getLevelTitle(int level, BuildContext context) {
    switch (level) {
      case 1: return AppLocalizations.of(context)!.beginnerlevel;
      case 2: return AppLocalizations.of(context)!.apprenticeLevel;
      case 3: return AppLocalizations.of(context)!.dedicatedLevel;
      case 4: return AppLocalizations.of(context)!.consistentLevel;
      case 5: return AppLocalizations.of(context)!.expertLevel;
      case 6: return AppLocalizations.of(context)!.masterLevel;
      case 7: return AppLocalizations.of(context)!.championLevel;
      case 8: return AppLocalizations.of(context)!.legendLevel;
      case 9: return AppLocalizations.of(context)!.heroLevel;
      case 10: return AppLocalizations.of(context)!.mythicLevel;
      default: return AppLocalizations.of(context)!.maximumLevel;
    }
  }
}