# 📊 Baseline de Warnings - Plan de Reducción

## 🎯 Objetivo

Reducir gradualmente los warnings del análisis estático de **303 → 0**.

---

## 📈 Histórico de Baseline

| Fecha | Errors | Warnings | Infos | Notas |
|-------|--------|----------|-------|-------|
| 2025-10-05 | 0 | **303** | ~303 | Baseline inicial - Plan Maestro implementado |

---

## 🚀 Plan de Reducción Gradual

### **Fase 1: Estabilización** (ACTUAL)
- **Meta**: Mantener warnings en **303** (no aumentar)
- **Duración**: Hasta PR #5
- **Estrategia**: CI bloquea si warnings > 303

### **Fase 2: Reducción Moderada**
- **Meta**: **303 → 250** (-53 warnings)
- **Duración**: PR #6 - PR #10
- **Estrategia**:
  - Dedicar 1-2 PRs específicos a corregir warnings
  - Priorizar: `unused_import`, `unused_element`

### **Fase 3: Reducción Agresiva**
- **Meta**: **250 → 200** (-50 warnings)
- **Duración**: PR #11 - PR #15
- **Estrategia**:
  - Corregir `deprecated_member_use` (background, onBackground, textScaleFactor)
  - Refactoring de theme_provider.dart

### **Fase 4: Limpieza Final**
- **Meta**: **200 → 100** (-100 warnings)
- **Duración**: PR #16 - PR #25
- **Estrategia**:
  - Corregir `prefer_const_constructors`
  - Refactoring de pantallas complejas

### **Fase 5: Cero Warnings** 🏆
- **Meta**: **100 → 0** (-100 warnings)
- **Duración**: PR #26+
- **Estrategia**:
  - Corregir todos los `info` restantes
  - Code review exhaustivo

---

## 📋 Categorías de Warnings Actuales (2025-10-05)

### **Por Tipo** (estimado)

| Tipo | Cantidad | Prioridad | Dificultad |
|------|----------|-----------|------------|
| `deprecated_member_use` | ~150 | 🔴 Alta | Media |
| `prefer_const_constructors` | ~80 | 🟡 Media | Baja |
| `unused_import` | ~10 | 🟢 Baja | Muy Baja |
| `unused_element` | ~5 | 🟢 Baja | Muy Baja |
| `avoid_print` | ~3 | 🟡 Media | Baja |
| `use_super_parameters` | ~5 | 🟢 Baja | Baja |
| Otros | ~50 | Variable | Variable |

### **Por Archivo** (top 5)

1. `lib/providers/theme_provider.dart` - ~50 warnings (deprecations)
2. `lib/core/theme.dart` - ~15 warnings (deprecations)
3. `lib/core/ritmo_typography.dart` - ~12 warnings (textScaleFactor)
4. `lib/screens/stats_screen.dart` - ~30 warnings (const, withOpacity)
5. `lib/screens/add_habit_screen.dart` - ~20 warnings (const, withOpacity)

---

## 🔧 Estrategias de Corrección

### **1. Deprecated `background` / `onBackground`**
```dart
// ❌ Antes (deprecated)
colorScheme: ColorScheme(
  background: Colors.white,
  onBackground: Colors.black,
)

// ✅ Después
colorScheme: ColorScheme(
  surface: Colors.white,
  onSurface: Colors.black,
)
```

### **2. Deprecated `textScaleFactor`**
```dart
// ❌ Antes
MediaQuery.of(context).textScaleFactor

// ✅ Después
MediaQuery.textScalerOf(context).scale(fontSize)
```

### **3. Deprecated `withOpacity`**
```dart
// ❌ Antes
color.withOpacity(0.5)

// ✅ Después
color.withValues(alpha: 0.5)
```

### **4. Unused imports**
```dart
// ❌ Antes
import 'package:flutter/foundation.dart';  // No usado
import 'package:flutter/material.dart';

// ✅ Después
import 'package:flutter/material.dart';
```

### **5. Prefer const constructors**
```dart
// ❌ Antes
return SizedBox(height: 16);

// ✅ Después
return const SizedBox(height: 16);
```

---

## 📊 Cómo Actualizar el Baseline

### **Cuando REDUCES warnings**:

1. El CI mostrará:
   ```
   🎉 ¡EXCELENTE! Redujiste X warnings
   Por favor actualizar baseline en .github/workflows/claude-ci.yml
   Cambiar: $baselineWarnings = NUEVO_VALOR
   ```

2. Editar `.github/workflows/claude-ci.yml`:
   ```yaml
   # BASELINE ACTUAL (FECHA)
   # Meta: Reducir gradualmente 303 → 250 → 200 → 100 → 0
   $baselineErrors = 0
   $baselineWarnings = NUEVO_VALOR  # ← Actualizar aquí
   ```

3. Actualizar esta tabla en `BASELINE_WARNINGS.md`:
   ```markdown
   | FECHA | 0 | NUEVO_VALOR | ~303 | Descripción del PR |
   ```

4. Commit:
   ```bash
   git commit -m "chore(ci): Update baseline warnings X → Y (-Z warnings)"
   ```

---

## 🎖️ Incentivos

- **-10 warnings**: 🥉 Bronce - Buen progreso
- **-25 warnings**: 🥈 Plata - Excelente trabajo
- **-50 warnings**: 🥇 Oro - Contribución significativa
- **-100 warnings**: 💎 Diamante - Refactoring mayor
- **0 warnings**: 🏆 Perfección - Código impecable

---

## 🚨 Reglas Importantes

1. **NUNCA aumentar baseline** sin justificación técnica documentada
2. **SIEMPRE corregir errores** (baseline = 0)
3. **PRs que reducen warnings** tienen prioridad alta para review
4. **Agregar warnings nuevos** = CI bloqueado (debe corregir)
5. **Documentar** en cada PR cuántos warnings se corrigieron

---

## 📚 Referencias

- [Flutter Lint Rules](https://dart.dev/tools/linter-rules)
- [Material 3 Migration Guide](https://docs.flutter.dev/release/breaking-changes/material-3-migration)
- [Deprecation Policy](https://docs.flutter.dev/release/compatibility-policy)

---

**Última actualización**: 2025-10-05
**Próxima revisión**: Después de PR #5
**Responsable**: Claude Code AI + Equipo de desarrollo
