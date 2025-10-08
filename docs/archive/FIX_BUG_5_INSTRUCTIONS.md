# 🔧 INSTRUCCIONES PARA FIX BUG #5: EditHabitScreen sin Slider Weekly

**Bug**: EditHabitScreen no tiene el selector de 4 modos (Daily/Weekdays/Custom/Weekly) como AddHabitScreen.

**Severidad**: 🟠 HIGH (UX inconsistente, feature no funcional)

---

## 📋 SOLUCIÓN

Reemplazar el método `_buildFrequencySelection()` en `lib/screens/edit_habit_screen.dart` copiando la implementación de `lib/screens/add_habit_screen.dart`.

### Archivos a Modificar:
1. `lib/screens/edit_habit_screen.dart`

---

## 🛠️ PASOS DETALLADOS

### 1. Eliminar método antiguo (líneas 256-362)

**Ubicación**: `lib/screens/edit_habit_screen.dart:256-362`

**Método a eliminar**:
```dart
Widget _buildFrequencySelection() {
  final l10n = AppLocalizations.of(context)!;
  final days = [/* 7 días */];
  final dayNames = [/* 7 nombres */];

  return Card(
    // Solo muestra 7 botones circulares
    // NO tiene selector de 4 modos
    // NO tiene slider para weekly
  );
}
```

### 2. Copiar métodos de AddHabitScreen

**Archivo fuente**: `lib/screens/add_habit_screen.dart`

**Métodos a copiar** (en orden):

#### A) `_buildFrequencySelection()` (líneas 238-298)
```dart
Widget _buildFrequencySelection() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.frequencyType, ...),
          Text(AppLocalizations.of(context)!.selectFrequencyType, ...),
          const SizedBox(height: 16),
          // 4 opciones con _buildFrequencyTypeOption
          _buildFrequencyTypeOption(FrequencyType.daily, ...),
          _buildFrequencyTypeOption(FrequencyType.weekdays, ...),
          _buildFrequencyTypeOption(FrequencyType.custom, ...),
          _buildFrequencyTypeOption(FrequencyType.weekly, ...),
          // Condicionales
          if (_selectedFrequencyType == FrequencyType.custom)
            _buildCustomDaysSelector(),
          if (_selectedFrequencyType == FrequencyType.weekly)
            _buildWeeklyTargetSelector(),
        ],
      ),
    ),
  );
}
```

#### B) `_buildFrequencyTypeOption()` (líneas 300-373)
```dart
Widget _buildFrequencyTypeOption(
  FrequencyType type,
  IconData icon,
  String title,
  String description,
) {
  final isSelected = _selectedFrequencyType == type;
  return InkWell(
    onTap: () {
      setState(() {
        _selectedFrequencyType = type;
        if (type == FrequencyType.daily) {
          _selectedDays = {1, 2, 3, 4, 5, 6, 7};
        } else if (type == FrequencyType.weekdays) {
          _selectedDays = {1, 2, 3, 4, 5};
        }
      });
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      // Diseño de tarjeta con borde coloreado
      // Muestra ícono, título, descripción, y check
    ),
  );
}
```

#### C) `_buildCustomDaysSelector()` (líneas 375-439)
```dart
Widget _buildCustomDaysSelector() {
  const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  final dayNames = [
    AppLocalizations.of(context)!.mondayFull,
    // ... otros días
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      Text(AppLocalizations.of(context)!.selectDays, ...),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          // Botones circulares para cada día
        }),
      ),
    ],
  );
}
```

#### D) `_buildWeeklyTargetSelector()` (líneas 441-488)
```dart
Widget _buildWeeklyTargetSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      Text(AppLocalizations.of(context)!.selectDaysPerWeek, ...),
      Row(
        children: [
          Expanded(
            child: Slider(
              value: _weeklyTarget.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              label: AppLocalizations.of(context)!.targetDaysPerWeek(_weeklyTarget),
              onChanged: (value) {
                setState(() {
                  _weeklyTarget = value.toInt();
                });
              },
            ),
          ),
          Container(
            // Badge con número seleccionado
          ),
        ],
      ),
    ],
  );
}
```

---

## 🎯 RESULTADO ESPERADO

Después de aplicar el fix:

### ANTES (Bug #5):
```
Edit Habit Screen
├── Name
├── Description
├── Icon
├── Color
├── Frequency
│   └── [7 botones: L M X J V S D]  ❌ Solo esto
│       └── [All Days] [Weekdays]    ❌ Botones simples
└── Reminder Time
```

### DESPUÉS (Fixed):
```
Edit Habit Screen
├── Name
├── Description
├── Icon
├── Color
├── Frequency
│   ├── [✓] Daily        (Todos los días)         ✅ Selector 4 modos
│   ├── [ ] Weekdays     (Lun-Vie)
│   ├── [ ] Custom Days  (Días específicos)
│   └── [ ] Weekly       (Meta semanal)
│
│       [CONDICIONAL según selección]
│
│       Si Custom:
│       └── [7 botones: L M X J V S D]           ✅ Condicional
│
│       Si Weekly:
│       └── [Slider: 1 ← ● → 7 días/semana]      ✅ Slider nuevo!
│           [Badge: 3 días/semana]
└── Reminder Time
```

---

## ✅ VERIFICACIÓN

Después de aplicar el fix:

1. Crear hábito Weekly con target 5/semana
2. Guardar hábito
3. Editar hábito
4. Verificar que aparece:
   - ✅ Selector de 4 modos
   - ✅ "Weekly" está seleccionado
   - ✅ Slider muestra valor 5
   - ✅ Puede cambiar a otros modos
   - ✅ Puede ajustar slider de 1 a 7

---

## 📝 NOTAS TÉCNICAS

### Variables de Estado Necesarias:
Ya existen en EditHabitScreen (líneas 26-28):
```dart
late FrequencyType _selectedFrequencyType;  ✅ Ya existe
late Set<int> _selectedDays;                ✅ Ya existe
late int _weeklyTarget;                     ✅ Ya existe
```

### Inicialización:
Ya correcta en initState (líneas 39-41):
```dart
_selectedFrequencyType = widget.habit.frequencyType;  ✅
_selectedDays = widget.habit.frequency.toSet();       ✅
_weeklyTarget = widget.habit.weeklyTarget ?? 3;       ✅
```

### Método Save:
Ya correcto en _saveHabit() (líneas 461-527). No requiere cambios.

---

## ⚠️ PRECAUCIONES

1. **NO modificar** otros métodos (_saveHabit, initState, etc.)
2. **SOLO reemplazar** el método `_buildFrequencySelection()` y agregar los 3 auxiliares
3. **Verificar** que no se rompan imports (todos los imports ya están)
4. **Probar** con los 4 tipos de frecuencia

---

## 🚀 TESTING DESPUÉS DEL FIX

1. **Test 1**: Editar hábito Daily
   - Debe mostrar "Daily" seleccionado
   - No debe mostrar selector de días ni slider

2. **Test 2**: Editar hábito Weekdays
   - Debe mostrar "Weekdays" seleccionado
   - No debe mostrar selector de días ni slider

3. **Test 3**: Editar hábito Custom (Lun-Mié-Vie)
   - Debe mostrar "Custom" seleccionado
   - Debe mostrar 7 botones con Lun-Mié-Vie marcados

4. **Test 4**: Editar hábito Weekly (target 5)
   - Debe mostrar "Weekly" seleccionado
   - Debe mostrar slider con valor 5
   - Puede ajustar slider

5. **Test 5**: Cambiar tipo
   - Desde Daily → Weekly: Debe aparecer slider
   - Desde Weekly → Custom: Debe aparecer botones
   - Desde Custom → Weekdays: Botones deben ajustarse a Lun-Vie

---

## 📦 COMMIT MESSAGE SUGERIDO

```
fix(high): Add 4-mode frequency selector to EditHabitScreen (#5)

## 🐛 Bug #5 Fixed

EditHabitScreen was missing the advanced frequency selector.

### Problem:
When editing a weekly habit, only 7 day buttons appeared.
No way to change frequency type or adjust weekly target.

### Changes:
- Replaced _buildFrequencySelection() with 4-mode selector
- Added _buildFrequencyTypeOption() method
- Added _buildCustomDaysSelector() method
- Added _buildWeeklyTargetSelector() method

### Impact:
- EditHabitScreen now matches AddHabitScreen UX ✅
- Users can edit weekly target ✅
- Users can change frequency type ✅

Files modified:
- lib/screens/edit_habit_screen.dart
```

---

**FIN DE LAS INSTRUCCIONES** 🔧
