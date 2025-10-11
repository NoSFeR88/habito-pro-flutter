import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/models/achievement.dart';
import 'package:ritmo/models/habit.dart';
import 'package:ritmo/providers/gamification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GamificationProvider - Initialization', () {
    test('should initialize with default values', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      expect(provider.totalPoints, 0);
      expect(provider.level, 1);
      expect(provider.achievements.length, 9); // 9 predefined achievements
      expect(provider.unlockedAchievements.length, 0);
    });

    test('should have 9 predefined achievements', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final achievementIds = provider.achievements.map((a) => a.id).toList();
      expect(achievementIds, containsAll([
        'first_streak',
        'week_warrior',
        'month_master',
        'first_completion',
        'century_club',
        'marathon_runner',
        'perfect_week',
        'habit_collector',
        'rhythm_master',
      ]));
    });

    test('should load saved progress from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 500,
        'gamification_level': 3,
        'gamification_achievements': '["first_streak", "first_completion"]',
      });

      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for async init

      expect(provider.totalPoints, 500);
      expect(provider.level, 3);
      expect(provider.unlockedAchievements.length, 2);
    });

    test('should categorize achievements by type', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final streakAchievements = provider.achievements
          .where((a) => a.type == AchievementType.streak)
          .toList();
      final completionAchievements = provider.achievements
          .where((a) => a.type == AchievementType.completion)
          .toList();
      final consistencyAchievements = provider.achievements
          .where((a) => a.type == AchievementType.consistency)
          .toList();
      final milestoneAchievements = provider.achievements
          .where((a) => a.type == AchievementType.milestone)
          .toList();

      expect(streakAchievements.length, 3); // first_streak, week_warrior, month_master
      expect(completionAchievements.length, 3); // first_completion, century_club, marathon_runner
      expect(consistencyAchievements.length, 1); // perfect_week
      expect(milestoneAchievements.length, 2); // habit_collector, rhythm_master
    });
  });

  group('GamificationProvider - Points Management', () {
    test('should add points and update level', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      provider.addPoints(50);
      expect(provider.totalPoints, 50);
      expect(provider.level, 1); // Still level 1 (need 100 for level 2)

      provider.addPoints(60);
      expect(provider.totalPoints, 110);
      expect(provider.level, 2); // Now level 2
    });

    test('should remove points and update level', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 500,
        'gamification_level': 3,
      });
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      provider.removePoints(300);
      expect(provider.totalPoints, 200);
      expect(provider.level, 2); // Downgrade to level 2
    });

    test('should not allow negative points', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      provider.removePoints(100); // Try to remove more than available
      expect(provider.totalPoints, 0); // Should clamp to 0
    });

    test('should notify listeners when adding points', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      var notified = false;
      provider.addListener(() => notified = true);

      provider.addPoints(25);
      expect(notified, true);
    });

    test('should notify listeners when removing points', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 100,
      });
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      var notified = false;
      provider.addListener(() => notified = true);

      provider.removePoints(50);
      expect(notified, true);
    });

    test('should persist points and level after changes', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for init

      provider.addPoints(150);
      await Future.delayed(const Duration(milliseconds: 200)); // Wait for async save

      // Verify in-memory state
      expect(provider.totalPoints, 150);
      expect(provider.level, 2); // 150 points = level 2

      // Verify persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('gamification_points'), 150);
      expect(prefs.getInt('gamification_level'), 2);
    });
  });

  group('GamificationProvider - Level Calculation', () {
    test('should calculate correct levels for point thresholds', () {
      expect(GameStats.calculateLevel(0), 1);
      expect(GameStats.calculateLevel(50), 1);
      expect(GameStats.calculateLevel(99), 1);
      expect(GameStats.calculateLevel(100), 2);
      expect(GameStats.calculateLevel(299), 2);
      expect(GameStats.calculateLevel(300), 3);
      expect(GameStats.calculateLevel(600), 4);
      expect(GameStats.calculateLevel(1000), 5);
      expect(GameStats.calculateLevel(1500), 6);
      expect(GameStats.calculateLevel(2100), 7);
      expect(GameStats.calculateLevel(2800), 8);
      expect(GameStats.calculateLevel(3600), 9);
      expect(GameStats.calculateLevel(4500), 10);
      expect(GameStats.calculateLevel(10000), 10); // Max level
    });

    test('should return correct points for each level', () {
      expect(GameStats.pointsForLevel(1), 0);
      expect(GameStats.pointsForLevel(2), 100);
      expect(GameStats.pointsForLevel(3), 300);
      expect(GameStats.pointsForLevel(4), 600);
      expect(GameStats.pointsForLevel(5), 1000);
      expect(GameStats.pointsForLevel(6), 1500);
      expect(GameStats.pointsForLevel(7), 2100);
      expect(GameStats.pointsForLevel(8), 2800);
      expect(GameStats.pointsForLevel(9), 3600);
      expect(GameStats.pointsForLevel(10), 4500);
      expect(GameStats.pointsForLevel(15), 4500); // Beyond max
    });

    test('should calculate level progress correctly', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      // Level 1: 0-99 points (range: 100)
      provider.addPoints(0);
      expect(provider.getLevelProgress(), 0.0);

      provider.addPoints(50); // 50/100 = 0.5
      expect(provider.getLevelProgress(), 0.5);

      provider.addPoints(50); // 100 points total - now level 2
      expect(provider.getLevelProgress(), 0.0); // Reset at new level
    });
  });

  group('GamificationProvider - GameStats', () {
    test('should return correct GameStats structure', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 150,
        'gamification_level': 2,
      });
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final stats = provider.gameStats;

      expect(stats.totalPoints, 150);
      expect(stats.level, 2);
      expect(stats.currentLevelPoints, 50); // 150 - 100 (level 2 starts at 100)
      expect(stats.pointsToNextLevel, 150); // 300 - 150
      expect(stats.unlockedAchievements, isA<List<Achievement>>());
    });

    test('should calculate points to next level correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      provider.addPoints(50);
      var stats = provider.gameStats;
      expect(stats.pointsToNextLevel, 50); // Need 100, have 50

      provider.addPoints(40);
      stats = provider.gameStats;
      expect(stats.pointsToNextLevel, 10); // Need 100, have 90
    });

    test('should return 0 points to next level at max level', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 5000,
        'gamification_level': 10,
      });
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final stats = provider.gameStats;
      expect(stats.pointsToNextLevel, 0); // At max level
    });
  });

  group('GamificationProvider - Achievement Unlocking', () {
    test('should unlock first_completion achievement', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {DateTime.now().toDateString(): true},
      );

      final newlyUnlocked = provider.checkForNewAchievements([habit]);

      expect(newlyUnlocked.length, greaterThanOrEqualTo(1));
      expect(newlyUnlocked.any((a) => a.id == 'first_completion'), true);
      expect(provider.unlockedAchievements.any((a) => a.id == 'first_completion'), true);
    });

    test('should unlock habit_collector achievement with 5 habits', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habits = List<Habit>.generate(5, (i) => Habit(
        id: 'test-$i',
        name: 'Habit $i',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      ));

      final newlyUnlocked = provider.checkForNewAchievements(habits);

      expect(newlyUnlocked.any((a) => a.id == 'habit_collector'), true);
    });

    test('should not unlock habit_collector with less than 5 habits', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habits = List<Habit>.generate(4, (i) => Habit(
        id: 'test-$i',
        name: 'Habit $i',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      ));

      final newlyUnlocked = provider.checkForNewAchievements(habits);

      expect(newlyUnlocked.any((a) => a.id == 'habit_collector'), false);
    });

    test('should unlock rhythm_master when reaching level 5', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      provider.addPoints(1000); // Reach level 5
      await Future.delayed(const Duration(milliseconds: 100));

      final newlyUnlocked = provider.checkForNewAchievements([]);

      expect(newlyUnlocked.any((a) => a.id == 'rhythm_master'), true);
    });

    test('should not re-unlock already unlocked achievements', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {DateTime.now().toDateString(): true},
      );

      // Unlock first time
      var newlyUnlocked = provider.checkForNewAchievements([habit]);
      expect(newlyUnlocked.length, greaterThan(0));

      // Try to unlock again
      newlyUnlocked = provider.checkForNewAchievements([habit]);
      expect(newlyUnlocked.length, 0); // Already unlocked
    });

    test('should add achievement points when unlocking', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final initialPoints = provider.totalPoints;

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {DateTime.now().toDateString(): true},
      );

      provider.checkForNewAchievements([habit]);

      expect(provider.totalPoints, greaterThan(initialPoints));
    });

    test('should notify listeners when unlocking achievements', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      var notified = false;
      provider.addListener(() => notified = true);

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {DateTime.now().toDateString(): true},
      );

      provider.checkForNewAchievements([habit]);

      await Future.delayed(const Duration(milliseconds: 50));
      expect(notified, true);
    });
  });

  group('GamificationProvider - Streak Achievements', () {
    test('should unlock first_streak with 3-day streak', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final now = DateTime.now();
      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: now.subtract(const Duration(days: 3)),
        completions: {
          now.toDateString(): true,
          now.subtract(const Duration(days: 1)).toDateString(): true,
          now.subtract(const Duration(days: 2)).toDateString(): true,
        },
      );

      final newlyUnlocked = provider.checkForNewAchievements([habit]);

      expect(newlyUnlocked.any((a) => a.id == 'first_streak'), true);
    });

    test('should unlock week_warrior with 7-day streak', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final now = DateTime.now();
      final completions = <String, bool>{};
      for (int i = 0; i < 7; i++) {
        completions[now.subtract(Duration(days: i)).toDateString()] = true;
      }

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: completions,
      );

      final newlyUnlocked = provider.checkForNewAchievements([habit]);

      expect(newlyUnlocked.any((a) => a.id == 'week_warrior'), true);
    });

    test('should unlock month_master with 30-day streak', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final now = DateTime.now();
      final completions = <String, bool>{};
      for (int i = 0; i < 30; i++) {
        completions[now.subtract(Duration(days: i)).toDateString()] = true;
      }

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: completions,
      );

      final newlyUnlocked = provider.checkForNewAchievements([habit]);

      expect(newlyUnlocked.any((a) => a.id == 'month_master'), true);
    });
  });

  group('GamificationProvider - Completion Achievements', () {
    test('should unlock century_club with 100 completions', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final now = DateTime.now();
      final completions = <String, bool>{};
      for (int i = 0; i < 100; i++) {
        completions['2025-${(i ~/ 30) + 1}-${(i % 30) + 1}'] = true;
      }

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: completions,
      );

      final newlyUnlocked = provider.checkForNewAchievements([habit]);

      expect(newlyUnlocked.any((a) => a.id == 'century_club'), true);
    });

    test('should count completions across multiple habits', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habits = List<Habit>.generate(5, (index) {
        final completions = <String, bool>{};
        for (int i = 0; i < 20; i++) {
          completions['2025-${index + 1}-${i + 1}'] = true;
        }
        return Habit(
          id: 'test-$index',
          name: 'Habit $index',
          description: '',
          icon: Icons.star,
          color: Colors.blue.value,
          frequency: [1, 2, 3, 4, 5, 6, 7],
          reminderTime: const TimeOfDay(hour: 9, minute: 0),
          createdAt: DateTime.now(),
          completions: completions,
        );
      });

      final newlyUnlocked = provider.checkForNewAchievements(habits);

      // 5 habits * 20 completions = 100 total
      expect(newlyUnlocked.any((a) => a.id == 'century_club'), true);
    });
  });

  group('GamificationProvider - Edge Cases', () {
    test('should handle empty habits list without crashing', () {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      // Should not crash with empty habits list
      final newlyUnlocked = provider.checkForNewAchievements([]);

      // Achievements that don't depend on habits (like rhythm_master at certain levels)
      // might still unlock, so we just check it doesn't crash
      expect(newlyUnlocked, isA<List<Achievement>>());
    });

    test('should handle rapid point additions', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      for (int i = 0; i < 50; i++) {
        provider.addPoints(10);
      }

      expect(provider.totalPoints, 500);
      expect(provider.level, 3); // 500 points = level 3
    });

    test('should handle level downgrade correctly', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 1000,
        'gamification_level': 5,
      });
      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      provider.removePoints(800); // Down to 200 points
      expect(provider.level, 2); // Should be level 2
    });

    test('should handle corrupted SharedPreferences data', () async {
      SharedPreferences.setMockInitialValues({
        'gamification_points': 'invalid',
        'gamification_level': 'invalid',
        'gamification_achievements': 'not-json',
      });

      final provider = GamificationProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      // Should fall back to defaults
      expect(provider.totalPoints, 0);
      expect(provider.level, 1);
      expect(provider.unlockedAchievements.length, 0);
    });

    test('should persist unlocked achievements', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {DateTime.now().toDateString(): true},
      );

      provider.checkForNewAchievements([habit]);
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final achievementsJson = prefs.getString('gamification_achievements');
      expect(achievementsJson, isNotNull);
      expect(achievementsJson, contains('first_completion'));
    });
  });

  group('GamificationProvider - Listener Notifications', () {
    test('should notify on achievement unlock', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      final habits = List<Habit>.generate(5, (i) => Habit(
        id: 'test-$i',
        name: 'Habit $i',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      ));

      provider.checkForNewAchievements(habits);

      await Future.delayed(const Duration(milliseconds: 50));
      expect(notificationCount, greaterThan(0));
    });

    test('should support multiple listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GamificationProvider();

      var listener1Called = 0;
      var listener2Called = 0;

      provider.addListener(() => listener1Called++);
      provider.addListener(() => listener2Called++);

      provider.addPoints(50);

      expect(listener1Called, 1);
      expect(listener2Called, 1);
    });
  });
}
