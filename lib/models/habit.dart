import 'dart:convert';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int color;
  final List<int> frequency; // 1-7 (Lun-Dom)
  final TimeOfDay reminderTime;
  final DateTime createdAt;
  final Map<String, bool> completions; // "2024-01-15": true
  final int streak;
  final bool isActive;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.reminderTime,
    required this.createdAt,
    required this.completions,
    this.streak = 0,
    this.isActive = true,
  });

  // Verificar si hábito está completado hoy
  bool get isCompletedToday {
    final today = DateTime.now().toDateString();
    return completions[today] ?? false;
  }

  // Obtener días completados esta semana
  int get completedThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int count = 0;
    
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      if (completions[day.toDateString()] ?? false) count++;
    }
    return count;
  }

  // Calcular racha actual
  int calculateStreak() {
    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final dayStr = day.toDateString();
      
      if (completions[dayStr] ?? false) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // Crear copia con cambios
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    int? color,
    List<int>? frequency,
    TimeOfDay? reminderTime,
    DateTime? createdAt,
    Map<String, bool>? completions,
    int? streak,
    bool? isActive,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      completions: completions ?? this.completions,
      streak: streak ?? this.streak,
      isActive: isActive ?? this.isActive,
    );
  }

  // Serialización JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'color': color,
      'frequency': frequency,
      'reminderHour': reminderTime.hour,
      'reminderMinute': reminderTime.minute,
      'createdAt': createdAt.toIso8601String(),
      'completions': completions,
      'streak': streak,
      'isActive': isActive,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: IconData(
        json['iconCodePoint'],
        fontFamily: 'MaterialIcons',
      ),
      color: json['color'],
      frequency: List<int>.from(json['frequency']),
      reminderTime: TimeOfDay(
        hour: json['reminderHour'],
        minute: json['reminderMinute'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      completions: Map<String, bool>.from(json['completions']),
      streak: json['streak'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Habit.fromJsonString(String jsonString) {
    return Habit.fromJson(jsonDecode(jsonString));
  }

  // Métodos para Firebase Firestore
  Map<String, dynamic> toMap() => toJson();

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit.fromJson(map);
  }
}

// Extension para formatear fechas
extension DateTimeExtension on DateTime {
  String toDateString() {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }
}

// Iconos predefinidos para hábitos
class HabitIcons {
  static const List<IconData> icons = [
    Icons.fitness_center,
    Icons.local_drink,
    Icons.book,
    Icons.bedtime,
    Icons.restaurant,
    Icons.directions_run,
    Icons.spa,
    Icons.work,
  ];

  static const List<int> colors = [
    0xFF6C5CE7,
    0xFF00D2D3,
    0xFF00B894,
    0xFFE17055,
    0xFFFF6B6B,
    0xFF4ECDC4,
  ];
}