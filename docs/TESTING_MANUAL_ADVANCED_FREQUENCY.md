# 🧪 PLAN DE TESTING MANUAL - ADVANCED FREQUENCY SYSTEM

**Feature**: Sistema de frecuencia avanzada (4 modos)
**PR**: #25
**Fecha**: 2025-10-06
**Tester**: [Tu nombre]
**Branch**: `claude/feature-advanced-frequency`

---

## 📋 CHECKLIST GENERAL

### Pre-Testing
- [ ] Branch `claude/feature-advanced-frequency` checked out
- [ ] `flutter pub get` ejecutado
- [ ] `flutter gen-l10n` ejecutado
- [ ] App compilada sin errores
- [ ] Dispositivo/emulador listo

### Idiomas a Probar
- [ ] 🇬🇧 Inglés (English)
- [ ] 🇪🇸 Español (Spanish)

---

## 🎯 TEST SUITES

## 1️⃣ MODO DAILY (Diario)

### 1.1 Crear Hábito Daily
**Steps**:
1. Abrir app → FAB "+" → "Add Habit"
2. Nombre: "Morning Workout"
3. Frecuencia: Seleccionar **"Daily"**
4. Verificar UI: NO debe mostrar selector de días ni slider
5. Guardar

**Expected**:
- [ ] Hábito creado exitosamente
- [ ] Aparece en lista "Today"
- [ ] Frecuencia muestra "Daily" / "Diario"

### 1.2 Completar y Verificar Puntos
**Steps**:
1. Marcar hábito como completado (checkbox)
2. Verificar puntos en GamificationCard

**Expected**:
- [ ] +5 puntos base
- [ ] NO bonus (daily no tiene weekly target)
- [ ] Total: 5 puntos

### 1.3 Verificar Racha
**Steps**:
1. Completar hábito hoy
2. Simular día siguiente (cambiar fecha dispositivo +1 día)
3. Completar nuevamente
4. Verificar racha en Stats

**Expected**:
- [ ] Racha cuenta en **días**
- [ ] Racha = 2 días
- [ ] Formato: "2 days" / "2 días"

---

## 2️⃣ MODO WEEKDAYS (Días Laborables)

### 2.1 Crear Hábito Weekdays
**Steps**:
1. FAB "+" → "Add Habit"
2. Nombre: "Work Focus"
3. Frecuencia: Seleccionar **"Weekdays (Mon-Fri)"**
4. Verificar UI: NO debe mostrar selector customizable ni slider
5. Guardar

**Expected**:
- [ ] Hábito creado exitosamente
- [ ] Aparece en lista "Today" (si hoy es lun-vie)
- [ ] Frecuencia muestra "Weekdays" / "Días laborables"

### 2.2 Verificar Aparición por Día
**Steps**:
1. Lunes: Verificar hábito aparece ✅
2. Martes: Verificar hábito aparece ✅
3. Sábado: Verificar hábito NO aparece ❌
4. Domingo: Verificar hábito NO aparece ❌

**Expected**:
- [ ] Solo aparece lun-vie
- [ ] No aparece sáb-dom
- [ ] Mensaje claro si no hay hábitos para hoy

### 2.3 Completar y Verificar Puntos
**Steps**:
1. Completar hábito en día laboral
2. Verificar puntos

**Expected**:
- [ ] +5 puntos base
- [ ] NO bonus (weekdays no tiene weekly target)
- [ ] Total: 5 puntos

---

## 3️⃣ MODO CUSTOM (Días Específicos)

### 3.1 Crear Hábito Custom
**Steps**:
1. FAB "+" → "Add Habit"
2. Nombre: "Gym (Mon-Wed-Fri)"
3. Frecuencia: Seleccionar **"Custom Days"**
4. Verificar UI: Debe mostrar 7 botones (Lun-Dom)
5. Seleccionar: Lunes ✅, Miércoles ✅, Viernes ✅
6. Verificar visualización de días seleccionados
7. Guardar

**Expected**:
- [ ] Hábito creado exitosamente
- [ ] Aparece solo lun/mié/vie
- [ ] Frecuencia muestra "Custom" / "Personalizado"
- [ ] Subtítulo muestra días seleccionados

### 3.2 Verificar Aparición por Día Seleccionado
**Steps**:
1. Lunes: Aparece ✅
2. Martes: NO aparece ❌
3. Miércoles: Aparece ✅
4. Jueves: NO aparece ❌
5. Viernes: Aparece ✅
6. Sábado: NO aparece ❌
7. Domingo: NO aparece ❌

**Expected**:
- [ ] Solo aparece en días seleccionados
- [ ] No aparece en días no seleccionados

### 3.3 Editar Días Seleccionados
**Steps**:
1. Abrir hábito → Editar
2. Cambiar días: Agregar Sábado ✅
3. Guardar
4. Verificar ahora aparece sábados

**Expected**:
- [ ] Cambios se guardan correctamente
- [ ] Nueva configuración se respeta

### 3.4 Completar y Verificar Puntos
**Steps**:
1. Completar hábito en día válido
2. Verificar puntos

**Expected**:
- [ ] +5 puntos base
- [ ] NO bonus (custom no tiene weekly target)
- [ ] Total: 5 puntos

---

## 4️⃣ MODO WEEKLY (Semanal con Target)

### 4.1 Crear Hábito Weekly (Target 3 días/semana)
**Steps**:
1. FAB "+" → "Add Habit"
2. Nombre: "Read 30min"
3. Frecuencia: Seleccionar **"Weekly Target"**
4. Verificar UI: Debe mostrar slider "Days per week"
5. Ajustar slider a **3 días/semana**
6. Verificar texto muestra "3 days per week" / "3 días por semana"
7. Guardar

**Expected**:
- [ ] Hábito creado exitosamente
- [ ] Aparece TODOS los días (7/7)
- [ ] Frecuencia muestra "3/week" / "3/semana"
- [ ] Progreso semanal visible

### 4.2 Completar y Verificar Bonus (Target NO Alcanzado)
**Steps**:
1. Lunes: Completar (1/3) ✅
2. Martes: Completar (2/3) ✅
3. Verificar puntos

**Expected**:
- [ ] Día 1: +5 puntos (solo base)
- [ ] Día 2: +5 puntos (solo base)
- [ ] Total: 10 puntos
- [ ] NO bonus (target 3 no alcanzado aún)

### 4.3 Completar y Verificar Bonus (Target ALCANZADO) ⭐
**Steps**:
1. Miércoles: Completar (3/3) ✅
2. Verificar puntos

**Expected**:
- [ ] +5 puntos base
- [ ] **+10 puntos BONUS** 🎉 (alcanzó target 3/3)
- [ ] Total sesión: 15 puntos
- [ ] Total acumulado: 25 puntos (10 + 15)
- [ ] Mensaje/animación de bonus (si existe)

### 4.4 Completar Adicional (Sobre el Target)
**Steps**:
1. Jueves: Completar (4/3) ✅ (sobre el target)
2. Verificar puntos

**Expected**:
- [ ] +5 puntos base
- [ ] NO bonus adicional (solo se da 1 vez al alcanzar)
- [ ] Total: 5 puntos
- [ ] Progreso muestra 4/3 (133%)

### 4.5 Descompletar y Verificar Pérdida de Bonus
**Steps**:
1. Desmarcar completado del miércoles (de 4/3 → 3/3)
2. Desmarcar completado del martes (de 3/3 → 2/3)
3. Verificar puntos

**Expected**:
- [ ] -15 puntos al desmarcar miércoles (5 base + 10 bonus)
- [ ] -5 puntos al desmarcar martes
- [ ] Target NO alcanzado: 2/3
- [ ] Puntos correctos

### 4.6 Verificar Racha Semanal
**Steps**:
1. Semana 1: Alcanzar target (3/3) ✅
2. Semana 2: Alcanzar target (3/3) ✅
3. Verificar racha en Stats

**Expected**:
- [ ] Racha cuenta en **semanas** (no días)
- [ ] Racha = 2 semanas
- [ ] Formato: "2 weeks" / "2 semanas"

### 4.7 Editar Weekly Target
**Steps**:
1. Abrir hábito → Editar
2. Cambiar slider: 3 → 5 días/semana
3. Guardar
4. Verificar nuevo target se aplica

**Expected**:
- [ ] Target actualizado a 5/7
- [ ] Progreso se recalcula
- [ ] Bonus se re-evalúa según nuevo target

---

## 5️⃣ TESTS TRANSVERSALES

### 5.1 Editar Tipo de Frecuencia
**Steps**:
1. Crear hábito Daily
2. Editar → Cambiar a Weekly (target 4)
3. Guardar
4. Verificar comportamiento weekly

**Expected**:
- [ ] Cambio de tipo funciona
- [ ] Configuración anterior se pierde (esperado)
- [ ] Nueva configuración se aplica

### 5.2 Migración de Datos (si aplica)
**Steps**:
1. Si tienes hábitos antiguos (antes del feature)
2. Verificar siguen funcionando como Daily

**Expected**:
- [ ] Hábitos legacy funcionan
- [ ] Frecuencia por defecto = Daily
- [ ] No hay crashes ni errores

### 5.3 Límite Premium (5 hábitos)
**Steps**:
1. Crear 5 hábitos de diferentes tipos
2. Intentar crear el 6to

**Expected**:
- [ ] Dialog de límite aparece
- [ ] No se permite crear más (sin premium)

### 5.4 Visualización en Stats
**Steps**:
1. Ir a Stats → Tab "Today"
2. Verificar hábitos se muestran correctamente
3. Tab "Week": Verificar weekly habits destacan progreso
4. Tab "Trends": Verificar rachas muestran unidad correcta

**Expected**:
- [ ] Stats reflejan nueva lógica
- [ ] Progreso semanal visible para weekly habits
- [ ] Rachas usan unidad correcta (días vs semanas)

---

## 6️⃣ INTERNACIONALIZACIÓN (i18n)

### 6.1 Cambiar a Español
**Steps**:
1. Settings → Language → Español
2. Navegar por app completa

**Expected**:
- [ ] "Daily" → "Diario"
- [ ] "Weekdays" → "Días laborables"
- [ ] "Custom Days" → "Días personalizados"
- [ ] "Weekly Target" → "Meta semanal"
- [ ] "days per week" → "días por semana"
- [ ] Todas las 24 strings nuevas traducidas

### 6.2 Cambiar a Inglés
**Steps**:
1. Settings → Language → English
2. Verificar traducciones correctas

**Expected**:
- [ ] Todas las strings en inglés
- [ ] No hay strings en español mezcladas

---

## 7️⃣ EDGE CASES

### 7.1 Weekly Target = 1
**Steps**:
1. Crear hábito weekly con target 1/semana
2. Completar 1 vez
3. Verificar bonus

**Expected**:
- [ ] Bonus se da al completar 1 vez
- [ ] Progreso: 1/1 (100%)

### 7.2 Weekly Target = 7
**Steps**:
1. Crear hábito weekly con target 7/semana (todos los días)
2. Completar 7 veces
3. Verificar bonus

**Expected**:
- [ ] Bonus se da al completar 7ma vez
- [ ] Progreso: 7/7 (100%)

### 7.3 Custom con 0 Días Seleccionados
**Steps**:
1. Intentar crear custom sin seleccionar días
2. Intentar guardar

**Expected**:
- [ ] Validación impide guardar
- [ ] Mensaje error claro
- [ ] O: Al menos 1 día seleccionado por defecto

### 7.4 Cambio de Semana
**Steps**:
1. Hábito weekly con progreso 2/3 (jueves)
2. Cambiar a lunes siguiente (nueva semana)
3. Verificar progreso se resetea

**Expected**:
- [ ] Progreso: 0/3 (nueva semana)
- [ ] Racha se mantiene si alcanzó target semana anterior
- [ ] Historial se preserva

---

## 📊 RESUMEN DE TESTING

### Completado
- [ ] Modo Daily (3 tests)
- [ ] Modo Weekdays (3 tests)
- [ ] Modo Custom (4 tests)
- [ ] Modo Weekly (7 tests)
- [ ] Tests Transversales (4 tests)
- [ ] Internacionalización (2 tests)
- [ ] Edge Cases (4 tests)

**Total**: 27 test cases

---

## 🐛 BUGS ENCONTRADOS

| # | Descripción | Severidad | Steps to Reproduce | Expected | Actual |
|---|-------------|-----------|-------------------|----------|--------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

**Severidad**:
- 🔴 Critical (bloqueante)
- 🟠 High (afecta UX principal)
- 🟡 Medium (afecta casos específicos)
- 🟢 Low (cosmético)

---

## ✅ APROBACIÓN FINAL

### Criterios de Aprobación
- [ ] 0 bugs críticos
- [ ] <3 bugs high
- [ ] Todos los modos funcionan correctamente
- [ ] Bonus points funcionan
- [ ] Rachas calculan correctamente (días vs semanas)
- [ ] i18n completa (EN + ES)
- [ ] No crashes ni errores
- [ ] Performance aceptable

### Decisión
- [ ] ✅ **APROBADO** - Listo para merge
- [ ] ⚠️ **APROBADO CON CONDICIONES** - Bugs menores a corregir
- [ ] ❌ **RECHAZADO** - Bugs críticos requieren fix

---

## 📝 NOTAS ADICIONALES

**Fecha de testing**: ___________
**Tiempo total**: ___________
**Dispositivo**: ___________
**OS Version**: ___________
**App Version**: ___________

**Observaciones**:
```
[Escribe aquí cualquier observación adicional]
```

---

**FIN DEL PLAN DE TESTING** 🧪

> 💡 **Tip**: Ejecutar este plan metódicamente. No saltarse pasos. Cada bug encontrado = mejora en calidad.
