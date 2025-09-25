import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';

class HabitProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  List<Habit> _habits = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isInitialized = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Inicializar hábitos desde la base de datos
  Future<void> initializeHabits() async {
    if (_isInitialized) return;

    _setLoading(true);
    try {
      // Inicializar notificaciones
      await _notificationService.initialize();

      await _loadHabitsFromDatabase();

      // Si no hay hábitos, crear datos de ejemplo
      if (_habits.isEmpty) {
        await _createSampleHabits();
      }

      // Programar notificaciones para todos los hábitos
      await _scheduleAllNotifications();

      _isInitialized = true;
      _clearError();
    } catch (e) {
      _setError('Error inicializando hábitos: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadHabitsFromDatabase() async {
    try {
      _habits = await _databaseHelper.getAllHabits();
      notifyListeners();
    } catch (e) {
      throw Exception('Error cargando hábitos: $e');
    }
  }

  // Añadir nuevo hábito
  Future<void> addHabit(Habit habit) async {
    _setLoading(true);
    try {
      await _databaseHelper.insertHabit(habit);
      _habits.add(habit);

      // Programar notificaciones para el nuevo hábito
      await _notificationService.scheduleHabitReminder(habit);

      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error añadiendo hábito: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar hábito
  Future<void> updateHabit(Habit habit) async {
    try {
      await _databaseHelper.updateHabit(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;

        // Actualizar notificaciones para el hábito modificado
        await _notificationService.scheduleHabitReminder(habit);

        notifyListeners();
      }
      _clearError();
    } catch (e) {
      _setError('Error actualizando hábito: $e');
    }
  }

  // Eliminar hábito
  Future<void> deleteHabit(String habitId) async {
    try {
      await _databaseHelper.deleteHabit(habitId);

      // Cancelar notificaciones del hábito eliminado
      await _notificationService.cancelHabitReminders(habitId);

      _habits.removeWhere((h) => h.id == habitId);
      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error eliminando hábito: $e');
    }
  }

  // Marcar hábito como completado/no completado
  Future<void> toggleHabitCompletion(String habitId, [DateTime? date]) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateStr = targetDate.toDateString();

      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final habit = _habits[habitIndex];
      final newCompletions = Map<String, bool>.from(habit.completions);

      // Toggle completion
      newCompletions[dateStr] = !(newCompletions[dateStr] ?? false);

      // Recalcular racha
      final updatedHabit = habit.copyWith(
        completions: newCompletions,
        streak: habit.calculateStreak(),
      );

      await updateHabit(updatedHabit);
      _clearError();
    } catch (e) {
      _setError('Error actualizando completado: $e');
    }
  }

  // Obtener estadísticas generales
  Map<String, dynamic> getStats() {
    if (_habits.isEmpty) {
      return {
        'totalHabits': 0,
        'completedToday': 0,
        'currentStreak': 0,
        'completionRate': 0.0,
      };
    }

    final completedToday = _habits.where((h) => h.isCompletedToday).length;
    final totalActive = _habits.where((h) => h.isActive).length;
    final completionRate = totalActive > 0 ? (completedToday / totalActive) : 0.0;
    
    final maxStreak = _habits.isNotEmpty 
        ? _habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b)
        : 0;

    return {
      'totalHabits': totalActive,
      'completedToday': completedToday,
      'currentStreak': maxStreak,
      'completionRate': completionRate,
    };
  }

  // Obtener hábitos por completar hoy (ordenados)
  List<Habit> get habitsForToday {
    final today = DateTime.now().weekday;
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();
    final todayStr = now.toDateString();

    final habitsToday = _habits.where((habit) =>
        habit.isActive &&
        habit.frequency.contains(today)
    ).toList();

    // Separar completados y pendientes
    final completed = <Habit>[];
    final pending = <Habit>[];

    for (final habit in habitsToday) {
      if (habit.isCompletedToday) {
        completed.add(habit);
      } else {
        pending.add(habit);
      }
    }

    // Ordenar pendientes por proximidad a la hora de recordatorio
    pending.sort((a, b) {
      final aMinutes = a.reminderTime.hour * 60 + a.reminderTime.minute;
      final bMinutes = b.reminderTime.hour * 60 + b.reminderTime.minute;
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;

      final aDistance = (aMinutes - currentMinutes).abs();
      final bDistance = (bMinutes - currentMinutes).abs();

      return aDistance.compareTo(bDistance);
    });

    // Ordenar completados por tiempo transcurrido (más reciente primero)
    // Por ahora usamos el orden por nombre como placeholder
    // TODO: En gamificación, implementar timestamps reales de completación
    completed.sort((a, b) => b.name.compareTo(a.name));

    // Retornar pendientes primero, luego completados
    return [...pending, ...completed];
  }

  // Obtener hábitos completados hoy
  List<Habit> get completedToday {
    return _habits.where((h) => h.isCompletedToday).toList();
  }

  // Obtener hábitos pendientes hoy
  List<Habit> get pendingToday {
    final today = DateTime.now().weekday;
    return _habits.where((habit) => 
        habit.isActive && 
        habit.frequency.contains(today) &&
        !habit.isCompletedToday
    ).toList();
  }

  // Métodos auxiliares
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  // Refrescar hábitos desde la base de datos
  Future<void> refreshHabits() async {
    _setLoading(true);
    try {
      await _loadHabitsFromDatabase();
      _clearError();
    } catch (e) {
      _setError('Error refrescando hábitos: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Crear hábitos de ejemplo (ahora persistente)
  Future<void> _createSampleHabits() async {
    final sampleHabits = [
      Habit(
        id: 'sample1',
        name: 'Beber agua',
        description: '8 vasos al día',
        icon: Icons.local_drink,
        color: 0xFF00D2D3,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        completions: {
          DateTime.now().subtract(const Duration(days: 1)).toDateString(): true,
          DateTime.now().subtract(const Duration(days: 2)).toDateString(): true,
        },
        streak: 2,
      ),
      Habit(
        id: 'sample2',
        name: 'Ejercicio',
        description: '30 min diarios',
        icon: Icons.fitness_center,
        color: 0xFF00B894,
        frequency: [1, 3, 5],
        reminderTime: const TimeOfDay(hour: 7, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        completions: {},
        streak: 0,
      ),
      Habit(
        id: 'sample3',
        name: 'Leer',
        description: '20 páginas',
        icon: Icons.book,
        color: 0xFF6C5CE7,
        frequency: [1, 2, 3, 4, 5, 6, 7],
        reminderTime: const TimeOfDay(hour: 22, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        completions: {
          DateTime.now().toDateString(): true,
        },
        streak: 1,
      ),
    ];

    // Guardar cada hábito en la base de datos
    for (final habit in sampleHabits) {
      try {
        await _databaseHelper.insertHabit(habit);
        _habits.add(habit);
      } catch (e) {
        print('Error insertando hábito de ejemplo ${habit.name}: $e');
      }
    }
    notifyListeners();
  }

  // Método para limpiar todos los datos (útil para testing)
  Future<void> clearAllData() async {
    try {
      await _databaseHelper.clearAllData();
      await _notificationService.cancelAllNotifications();
      _habits.clear();
      _isInitialized = false;
      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error limpiando datos: $e');
    }
  }

  // Programar notificaciones para todos los hábitos
  Future<void> _scheduleAllNotifications() async {
    try {
      for (final habit in _habits) {
        await _notificationService.scheduleHabitReminder(habit);
      }
    } catch (e) {
      print('Error programando notificaciones: $e');
    }
  }

  // Método para reprogramar todas las notificaciones
  Future<void> rescheduleAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      await _scheduleAllNotifications();
    } catch (e) {
      _setError('Error reprogramando notificaciones: $e');
    }
  }
}