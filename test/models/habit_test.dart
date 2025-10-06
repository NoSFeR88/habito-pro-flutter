import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/models/habit.dart';

void main() {
  group('Habit - Creation', () {
    test('should create habit with all required fields', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Morning Workout',
        description: 'Exercise for 30 minutes',
        icon: Icons.fitness_center,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5], // Mon-Fri
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2025, 1, 1),
        completions: {},
      );

      expect(habit.id, 'test-1');
      expect(habit.name, 'Morning Workout');
      expect(habit.description, 'Exercise for 30 minutes');
      expect(habit.icon, Icons.fitness_center);
      expect(habit.color, Colors.blue.value);
      expect(habit.frequency, [1, 2, 3, 4, 5]);
      expect(habit.reminderTime, const TimeOfDay(hour: 9, minute: 0));
      expect(habit.isReminderEnabled, true); // default
      expect(habit.createdAt, DateTime(2025, 1, 1));
      expect(habit.completions, {});
      expect(habit.streak, 0); // default
      expect(habit.isActive, true); // default
    });

    test('should create habit with custom defaults', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Reading',
        description: 'Read for 20 minutes',
        icon: Icons.book,
        color: Colors.green.value,
        frequency: [1, 2, 3, 4, 5, 6, 7], // Everyday
        reminderTime: const TimeOfDay(hour: 20, minute: 30),
        isReminderEnabled: false,
        createdAt: DateTime(2025, 1, 15),
        completions: {},
        streak: 5,
        isActive: false,
      );

      expect(habit.isReminderEnabled, false);
      expect(habit.streak, 5);
      expect(habit.isActive, false);
    });
  });

  group('Habit - isCompletedToday', () {
    test('should return true when completed today', () {
      final today = DateTime.now();
      final dateKey = today.toDateString();

      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {dateKey: true},
      );

      expect(habit.isCompletedToday, true);
    });

    test('should return false when not completed today', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.isCompletedToday, false);
    });

    test('should return false when completed yesterday only', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dateKey = yesterday.toDateString();

      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {dateKey: true},
      );

      expect(habit.isCompletedToday, false);
    });
  });

  group('Habit - completedThisWeek', () {
    test('should count completions in current week', () {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final completions = <String, bool>{};
      for (int i = 0; i < 3; i++) {
        final day = startOfWeek.add(Duration(days: i));
        completions[day.toDateString()] = true;
      }

      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: completions,
      );

      expect(habit.completedThisWeek, 3);
    });

    test('should return 0 when no completions this week', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.completedThisWeek, 0);
    });

    test('should not count completions from previous weeks', () {
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 7));

      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {lastWeek.toDateString(): true},
      );

      expect(habit.completedThisWeek, 0);
    });
  });

  group('Habit - copyWith', () {
    test('should copy habit with modified fields', () {
      final original = Habit(
        id: 'test-1',
        name: 'Original Name',
        description: 'Original Description',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2025, 1, 1),
        completions: {},
      );

      final modified = original.copyWith(
        name: 'Modified Name',
        streak: 10,
        isActive: false,
      );

      expect(modified.id, original.id);
      expect(modified.name, 'Modified Name');
      expect(modified.description, original.description);
      expect(modified.streak, 10);
      expect(modified.isActive, false);
      expect(modified.icon, original.icon);
    });

    test('should preserve original when no changes', () {
      final original = Habit(
        id: 'test-1',
        name: 'Test',
        description: 'Description',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2025, 1, 1),
        completions: {'2025-01-01': true},
        streak: 5,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.description, original.description);
      expect(copied.completions, original.completions);
      expect(copied.streak, original.streak);
    });
  });

  group('Habit - JSON Serialization', () {
    test('should convert to JSON correctly', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Morning Workout',
        description: 'Exercise',
        icon: Icons.fitness_center,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5],
        reminderTime: const TimeOfDay(hour: 9, minute: 30),
        isReminderEnabled: true,
        createdAt: DateTime(2025, 1, 15, 10, 30),
        completions: {'2025-01-15': true},
        streak: 3,
        isActive: true,
      );

      final json = habit.toJson();

      expect(json['id'], 'test-1');
      expect(json['name'], 'Morning Workout');
      expect(json['description'], 'Exercise');
      expect(json['iconCodePoint'], Icons.fitness_center.codePoint);
      expect(json['color'], Colors.blue.value);
      expect(json['frequency'], [1, 2, 3, 4, 5]);
      expect(json['reminderHour'], 9);
      expect(json['reminderMinute'], 30);
      expect(json['isReminderEnabled'], true);
      expect(json['createdAt'], '2025-01-15T10:30:00.000');
      expect(json['completions'], {'2025-01-15': true});
      expect(json['streak'], 3);
      expect(json['isActive'], true);
    });

    test('should create from JSON correctly', () {
      final json = {
        'id': 'test-1',
        'name': 'Morning Workout',
        'description': 'Exercise',
        'iconCodePoint': Icons.fitness_center.codePoint,
        'color': Colors.blue.value,
        'frequency': [1, 2, 3, 4, 5],
        'reminderHour': 9,
        'reminderMinute': 30,
        'isReminderEnabled': true,
        'createdAt': '2025-01-15T10:30:00.000',
        'completions': {'2025-01-15': true},
        'streak': 3,
        'isActive': true,
      };

      final habit = Habit.fromJson(json);

      expect(habit.id, 'test-1');
      expect(habit.name, 'Morning Workout');
      expect(habit.description, 'Exercise');
      expect(habit.icon, Icons.fitness_center);
      expect(habit.color, Colors.blue.value);
      expect(habit.frequency, [1, 2, 3, 4, 5]);
      expect(habit.reminderTime, const TimeOfDay(hour: 9, minute: 30));
      expect(habit.isReminderEnabled, true);
      expect(habit.createdAt, DateTime(2025, 1, 15, 10, 30));
      expect(habit.completions, {'2025-01-15': true});
      expect(habit.streak, 3);
      expect(habit.isActive, true);
    });

    test('should handle missing optional fields in JSON', () {
      final json = {
        'id': 'test-1',
        'name': 'Test',
        'description': '',
        'iconCodePoint': Icons.star.codePoint,
        'color': Colors.blue.value,
        'frequency': [1, 2, 3],
        'reminderHour': 9,
        'reminderMinute': 0,
        'createdAt': '2025-01-15T10:30:00.000',
        'completions': {},
      };

      final habit = Habit.fromJson(json);

      expect(habit.isReminderEnabled, true); // default
      expect(habit.streak, 0); // default
      expect(habit.isActive, true); // default
    });

    test('should serialize and deserialize correctly (round trip)', () {
      final original = Habit(
        id: 'test-1',
        name: 'Morning Workout',
        description: 'Exercise',
        icon: Icons.fitness_center,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5],
        reminderTime: const TimeOfDay(hour: 9, minute: 30),
        isReminderEnabled: false,
        createdAt: DateTime(2025, 1, 15, 10, 30),
        completions: {'2025-01-15': true, '2025-01-14': true},
        streak: 2,
        isActive: false,
      );

      final json = original.toJson();
      final deserialized = Habit.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.name, original.name);
      expect(deserialized.description, original.description);
      expect(deserialized.icon, original.icon);
      expect(deserialized.color, original.color);
      expect(deserialized.frequency, original.frequency);
      expect(deserialized.reminderTime, original.reminderTime);
      expect(deserialized.isReminderEnabled, original.isReminderEnabled);
      expect(deserialized.createdAt, original.createdAt);
      expect(deserialized.completions, original.completions);
      expect(deserialized.streak, original.streak);
      expect(deserialized.isActive, original.isActive);
    });
  });

  group('Habit - DateTimeExtension', () {
    test('should format date string correctly', () {
      final date1 = DateTime(2025, 1, 5);
      expect(date1.toDateString(), '2025-01-05');

      final date2 = DateTime(2025, 12, 25);
      expect(date2.toDateString(), '2025-12-25');

      final date3 = DateTime(2025, 3, 9);
      expect(date3.toDateString(), '2025-03-09');
    });

    test('should handle single digit months and days', () {
      final date = DateTime(2025, 1, 1);
      expect(date.toDateString(), '2025-01-01');
    });

    test('should handle double digit months and days', () {
      final date = DateTime(2025, 10, 15);
      expect(date.toDateString(), '2025-10-15');
    });
  });

  group('Habit - Edge Cases', () {
    test('should handle empty description', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.description, '');
    });

    test('should handle very long name', () {
      final longName = 'A' * 200;
      final habit = Habit(
        id: 'test-1',
        name: longName,
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.name, longName);
      expect(habit.name.length, 200);
    });

    test('should handle all days frequency (everyday)', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.frequency, [1, 2, 3, 4, 5, 6, 7]);
      expect(habit.frequency.length, 7);
    });

    test('should handle single day frequency', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [7], // Sunday only
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.frequency, [7]);
      expect(habit.frequency.length, 1);
    });

    test('should handle midnight reminder time', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3],
        reminderTime: const TimeOfDay(hour: 0, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
      );

      expect(habit.reminderTime, const TimeOfDay(hour: 0, minute: 0));
    });

    test('should handle large completion history', () {
      final completions = <String, bool>{};
      for (int i = 0; i < 365; i++) {
        final date = DateTime(2025, 1, 1).add(Duration(days: i));
        completions[date.toDateString()] = true;
      }

      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2025, 1, 1),
        completions: completions,
      );

      expect(habit.completions.length, 365);
    });

    test('should handle high streak values', () {
      final habit = Habit(
        id: 'test-1',
        name: 'Test',
        description: '',
        icon: Icons.star,
        color: Colors.blue.value,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now(),
        completions: {},
        streak: 365,
      );

      expect(habit.streak, 365);
    });
  });
}
