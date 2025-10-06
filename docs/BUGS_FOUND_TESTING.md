# 🐛 BUGS ENCONTRADOS - TESTING MANUAL ADVANCED FREQUENCY

**Fecha**: 2025-10-06
**Tester**: Usuario
**Branch**: `claude/feature-advanced-frequency`
**Commit base**: `a1d1200`

---

## 📊 RESUMEN

| Severidad | Total | Fixed | Pendiente |
|-----------|-------|-------|-----------|
| 🔴 Critical | 1 | 1 ✅ | 0 |
| 🟠 High | 1 | 0 | 1 ⏳ |
| 🟡 Medium | 1 | 0 | 1 ⏳ |
| 🟢 Low | 4 | 0 | 4 ⏳ |
| **TOTAL** | **7** | **1** | **6** |

---

## 🔴 CRITICAL BUGS

### BUG #7: Bonus Points Infinitos ✅ FIXED

**Descripción**: Al completar/descompletar repeatedly, se suman puntos infinitos sin restar el bonus.

**Severidad**: 🔴 Critical (exploit de gamificación)

**Steps to Reproduce**:
1. Crear hábito Weekly con target 3/semana
2. Completar 3 veces → +15 pts (5 base + 10 bonus)
3. Descompletar 1 → Se restan solo 5 pts (debería restar 15)
4. Volver a completar → +15 pts again
5. Loop infinito = puntos infinitos

**Expected**:
- Completar 3ra vez: +15 pts (cumple target)
- Descompletar: -15 pts (pierde target)
- Re-completar: +15 pts (vuelve a cumplir target)

**Actual (ANTES)**:
- Completar 3ra vez: +15 pts
- Descompletar: -5 pts ❌ (solo quita base, bonus se queda)
- Re-completar: +15 pts
- **Resultado**: +25 pts netos por ciclo

**Root Cause**:
```dart
// lib/providers/habit_provider.dart:196-201 (ANTES)
if (previousHabit.frequencyType == FrequencyType.weekly &&
    previousHabit.isWeeklyTargetMet) { // ❌ Verifica ANTES de descompletar
  pointsToRemove += 10;
}
```

**Fix Applied** ✅:
```dart
// lib/providers/habit_provider.dart:197-203 (DESPUÉS)
if (previousHabit.frequencyType == FrequencyType.weekly &&
    previousHabit.isWeeklyTargetMet &&
    !updatedHabit.isWeeklyTargetMet) { // ✅ Verifica transición
  // Solo quitar bonus si ANTES cumplía y AHORA no cumple
  pointsToRemove += 10;
}
```

**Commit**: `a1d1200` (parte del refactor cleanup)

**Testing**:
- [ ] Manual regression testing required
- [ ] Unit test creado (pendiente)

---

## 🟠 HIGH SEVERITY BUGS

### BUG #5: EditHabitScreen sin Selector 4 Modos ⏳ PENDIENTE

**Descripción**: Al editar hábito Weekly, no aparece slider para weekly target. Solo aparecen los 7 botones de días.

**Severidad**: 🟠 High (UX inconsistente, feature no funcional)

**Steps to Reproduce**:
1. Crear hábito Weekly con target 5/semana
2. Editar hábito
3. Ir a sección "Frequency"

**Expected**:
- Selector de 4 modos (Daily/Weekdays/Custom/Weekly) como en AddHabitScreen
- Si Weekly seleccionado → Slider 1-7 días/semana
- Puede cambiar de Weekly a otro tipo

**Actual**:
- Solo aparecen 7 botones circulares (L-M-X-J-V-S-D)
- No hay forma de cambiar tipo de frecuencia
- No hay slider para weekly target

**Root Cause**:
EditHabitScreen tiene UI antigua (pre-advanced frequency). No se actualizó con los 4 modos nuevos.

**Fix Plan** ⏳:
1. Copiar `_buildFrequencySelection()` de AddHabitScreen
2. Agregar `_buildFrequencyTypeOption()` (selector 4 modos)
3. Agregar `_buildCustomDaysSelector()` (7 botones condicionales)
4. Agregar `_buildWeeklyTargetSelector()` (slider condicional)

**Files to Modify**:
- `lib/screens/edit_habit_screen.dart` (líneas 256-338 reemplazar completamente)

**Estimated Effort**: 30 min

**Priority**: Alta (bloquea edición completa de weekly habits)

---

## 🟡 MEDIUM SEVERITY BUGS

### BUG #1: Strings sin i18n Automático ⏳ PENDIENTE

**Descripción**: Varios strings no cambian automáticamente al cambiar idioma.

**Severidad**: 🟡 Medium (i18n incompleta)

**Steps to Reproduce**:
1. Cambiar idioma a inglés (Settings → Language → English)
2. Ir a pantalla principal (Today tab)
3. Observar encabezado de fecha

**Expected**:
```
EN: Mon · 6 Oct
ES: Lun · 6 Oct
```

**Actual**:
```
EN: Hoy · Lun, 6 Oct  ❌ (mezcla español/inglés)
ES: Hoy · Lun, 6 Oct  ✅ (correcto)
```

**Affected Strings**:
- Fecha en home_screen.dart encabezado
- Posiblemente otros en stats_screen.dart

**Root Cause**:
Hardcoded strings o formateo manual de fechas sin `AppLocalizations`.

**Fix Plan** ⏳:
1. Grep por hardcoded "Hoy", "Lun", "Mon", etc.
2. Reemplazar por `AppLocalizations.of(context)!.today`
3. Usar `DateFormat` con locale correcto

**Files to Check**:
- `lib/screens/home_screen.dart`
- `lib/screens/stats_screen.dart`
- `lib/widgets/stats_overview.dart`

**Estimated Effort**: 20 min

---

## 🟢 LOW SEVERITY BUGS

### BUG #2: No se Muestra Frecuencia del Hábito ⏳ PENDIENTE

**Descripción**: En la pantalla principal, no se muestra el tipo de frecuencia del hábito (Daily/Weekly/etc).

**Severidad**: 🟢 Low (UX mejorable)

**Steps to Reproduce**:
1. Crear hábito con cualquier frecuencia (Daily/Weekdays/Custom/Weekly)
2. Ir a pantalla principal
3. Ver habit card

**Expected**:
```
Morning Workout
Daily | 🔥 5 days streak
[Checkbox]
```

**Actual**:
```
Morning Workout
🔥 5 days streak
[Checkbox]
```
(Falta el indicador de frecuencia)

**Fix Plan** ⏳:
1. Agregar campo `frequencyLabel` al HabitCard widget
2. Mostrar: "Daily", "Weekdays", "Custom", "3/week", etc.
3. Localizar strings

**Files to Modify**:
- `lib/widgets/habit_card.dart`

**Estimated Effort**: 15 min

---

### BUG #3: Subtítulo no Muestra Días Seleccionados ⏳ PENDIENTE

**Descripción**: En Custom frequency, el subtítulo debería mostrar qué días están seleccionados (ej: "Mon, Wed, Fri").

**Severidad**: 🟢 Low (UX mejorable)

**Steps to Reproduce**:
1. Crear hábito Custom con días Lun-Mié-Vie seleccionados
2. Ir a pantalla principal
3. Ver habit card

**Expected**:
```
Gym Routine
Custom | Mon, Wed, Fri
🔥 2 weeks streak
[Checkbox]
```

**Actual**:
```
Gym Routine
Custom
🔥 2 weeks streak
[Checkbox]
```
(Falta "Mon, Wed, Fri")

**Fix Plan** ⏳:
1. En `habit_card.dart`, formatear `habit.frequency` como string legible
2. Ejemplo: `[1,3,5]` → "Mon, Wed, Fri"
3. Localizar nombres de días

**Files to Modify**:
- `lib/widgets/habit_card.dart`
- Posiblemente agregar helper en `lib/models/habit.dart`

**Estimated Effort**: 20 min

---

### BUG #4: Puntos Totales Incorrectos al Iniciar ⏳ PENDIENTE

**Descripción**: Al iniciar app por primera vez, el contador de puntos totales no empieza en 0.

**Severidad**: 🟢 Low (solo afecta primera vez)

**Steps to Reproduce**:
1. Instalar app fresh (o limpiar datos)
2. Iniciar app
3. Ver GamificationCard

**Expected**:
```
Level 1
0 points
```

**Actual**:
```
Level 1
X points  ❌ (puntos de más, ej: 5, 10, etc.)
```

**Root Cause**:
Posible inicialización incorrecta de `GamificationProvider` o puntos por logros iniciales.

**Fix Plan** ⏳:
1. Revisar `lib/providers/gamification_provider.dart` constructor
2. Asegurar `_totalPoints = 0` en init
3. Revisar si logros iniciales otorgan puntos automáticamente

**Files to Check**:
- `lib/providers/gamification_provider.dart`

**Estimated Effort**: 10 min

---

### BUG #6: Pluralización "1 días" ⏳ PENDIENTE

**Descripción**: Cuando la racha es de 1 día, muestra "1 días" (debería ser "1 día").

**Severidad**: 🟢 Low (gramática incorrecta)

**Steps to Reproduce**:
1. Crear hábito Daily
2. Completar 1 vez
3. Ir a Stats → Tab "Today"
4. Ver streak

**Expected**:
```
1 día   (singular)
2 días  (plural)
3 días  (plural)
```

**Actual**:
```
1 días  ❌ (plural incorrecto)
2 días  ✅
3 días  ✅
```

**Affected Locations**:
- Stats → Tab "Today"
- Stats → Tab "Week"
- Stats → Tab "Trends"
- HabitCard streak display
- Posiblemente otros

**Root Cause**:
Falta pluralización en `app_es.arb` y `app_en.arb`.

**Fix Plan** ⏳:
1. Usar ICU pluralization en ARB files:
```json
"streakDays": "{count, plural, =1{1 día} other{{count} días}}",
"streakWeeks": "{count, plural, =1{1 semana} other{{count} semanas}}"
```
2. Reemplazar en todos los puntos donde se muestra streak
3. Regenerar `flutter gen-l10n`

**Files to Modify**:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_es.arb`
- Todos los archivos que muestran streak (grep "días")

**Estimated Effort**: 30 min

---

## 📝 NOTA ADICIONAL: SIMULACIÓN DE FECHAS

**Comentario del tester**:
> "Simular día siguiente (cambiar fecha dispositivo +1 día): No puedo hacer esto en mi dispositivo y no se hacerlo en el emulador, pero en calendario de estadísticas Semana aparecen los días bien marcados"

**Interpretación**:
- El tester no pudo simular fechas futuras
- Sin embargo, verific ó que el calendario semanal muestra correctamente los días marcados
- **No hay bug reportado** en esta área

**Recomendación para testing futuro**:
- Usar emulador Android Studio (permite cambiar fecha del sistema)
- O implementar feature de "testing mode" con fecha simulada

---

## 🎯 PLAN DE ACCIÓN

### Inmediato (Sesión actual):
1. ✅ **BUG #7 CRÍTICO**: FIXED
2. ⏳ **BUG #5 HIGH**: En progreso (requiere reescribir EditHabitScreen UI)

### Próxima sesión:
3. **BUG #1 MEDIUM**: i18n strings mixtos
4. **BUG #6 LOW**: Pluralización streaks
5. **BUG #2 LOW**: Display frecuencia en card
6. **BUG #3 LOW**: Subtítulo custom days
7. **BUG #4 LOW**: Puntos iniciales

### Testing de regresión:
- Verificar BUG #7 fixed funcionando correctamente
- Re-test todos los casos de bonus points
- Re-test edición de hábitos weekly (cuando #5 esté fixed)

---

**FIN DEL REPORTE** 🐛
