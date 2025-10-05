# CHECKLIST /remember - Validación Output Completo

> **USO**: Consultar DESPUÉS de ejecutar `/remember` para verificar que el output sea correcto y completo.
> **NO se lee automáticamente** - solo referencia para validación.

---

## ✅ CONFIRMACIÓN ARCHIVOS (8/8)

Cuando ejecutes `/remember` por primera vez en sesión o necesites contexto completo, el output debe confirmar explícitamente cada archivo leído:

### Formato Esperado por Archivo

```
✅ CLAUDE.md - [Confirmación contenido clave]
   Ejemplo: "Stack: Flutter+Provider+SQLite, 26 idiomas, Premium features, CI/CD configurado"

✅ ../../CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md - [Confirmación principios]
   Ejemplo: "SOLID, A11Y, i18n, Mobile-First, LayoutBuilder pattern cargados"

✅ docs/CONTEXT_LAST_SESSION.md - [Sesión + fecha + estado]
   Ejemplo: "Sesión 30 - 2025-10-05 - FASE 1 Plan Maestro 90% completada"

✅ docs/PROJECT_INDEX.md - [Confirmación disponibilidad]
   Ejemplo: "39 archivos Dart, 11 pantallas, 8 providers indexados"

✅ docs/BILINGUAL_GUIDE.md - [Estado traducciones]
   Ejemplo: "140 strings ES pendientes (71% completado), protocolo bilingüe confirmado"

✅ docs/PROJECT_STATUS.md - [Estado general]
   Ejemplo: "FASE 2 completada, baseline 303 warnings, CI/CD funcional"

✅ README.md - [Tipo proyecto]
   Ejemplo: "Proyecto Flutter - RITMO Habit Tracker"

✅ ../../doc/README.md - [Biblioteca disponible]
   Ejemplo: "7 docs Flutter disponibles - consulta por keyword en 00_MASTER_INDEX.md"
```

---

## 📊 RESUMEN EJECUTIVO (OBLIGATORIO)

Después de confirmar archivos, **SIEMPRE incluir**:

### 1. Estado Actual del Proyecto
```
- **Branch activo**: [nombre]
- **Último commit**: [hash] - [mensaje]
- **Fase actual**: [Nombre Fase] - XX% completada
- **PR activo**: #X (estado) o "ninguno"
```

### 2. Tareas Pendientes (Top 3-5)
```
Alta Prioridad:
1. [Tarea 1] - [Estimado] - [Archivo principal]
2. [Tarea 2] - [Estimado] - [Archivo principal]

Media Prioridad:
3. [Tarea 3] - [Estimado]
```

### 3. Archivos Modificados Recientemente
```
Sesión anterior:
- `path/file1.ext` - [Qué se cambió]
- `path/file2.ext` - [Qué se cambió]
```

### 4. Issues Activos
```
Resueltos última sesión:
- ✅ [Issue 1]

Pendientes:
- ⏳ [Issue 1] - [Prioridad]
- ⏳ [Issue 2] - [Prioridad]
```

### 5. PRs Abiertos (si aplica)
```
PR #X - [Título]
- Status: ✅ Pass / ⏳ Pending / ❌ Failed
- Checks: [Resumen estado]
- Acción: [Qué hacer]
```

---

## 🎯 PUNTO EXACTO DONDE QUEDAMOS (OBLIGATORIO)

Declarar explícitamente:

### Dónde Quedamos
```
Última tarea completada: [Nombre tarea]
Estado: [Descripción específica]
```

### Próximo Paso Inmediato
```
Acción: [Qué hacer exactamente]
Archivo: `path/file.ext` (si aplica)
Comando: `comando` (si aplica)
```

### Comandos Ready-to-Use (si aplica)
```bash
# [Descripción comando 1]
comando1

# [Descripción comando 2]
comando2
```

---

## ✅ DECLARACIÓN FINAL (OBLIGATORIA)

Terminar SIEMPRE con:

```
✅ LISTO PARA CONTINUAR EXACTAMENTE DONDE QUEDAMOS
```

O si fue lectura selectiva (ciclo intermedio):

```
✅ CONTEXTO ACTUALIZADO - LISTO PARA CONTINUAR
```

---

## ⚠️ VALIDACIÓN DE FRESCURA

Si `CONTEXT_LAST_SESSION.md` tiene fecha antigua (>1 día) o hay discrepancia con expectativa, **ADVERTIR**:

```
⚠️ CONTEXT_LAST_SESSION.md tiene fecha antigua (YYYY-MM-DD)

Posible causa:
1. /clear sin /save previo → pérdida de contexto
2. Nueva sesión después de días → contexto desactualizado

Recomendación:
- Verificar si fecha es esperada
- Si hay pérdida de contexto, solicitar al usuario información faltante
- Leer archivos adicionales (CLAUDE.md, PROJECT_STATUS.md) para contexto completo
```

---

## ⚠️ MANEJO DE ERRORES

Si algún archivo falla al leer:

### Output Esperado
```
❌ Error leyendo: [nombre archivo]
   Razón: [mensaje error específico]

✅ Archivos leídos exitosamente: X/8
   [Lista de archivos OK]

⚠️ Acción requerida:
   Usuario debe verificar existencia/permisos de: [archivo]

Contexto parcial cargado. Continuando con archivos disponibles.
```

### Continuar con Archivos Disponibles
- **NO** bloquear por 1-2 archivos faltantes
- Cargar máximo contexto posible
- Advertir al usuario específicamente qué falta

---

## 🎯 MODOS DE /remember

### Modo QUICK (ciclos intermedios)
**Archivos**: Solo CONTEXT_LAST_SESSION.md
**Output**: Resumen ejecutivo + próximo paso
**Tokens**: ~5,000

### Modo FULL (primera vez sesión)
**Archivos**: 8/8 completos
**Output**: Confirmación explícita + resumen ejecutivo completo
**Tokens**: ~35,000

---

## 📏 CHECKLIST DE CALIDAD

Validar que el output incluya:

- [ ] ✅ Al menos 1 archivo confirmado (mínimo CONTEXT_LAST_SESSION.md)
- [ ] 📊 Resumen ejecutivo con estado actual
- [ ] 🎯 Próximo paso claramente identificado
- [ ] 📂 Archivos modificados recientemente mencionados
- [ ] 🚨 Issues activos listados (si aplica)
- [ ] 📊 PRs abiertos con estado (si aplica)
- [ ] ✅ Declaración final incluida
- [ ] ⚠️ Advertencias de frescura (si fecha antigua)
- [ ] ❌ Manejo de errores (si archivos faltantes)

---

**END OF CHECKLIST**

**Recordatorio**: Este archivo es REFERENCIA. No se lee automáticamente en cada `/remember`. Solo consúltalo cuando necesites validar que tu output de `/remember` sea completo.
