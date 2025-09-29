# RITMO - Habit Tracker App

## Proyecto: habito_pro_clean
**Estado**: ✅ PRODUCTION-READY CON CARACTERÍSTICAS PREMIUM

### Descripción
RITMO es una aplicación Flutter para seguimiento de hábitos con características premium, gamificación y soporte completo de internacionalización (26 idiomas).

### Comandos Útiles

```bash
# Ejecutar en dispositivo Android
flutter run -d 2311DRK48G

# Ejecutar en servidor web
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

# Generar traducciones
flutter gen-l10n
```

### Archivos Clave
- `lib/models/habit.dart` - Lógica de rachas corregida
- `lib/providers/theme_provider.dart` - 6 temas premium ($2.99/mes)
- `lib/screens/settings_screen.dart` - UI premium y configuración
- `docs/CONTEXT_LAST_SESSION.md` - Contexto completo de sesiones

### Características Implementadas
- ✅ Sistema de rachas corregido e intuitivo
- ✅ 6 temas premium dramáticos
- ✅ Gamificación funcional (puntos por completar hábitos)
- ✅ 26 idiomas soportados
- ✅ UI/UX profesional sin elementos de desarrollo
- ✅ Orientación bloqueada a vertical

### Gestión de Contexto Automática
- ⚠️ SIEMPRE avisar antes de tareas que puedan consumir >50% del contexto estimado
- 💾 Para tareas complejas (>5 archivos, búsquedas extensas): sugerir `/save` primero
- 📦 Dividir tareas grandes en pasos de máximo 3-5 archivos por vez (solo si hay riesgo de agotamiento)
- 🔄 Usar `/remember` al recuperar contexto después de `/save`

### 🤖 PROTOCOLO /remember AUTOMÁTICO Y OBLIGATORIO

⚠️ **IMPORTANTE**: Al recibir `/remember`, **INMEDIATAMENTE** leer estos archivos en este orden exacto:

**LISTA FIJA DE ARCHIVOS OBLIGATORIOS**:
1. 📋 `CLAUDE.md` (este archivo - instrucciones proyecto)
2. 📝 `docs/CONTEXT_LAST_SESSION.md` (estado última sesión)
3. 🌍 `docs/BILINGUAL_GUIDE.md` (protocolo bilingüe)
4. 📊 `docs/PROJECT_STATUS.md` (estado general proyecto)
5. 📖 `README.md` (info básica proyecto)

**PROTOCOLO DE EJECUCIÓN**:
1. ✅ Leer TODOS los 5 archivos de la lista SIN EXCEPCIÓN (usar Read tool)
2. ✅ Confirmar explícitamente cada archivo leído con formato:
   - "✅ CLAUDE.md - [contenido clave confirmado]"
   - "✅ docs/CONTEXT_LAST_SESSION.md - [fecha y estado actual]"
   - "✅ docs/BILINGUAL_GUIDE.md - [protocolo bilingüe confirmado]"
   - "✅ docs/PROJECT_STATUS.md - [estado general confirmado]"
   - "✅ README.md - [tipo de proyecto confirmado]"
3. ✅ Presentar resumen ejecutivo del contexto recuperado
4. ✅ Identificar exactamente dónde quedamos y próximo paso
5. ✅ Declarar "Listo para continuar exactamente donde quedamos"
6. ⚠️ Si hay errores leyendo archivos: reportar específicamente y continuar con los demás

**🚨 REGLA ABSOLUTA**: NO responder al usuario hasta completar TODOS los pasos anteriores

### Referencias de Estado
- 📊 **Estado del proyecto**: Ver `docs/PROJECT_STATUS.md`
- 📝 **Contexto de sesiones**: Ver `docs/CONTEXT_LAST_SESSION.md`
-    **Proceso a seguir en casa sesion para idiomas**: Ver `docs/BILINGUAL_GUIDE.md`
