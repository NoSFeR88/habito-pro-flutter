import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/models/habit.dart';
import 'package:ritmo/providers/habit_provider.dart';
import 'package:ritmo/providers/gamification_provider.dart';

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Creates a test habit with default values
Habit createTestHabit({
  required String id,
  required String name,
  String description = 'Test description',
  IconData icon = Icons.star,
  int color = 0xFF00B894,
  List<int> frequency = const [1, 2, 3, 4, 5, 6, 7],
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0),
  DateTime? createdAt,
  Map<String, bool>? completions,
  int streak = 0,
  bool isActive = true,
}) {
  return Habit(
    id: id,
    name: name,
    description: description,
    icon: icon,
    color: color,
    frequency: frequency,
    reminderTime: reminderTime,
    createdAt: createdAt ?? DateTime.now(),
    completions: completions ?? {},
    streak: streak,
    isActive: isActive,
  );
}

// ============================================================================
// TESTS
// ============================================================================

void main() {
  late HabitProvider provider;
  late GamificationProvider gamificationProvider;

  setUp(() {
    provider = HabitProvider();
    gamificationProvider = GamificationProvider();
  });

  tearDown(() {
    provider.dispose();
    gamificationProvider.dispose();
  });

  // ==========================================================================
  // GROUP 1: INITIALIZATION TESTS
  // ==========================================================================
  group('Initialization', () {
    test('should start with default state', () {
      expect(provider.habits, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, isEmpty);
      expect(provider.isInitialized, false);
    });

    test('should have all public getters accessible', () {
      expect(provider.habits, isA<List<Habit>>());
      expect(provider.isLoading, isA<bool>());
      expect(provider.errorMessage, isA<String>());
      expect(provider.isInitialized, isA<bool>());
    });
  });

  // ==========================================================================
  // GROUP 2: GETTERS TESTS
  // ==========================================================================
  group('Getters', () {
    test('completedToday should return empty list initially', () {
      expect(provider.completedToday, isEmpty);
    });

    test('pendingToday should return empty list initially', () {
      expect(provider.pendingToday, isEmpty);
    });

    test('habitsForToday should return empty list initially', () {
      expect(provider.habitsForToday, isEmpty);
    });

    test('habitsForWeek should return empty list initially', () {
      expect(provider.habitsForWeek, isEmpty);
    });
  });

  // ==========================================================================
  // GROUP 3: STATS TESTS
  // ==========================================================================
  group('Statistics', () {
    test('getStats should return zero values when no habits', () {
      final stats = provider.getStats();

      expect(stats['totalHabits'], 0);
      expect(stats['completedToday'], 0);
      expect(stats['currentStreak'], 0);
      expect(stats['completionRate'], 0.0);
    });

    test('getStats should have correct structure', () {
      final stats = provider.getStats();

      expect(stats.containsKey('totalHabits'), true);
      expect(stats.containsKey('completedToday'), true);
      expect(stats.containsKey('currentStreak'), true);
      expect(stats.containsKey('completionRate'), true);
    });

    test('getStats should return valid types', () {
      final stats = provider.getStats();

      expect(stats['totalHabits'], isA<int>());
      expect(stats['completedToday'], isA<int>());
      expect(stats['currentStreak'], isA<int>());
      expect(stats['completionRate'], isA<double>());
    });
  });

  // ==========================================================================
  // GROUP 4: HELPER METHODS TESTS
  // ==========================================================================
  group('Helper Methods', () {
    test('clearError should not throw', () {
      expect(() => provider.clearError(), returnsNormally);
    });

    test('getHabitCompletionCount should return 0 for non-existent habit', () {
      final count = provider.getHabitCompletionCount('nonexistent');
      expect(count, 0);
    });

    test('getHabitStreak should return 0 for non-existent habit', () {
      final streak = provider.getHabitStreak('nonexistent');
      expect(streak, 0);
    });

    test('isHabitCompletedToday should return false for non-existent habit', () {
      final completed = provider.isHabitCompletedToday('nonexistent');
      expect(completed, false);
    });
  });

  // ==========================================================================
  // GROUP 5: GAMIFICATION INTEGRATION TESTS
  // ==========================================================================
  group('Gamification Integration', () {
    test('setGamificationProvider should not throw', () {
      expect(
        () => provider.setGamificationProvider(gamificationProvider),
        returnsNormally,
      );
    });

    test('setGamificationProvider should accept provider', () {
      provider.setGamificationProvider(gamificationProvider);
      // If no exception thrown, test passes
      expect(true, true);
    });
  });

  // ==========================================================================
  // GROUP 6: MODEL INTEGRATION TESTS (Habit model)
  // ==========================================================================
  group('Habit Model Integration', () {
    test('should work with Habit model - basic creation', () {
      final habit = createTestHabit(
        id: 'test1',
        name: 'Test Habit',
      );

      expect(habit.id, 'test1');
      expect(habit.name, 'Test Habit');
      expect(habit.isActive, true);
      expect(habit.completions, isEmpty);
      expect(habit.streak, 0);
    });

    test('should work with Habit model - with completions', () {
      final todayKey = DateTime.now().toDateString();
      final habit = createTestHabit(
        id: 'test2',
        name: 'Completed Habit',
        completions: {todayKey: true},
        streak: 1,
      );

      expect(habit.completions, isNotEmpty);
      expect(habit.completions[todayKey], true);
      expect(habit.streak, 1);
    });

    test('should work with Habit model - inactive habit', () {
      final habit = createTestHabit(
        id: 'test3',
        name: 'Inactive Habit',
        isActive: false,
      );

      expect(habit.isActive, false);
    });

    test('should work with Habit model - custom frequency', () {
      final habit = createTestHabit(
        id: 'test4',
        name: 'Mon-Wed-Fri',
        frequency: [1, 3, 5],
      );

      expect(habit.frequency, [1, 3, 5]);
      expect(habit.frequency.length, 3);
    });

    test('should work with Habit model - custom reminder time', () {
      final habit = createTestHabit(
        id: 'test5',
        name: 'Early Bird',
        reminderTime: const TimeOfDay(hour: 6, minute: 30),
      );

      expect(habit.reminderTime.hour, 6);
      expect(habit.reminderTime.minute, 30);
    });

    test('should work with Habit model - copyWith', () {
      final original = createTestHabit(
        id: 'test6',
        name: 'Original',
      );

      final updated = original.copyWith(name: 'Updated');

      expect(original.name, 'Original');
      expect(updated.name, 'Updated');
      expect(original.id, updated.id); // ID should remain same
    });

    test('should work with Habit model - isCompletedToday getter', () {
      final todayKey = DateTime.now().toDateString();

      final completedHabit = createTestHabit(
        id: 'completed',
        name: 'Completed Today',
        completions: {todayKey: true},
      );

      final pendingHabit = createTestHabit(
        id: 'pending',
        name: 'Pending Today',
        completions: {},
      );

      expect(completedHabit.isCompletedToday, true);
      expect(pendingHabit.isCompletedToday, false);
    });
  });

  // ==========================================================================
  // GROUP 7: STREAK CALCULATION TESTS
  // ==========================================================================
  group('Streak Calculation', () {
    test('should handle habit with zero streak', () {
      final habit = createTestHabit(
        id: 'nostreak',
        name: 'No Streak',
        streak: 0,
      );

      expect(habit.streak, 0);
    });

    test('should handle habit with positive streak', () {
      final habit = createTestHabit(
        id: 'streak5',
        name: '5 Day Streak',
        streak: 5,
      );

      expect(habit.streak, 5);
    });

    test('should calculate streak with calculateStreak method', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final today = DateTime.now();

      final habit = createTestHabit(
        id: 'streak_test',
        name: 'Streak Test',
        frequency: [1, 2, 3, 4, 5, 6, 7],
        completions: {
          yesterday.toDateString(): true,
          today.toDateString(): true,
        },
      );

      final calculatedStreak = habit.calculateStreak();
      expect(calculatedStreak, greaterThanOrEqualTo(1));
    });

    test('should handle streak with gaps', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));

      final habit = createTestHabit(
        id: 'gap_streak',
        name: 'Gapped Streak',
        frequency: [1, 2, 3, 4, 5, 6, 7],
        completions: {
          twoDaysAgo.toDateString(): true,
          // Gap of 1 day (yesterday not completed)
        },
      );

      final calculatedStreak = habit.calculateStreak();
      // Streak should be broken due to gap
      expect(calculatedStreak, equals(0));
    });
  });

  // ==========================================================================
  // GROUP 8: DATETIME EXTENSION TESTS
  // ==========================================================================
  group('DateTime Extension', () {
    test('toDateString should format date correctly', () {
      final date = DateTime(2025, 10, 6);
      final dateString = date.toDateString();

      expect(dateString, '2025-10-06');
    });

    test('toDateString should be consistent', () {
      final now = DateTime.now();
      final str1 = now.toDateString();
      final str2 = now.toDateString();

      expect(str1, str2);
    });

    test('toDateString should differ for different dates', () {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      expect(today.toDateString(), isNot(tomorrow.toDateString()));
    });
  });

  // ==========================================================================
  // GROUP 9: FREQUENCY TESTS
  // ==========================================================================
  group('Habit Frequency', () {
    test('should support everyday frequency', () {
      final habit = createTestHabit(
        id: 'everyday',
        name: 'Every Day',
        frequency: [1, 2, 3, 4, 5, 6, 7],
      );

      expect(habit.frequency.length, 7);
      expect(habit.frequency, containsAll([1, 2, 3, 4, 5, 6, 7]));
    });

    test('should support weekday-only frequency', () {
      final habit = createTestHabit(
        id: 'weekdays',
        name: 'Weekdays Only',
        frequency: [1, 2, 3, 4, 5],
      );

      expect(habit.frequency.length, 5);
      expect(habit.frequency, containsAll([1, 2, 3, 4, 5]));
      expect(habit.frequency, isNot(contains(6)));
      expect(habit.frequency, isNot(contains(7)));
    });

    test('should support weekend-only frequency', () {
      final habit = createTestHabit(
        id: 'weekends',
        name: 'Weekends Only',
        frequency: [6, 7],
      );

      expect(habit.frequency.length, 2);
      expect(habit.frequency, containsAll([6, 7]));
    });

    test('should support custom frequency', () {
      final habit = createTestHabit(
        id: 'custom',
        name: 'Mon-Wed-Fri',
        frequency: [1, 3, 5],
      );

      expect(habit.frequency.length, 3);
      expect(habit.frequency, containsAll([1, 3, 5]));
    });

    test('should support single day frequency', () {
      final habit = createTestHabit(
        id: 'sunday',
        name: 'Sunday Only',
        frequency: [7],
      );

      expect(habit.frequency.length, 1);
      expect(habit.frequency, contains(7));
    });
  });

  // ==========================================================================
  // GROUP 10: COMPLETION MAP TESTS
  // ==========================================================================
  group('Completion Map', () {
    test('should handle empty completions', () {
      final habit = createTestHabit(
        id: 'nocomp',
        name: 'No Completions',
        completions: {},
      );

      expect(habit.completions, isEmpty);
    });

    test('should handle single completion', () {
      final today = DateTime.now().toDateString();
      final habit = createTestHabit(
        id: 'onecomp',
        name: 'One Completion',
        completions: {today: true},
      );

      expect(habit.completions.length, 1);
      expect(habit.completions[today], true);
    });

    test('should handle multiple completions', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final habit = createTestHabit(
        id: 'multicomp',
        name: 'Multiple Completions',
        completions: {
          today.toDateString(): true,
          yesterday.toDateString(): true,
          twoDaysAgo.toDateString(): true,
        },
      );

      expect(habit.completions.length, 3);
    });

    test('should handle uncompleted days (false values)', () {
      final today = DateTime.now().toDateString();
      final habit = createTestHabit(
        id: 'uncompleted',
        name: 'Uncompleted',
        completions: {today: false},
      );

      expect(habit.completions[today], false);
    });
  });

  // ==========================================================================
  // GROUP 11: ICON AND COLOR TESTS
  // ==========================================================================
  group('Habit Appearance', () {
    test('should support different icons', () {
      final habit1 = createTestHabit(
        id: 'icon1',
        name: 'Fitness',
        icon: Icons.fitness_center,
      );

      final habit2 = createTestHabit(
        id: 'icon2',
        name: 'Book',
        icon: Icons.book,
      );

      expect(habit1.icon, Icons.fitness_center);
      expect(habit2.icon, Icons.book);
      expect(habit1.icon, isNot(habit2.icon));
    });

    test('should support different colors', () {
      final habit1 = createTestHabit(
        id: 'color1',
        name: 'Green Habit',
        color: 0xFF00B894,
      );

      final habit2 = createTestHabit(
        id: 'color2',
        name: 'Purple Habit',
        color: 0xFF6C5CE7,
      );

      expect(habit1.color, 0xFF00B894);
      expect(habit2.color, 0xFF6C5CE7);
      expect(habit1.color, isNot(habit2.color));
    });
  });

  // ==========================================================================
  // GROUP 12: CREATION DATE TESTS
  // ==========================================================================
  group('Creation Date', () {
    test('should have creation date', () {
      final habit = createTestHabit(
        id: 'dated',
        name: 'Dated Habit',
      );

      expect(habit.createdAt, isA<DateTime>());
      expect(habit.createdAt.isBefore(DateTime.now().add(const Duration(seconds: 1))), true);
    });

    test('should support custom creation date', () {
      final customDate = DateTime(2025, 1, 1);
      final habit = createTestHabit(
        id: 'custom_date',
        name: 'Custom Date',
        createdAt: customDate,
      );

      expect(habit.createdAt, customDate);
    });

    test('should preserve creation date on copyWith', () {
      final creationDate = DateTime(2025, 1, 1);
      final original = createTestHabit(
        id: 'preserve',
        name: 'Original',
        createdAt: creationDate,
      );

      final updated = original.copyWith(name: 'Updated');

      expect(updated.createdAt, creationDate);
    });
  });

  // ==========================================================================
  // GROUP 13: ACTIVE/INACTIVE STATUS TESTS
  // ==========================================================================
  group('Active/Inactive Status', () {
    test('should default to active', () {
      final habit = createTestHabit(
        id: 'default_active',
        name: 'Default Active',
      );

      expect(habit.isActive, true);
    });

    test('should support inactive status', () {
      final habit = createTestHabit(
        id: 'inactive',
        name: 'Inactive Habit',
        isActive: false,
      );

      expect(habit.isActive, false);
    });

    test('should toggle status with copyWith', () {
      final active = createTestHabit(
        id: 'toggle',
        name: 'Toggle Test',
        isActive: true,
      );

      final inactive = active.copyWith(isActive: false);

      expect(active.isActive, true);
      expect(inactive.isActive, false);
    });
  });

  // ==========================================================================
  // GROUP 14: EDGE CASES
  // ==========================================================================
  group('Edge Cases', () {
    test('should handle empty name', () {
      final habit = createTestHabit(
        id: 'empty_name',
        name: '',
      );

      expect(habit.name, isEmpty);
    });

    test('should handle empty description', () {
      final habit = createTestHabit(
        id: 'empty_desc',
        name: 'Test',
        description: '',
      );

      expect(habit.description, isEmpty);
    });

    test('should handle very long name', () {
      final longName = 'A' * 1000;
      final habit = createTestHabit(
        id: 'long_name',
        name: longName,
      );

      expect(habit.name.length, 1000);
    });

    test('should handle midnight reminder time', () {
      final habit = createTestHabit(
        id: 'midnight',
        name: 'Midnight',
        reminderTime: const TimeOfDay(hour: 0, minute: 0),
      );

      expect(habit.reminderTime.hour, 0);
      expect(habit.reminderTime.minute, 0);
    });

    test('should handle late night reminder time', () {
      final habit = createTestHabit(
        id: 'latenight',
        name: 'Late Night',
        reminderTime: const TimeOfDay(hour: 23, minute: 59),
      );

      expect(habit.reminderTime.hour, 23);
      expect(habit.reminderTime.minute, 59);
    });

    test('should handle very high streak', () {
      final habit = createTestHabit(
        id: 'highstreak',
        name: 'High Streak',
        streak: 365,
      );

      expect(habit.streak, 365);
    });

    test('should handle large completion history', () {
      final completions = <String, bool>{};
      for (int i = 0; i < 365; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        completions[date.toDateString()] = true;
      }

      final habit = createTestHabit(
        id: 'large_history',
        name: 'Large History',
        completions: completions,
      );

      expect(habit.completions.length, 365);
    });
  });
}
