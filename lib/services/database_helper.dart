import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        color INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        reminder_hour INTEGER NOT NULL,
        reminder_minute INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        completions TEXT NOT NULL,
        streak INTEGER NOT NULL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Manejar upgrades de base de datos en el futuro
  }

  // CRUD Operations para Habits

  Future<int> insertHabit(Habit habit) async {
    final db = await database;

    final habitMap = {
      'id': habit.id,
      'name': habit.name,
      'description': habit.description,
      'icon_code_point': habit.icon.codePoint,
      'color': habit.color,
      'frequency': jsonEncode(habit.frequency),
      'reminder_hour': habit.reminderTime.hour,
      'reminder_minute': habit.reminderTime.minute,
      'created_at': habit.createdAt.toIso8601String(),
      'completions': jsonEncode(habit.completions),
      'streak': habit.streak,
      'is_active': habit.isActive ? 1 : 0,
    };

    return await db.insert('habits', habitMap);
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _habitFromMap(map)).toList();
  }

  Future<Habit?> getHabitById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return _habitFromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;

    final habitMap = {
      'name': habit.name,
      'description': habit.description,
      'icon_code_point': habit.icon.codePoint,
      'color': habit.color,
      'frequency': jsonEncode(habit.frequency),
      'reminder_hour': habit.reminderTime.hour,
      'reminder_minute': habit.reminderTime.minute,
      'completions': jsonEncode(habit.completions),
      'streak': habit.streak,
      'is_active': habit.isActive ? 1 : 0,
    };

    return await db.update(
      'habits',
      habitMap,
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(String id) async {
    final db = await database;

    // Soft delete - marcamos como inactivo
    return await db.update(
      'habits',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> hardDeleteHabit(String id) async {
    final db = await database;

    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos de utilidad

  Future<void> updateHabitCompletion(String habitId, String date, bool completed) async {
    final habit = await getHabitById(habitId);
    if (habit == null) return;

    final newCompletions = Map<String, bool>.from(habit.completions);
    newCompletions[date] = completed;

    // Recalcular streak
    final updatedHabit = habit.copyWith(
      completions: newCompletions,
      streak: _calculateStreakFromCompletions(newCompletions),
    );

    await updateHabit(updatedHabit);
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('habits');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Métodos privados

  Habit _habitFromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: IconData(
        map['icon_code_point'],
        fontFamily: 'MaterialIcons',
      ),
      color: map['color'],
      frequency: List<int>.from(jsonDecode(map['frequency'])),
      reminderTime: TimeOfDay(
        hour: map['reminder_hour'],
        minute: map['reminder_minute'],
      ),
      createdAt: DateTime.parse(map['created_at']),
      completions: Map<String, bool>.from(
        jsonDecode(map['completions']).map(
          (key, value) => MapEntry(key.toString(), value == true),
        ),
      ),
      streak: map['streak'],
      isActive: map['is_active'] == 1,
    );
  }

  int _calculateStreakFromCompletions(Map<String, bool> completions) {
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final dayStr = day.toDateString();

      if (completions[dayStr] == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}