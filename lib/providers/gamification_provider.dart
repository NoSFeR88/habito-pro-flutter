import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/achievement.dart';
import '../models/habit.dart';
import '../generated/l10n/app_localizations.dart';

class GamificationProvider with ChangeNotifier {
  List<Achievement> _achievements = [];
  int _totalPoints = 0;
  int _level = 1;
  List<String> _unlockedAchievementIds = [];

  List<Achievement> get achievements => _achievements;
  int get totalPoints => _totalPoints;
  int get level => _level;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  GameStats get gameStats {
    final currentLevelPoints = GameStats.pointsForLevel(_level);
    final nextLevelPoints = GameStats.pointsForLevel(_level + 1);
    final pointsToNextLevel = nextLevelPoints - _totalPoints;

    return GameStats(
      totalPoints: _totalPoints,
      level: _level,
      currentLevelPoints: _totalPoints - currentLevelPoints,
      pointsToNextLevel: pointsToNextLevel > 0 ? pointsToNextLevel : 0,
      unlockedAchievements: unlockedAchievements,
      longestStreak: _calculateLongestStreak(),
      totalCompletions: _calculateTotalCompletions(),
      averageCompletion: _calculateAverageCompletion(),
    );
  }

  static const String _pointsKey = 'gamification_points';
  static const String _levelKey = 'gamification_level';
  static const String _achievementsKey = 'gamification_achievements';

  GamificationProvider() {
    _initializeAchievements();
    _loadProgress();
  }

  void _initializeAchievements() {
    _achievements = [
      // Streak Achievements
      Achievement(
        id: 'first_streak',
        name: 'First Streak', // Will be localized when displayed
        description: 'Complete your first habit 3 days in a row', // Will be localized when displayed
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 3,
        points: 50,
      ),
      Achievement(
        id: 'week_warrior',
        name: 'Week Warrior', // Will be localized when displayed
        description: 'Maintain a 7-day streak', // Will be localized when displayed
        icon: Icons.shield,
        color: Colors.blue,
        type: AchievementType.streak,
        targetValue: 7,
        points: 100,
      ),
      Achievement(
        id: 'month_master',
        name: 'Month Master', // Will be localized when displayed
        description: 'Maintain a 30-day streak', // Will be localized when displayed
        icon: Icons.emoji_events,
        color: Colors.amber,
        type: AchievementType.streak,
        targetValue: 30,
        points: 300,
      ),

      // Completion Achievements
      Achievement(
        id: 'first_completion',
        name: 'First Step', // Will be localized when displayed
        description: 'Complete your first habit', // Will be localized when displayed
        icon: Icons.check_circle,
        color: Colors.green,
        type: AchievementType.completion,
        targetValue: 1,
        points: 10,
      ),
      Achievement(
        id: 'century_club',
        name: 'Century Club', // Will be localized when displayed
        description: 'Complete 100 habits total', // Will be localized when displayed
        icon: Icons.military_tech,
        color: Colors.purple,
        type: AchievementType.completion,
        targetValue: 100,
        points: 200,
      ),
      Achievement(
        id: 'marathon_runner',
        name: 'Marathon Runner', // Will be localized when displayed
        description: 'Complete 500 habits total', // Will be localized when displayed
        icon: Icons.run_circle,
        color: Colors.red,
        type: AchievementType.completion,
        targetValue: 500,
        points: 500,
      ),

      // Consistency Achievements
      Achievement(
        id: 'perfect_week',
        name: 'Perfect Week', // Will be localized when displayed
        description: 'Complete all your habits during a week', // Will be localized when displayed
        icon: Icons.star,
        color: Colors.yellow,
        type: AchievementType.consistency,
        targetValue: 7,
        points: 150,
      ),
      Achievement(
        id: 'habit_collector',
        name: 'Collector', // Will be localized when displayed
        description: 'Create 5 different habits', // Will be localized when displayed
        icon: Icons.collections,
        color: Colors.teal,
        type: AchievementType.milestone,
        targetValue: 5,
        points: 75,
      ),
      Achievement(
        id: 'rhythm_master',
        name: 'Rhythm Master', // Will be localized when displayed
        description: 'Reach level 5', // Will be localized when displayed
        icon: Icons.music_note,
        color: Colors.indigo,
        type: AchievementType.milestone,
        targetValue: 5,
        points: 250,
      ),
    ];
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalPoints = prefs.getInt(_pointsKey) ?? 0;
      _level = prefs.getInt(_levelKey) ?? 1;

      final achievementsJson = prefs.getString(_achievementsKey);
      if (achievementsJson != null) {
        final List<dynamic> achievementsList = json.decode(achievementsJson);
        _unlockedAchievementIds = achievementsList.cast<String>();

        // Update achievements with unlocked status
        _achievements = _achievements.map((achievement) {
          if (_unlockedAchievementIds.contains(achievement.id)) {
            return achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(), // Could be improved with actual unlock time
            );
          }
          return achievement;
        }).toList();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading gamification progress: $e');
    }
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_pointsKey, _totalPoints);
      await prefs.setInt(_levelKey, _level);
      await prefs.setString(_achievementsKey, json.encode(_unlockedAchievementIds));
    } catch (e) {
      debugPrint('Error saving gamification progress: $e');
    }
  }

  List<Achievement> checkForNewAchievements(List<Habit> habits) {
    final newlyUnlocked = <Achievement>[];

    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.streak:
          final longestStreak = _calculateLongestStreakFromHabits(habits);
          shouldUnlock = longestStreak >= achievement.targetValue;
          break;
        case AchievementType.completion:
          final totalCompletions = _calculateTotalCompletionsFromHabits(habits);
          shouldUnlock = totalCompletions >= achievement.targetValue;
          break;
        case AchievementType.consistency:
          shouldUnlock = _checkConsistencyAchievement(habits, achievement);
          break;
        case AchievementType.milestone:
          if (achievement.id == 'habit_collector') {
            shouldUnlock = habits.length >= achievement.targetValue;
          } else if (achievement.id == 'rhythm_master') {
            shouldUnlock = _level >= achievement.targetValue;
          }
          break;
      }

      if (shouldUnlock) {
        _unlockAchievement(achievement);
        newlyUnlocked.add(achievement);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      _saveProgress();
      notifyListeners();
    }

    return newlyUnlocked;
  }

  void _unlockAchievement(Achievement achievement) {
    _unlockedAchievementIds.add(achievement.id);
    _totalPoints += achievement.points;
    _level = GameStats.calculateLevel(_totalPoints);

    // Update the achievement in the list
    final index = _achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      _achievements[index] = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }
  }

  int _calculateLongestStreak() {
    // This would be calculated from actual habit data
    return 0; // Placeholder
  }

  int _calculateTotalCompletions() {
    // This would be calculated from actual habit data
    return 0; // Placeholder
  }

  double _calculateAverageCompletion() {
    // This would be calculated from actual habit data
    return 0.0; // Placeholder
  }

  int _calculateLongestStreakFromHabits(List<Habit> habits) {
    int longestStreak = 0;
    for (final habit in habits) {
      final streak = _calculateHabitStreak(habit);
      if (streak > longestStreak) {
        longestStreak = streak;
      }
    }
    return longestStreak;
  }

  int _calculateTotalCompletionsFromHabits(List<Habit> habits) {
    int total = 0;
    for (final habit in habits) {
      total += habit.completions.values.where((completed) => completed).length;
    }
    return total;
  }

  int _calculateHabitStreak(Habit habit) {
    // Usar el método mejorado del modelo Habit
    return habit.calculateStreak();
  }

  bool _checkConsistencyAchievement(List<Habit> habits, Achievement achievement) {
    if (achievement.id == 'perfect_week') {
      // Check if all habits were completed for the last 7 days
      final now = DateTime.now();
      for (int i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: i));
        final dayStr = day.toDateString();

        for (final habit in habits) {
          if (habit.frequency.contains(day.weekday)) {
            if (!(habit.completions[dayStr] ?? false)) {
              return false;
            }
          }
        }
      }
      return true;
    }
    return false;
  }

  void addPoints(int points) {
    _totalPoints += points;
    final newLevel = GameStats.calculateLevel(_totalPoints);
    if (newLevel > _level) {
      _level = newLevel;
    }
    _saveProgress();
    notifyListeners();
  }

  void removePoints(int points) {
    _totalPoints = (_totalPoints - points).clamp(0, _totalPoints);
    final newLevel = GameStats.calculateLevel(_totalPoints);
    if (newLevel < _level) {
      _level = newLevel;
    }
    _saveProgress();
    notifyListeners();
  }

  double getLevelProgress() {
    final currentLevelPoints = GameStats.pointsForLevel(_level);
    final nextLevelPoints = GameStats.pointsForLevel(_level + 1);
    final levelRange = nextLevelPoints - currentLevelPoints;
    final currentProgress = _totalPoints - currentLevelPoints;

    if (levelRange <= 0) return 1.0;
    return (currentProgress / levelRange).clamp(0.0, 1.0);
  }

  // Método para obtener el nombre localizado de un achievement
  String getLocalizedAchievementName(String achievementId, BuildContext context) {
    switch (achievementId) {
      case 'first_streak':
        return AppLocalizations.of(context)!.firstStreakAchievement;
      case 'week_warrior':
        return AppLocalizations.of(context)!.weekWarriorAchievement;
      case 'month_master':
        return AppLocalizations.of(context)!.monthMasterAchievement;
      case 'first_completion':
        return AppLocalizations.of(context)!.firstStepAchievement;
      case 'century_club':
        return AppLocalizations.of(context)!.centuryClubAchievement;
      case 'marathon_runner':
        return AppLocalizations.of(context)!.marathonRunnerAchievement;
      case 'perfect_week':
        return AppLocalizations.of(context)!.perfectWeekAchievement;
      case 'habit_collector':
        return AppLocalizations.of(context)!.habitCollectorAchievement;
      case 'rhythm_master':
        return AppLocalizations.of(context)!.rhythmMasterAchievement;
      default:
        return achievementId; // Fallback
    }
  }

  // Método para obtener la descripción localizada de un achievement
  String getLocalizedAchievementDescription(String achievementId, BuildContext context) {
    switch (achievementId) {
      case 'first_streak':
        return AppLocalizations.of(context)!.completeFirstHabit3Days;
      case 'week_warrior':
        return AppLocalizations.of(context)!.maintain7DayStreak;
      case 'month_master':
        return AppLocalizations.of(context)!.maintain30DayStreak;
      case 'first_completion':
        return AppLocalizations.of(context)!.completeFirstHabit;
      case 'century_club':
        return AppLocalizations.of(context)!.complete100Habits;
      case 'marathon_runner':
        return AppLocalizations.of(context)!.complete500Habits;
      case 'perfect_week':
        return AppLocalizations.of(context)!.completeAllHabitsWeek;
      case 'habit_collector':
        return AppLocalizations.of(context)!.create5DifferentHabits;
      case 'rhythm_master':
        return AppLocalizations.of(context)!.reachLevel5;
      default:
        return achievementId; // Fallback
    }
  }

  // Método para obtener una copia localizada de los achievements
  List<Achievement> getLocalizedAchievements(BuildContext context) {
    return _achievements.map((achievement) {
      return Achievement(
        id: achievement.id,
        name: getLocalizedAchievementName(achievement.id, context),
        description: getLocalizedAchievementDescription(achievement.id, context),
        icon: achievement.icon,
        color: achievement.color,
        type: achievement.type,
        targetValue: achievement.targetValue,
        points: achievement.points,
        isUnlocked: achievement.isUnlocked,
        unlockedAt: achievement.unlockedAt,
      );
    }).toList();
  }
}