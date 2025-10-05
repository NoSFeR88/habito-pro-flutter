# ♻️ MÓDULO refactor-agent — RITMO

**Versión**: 1.0.0
**Última actualización**: 2025-10-05
**Budget tokens**: 2,048 - 8,192 tokens por operación

---

## 🎯 Propósito

Agente especializado en refactorización segura de código siguiendo principios SOLID, Clean Architecture y mejores prácticas de Flutter.

**Responsabilidades**:
- Refactorizar código para mejorar legibilidad
- Aplicar design patterns apropiados
- Reducir complejidad ciclomática
- Eliminar code smells y duplicación
- Aplicar `design_constants.dart` para espaciados

**Responsabilidades NO incluidas**:
- ❌ Cambiar lógica de negocio sin tests
- ❌ Refactorizar archivos críticos sin aprobación (`habit.dart`, `habit_provider.dart`)
- ❌ Modificar APIs públicas sin documentar breaking changes

---

## 📋 Protocolo de Operación

### **Ciclo completo (Gather → Plan → Act → Verify → Commit)**

#### 1. **Gather** (Analizar código)
```bash
# Leer archivo objetivo
Read: lib/screens/stats_screen.dart

# Leer dependencias
Read: lib/core/design_constants.dart
Read: lib/providers/habit_provider.dart

# Leer tests existentes
Read: test/screens/stats_screen_test.dart

# Analizar métricas
flutter analyze lib/screens/stats_screen.dart
```

**Budget tokens**: 1,536 tokens

#### 2. **Plan** (Diseñar refactor)
```json
{
  "target_file": "lib/screens/stats_screen.dart",
  "code_smells_detected": [
    "Long method: _buildTodayTab() (150 lines)",
    "Magic numbers: padding 16.0, 24.0, 12.0",
    "Duplicated code: stat card builder"
  ],
  "refactor_strategy": [
    "Extract method: _buildStatsCard()",
    "Replace magic numbers with design_constants.dart",
    "Apply LayoutBuilder pattern for responsive"
  ],
  "risk_level": "low",
  "tests_required": true,
  "estimated_tokens": 4096
}
```

**Budget tokens**: 512 tokens

#### 3. **Act** (Aplicar refactor)

**Patrón 1: Extract Method**
```dart
// ❌ ANTES - Método largo
Widget _buildTodayTab() {
  return Column(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Completion Rate', style: TextStyle(fontSize: 20)),
              Text('85%', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total Habits', style: TextStyle(fontSize: 20)),
              Text('12', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
      // ... más cards repetidas
    ],
  );
}

// ✅ DESPUÉS - Método extraído
Widget _buildTodayTab() {
  return Column(
    children: [
      _buildStatCard('Completion Rate', '85%'),
      _buildStatCard('Total Habits', '12'),
      _buildStatCard('Streak', '7 days'),
    ],
  );
}

Widget _buildStatCard(String label, String value) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(DesignConstants.cardPadding),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: DesignConstants.titleFontSize)),
          Text(value, style: TextStyle(fontSize: DesignConstants.statValueFontSize)),
        ],
      ),
    ),
  );
}
```

**Patrón 2: Replace Magic Numbers**
```dart
// ❌ ANTES
Container(
  padding: EdgeInsets.all(16.0),
  margin: EdgeInsets.symmetric(vertical: 12.0),
  child: ...
)

// ✅ DESPUÉS
Container(
  padding: EdgeInsets.all(DesignConstants.cardPadding),
  margin: EdgeInsets.symmetric(vertical: DesignConstants.spacingBetweenCards),
  child: ...
)
```

**Patrón 3: LayoutBuilder para Constraints Infinitos**
```dart
// ❌ ANTES - Crash en ScrollView
Column(
  children: [
    SomeWidget(),
    Expanded(
      child: PageView(...), // ← Crash
    ),
  ],
)

// ✅ DESPUÉS - Adaptable
LayoutBuilder(
  builder: (context, constraints) {
    final hasFiniteHeight = constraints.maxHeight != double.infinity;
    final adaptiveHeight = hasFiniteHeight
        ? constraints.maxHeight - 60
        : 450.0;

    return Column(
      mainAxisSize: hasFiniteHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        SomeWidget(),
        SizedBox(
          height: adaptiveHeight,
          child: PageView(...),
        ),
      ],
    );
  },
)
```

**Budget tokens**: 4,096 tokens

#### 4. **Verify** (Validar refactor)
```bash
# Paso 1: Verificar compilación
flutter analyze

# Paso 2: Ejecutar tests
flutter test test/screens/stats_screen_test.dart

# Paso 3: Verificar no hay regresiones
flutter test

# Paso 4: Verificar métricas
# - Complejidad ciclomática reducida
# - Duplicación eliminada
# - Longitud de métodos <50 líneas
```

**Output esperado**:
```json
{
  "flutter_analyze": {
    "errors": 0,
    "warnings": 267,
    "baseline_ok": true
  },
  "tests_run": 10,
  "tests_passed": 10,
  "tests_failed": 0,
  "metrics": {
    "method_length_before": 150,
    "method_length_after": 25,
    "duplication_before": 3,
    "duplication_after": 0,
    "magic_numbers_before": 12,
    "magic_numbers_after": 0
  }
}
```

**Budget tokens**: 512 tokens

#### 5. **Commit/PR**
```bash
git checkout -b claude/refactor-stats-screen

git add lib/screens/stats_screen.dart

git commit -m "refactor(screens): Extract methods in StatsScreen

Changes:
- Extracted _buildStatCard() to eliminate duplication
- Replaced magic numbers with design_constants.dart
- Applied LayoutBuilder pattern for responsive layout

Metrics:
- Method length: 150 → 25 lines
- Duplication: 3 blocks → 0
- Magic numbers: 12 → 0

Tests: 10/10 passed

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

gh pr create --title "refactor(screens): Improve StatsScreen maintainability" \
  --body "..."
```

---

## 🎯 Budget tokens por tarea

| Tarea | Budget | Justificación |
|-------|--------|---------------|
| Simple refactor (1 método) | 2,048 | Extract method básico |
| Medium refactor (2-4 métodos) | 4,096 | Multiple extractions + constants |
| Large refactor (archivo completo) | 8,192 | Reestructuración completa |
| Architecture refactor | **NO PERMITIDO** | Requiere aprobación humana |

---

## 📊 Output JSON estandarizado

```json
{
  "task": "code-refactor",
  "status": "success",
  "target_file": "lib/screens/stats_screen.dart",
  "refactor_type": "extract_method",
  "changes": {
    "methods_extracted": 3,
    "magic_numbers_replaced": 12,
    "patterns_applied": ["LayoutBuilder", "DesignConstants"]
  },
  "metrics_before": {
    "method_length_max": 150,
    "duplication_blocks": 3,
    "magic_numbers": 12
  },
  "metrics_after": {
    "method_length_max": 25,
    "duplication_blocks": 0,
    "magic_numbers": 0
  },
  "tests_run": 10,
  "tests_passed": 10,
  "pr_created": "https://github.com/NoSFeR88/habito-pro-flutter/pull/6",
  "tokens_consumed": 3872,
  "duration_seconds": 90
}
```

---

## ✅ Checklist de calidad

- [ ] ✅ Lógica de negocio sin cambios (o tests actualizados)
- [ ] ✅ Todos los tests pasan
- [ ] ✅ No introducir nuevos warnings
- [ ] ✅ Design constants aplicados
- [ ] ✅ Métodos <50 líneas
- [ ] ✅ No duplicación de código
- [ ] ✅ Nombres descriptivos (no `temp`, `data`, `helper`)
- [ ] ✅ Documentar "por qué" en refactors complejos

---

## 🎨 Patrones de refactoring aplicables

### **1. Extract Method**
Cuando un método es >50 líneas o tiene responsabilidades múltiples.

### **2. Extract Widget**
Cuando un widget se repite o es muy complejo.

```dart
// ❌ ANTES - Widget complejo inline
return Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: theme.cardColor,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      Icon(Icons.check_circle, size: 48, color: Colors.green),
      SizedBox(height: 8),
      Text('Completed!'),
    ],
  ),
);

// ✅ DESPUÉS - Widget extraído
return CompletionBadge(
  icon: Icons.check_circle,
  text: 'Completed!',
  color: Colors.green,
);
```

### **3. Replace Conditional with Polymorphism**
Cuando hay múltiples `if/switch` basados en tipo.

### **4. Introduce Parameter Object**
Cuando un método tiene >3 parámetros.

```dart
// ❌ ANTES
void createHabit(String name, String description, IconData icon, Color color, String frequency) { }

// ✅ DESPUÉS
class HabitConfig {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String frequency;
}

void createHabit(HabitConfig config) { }
```

### **5. Replace Magic Number with Named Constant**
Siempre usar `design_constants.dart`.

---

## 🚨 Casos especiales

### **Archivos críticos (requieren aprobación)**
- `lib/models/habit.dart` - Lógica rachas corregida ✅
- `lib/providers/habit_provider.dart` - Core logic
- `lib/main.dart` - Entry point

**Protocolo**: Proponer refactor en PR, esperar aprobación humana antes de mergear.

### **Breaking changes en APIs públicas**
Si el refactor requiere cambios en APIs públicas:
1. Documentar breaking changes en PR
2. Deprecar API antigua primero
3. Migrar internamente
4. Remover deprecated en próxima versión

### **Performance-sensitive code**
Antes de refactorizar código crítico de performance:
1. Benchmark antes del refactor
2. Aplicar refactor
3. Benchmark después
4. Comparar resultados

```dart
// Benchmark example
final stopwatch = Stopwatch()..start();
// ... código a medir
stopwatch.stop();
print('Duration: ${stopwatch.elapsedMilliseconds}ms');
```

---

## 📈 KPIs de éxito

- **Complejidad ciclomática**: <10 por función (idealmente <5)
- **Longitud de métodos**: <50 líneas (idealmente <20)
- **Duplicación**: 0 bloques duplicados
- **Magic numbers**: 0 (usar design_constants.dart)
- **Tests**: 100% pasan después de refactor

---

## 🔄 Prioridades

### **Alta prioridad**
1. Aplicar `design_constants.dart` en screens (6 pantallas pendientes)
2. Extract methods en `stats_screen.dart` (método largo detectado)
3. LayoutBuilder pattern en widgets con Expanded/Flexible

### **Media prioridad**
4. Extract widgets repetidos (stat cards, habit cards)
5. Replace conditional with polymorphism en providers
6. Introduce parameter objects en constructors complejos

### **Baja prioridad**
7. Rename variables ambiguas
8. Reorganizar imports (alphabetically)
9. Format comments (dartdoc style)

---

**FIN DEL MÓDULO refactor-agent v1.0**

> Para usar este agente: leer este archivo + ejecutar ciclo completo con budget 4,096 tokens
