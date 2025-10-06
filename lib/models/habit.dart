import 'dart:convert';
import 'package:flutter/material.dart';

/// Tipo de frecuencia del hábito
enum FrequencyType {
  daily,      // Todos los días (7 días/semana)
  weekdays,   // Solo días laborales (Lun-Vie)
  custom,     // Días específicos de la semana
  weekly,     // X días por semana (flexible)
}

/// Extensión para serialización del enum
extension FrequencyTypeExtension on FrequencyType {
  String toJson() => name;

  static FrequencyType fromJson(String json) {
    return FrequencyType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => FrequencyType.daily,
    );
  }
}

class Habit {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int color;
  final FrequencyType frequencyType;
  final List<int> frequency; // 1-7 (Lun-Dom) - usado en custom/weekdays
  final int? weeklyTarget; // 1-7 días - usado solo en weekly
  final TimeOfDay reminderTime;
  final bool isReminderEnabled;
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
    this.frequencyType = FrequencyType.daily,
    required this.frequency,
    this.weeklyTarget,
    required this.reminderTime,
    this.isReminderEnabled = true,
    required this.createdAt,
    required this.completions,
    this.streak = 0,
    this.isActive = true,
  }) : assert(
          frequencyType != FrequencyType.weekly || weeklyTarget != null,
          'weeklyTarget is required when frequencyType is weekly',
        ),
        assert(
          frequencyType != FrequencyType.weekly ||
          (weeklyTarget != null && weeklyTarget >= 1 && weeklyTarget <= 7),
          'weeklyTarget must be between 1 and 7',
        );

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
    if (frequencyType == FrequencyType.weekly) {
      return _calculateWeeklyStreak();
    } else {
      return _calculateDailyStreak();
    }
  }

  /// Calcula racha para hábitos diarios/custom/weekdays (en días)
  int _calculateDailyStreak() {
    final today = DateTime.now();
    int streak = 0;

    // Contar días consecutivos completados hacia atrás desde hoy
    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final dayStr = day.toDateString();

      // Obtener días requeridos según el tipo
      final requiredDays = _getRequiredDaysForType();

      // Solo contar días que corresponden a la frecuencia del hábito
      if (requiredDays.contains(day.weekday)) {
        if (completions[dayStr] ?? false) {
          streak++;
        } else {
          // Si encontramos un día obligatorio no completado, romper la racha
          break;
        }
      }
      // Si no es un día de frecuencia, continuar sin romper la racha
    }
    return streak;
  }

  /// Calcula racha para hábitos semanales (en semanas completas)
  int _calculateWeeklyStreak() {
    final now = DateTime.now();
    int weekStreak = 0;

    // Iterar por semanas completas hacia atrás
    for (int weekOffset = 0; weekOffset < 52; weekOffset++) {
      // Calcular inicio de la semana (lunes)
      final weekStart = now.subtract(
        Duration(days: now.weekday - 1 + (weekOffset * 7)),
      );
      int completedThisWeek = 0;

      // Contar completions en esta semana
      for (int day = 0; day < 7; day++) {
        final date = weekStart.add(Duration(days: day));
        if (completions[date.toDateString()] ?? false) {
          completedThisWeek++;
        }
      }

      // Verificar si cumplió el target semanal
      if (completedThisWeek >= weeklyTarget!) {
        weekStreak++;
      } else {
        break; // Racha rota
      }
    }

    return weekStreak; // Retorna semanas, no días
  }

  /// Obtiene los días requeridos según el tipo de frecuencia
  List<int> _getRequiredDaysForType() {
    switch (frequencyType) {
      case FrequencyType.daily:
        return [1, 2, 3, 4, 5, 6, 7]; // Todos los días
      case FrequencyType.weekdays:
        return [1, 2, 3, 4, 5]; // Lunes a Viernes
      case FrequencyType.custom:
        return frequency; // Días personalizados
      case FrequencyType.weekly:
        return []; // No aplica para weekly (usa otro cálculo)
    }
  }

  /// Verifica si el hábito cumplió su target esta semana (solo para weekly)
  bool get isWeeklyTargetMet {
    if (frequencyType != FrequencyType.weekly) return false;

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    int completedThisWeek = 0;

    for (int day = 0; day < 7; day++) {
      final date = weekStart.add(Duration(days: day));
      if (completions[date.toDateString()] ?? false) {
        completedThisWeek++;
      }
    }

    return completedThisWeek >= weeklyTarget!;
  }

  // Crear copia con cambios
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    int? color,
    FrequencyType? frequencyType,
    List<int>? frequency,
    int? weeklyTarget,
    TimeOfDay? reminderTime,
    bool? isReminderEnabled,
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
      frequencyType: frequencyType ?? this.frequencyType,
      frequency: frequency ?? this.frequency,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      reminderTime: reminderTime ?? this.reminderTime,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
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
      'frequencyType': frequencyType.toJson(),
      'frequency': frequency,
      'weeklyTarget': weeklyTarget,
      'reminderHour': reminderTime.hour,
      'reminderMinute': reminderTime.minute,
      'isReminderEnabled': isReminderEnabled,
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
      frequencyType: json['frequencyType'] != null
          ? FrequencyTypeExtension.fromJson(json['frequencyType'])
          : FrequencyType.daily,
      frequency: List<int>.from(json['frequency']),
      weeklyTarget: json['weeklyTarget'],
      reminderTime: TimeOfDay(
        hour: json['reminderHour'],
        minute: json['reminderMinute'],
      ),
      isReminderEnabled: json['isReminderEnabled'] ?? true,
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

  /// Obtener etiqueta de frecuencia para UI
  /// Retorna: "Daily", "Weekdays", "Custom", "3/week"
  String getFrequencyLabel() {
    switch (frequencyType) {
      case FrequencyType.daily:
        return 'Daily';
      case FrequencyType.weekdays:
        return 'Weekdays';
      case FrequencyType.custom:
        return 'Custom';
      case FrequencyType.weekly:
        return '$weeklyTarget/week';
    }
  }

  /// Obtener días seleccionados como string legible
  /// Retorna: "Mon, Wed, Fri" o "Lun, Mié, Vie"
  String getCustomDaysString(List<String> dayNames) {
    if (frequencyType != FrequencyType.custom) return '';

    final selectedDayNames = <String>[];
    for (int day in frequency) {
      if (day >= 1 && day <= 7) {
        selectedDayNames.add(dayNames[day - 1]);
      }
    }
    return selectedDayNames.join(', ');
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