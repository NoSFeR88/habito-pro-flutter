# 🧪 MÓDULO tests-agent — RITMO

**Versión**: 1.0.0
**Última actualización**: 2025-10-05
**Budget tokens**: 2,048 - 4,096 tokens por operación

---

## 🎯 Propósito

Agente especializado en crear y mantener tests unitarios y de integración para aumentar coverage de 50% → 80%+.

**Responsabilidades**:
- Crear tests unitarios para providers
- Crear tests de integración para flujos críticos
- Mantener y refactorizar tests existentes
- Verificar coverage y reportar métricas

**Prioridad alta**:
1. `lib/providers/habit_provider.dart` (core logic)
2. `lib/providers/premium_provider.dart` (monetización)
3. `lib/providers/gamification_provider.dart` (engagement)

---

## 📋 Protocolo de Operación

### **Ciclo completo (Gather → Plan → Act → Verify → Commit)**

#### 1. **Gather** (Recuperar contexto)
```bash
# Leer archivo objetivo
Read: lib/providers/habit_provider.dart

# Leer tests existentes (si existen)
Read: test/providers/habit_provider_test.dart

# Leer modelos relacionados
Read: lib/models/habit.dart
```

**Budget tokens**: 1,024 tokens

#### 2. **Plan** (Diseñar tests)
```json
{
  "target_file": "lib/providers/habit_provider.dart",
  "methods_to_test": [
    "addHabit()",
    "updateHabit()",
    "deleteHabit()",
    "toggleCompletion()",
    "getStats()"
  ],
  "test_types": [
    "unit",
    "edge_cases",
    "error_handling"
  ],
  "estimated_tests": 15,
  "estimated_tokens": 3072
}
```

**Budget tokens**: 512 tokens

#### 3. **Act** (Generar tests)
```dart
// Estructura recomendada
import 'package:flutter_test/flutter_test.dart';
import 'package:habito_pro_clean/providers/habit_provider.dart';
import 'package:habito_pro_clean/models/habit.dart';

void main() {
  group('HabitProvider', () {
    late HabitProvider provider;

    setUp(() {
      provider = HabitProvider();
    });

    group('addHabit', () {
      test('should add habit when name is valid', () async {
        // Arrange
        final habit = Habit(
          id: 'test-1',
          name: 'Morning Workout',
          frequency: 'daily',
        );

        // Act
        await provider.addHabit(habit);

        // Assert
        expect(provider.habits.length, 1);
        expect(provider.habits.first.name, 'Morning Workout');
      });

      test('should throw exception when name is empty', () {
        // Arrange
        final habit = Habit(id: 'test-1', name: '', frequency: 'daily');

        // Act & Assert
        expect(
          () => provider.addHabit(habit),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('toggleCompletion', () {
      test('should mark habit as completed today', () async {
        // Arrange
        final habit = Habit(id: 'test-1', name: 'Test', frequency: 'daily');
        await provider.addHabit(habit);

        // Act
        await provider.toggleCompletion('test-1');

        // Assert
        final updatedHabit = provider.habits.first;
        expect(updatedHabit.isCompletedToday, true);
      });

      test('should award 5 points when habit completed', () async {
        // Arrange
        final habit = Habit(id: 'test-1', name: 'Test', frequency: 'daily');
        await provider.addHabit(habit);

        // Act
        await provider.toggleCompletion('test-1');

        // Assert
        // Verificar gamificación (requiere mock de GamificationProvider)
        expect(provider.lastPointsAwarded, 5);
      });
    });

    group('getStats', () {
      test('should return correct completion rate', () async {
        // Arrange
        await provider.addHabit(Habit(id: '1', name: 'A', frequency: 'daily'));
        await provider.addHabit(Habit(id: '2', name: 'B', frequency: 'daily'));
        await provider.toggleCompletion('1');

        // Act
        final stats = provider.getStats();

        // Assert
        expect(stats.completionRate, 0.5); // 50%
        expect(stats.totalHabits, 2);
        expect(stats.completedToday, 1);
      });
    });
  });
}
```

**Budget tokens**: 2,048 tokens

#### 4. **Verify** (Ejecutar tests)
```bash
# Ejecutar tests específicos
flutter test test/providers/habit_provider_test.dart

# Ejecutar con coverage
flutter test --coverage

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Verificar coverage mínimo (80%)
lcov --summary coverage/lcov.info | grep "lines"
```

**Output esperado**:
```json
{
  "tests_run": 15,
  "tests_passed": 15,
  "tests_failed": 0,
  "coverage_before": 50.0,
  "coverage_after": 65.0,
  "coverage_delta": "+15.0%",
  "file": "test/providers/habit_provider_test.dart"
}
```

**Budget tokens**: 512 tokens

#### 5. **Commit/PR**
```bash
git checkout -b claude/tests-habit-provider

git add test/providers/habit_provider_test.dart
git add coverage/

git commit -m "test(providers): Add unit tests for HabitProvider

Added 15 tests covering:
- addHabit() - 3 tests
- updateHabit() - 3 tests
- deleteHabit() - 2 tests
- toggleCompletion() - 4 tests
- getStats() - 3 tests

Coverage: 50% → 65% (+15%)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

gh pr create --title "test(providers): Add comprehensive unit tests for HabitProvider" \
  --body "..."
```

---

## 🎯 Budget tokens por tarea

| Tarea | Budget | Justificación |
|-------|--------|---------------|
| Simple provider (1-3 methods) | 2,048 | Tests básicos |
| Medium provider (4-6 methods) | 4,096 | Tests + edge cases |
| Complex provider (7+ methods) | 8,192 | Tests + mocks + integration |
| Widget tests | 4,096 | Pump widgets + interaction |

---

## 📊 Output JSON estandarizado

```json
{
  "task": "unit-tests-creation",
  "status": "success",
  "target_file": "lib/providers/habit_provider.dart",
  "test_file": "test/providers/habit_provider_test.dart",
  "tests_added": 15,
  "tests_run": 15,
  "tests_passed": 15,
  "tests_failed": 0,
  "coverage": {
    "before": 50.0,
    "after": 65.0,
    "delta": 15.0,
    "target": 80.0,
    "remaining": 15.0
  },
  "pr_created": "https://github.com/NoSFeR88/habito-pro-flutter/pull/5",
  "tokens_consumed": 3421,
  "duration_seconds": 120
}
```

---

## ✅ Checklist de calidad

- [ ] ✅ Tests siguen naming convention: `should [expected] when [condition]`
- [ ] ✅ Estructura AAA (Arrange, Act, Assert)
- [ ] ✅ Edge cases cubiertos (null, empty, invalid)
- [ ] ✅ Error handling testeado
- [ ] ✅ Mocks usados para dependencias externas
- [ ] ✅ Coverage aumentó (meta: +15% mínimo)
- [ ] ✅ Todos los tests pasan
- [ ] ✅ No tests flaky (ejecutar 3 veces para verificar)

---

## 🧪 Patrones de testing

### **Mocking DatabaseHelper**
```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late HabitProvider provider;
  late MockDatabaseHelper mockDb;

  setUp(() {
    mockDb = MockDatabaseHelper();
    provider = HabitProvider(database: mockDb);
  });

  test('should call database.insert when adding habit', () async {
    // Arrange
    final habit = Habit(id: 'test', name: 'Test', frequency: 'daily');
    when(mockDb.insertHabit(any)).thenAnswer((_) async => 1);

    // Act
    await provider.addHabit(habit);

    // Assert
    verify(mockDb.insertHabit(habit)).called(1);
  });
}
```

### **Testing async operations**
```dart
test('should load habits asynchronously', () async {
  // Arrange
  when(mockDb.getHabits()).thenAnswer((_) async => [
    Habit(id: '1', name: 'A', frequency: 'daily'),
  ]);

  // Act
  await provider.initializeHabits();

  // Assert
  expect(provider.habits.length, 1);
  expect(provider.isLoading, false);
});
```

### **Testing error handling**
```dart
test('should handle database errors gracefully', () async {
  // Arrange
  when(mockDb.getHabits()).thenThrow(DatabaseException('Connection failed'));

  // Act & Assert
  expect(
    () => provider.initializeHabits(),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## 📈 KPIs de éxito

- **Coverage actual**: 50%
- **Coverage meta**: 80%+
- **Tests críticos**: 100% coverage en `habit_provider.dart`, `premium_provider.dart`
- **Flakiness**: 0% tests flaky
- **Performance**: <5s para ejecutar suite completa

---

## 🔄 Prioridades

### **Fase 1 (Alta prioridad)**
1. `habit_provider.dart` - 15 tests → Coverage 50% → 70%
2. `premium_provider.dart` - 10 tests → Coverage 30% → 80%
3. `gamification_provider.dart` - 12 tests → Coverage 40% → 75%

### **Fase 2 (Media prioridad)**
4. `theme_provider.dart` - 5 tests
5. `auth_provider.dart` - 8 tests
6. Widget tests para screens críticos

### **Fase 3 (Baja prioridad)**
7. Integration tests para flujos completos
8. Golden tests para UI consistency

---

**FIN DEL MÓDULO tests-agent v1.0**

> Para usar este agente: leer este archivo + ejecutar ciclo completo con budget 4,096 tokens
