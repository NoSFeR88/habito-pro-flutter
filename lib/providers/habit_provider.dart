import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import 'gamification_provider.dart';

class HabitProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  List<Habit> _habits = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isInitialized = false;
  GamificationProvider? _gamificationProvider;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Método para conectar con GamificationProvider
  void setGamificationProvider(GamificationProvider provider) {
    _gamificationProvider = provider;
  }

  // Inicializar hábitos desde la base de datos
  Future<void> initializeHabits() async {
    if (_isInitialized) return;

    _setLoading(true);
    try {
      // Inicializar notificaciones
      await _notificationService.initialize();

      await _loadHabitsFromDatabase();

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

  // Actualizar hábito (solo datos, sin reprogramar notificaciones)
  Future<void> _updateHabitData(Habit habit) async {
    await _databaseHelper.updateHabit(habit);
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  // Actualizar hábito completo (con reprogramación de notificaciones)
  Future<void> updateHabit(Habit habit) async {
    try {
      await _updateHabitData(habit);

      // Solo reprogramar notificaciones si el hábito está activo
      if (habit.isActive) {
        await _notificationService.scheduleHabitReminder(habit);
      } else {
        await _notificationService.cancelHabitReminders(habit.id);
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
  /// Retorna true si necesita mostrar diálogo para cambiar hora de notificación
  Future<bool> toggleHabitCompletion(String habitId, [DateTime? date]) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateStr = targetDate.toDateString();

      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return false;

      final habit = _habits[habitIndex];
      final newCompletions = Map<String, bool>.from(habit.completions);

      // Verificar si se está completando o descompletando
      final wasCompleted = habit.completions[dateStr] ?? false;
      final willBeCompleted = !wasCompleted;

      // Toggle completion
      newCompletions[dateStr] = willBeCompleted;

      // Crear hábito temporal para recalcular racha con las nuevas completaciones
      final tempHabit = habit.copyWith(completions: newCompletions);
      final newStreak = tempHabit.calculateStreak();

      // Crear hábito final con racha actualizada
      final updatedHabit = habit.copyWith(
        completions: newCompletions,
        streak: newStreak,
      );

      // Solo actualizar datos, sin reprogramar notificaciones
      await _updateHabitData(updatedHabit);

      // NUEVA LÓGICA DE NOTIFICACIONES SIMPLIFICADA
      final now = DateTime.now();
      final isToday = targetDate.year == now.year &&
                      targetDate.month == now.month &&
                      targetDate.day == now.day;

      bool needsTimeDialog = false; // Flag para mostrar diálogo de hora

      if (isToday && updatedHabit.isReminderEnabled) {
        if (willBeCompleted) {
          // COMPLETAR: Cancelar todas + Reprogramar desde próxima ocurrencia
          await _notificationService.scheduleFromNextOccurrence(updatedHabit);
          debugPrint('✅ Hábito completado - Notificaciones desde próxima ocurrencia: ${habit.name}');
        } else {
          // DESMARCAR: Solicitar nueva hora (diálogo en UI)
          needsTimeDialog = true;
          debugPrint('🔔 Hábito desmarcado - Se necesita nueva hora de notificación');
        }
      }

      // Manejar puntos de gamificación
      if (_gamificationProvider != null) {
        if (willBeCompleted) {
          // Puntos base por completar
          int pointsEarned = 5;

          // BONUS SEMANAL para hábitos con frecuencia weekly
          if (updatedHabit.frequencyType == FrequencyType.weekly) {
            // Verificar si con esta completion cumple el target semanal
            if (updatedHabit.isWeeklyTargetMet) {
              pointsEarned += 10; // +10 puntos bonus por cumplir target semanal
              debugPrint('🎯 +10 puntos BONUS por cumplir target semanal: ${habit.name}');
            }
          }

          _gamificationProvider!.addPoints(pointsEarned);
          debugPrint('✅ +$pointsEarned puntos por completar hábito: ${habit.name}');
        } else {
          // Descompletando hábito
          int pointsToRemove = 5;

          // Si tenía bonus semanal, también se pierde
          final previousHabit = _habits[habitIndex];
          if (previousHabit.frequencyType == FrequencyType.weekly &&
              previousHabit.isWeeklyTargetMet) {
            pointsToRemove += 10; // Remover también el bonus
            debugPrint('⚠️ Perdiendo bonus semanal');
          }

          _gamificationProvider!.removePoints(pointsToRemove);
          debugPrint('❌ -$pointsToRemove puntos por descompletar hábito: ${habit.name}');
        }

        // Verificar logros
        final newAchievements = _gamificationProvider!.checkForNewAchievements(_habits);

        // Mostrar diálogos de logros desbloqueados
        for (final achievement in newAchievements) {
          // El diálogo se mostrará desde el widget cuando reciba la notificación
          debugPrint('🏆 Nuevo logro desbloqueado: ${achievement.name}');
        }
      }

      _clearError();
      return needsTimeDialog; // Retornar si necesita mostrar diálogo
    } catch (e) {
      _setError('Error actualizando completado: $e');
      return false;
    }
  }

  // Actualizar hora de recordatorio y reprogramar notificaciones
  Future<void> updateReminderTime(String habitId, TimeOfDay newTime) async {
    try {
      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) {
        _setError('Hábito no encontrado');
        return;
      }

      final habit = _habits[habitIndex];
      final updatedHabit = habit.copyWith(reminderTime: newTime);

      // Actualizar en base de datos
      await _updateHabitData(updatedHabit);

      // Reprogramar TODAS las notificaciones con la nueva hora
      await _notificationService.scheduleHabitReminder(updatedHabit);

      debugPrint('✅ Hora de recordatorio actualizada: ${habit.name} - ${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}');
      _clearError();
    } catch (e) {
      _setError('Error actualizando hora de recordatorio: $e');
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

  // Obtener todos los hábitos activos de la semana actual con su progreso
  List<Map<String, dynamic>> get habitsForWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return _habits.where((habit) => habit.isActive).map((habit) {
      int completedDays = 0;
      int scheduledDays = 0;

      // Contar días completados y programados en la semana
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        if (habit.frequency.contains(day.weekday)) {
          scheduledDays++;
          final dayStr = day.toDateString();
          if (habit.completions[dayStr] ?? false) {
            completedDays++;
          }
        }
      }

      return {
        'habit': habit,
        'completedDays': completedDays,
        'scheduledDays': scheduledDays,
        'percentage': scheduledDays > 0 ? (completedDays / scheduledDays * 100).toInt() : 0,
      };
    }).toList();
  }

  // Obtener hábitos por completar hoy (ordenados)

  List<Habit> get habitsForToday {
    final today = DateTime.now().weekday;
    final currentTime = TimeOfDay.now();

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
        print('Error inserting example habit ${habit.name}: $e');
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
      print('Notification scheduling error: $e');
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

  // Obtener el número total de completaciones de un hábito
  int getHabitCompletionCount(String habitId) {
    try {
      // TODO: Implementar con base de datos cuando esté disponible
      // Por ahora retornamos un valor simulado basado en el hábito
      final habit = _habits.firstWhere((h) => h.id == habitId);
      // Simulamos basándonos en cuánto tiempo ha existido el hábito
      final daysSinceCreation = DateTime.now().difference(habit.createdAt).inDays;
      return (daysSinceCreation * 0.7).round(); // Simula 70% de completación
    } catch (e) {
      return 0;
    }
  }

  // Obtener la racha actual de un hábito
  int getHabitStreak(String habitId) {
    try {
      // TODO: Implementar con base de datos cuando esté disponible
      // Por ahora retornamos un valor simulado
      final habit = _habits.firstWhere((h) => h.id == habitId);
      final daysSinceCreation = DateTime.now().difference(habit.createdAt).inDays;
      return (daysSinceCreation * 0.5).round().clamp(0, 30); // Simula racha máxima de 30 días
    } catch (e) {
      return 0;
    }
  }

  // Verificar si un hábito fue completado hoy
  bool isHabitCompletedToday(String habitId) {
    try {
      final habit = _habits.firstWhere((h) => h.id == habitId);
      final todayStr = DateTime.now().toDateString();
      return habit.completions[todayStr] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Alternar el estado activo/pausado de un hábito
  Future<void> toggleHabitStatus(String habitId) async {
    try {
      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex != -1) {
        final habit = _habits[habitIndex];
        final updatedHabit = habit.copyWith(isActive: !habit.isActive);

        _habits[habitIndex] = updatedHabit;
        await _databaseHelper.updateHabit(updatedHabit);

        // Actualizar notificaciones
        if (updatedHabit.isActive) {
          await _notificationService.scheduleHabitReminder(updatedHabit);
        } else {
          await _notificationService.cancelHabitReminders(updatedHabit.id);
        }

        notifyListeners();
        _clearError();
      }
    } catch (e) {
      _setError('Error cambiando estado del hábito: $e');
    }
  }
}