import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ritmo/services/database_helper.dart';
import 'package:ritmo/models/habit.dart';

void main() {
  // Setup sqflite_ffi para tests en escritorio
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // Helper para crear habit de prueba
  Habit createTestHabit({
    String? id,
    String name = 'Test Habit',
    String description = 'Test Description',
    IconData icon = Icons.star,
    int color = 0xFF2196F3,
    List<int>? frequency,
    TimeOfDay? reminderTime,
    DateTime? createdAt,
    Map<String, bool>? completions,
    int streak = 0,
    bool isActive = true,
  }) {
    return Habit(
      id: id ?? 'test-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      icon: icon,
      color: color,
      frequency: frequency ?? [1, 2, 3, 4, 5, 6, 7], // Everyday
      reminderTime: reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
      createdAt: createdAt ?? DateTime.now(),
      completions: completions ?? {},
      streak: streak,
      isActive: isActive,
    );
  }

  group('DatabaseHelper - Initialization', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should initialize database successfully', () async {
      final db = await dbHelper.database;
      expect(db, isNotNull);
      expect(db.isOpen, true);
    });

    test('should return same database instance (singleton)', () async {
      final db1 = await dbHelper.database;
      final db2 = await dbHelper.database;
      expect(db1, same(db2));
    });

    test('should create habits table with correct schema', () async {
      final db = await dbHelper.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='habits'",
      );
      expect(tables.isNotEmpty, true);
      expect(tables.first['name'], 'habits');
    });
  });

  group('DatabaseHelper - Insert Operations', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should insert habit successfully', () async {
      final habit = createTestHabit(id: 'test-1', name: 'Morning Run');

      final result = await dbHelper.insertHabit(habit);

      expect(result, greaterThan(0));
    });

    test('should insert habit with all properties', () async {
      final habit = createTestHabit(
        id: 'test-complex',
        name: 'Complex Habit',
        description: 'Detailed description',
        icon: Icons.fitness_center,
        color: 0xFFFF5722,
        frequency: [1, 3, 5], // Mon, Wed, Fri
        reminderTime: const TimeOfDay(hour: 18, minute: 30),
        streak: 5,
        completions: {
          '2025-10-01': true,
          '2025-10-02': false,
          '2025-10-03': true,
        },
      );

      await dbHelper.insertHabit(habit);
      final retrieved = await dbHelper.getHabitById('test-complex');

      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Complex Habit');
      expect(retrieved.description, 'Detailed description');
      expect(retrieved.icon.codePoint, Icons.fitness_center.codePoint);
      expect(retrieved.color, 0xFFFF5722);
      expect(retrieved.frequency, [1, 3, 5]);
      expect(retrieved.reminderTime.hour, 18);
      expect(retrieved.reminderTime.minute, 30);
      expect(retrieved.streak, 5);
      expect(retrieved.completions.length, 3);
    });

    test('should insert multiple habits', () async {
      final habit1 = createTestHabit(id: 'test-1', name: 'Habit 1');
      final habit2 = createTestHabit(id: 'test-2', name: 'Habit 2');
      final habit3 = createTestHabit(id: 'test-3', name: 'Habit 3');

      await dbHelper.insertHabit(habit1);
      await dbHelper.insertHabit(habit2);
      await dbHelper.insertHabit(habit3);

      final habits = await dbHelper.getAllHabits();
      expect(habits.length, 3);
    });
  });

  group('DatabaseHelper - Read Operations', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should get all habits', () async {
      await dbHelper.insertHabit(createTestHabit(id: 'test-1'));
      await dbHelper.insertHabit(createTestHabit(id: 'test-2'));

      final habits = await dbHelper.getAllHabits();

      expect(habits.length, 2);
    });

    test('should get habits ordered by created_at DESC', () async {
      final habit1 = createTestHabit(
        id: 'test-1',
        name: 'First',
        createdAt: DateTime(2025, 1, 1),
      );
      final habit2 = createTestHabit(
        id: 'test-2',
        name: 'Second',
        createdAt: DateTime(2025, 1, 2),
      );
      final habit3 = createTestHabit(
        id: 'test-3',
        name: 'Third',
        createdAt: DateTime(2025, 1, 3),
      );

      await dbHelper.insertHabit(habit1);
      await dbHelper.insertHabit(habit2);
      await dbHelper.insertHabit(habit3);

      final habits = await dbHelper.getAllHabits();

      expect(habits[0].name, 'Third');  // Most recent first
      expect(habits[1].name, 'Second');
      expect(habits[2].name, 'First');
    });

    test('should get habit by id', () async {
      final habit = createTestHabit(id: 'test-specific', name: 'Specific Habit');
      await dbHelper.insertHabit(habit);

      final retrieved = await dbHelper.getHabitById('test-specific');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'test-specific');
      expect(retrieved.name, 'Specific Habit');
    });

    test('should return null for non-existent habit id', () async {
      final retrieved = await dbHelper.getHabitById('non-existent-id');

      expect(retrieved, isNull);
    });

    test('should not return inactive habits in getAllHabits', () async {
      final activeHabit = createTestHabit(id: 'test-active', isActive: true);
      final inactiveHabit = createTestHabit(id: 'test-inactive', isActive: false);

      await dbHelper.insertHabit(activeHabit);
      await dbHelper.insertHabit(inactiveHabit);

      final habits = await dbHelper.getAllHabits();

      expect(habits.length, 1);
      expect(habits[0].id, 'test-active');
    });
  });

  group('DatabaseHelper - Update Operations', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should update habit name', () async {
      final habit = createTestHabit(id: 'test-1', name: 'Original Name');
      await dbHelper.insertHabit(habit);

      final updatedHabit = habit.copyWith(name: 'Updated Name');
      await dbHelper.updateHabit(updatedHabit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.name, 'Updated Name');
    });

    test('should update habit completions', () async {
      final habit = createTestHabit(id: 'test-1', completions: {});
      await dbHelper.insertHabit(habit);

      final updatedHabit = habit.copyWith(
        completions: {'2025-10-06': true},
        streak: 1,
      );
      await dbHelper.updateHabit(updatedHabit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.completions['2025-10-06'], true);
      expect(retrieved.streak, 1);
    });

    test('should update habit frequency', () async {
      final habit = createTestHabit(
        id: 'test-1',
        frequency: [1, 2, 3, 4, 5, 6, 7], // Everyday
      );
      await dbHelper.insertHabit(habit);

      final updatedHabit = habit.copyWith(frequency: [1, 3, 5]); // Mon, Wed, Fri
      await dbHelper.updateHabit(updatedHabit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.frequency, [1, 3, 5]);
    });

    test('should update habit reminder time', () async {
      final habit = createTestHabit(
        id: 'test-1',
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
      );
      await dbHelper.insertHabit(habit);

      final updatedHabit = habit.copyWith(
        reminderTime: const TimeOfDay(hour: 18, minute: 30),
      );
      await dbHelper.updateHabit(updatedHabit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.reminderTime.hour, 18);
      expect(retrieved.reminderTime.minute, 30);
    });
  });

  group('DatabaseHelper - Delete Operations', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should soft delete habit (mark as inactive)', () async {
      final habit = createTestHabit(id: 'test-1');
      await dbHelper.insertHabit(habit);

      await dbHelper.deleteHabit('test-1');

      final habits = await dbHelper.getAllHabits();
      expect(habits.length, 0); // No aparece en getAllHabits

      // Pero aún existe en DB
      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.isActive, false);
    });

    test('should hard delete habit permanently', () async {
      final habit = createTestHabit(id: 'test-1');
      await dbHelper.insertHabit(habit);

      await dbHelper.hardDeleteHabit('test-1');

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved, isNull);
    });

    test('should soft delete multiple habits', () async {
      await dbHelper.insertHabit(createTestHabit(id: 'test-1'));
      await dbHelper.insertHabit(createTestHabit(id: 'test-2'));
      await dbHelper.insertHabit(createTestHabit(id: 'test-3'));

      await dbHelper.deleteHabit('test-1');
      await dbHelper.deleteHabit('test-2');

      final habits = await dbHelper.getAllHabits();
      expect(habits.length, 1);
      expect(habits[0].id, 'test-3');
    });
  });

  group('DatabaseHelper - Utility Methods', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should update habit completion', () async {
      final habit = createTestHabit(id: 'test-1', completions: {});
      await dbHelper.insertHabit(habit);

      await dbHelper.updateHabitCompletion('test-1', '2025-10-06', true);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.completions['2025-10-06'], true);
    });

    test('should clear all data', () async {
      await dbHelper.insertHabit(createTestHabit(id: 'test-1'));
      await dbHelper.insertHabit(createTestHabit(id: 'test-2'));

      await dbHelper.clearAllData();

      final habits = await dbHelper.getAllHabits();
      expect(habits.length, 0);
    });

    test('should close and reopen database', () async {
      final db1 = await dbHelper.database;
      expect(db1.isOpen, true);

      await dbHelper.closeDatabase();

      final db2 = await dbHelper.database;
      expect(db2.isOpen, true);
      expect(db1, isNot(same(db2))); // Different instance after close/reopen
    });
  });

  group('DatabaseHelper - Edge Cases', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      await dbHelper.clearAllData();
    });

    tearDown(() async {
      await dbHelper.clearAllData();
      await dbHelper.closeDatabase();
    });

    test('should handle empty completions map', () async {
      final habit = createTestHabit(id: 'test-1', completions: {});
      await dbHelper.insertHabit(habit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.completions, isEmpty);
    });

    test('should handle large completions map', () async {
      final largeCompletions = <String, bool>{};
      for (int i = 0; i < 365; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        largeCompletions[date.toDateString()] = i % 2 == 0;
      }

      final habit = createTestHabit(id: 'test-1', completions: largeCompletions);
      await dbHelper.insertHabit(habit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.completions.length, 365);
    });

    test('should handle special characters in name', () async {
      final habit = createTestHabit(
        id: 'test-1',
        name: "Test with 'quotes' and \"double quotes\"",
        description: 'Special chars: !@#\$%^&*()',
      );
      await dbHelper.insertHabit(habit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.name, "Test with 'quotes' and \"double quotes\"");
      expect(retrieved.description, 'Special chars: !@#\$%^&*()');
    });

    test('should handle very long habit names', () async {
      final longName = 'A' * 500;
      final habit = createTestHabit(id: 'test-1', name: longName);
      await dbHelper.insertHabit(habit);

      final retrieved = await dbHelper.getHabitById('test-1');
      expect(retrieved!.name, longName);
    });

    test('should handle updating non-existent habit gracefully', () async {
      final habit = createTestHabit(id: 'non-existent');
      final result = await dbHelper.updateHabit(habit);

      expect(result, 0); // No rows affected
    });

    test('should handle deleting non-existent habit gracefully', () async {
      final result = await dbHelper.deleteHabit('non-existent');

      expect(result, 0); // No rows affected
    });

    test('should handle updateHabitCompletion for non-existent habit', () async {
      // Should not throw, just return silently
      await dbHelper.updateHabitCompletion('non-existent', '2025-10-06', true);

      final retrieved = await dbHelper.getHabitById('non-existent');
      expect(retrieved, isNull);
    });
  });
}
