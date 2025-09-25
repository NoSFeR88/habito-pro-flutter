import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener referencia a la colección de hábitos del usuario actual
  CollectionReference get _habitsCollection {
    final userId = _auth.currentUser?.uid ?? 'anonymous';
    return _firestore.collection('users').doc(userId).collection('habits');
  }

  // Crear nuevo hábito
  Future<Habit> createHabit(Habit habit) async {
    try {
      final docRef = _habitsCollection.doc();
      final newHabit = habit.copyWith(id: docRef.id);
      
      await docRef.set(newHabit.toMap());
      return newHabit;
    } catch (e) {
      throw Exception('Error creando hábito: $e');
    }
  }

  // Obtener todos los hábitos
  Future<List<Habit>> getHabits() async {
    try {
      final querySnapshot = await _habitsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Habit.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error obteniendo hábitos: $e');
    }
  }

  // Obtener stream de hábitos en tiempo real
  Stream<List<Habit>> getHabitsStream() {
    return _habitsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Habit.fromMap(data);
      }).toList();
    });
  }

  // Actualizar hábito
  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitsCollection.doc(habit.id).update(habit.toMap());
    } catch (e) {
      throw Exception('Error actualizando hábito: $e');
    }
  }

  // Eliminar hábito (soft delete)
  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitsCollection.doc(habitId).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error eliminando hábito: $e');
    }
  }

  // Marcar hábito como completado/no completado
  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    try {
      final docRef = _habitsCollection.doc(habitId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Hábito no encontrado');
      }

      final habit = Habit.fromMap(doc.data() as Map<String, dynamic>);
      final dateStr = date.toDateString();
      
      // Toggle completion
      final newCompletions = Map<String, bool>.from(habit.completions);
      newCompletions[dateStr] = !(newCompletions[dateStr] ?? false);
      
      // Recalcular racha
      final updatedHabit = habit.copyWith(completions: newCompletions);
      final newStreak = updatedHabit.calculateStreak();
      
      // Actualizar en Firebase
      await docRef.update({
        'completions': newCompletions,
        'streak': newStreak,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error actualizando completación: $e');
    }
  }

  // Obtener estadísticas del usuario
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final habits = await getHabits();
      final today = DateTime.now();
      
      if (habits.isEmpty) {
        return {
          'totalHabits': 0,
          'completedToday': 0,
          'completedThisWeek': 0,
          'completedThisMonth': 0,
          'currentStreak': 0,
          'longestStreak': 0,
          'completionRate': 0.0,
        };
      }

      final completedToday = habits.where((h) => h.isCompletedToday).length;
      final activeHabits = habits.where((h) => h.isActive).length;
      
      // Completados esta semana
      int completedThisWeek = 0;
      for (final habit in habits) {
        completedThisWeek += habit.completedThisWeek;
      }
      
      // Completados este mes
      int completedThisMonth = 0;
      for (final habit in habits) {
        final startOfMonth = DateTime(today.year, today.month, 1);
        for (int i = 0; i < today.day; i++) {
          final day = startOfMonth.add(Duration(days: i));
          if (habit.completions[day.toDateString()] ?? false) {
            completedThisMonth++;
          }
        }
      }
      
      // Rachas
      final streaks = habits.map((h) => h.streak).toList();
      final currentStreak = streaks.isNotEmpty ? streaks.reduce((a, b) => a > b ? a : b) : 0;
      final longestStreak = currentStreak; // Por ahora igual, se puede mejorar guardando histórico
      
      // Tasa de completación
      final completionRate = activeHabits > 0 ? (completedToday / activeHabits) : 0.0;

      return {
        'totalHabits': activeHabits,
        'completedToday': completedToday,
        'completedThisWeek': completedThisWeek,
        'completedThisMonth': completedThisMonth,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'completionRate': completionRate,
      };
    } catch (e) {
      throw Exception('Error obteniendo estadísticas: $e');
    }
  }

  // Backup de datos locales a Firebase
  Future<void> backupLocalData(List<Habit> localHabits) async {
    try {
      final batch = _firestore.batch();
      
      for (final habit in localHabits) {
        final docRef = _habitsCollection.doc(habit.id);
        batch.set(docRef, habit.toMap());
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Error realizando backup: $e');
    }
  }

  // Obtener datos de un período específico para gráficos
  Future<Map<String, int>> getCompletionDataForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    String? habitId,
  }) async {
    try {
      final habits = habitId != null 
          ? [(await _habitsCollection.doc(habitId).get()).data() as Map<String, dynamic>]
              .map((data) => Habit.fromMap(data)).toList()
          : await getHabits();
      
      final Map<String, int> completionData = {};
      
      for (DateTime date = startDate; 
           date.isBefore(endDate.add(const Duration(days: 1))); 
           date = date.add(const Duration(days: 1))) {
        
        final dateStr = date.toDateString();
        int completions = 0;
        
        for (final habit in habits) {
          if (habit.completions[dateStr] ?? false) {
            completions++;
          }
        }
        
        completionData[dateStr] = completions;
      }
      
      return completionData;
    } catch (e) {
      throw Exception('Error obteniendo datos del período: $e');
    }
  }

  // Limpiar datos antiguos (opcional, para optimización)
  Future<void> cleanOldData({int daysToKeep = 365}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final habits = await getHabits();
      
      for (final habit in habits) {
        final newCompletions = <String, bool>{};
        
        habit.completions.forEach((dateStr, completed) {
          final date = DateTime.parse(dateStr);
          if (date.isAfter(cutoffDate)) {
            newCompletions[dateStr] = completed;
          }
        });
        
        if (newCompletions.length != habit.completions.length) {
          await _habitsCollection.doc(habit.id).update({
            'completions': newCompletions,
          });
        }
      }
    } catch (e) {
      throw Exception('Error limpiando datos antiguos: $e');
    }
  }

  // Verificar conectividad y sincronizar
  Future<bool> isOnline() async {
    try {
      await _firestore.doc('connectivity/test').get(
        const GetOptions(source: Source.server)
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}