---
allowed-tools: [Read]
description: "Recupera contexto completo del proyecto siguiendo protocolo CLAUDE.md"
---

# Comando /remember

## 🎯 Objetivo
Recuperar contexto del proyecto RITMO para continuar exactamente donde quedamos.

## 📚 Archivos a Leer (prioridad)

**SIEMPRE leer**:
1. @/docs/CONTEXT_LAST_SESSION.md

**Primera vez en sesión** (o si necesitas refresh completo):
2. @CLAUDE.md
3. @../../CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md
4. @/docs/PROJECT_INDEX.md
5. @/docs/BILINGUAL_GUIDE.md
6. @/docs/PROJECT_STATUS.md
7. @README.md
8. @../../doc/README.md

**Lectura selectiva**: Si ya trabajaste en esta sesión, solo leer archivos relevantes para la tarea actual.

## ✅ Validación de Frescura

Después de leer CONTEXT_LAST_SESSION.md, verificar:
- **Fecha**: ¿Es de hoy o reciente?
- **Última tarea**: ¿Coincide con contexto esperado?

Si la fecha es antigua (>1 día) o hay discrepancia, ADVERTIR:
```
⚠️ CONTEXT_LAST_SESSION.md tiene fecha antigua (YYYY-MM-DD)
Posible /clear sin /save previo o nueva sesión después de días.
Recomiendo leer archivos adicionales para contexto completo.
```

## 📋 Output Requerido

**Formato mínimo**:
```
✅ [X/8] archivos leídos y confirmados

📊 RESUMEN EJECUTIVO:
- Estado: [branch activo, fase actual, último commit]
- Pendientes: [top 3-5 tareas]
- PRs: [activos con estado]

🎯 PRÓXIMO PASO:
[Acción inmediata a tomar]

✅ LISTO PARA CONTINUAR
```

**Para output detallado** (primera vez sesión), consultar: @/docs/REMEMBER_CHECKLIST.md

## ⚠️ Manejo de Errores

Si algún archivo falla al leer:
1. Reportar específicamente cuál archivo y error
2. Continuar con los demás archivos
3. Al final, solicitar al usuario verificar archivo faltante
