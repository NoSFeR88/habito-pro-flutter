---
allowed-tools: [Read, Edit]
description: "Guarda contexto de sesión - EJECUTAR ANTES DE /clear"
---

# Comando /save

## ⚠️ IMPORTANTE - Flujo Correcto

**SIEMPRE ejecutar /save ANTES de /clear**

Flujo correcto:
```
[Trabajas en tarea]
  → /save          ← Guarda contexto
  → /clear         ← Limpia chat (opcional)
  → /remember      ← Recupera contexto actualizado
```

Si haces `/clear` sin `/save` previo, **perderás el contexto** de esta sesión.

## 📝 Tarea

Actualizar @/docs/CONTEXT_LAST_SESSION.md con el trabajo de esta sesión.

### Edits Incrementales (preferido)

**NO reescribir archivo completo**. Solo actualizar:

1. **Fecha y sesión**: Línea 3 → HOY + número sesión
2. **Sección "RESUMEN DE ESTA SESIÓN"**: Agregar nueva tarea completada
3. **Sección "PRÓXIMOS PASOS"**: Actualizar siguiente acción
4. **Sección "MÉTRICAS"**: Actualizar tokens consumidos
5. **Sección "PUNTO EXACTO"**: Actualizar branch/commit/estado

### Template Tarea Nueva

```markdown
#### **[Nombre Tarea]** (COMPLETADO XX%)

**Implementación**:
- ✅ [Subtarea 1]
- ✅ [Subtarea 2]

**Archivos modificados**:
- `path/file.ext` (XXX líneas) - [Descripción cambios]

**Resultado**:
- ✅ [Métrica/impacto]
```

### Estructura Completa

Para ver estructura completa del archivo, consultar: @/docs/SAVE_TEMPLATE.md

## ✅ Output Requerido

Después de actualizar:

```
✅ CONTEXT_LAST_SESSION.md actualizado

📋 Cambios:
- Sesión: XX
- Fecha: YYYY-MM-DD
- Nueva tarea: [nombre]
- Archivos: [X modificados, X creados]
- Tokens: +XXXk (total: XXXk/200k)

📦 Listo para compresión/limpieza.
En próxima sesión, usar /remember para recuperar este estado.
```

## 🎯 Reglas de Calidad

### ✅ SIEMPRE incluir:
- Rutas completas de archivos modificados
- Números de línea cuando relevante (ej: `file.dart:100-150`)
- Comandos ready-to-use para próxima sesión
- Métricas de tokens consumidos

### ❌ NUNCA:
- Información vaga sin especificar archivos
- Próximos pasos ambiguos
- Omitir lecciones aprendidas de errores
