# 🚀 PRE-LAUNCH FIXES - BLOQUEADORES DE PRODUCCIÓN

**Fecha Inicio**: 2025-10-08
**Estado**: 🔴 EN PROGRESO - NO LAUNCH HASTA COMPLETAR
**Versión Target**: 1.0.1+2

---

## ⚠️ **REGLA CRÍTICA: NO DEPLOY HASTA COMPLETAR TODOS LOS FIXES**

Este documento lista TODOS los problemas que DEBEN resolverse antes del primer deployment a Play Store.

---

## 📊 **PROGRESO GENERAL**

```
CRÍTICOS:     0/4 ✗ (0%)
IMPORTANTES:  0/3 ✗ (0%)
OPCIONALES:   0/3 ✗ (0%)
────────────────────────────
TOTAL:        0/10 ✗ (0%)
```

**Estado**: 🔴 BLOQUEADO PARA PRODUCCIÓN

---

## 🔴 **FASE 1: CRÍTICOS (BLOQUEADORES ABSOLUTOS)**

### ✗ **FIX-001: Strings Hardcoded en Diálogo Notificaciones**

**Prioridad**: 🔥 CRÍTICA
**Archivo**: `lib/screens/home_screen.dart:622-640`
**Problema**: Texto de ayuda de notificaciones siempre en español
**Impacto**: Usuarios de otros idiomas ven texto en español

**Código Problemático**:
```dart
content: const Text(
  'Si no recibes notificaciones:\n\n'
  '• Verifica que las notificaciones estén activadas en la configuración del sistema\n'
  '• Asegúrate de que la app tenga permisos de notificación\n'
  '• Revisa que no esté en modo "No molestar"\n'
  '• Intenta reprogramar las notificaciones con el botón de arriba',
),
```

**Solución**:
1. Agregar keys a `lib/l10n/app_en.arb`:
   - `notificationHelpBullet1`
   - `notificationHelpBullet2`
   - `notificationHelpBullet3`
   - `notificationHelpBullet4`
2. Traducir a `lib/l10n/app_es.arb`
3. Regenerar: `flutter gen-l10n`
4. Reemplazar por: `Text(AppLocalizations.of(context)!.notificationHelpBullet1)`

**Tiempo Estimado**: 20 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **FIX-002: Botón "Ver Estadísticas" No Funcional**

**Prioridad**: 🔥 CRÍTICA
**Archivo**: `lib/screens/home_screen.dart:324-327`
**Problema**: Botón visible pero no hace nada (TODO comentado)
**Impacto**: UX confusa - botón que no responde

**Código Problemático**:
```dart
onTap: () {
  Navigator.pop(context);
  // TODO: Navegar a estadísticas del hábito
},
```

**Solución**:
```dart
onTap: () {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StatsScreen(
        initialHabitFilter: habit.id, // Mostrar solo este hábito
      ),
    ),
  );
},
```

**Pasos**:
1. Modificar `StatsScreen` para aceptar parámetro `initialHabitFilter`
2. Implementar filtro en gráficas
3. Actualizar navegación en `home_screen.dart`
4. Test manual: Long press → Ver estadísticas → Debe mostrar stats del hábito

**Tiempo Estimado**: 45 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **FIX-003: Notificaciones Sistema Siempre en Inglés**

**Prioridad**: 🔥 CRÍTICA
**Archivo**: `lib/services/notification_service.dart` (estimado)
**Problema**: Notificaciones push no respetan idioma de la app
**Impacto**: Usuarios hispanos reciben notificaciones en inglés

**Investigación Necesaria**:
1. Revisar `lib/services/notification_service.dart`
2. Identificar strings hardcoded
3. Inyectar `AppLocalizations` en servicio

**Solución Esperada**:
- Pasar contexto o locale al servicio de notificaciones
- Usar traducciones en títulos/cuerpos de notificaciones

**Tiempo Estimado**: 1 hora
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **FIX-004: Error Hardcoded en PaywallScreen**

**Prioridad**: 🔥 CRÍTICA
**Archivo**: `lib/screens/paywall_screen.dart:148`
**Problema**: Mensaje de error en inglés
**Impacto**: Menor pero afecta experiencia de error

**Código Problemático**:
```dart
content: Text('Error: $e'),
```

**Solución**:
```dart
content: Text('${AppLocalizations.of(context)!.error}: $e'),
```

**Tiempo Estimado**: 10 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

## ⚠️ **FASE 2: IMPORTANTES (NO BLOQUEANTES PERO URGENTES)**

### ✗ **FIX-005: Gráficas Estadísticas - Diferencias No Visibles**

**Prioridad**: 🟡 IMPORTANTE
**Archivo**: `lib/screens/stats_screen.dart`
**Problema**: Gráficas no muestran claramente las diferencias de datos
**Impacto**: UX pobre en feature importante

**Investigación Necesaria**:
1. Revisar configuración de `fl_chart`
2. Analizar `minY` y `maxY` dinámicos
3. Verificar colores de contraste

**Solución Esperada**:
- Ajustar escala Y automáticamente según datos
- Aumentar contraste de líneas/barras
- Agregar labels de valores

**Tiempo Estimado**: 1 hora
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **FIX-006: BottomSheet Notificaciones Sin Estilo**

**Prioridad**: 🟡 IMPORTANTE
**Archivo**: `lib/screens/home_screen.dart:547`
**Problema**: "Caja fea" sin bordes redondeados ni gradientes
**Impacto**: UX no profesional

**Solución**:
```dart
showModalBottomSheet(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  backgroundColor: Theme.of(context).colorScheme.surface,
  builder: (context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceVariant,
        ],
      ),
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    // ... resto
  ),
);
```

**Tiempo Estimado**: 30 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **FIX-007: Deprecation Warnings (Top 20)**

**Prioridad**: 🟡 IMPORTANTE
**Archivos**: Múltiples
**Problema**: 131 deprecation warnings
**Impacto**: Puede fallar en futuras versiones de Flutter

**Estrategia**:
1. Ejecutar: `flutter analyze | grep -i deprecated | head -20`
2. Identificar top 20 más críticos
3. Refactorizar uno por uno
4. Priorizar API críticas

**Tiempo Estimado**: 1 hora (top 20), 2-3h (todos)
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

## 🟢 **FASE 3: OPCIONALES (MEJORAS POST-FIX)**

### ✗ **MEJORA-001: Themes - Fondos Dinámicos**

**Prioridad**: 🟢 OPCIONAL
**Archivo**: `lib/core/theme.dart`
**Problema**: Algunos fondos no cambian con themes
**Impacto**: Oportunidad de personalización

**Solución**:
- Agregar variaciones de `backgroundColor`
- Definir `surfaceContainerHigh`, `surfaceContainerLow`
- Aplicar en screens principales

**Tiempo Estimado**: 45 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **MEJORA-002: Actualizar Versión pubspec.yaml**

**Prioridad**: 🟢 OPCIONAL
**Archivo**: `pubspec.yaml`
**Estado Actual**: `version: 1.0.0+1`
**Nuevo**: `version: 1.0.1+2`

**Razón**: Primera versión con todos los fixes

**Tiempo Estimado**: 2 minutos
**Asignado a**: Claude Code
**Estado**: ⏳ PENDIENTE

---

### ✗ **MEJORA-003: Responsive Testing Report**

**Prioridad**: 🟢 OPCIONAL
**Problema**: No hay reporte formal de responsive testing
**Solución**: Documento con screenshots de múltiples tamaños

**Tiempo Estimado**: 30 minutos
**Asignado a**: Manual + Claude Code
**Estado**: ⏳ PENDIENTE

---

## 📋 **CHECKLIST DE DEPLOYMENT**

**Solo cuando TODO esté ✅ se permite deploy:**

### Pre-Deploy Checks:
- [ ] Todos los CRÍTICOS (FIX-001 a FIX-004) ✅
- [ ] Todos los IMPORTANTES (FIX-005 a FIX-007) ✅
- [ ] Tests: 467/467 passing
- [ ] Lint: 0 errors (warnings aceptables < 50)
- [ ] Traducciones: EN 100%, ES 100%
- [ ] Manual testing en 3 devices (phone small, medium, tablet)

### Store Prep:
- [ ] Screenshots (EN + ES) 8 imágenes mínimo
- [ ] Store listing texts (EN + ES)
- [ ] Privacy Policy publicada
- [ ] Version bump: `1.0.1+2`

### Final Validation:
- [ ] AAB generado: `flutter build appbundle --release`
- [ ] APK testing: `flutter build apk --release`
- [ ] Signing keys configurados
- [ ] Play Store cuenta activa

---

## 🎯 **OBJETIVO FINAL**

**✅ TODOS LOS FIXES COMPLETADOS → DEPLOYMENT AUTORIZADO**

**Fecha Objetivo**: TBD (depende de velocidad de fixes)
**Responsable**: Claude Code + Human QA
**Tracking**: Este documento + GitHub Issues (crear)

---

## 📝 **NOTAS DE SESIÓN**

### Sesión 2025-10-08 (Inicio):
- ✅ Auditoría completa realizada
- ✅ Documento PRE_LAUNCH_FIXES.md creado
- ⏳ Iniciando FIX-001...

---

**Última actualización**: 2025-10-08 17:45 UTC
**Próxima revisión**: Después de cada fix completado
