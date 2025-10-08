# CLAUDE.md — RITMO Habit Tracker

**Versión**: 3.1.0
**Última actualización**: 2025-10-07
**Estado**: ✅ PRODUCTION-READY CON CARACTERÍSTICAS PREMIUM

---

## 🧠 Resumen Ejecutivo (Quick Start)

| Campo | Valor |
|-------|-------|
| **Proyecto** | RITMO Habit Tracker |
| **Tipo** | Flutter Mobile App (Android/iOS) |
| **Arquitectura** | Clean Architecture + Provider Pattern |
| **Stack** | Flutter 3.x + SQLite + Firebase |
| **Estado** | Production-ready (Fase 4 completada) |
| **Idiomas** | 26 soportados (EN: 100%, ES: 100%) |
| **Principios** | Mobile-First + A11Y (WCAG AA) + i18n |
| **Branch actual** | `claude/session49-tests-maintenance-optimizations` |
| **PR activo** | #26 - Esperando CI verde |

### 🚀 Comandos Rápidos

```powershell
# Testing
flutter test --coverage                # Tests con coverage
flutter analyze                        # Análisis estático

# Traducciones
flutter gen-l10n                       # Regenerar traducciones

# Git & PR
gh pr status                           # Ver estado PRs
gh pr checks 26 --watch                # Monitorear CI PR #26
```

---

## 📋 Propósito y Alcance

**RITMO** es una aplicación Flutter de seguimiento de hábitos con características premium, gamificación y soporte de 26 idiomas. Este documento guía a Claude Code y agentes autónomos en el mantenimiento, desarrollo y optimización del proyecto.

**Rol del agente**: Asistir en desarrollo, refactoring, testing, internacionalización y optimización. **NO** tocar Firebase credentials, secrets o configuraciones de producción sin aprobación explícita.

---

## 🚨 Reglas Generales (CRÍTICO)

### 🔐 Información Confidencial de Negocio

⚠️ **REGLA CRÍTICA**: **NUNCA mencionar** información de negocio en outputs a menos que el usuario **explícitamente** pregunte sobre ello.

**Información confidencial** (ver `docs/BUSINESS_INFO.md`):
- ❌ Pricing específico ($X.XX/mes)
- ❌ Proyecciones de revenue
- ❌ Estrategia de monetización
- ❌ Análisis competitivo con precios
- ❌ Metas de conversión/KPIs

**Respuestas técnicas permitidas**:
- ✅ "Sistema premium implementado"
- ✅ "Límite de 5 hábitos en tier gratuito"
- ✅ "Features premium disponibles"
- ✅ "Validación de premium en `premium_provider.dart`"

**Cuándo SÍ mencionar**:
- Usuario pregunta explícitamente sobre pricing
- Debugging específico de paywall screen
- Cambios solicitados en monetización

**Archivo de referencia**: `docs/BUSINESS_INFO.md` (⚠️ Confidencial - Solo product owner)

---

### Seguridad y Privacidad
1. **NUNCA** ejecutar comandos que accedan a:
   - `/secrets`, `firebase_options.dart` (solo lectura permitida)
   - `google-services.json`, API keys, credenciales
   - Datos de usuarios reales (usar mocks en desarrollo)
   - `docs/BUSINESS_INFO.md` (solo leer si usuario pregunta sobre pricing)

2. **SIEMPRE** reemplazar datos sensibles por mocks antes de logging/debugging

3. **Política de datos**: Este proyecto usa Firebase. Datos de usuarios NO deben exponerse en prompts/logs

### Flujo de Trabajo Git
1. **Todas las modificaciones generan rama** `claude/<tarea>` y PR
2. **NO mergear a `master`** sin:
   - ✅ CI verde (tests + lint)
   - ✅ Al menos 1 revisión humana
3. **Crear tests** unitarios/integración para cambios relevantes
4. **Commits descriptivos** siguiendo convención

### Internacionalización (i18n)
1. **NUNCA hardcodear strings** — usar `AppLocalizations.of(context)!.key`
2. **Agregar a AMBOS archivos**: `lib/l10n/app_en.arb` Y `lib/l10n/app_es.arb`
3. **Regenerar** traducciones: `flutter gen-l10n`
4. Ver protocolo completo: `docs/BILINGUAL_GUIDE.md`

---

## 💻 Comandos Útiles del Proyecto

### Desarrollo Local
```powershell
# Ejecutar en dispositivo Android específico
flutter run -d 2311DRK48G

# Ejecutar en servidor web (desarrollo)
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

# Generar traducciones
flutter gen-l10n

# Análisis estático
flutter analyze

# Tests
flutter test

# Formateo de código
dart format lib/
```

### Telemetría (Plan Maestro)
```powershell
# Registrar operación individual
.\scripts\log-tokens.ps1 -Operation "Read habit_provider.dart" -TokensUsed 1250 -SessionId "54"

# Registrar sesión completa
.\scripts\log-session.ps1 -SessionId "54" -DurationMinutes 120 -TasksCompleted 5 -TotalTokens 45000 -Notes "Descripción de la sesión"

# Ver resumen de sesiones
Get-Content telemetry\sessions\*.json | ConvertFrom-Json | Select-Object session_id, tokens_used, duration_minutes, tasks_completed | Format-Table
```

---

## 🛠️ Allowlist de Herramientas (WINDOWS)

### ✅ Herramientas Permitidas
```powershell
# Testing y Calidad
flutter test                           # Ejecuta tests
flutter analyze                        # Análisis estático
dart format --output=none --set-exit-if-changed .  # Validar formato

# Git (solo lectura)
git status
git diff
git log --oneline -n 10
git branch --list

# Build (validación)
flutter pub get                        # Dependencias
flutter gen-l10n                       # Traducciones

# Información (Windows)
dir                                    # Listar archivos
type <archivo>                         # Ver contenido
Get-Content <archivo>                  # PowerShell alternativa
findstr /s /i "pattern" *.dart        # Búsqueda en código
```

### ❌ Herramientas Prohibidas (sin aprobación)
- `flutter run -d <device-id>` sin aprobación
- `firebase deploy`
- `git push` a `master`/`main`
- Modificación de `.env`, `firebase_options.dart`, `google-services.json`
- Acceso a databases de producción

---

## 🔄 Flujos Autorizados

### 1️⃣ Refactor de Código
```powershell
# 1. Crear branch
git checkout -b claude/refactor-<component>

# 2. Modificar código (aplicar SOLID, design patterns)

# 3. Ejecutar tests
flutter test

# 4. Verificar formato y análisis
dart format lib/
flutter analyze

# 5. Proponer PR con checklist
```

### 2️⃣ Agregar/Completar Traducciones
```powershell
# 1. Crear branch
git checkout -b claude/i18n-<feature>

# 2. Identificar strings hardcoded
findstr /s /i "Text(" lib\*.dart | findstr /v "AppLocalizations"

# 3. Agregar claves a app_en.arb Y app_es.arb

# 4. Regenerar traducciones
flutter gen-l10n

# 5. Reemplazar strings por AppLocalizations

# 6. Proponer PR
```

### 3️⃣ Corrección de Bugs
```powershell
# 1. Crear branch
git checkout -b claude/fix-<issue-number>

# 2. Reproducir bug (documentar steps)

# 3. Implementar fix

# 4. Agregar test de regresión

# 5. Ejecutar suite completa
flutter test

# 6. Proponer PR con evidencia
```

---

## 📁 Arquitectura del Proyecto

### Stack Técnico
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Local DB**: SQLite (DatabaseHelper)
- **Cloud**: Firebase (Auth, Firestore, Analytics)
- **Monetización**: Sistema premium implementado (límite free tier)
- **Platform**: Windows (desarrollo), Android/iOS (producción)

### Archivos Clave
- `lib/models/habit.dart` - ⚠️ CRÍTICO: Lógica de rachas corregida
- `lib/providers/habit_provider.dart` - ⭐ Core logic
- `lib/providers/theme_provider.dart` - 6 temas premium
- `lib/providers/premium_provider.dart` - Límite 5 hábitos free
- `lib/screens/settings_screen.dart` - UI premium y configuración
- `lib/core/design_constants.dart` - ⭐ USAR para espaciados
- `docs/CONTEXT_LAST_SESSION.md` - Contexto completo de sesiones

### Características Implementadas
- ✅ Sistema de rachas corregido e intuitivo
- ✅ 6 temas premium dramáticos
- ✅ Gamificación funcional (5 puntos por hábito)
- ✅ 26 idiomas soportados (EN 100%, ES 71%)
- ✅ UI/UX profesional sin elementos de desarrollo
- ✅ Orientación bloqueada a vertical
- ✅ Límite 5 hábitos free → Premium ilimitado

---

## 🎯 Tareas Priorizadas para Agentes

### 🔥 Alta Prioridad
1. ✅ ~~**Completar traducciones ES**~~ **COMPLETADO** (100% - 571/571 strings)

2. ✅ ~~**Fix overflows en GamificationCard**~~ **COMPLETADO** (PR #26 merged)

3. **Tests unitarios para providers** 🧪
   - Coverage actual: ~50%
   - Meta: 80%+
   - Prioridad: `habit_provider.dart`, `premium_provider.dart`

### 📋 Media Prioridad
4. **Refactoring de layouts complejos**
   - Aplicar LayoutBuilder pattern (ver CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md)

5. **Documentación técnica**
   - Actualizar `docs/PROJECT_STATUS.md`
   - Screenshots para Store

6. **Bump de dependencias seguro**
   - Actualizar packages non-critical

---

## 🎨 Principios de Desarrollo

### 📚 Principios Globales (Todos los Proyectos)
Ver documento completo: [CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md](../../CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md)

**Ubicación global**: `C:\Users\shill\AppData\Local\Android\Sdk\Proyectos\CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md`

### 🚨 MOBILE-FIRST + ACCESSIBILITY (A11Y) - SIEMPRE APLICAR

1. **📱 MOBILE-FIRST**:
   - Diseño optimizado primero para móvil (Android/iOS)
   - Touch-friendly (tamaños mínimos 44x44 dp)
   - Orientación vertical prioritaria

2. **♿ ACCESSIBILITY (A11Y)**:
   - Semantic widgets (usar nombres descriptivos)
   - Contraste suficiente (WCAG AA mínimo)
   - Screen reader compatible (Semantics widgets)

3. **🌍 INTERNACIONALIZACIÓN**:
   - NUNCA hardcodear strings
   - SIEMPRE usar AppLocalizations
   - Layouts flexibles para textos largos

**✅ CHECKLIST DE REVISIÓN** (mental en cada cambio):
- ❓ ¿Funciona bien en pantallas pequeñas?
- ❓ ¿Los botones son suficientemente grandes para touch?
- ❓ ¿Los textos están internacionalizados?
- ❓ ¿Hay contraste suficiente?
- ❓ ¿Es navegable sin ver la pantalla?

### 🎨 Principios Específicos de RITMO

**Design System:**
- Usar constantes de `lib/core/design_constants.dart` para espaciados
- Material 3 con temas oscuros/claros
- Tipografía custom en `lib/core/ritmo_typography.dart`
- 6 temas premium + 1 free (protección con candados 🔒)

**Estado y Lógica:**
- Provider pattern para state management
- DatabaseHelper (SQLite) para persistencia local
- Firebase para autenticación y cloud sync (premium)
- Gamificación: 5 puntos por hábito completado

---

## 📈 Gestión de Contexto Automática

- ⚠️ **SIEMPRE avisar** antes de tareas que puedan consumir >50% del contexto estimado
- 💾 **Para tareas complejas** (>5 archivos, búsquedas extensas): sugerir `/save` primero
- 📦 **Dividir tareas grandes** en pasos de máximo 3-5 archivos por vez (solo si hay riesgo de agotamiento)
- 🔄 **Usar `/remember`** al recuperar contexto después de `/save`

### 🔄 Flujo Correcto: /save → /clear → /bootstrap

**PROTOCOLO OBLIGATORIO** para limpiar contexto sin pérdida:

```
1. /save          ← Guarda contexto actual en CONTEXT_LAST_SESSION.md
2. /clear         ← Limpia chat (opcional - solo si necesitas liberar contexto)
3. /bootstrap     ← Recupera contexto completo desde cero
   O
3. /remember      ← Recupera contexto parcial (si ya tienes base cargada)
```

⚠️ **CRÍTICO**: NUNCA ejecutar `/clear` sin `/save` previo → **pérdida total de trabajo**

**Diferencia entre comandos de restauración:**

| Comando | Uso | Archivos Leídos | Cuándo Usar |
|---------|-----|-----------------|-------------|
| `/bootstrap` | Restauración completa | TODOS (8 archivos) | Después de `/clear`, primera sesión del día |
| `/remember` | Restauración parcial | Selectivo (1-8 archivos) | Durante sesión activa, actualizaciones |

**Frecuencia típica** en sesiones largas:
- Cada 40-50k tokens consumidos → `/save` + `/clear` + `/bootstrap`
- Permite múltiples ciclos de trabajo en sesión única
- Budget efectivo: ~200k × N ciclos

### Control de Tokens y Budget

**Estrategia de Optimización:**
1. **RAG con chunking semántico**: Recuperar solo contexto relevante
2. **Pre-summarization**: Resumir archivos grandes antes de enviar
3. **Budget por tarea**:
   - Simple refactor: 1,024 tokens
   - Feature nueva: 4,096 tokens
   - Análisis complejo: 8,192 tokens (máximo)

**Prompts Compactos** (usar formato estructurado):
```xml
<instructions>
Action: PROPOSE_PATCH
Rules: No tocar APIs públicas, add tests
Output: JSON {"title","patch","tests_run"}
</instructions>
<context>
summaries: [<<s1>>, <<s2>>]
</context>
```

---

## 🤖 PROTOCOLO /remember AUTOMÁTICO Y OBLIGATORIO

⚠️ **IMPORTANTE**: Al recibir `/remember`, **INMEDIATAMENTE** leer estos archivos en este orden exacto:

### LISTA FIJA DE ARCHIVOS OBLIGATORIOS:
1. 📋 `CLAUDE.md` (este archivo - instrucciones proyecto)
2. 🌐 `../../CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md` (principios universales desarrollo)
3. 📝 `docs/CONTEXT_LAST_SESSION.md` (estado última sesión)
4. 🔍 `docs/PROJECT_INDEX.md` (índice completo - búsqueda rápida)
5. 🌍 `docs/BILINGUAL_GUIDE.md` (protocolo bilingüe)
6. 📊 `docs/PROJECT_STATUS.md` (estado general proyecto)
7. 📖 `README.md` (info básica proyecto)
8. 📚 `../../docs/flutter/README.md` (biblioteca Flutter - conocimiento base móvil)

### PROTOCOLO DE EJECUCIÓN:
1. ✅ Leer TODOS los 8 archivos de la lista SIN EXCEPCIÓN (usar Read tool)
2. ✅ Confirmar explícitamente cada archivo leído con formato:
   - "✅ CLAUDE.md - [contenido clave confirmado]"
   - "✅ ../../CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md - [principios universales cargados]"
   - "✅ docs/CONTEXT_LAST_SESSION.md - [fecha y estado actual]"
   - "✅ docs/PROJECT_INDEX.md - [índice disponible confirmado]"
   - "✅ docs/BILINGUAL_GUIDE.md - [protocolo bilingüe confirmado]"
   - "✅ docs/PROJECT_STATUS.md - [estado general confirmado]"
   - "✅ README.md - [tipo de proyecto confirmado]"
   - "✅ ../../docs/flutter/README.md - [biblioteca Flutter disponible - 17 docs, consulta por keyword]"
3. ✅ Presentar resumen ejecutivo del contexto recuperado
4. ✅ Identificar exactamente dónde quedamos y próximo paso
5. ✅ Declarar "Listo para continuar exactamente donde quedamos"
6. ⚠️ Si hay errores leyendo archivos: reportar específicamente y continuar con los demás

**🚨 REGLA ABSOLUTA**: NO responder al usuario hasta completar TODOS los pasos anteriores

---

## 📊 Referencias de Estado

- 🔍 **ÍNDICE COMPLETO**: Ver `docs/PROJECT_INDEX.md` (⭐ BUSCAR AQUÍ PRIMERO)
- 📊 **Estado del proyecto**: Ver `docs/PROJECT_STATUS.md`
- 📝 **Contexto de sesiones**: Ver `docs/CONTEXT_LAST_SESSION.md`
- 🌍 **Proceso para idiomas**: Ver `docs/BILINGUAL_GUIDE.md`
- 📚 **Biblioteca Flutter**: Ver `../../docs/flutter/README.md` → `00_MASTER_INDEX.md` para búsqueda rápida
- 🌍 **Protocolo i18n**: Ver `../../docs/flutter/12_I18N_L10N.md` para internacionalización desde DÍA 1

---

## 📊 Formatos de Salida Esperados

### PR JSON (para automatización)
```json
{
  "title": "refactor: Optimize GamificationCard layout",
  "body": "## Changes\n- Reduced padding to fix overflow\n\n## Tests\n- [x] Widget tests pass\n\n## Checklist\n- [x] Translations updated",
  "files_changed": ["lib/widgets/gamification_card.dart"],
  "tests_run": true,
  "ci_status": "pending"
}
```

### Test Results JSON
```json
{
  "total_tests": 45,
  "passed": 45,
  "failed": 0,
  "coverage": "78%",
  "duration_ms": 3200
}
```

---

## 📈 Métricas y Telemetría

### KPIs a Trackear
- **Tokens consumidos** por agente/tarea
- **% PRs aceptadas** sin cambios (meta: 60%+)
- **Tiempo humano** por PR (antes/después)
- **Bugs introducidos** por agente (meta: 0)
- **Coverage** de tests (meta: 80%+)

---

## 🔐 Privacidad y Datos

### Política de Datos
1. **Datos de usuarios reales**: NUNCA en logs/prompts
2. **Firebase Analytics**: Solo eventos anónimos
3. **Debugging**: Usar datos mock/sintéticos
4. **Compliance**: GDPR-ready (data export/delete)

### Datos Mock Recomendados
```dart
// Usar en desarrollo/testing
final mockHabits = [
  Habit(id: 'test-1', name: 'Morning Workout', ...),
  Habit(id: 'test-2', name: 'Read 30min', ...),
];
```

---

## 👥 Contactos y Gating

### Cambios que Requieren Aprobación Manual
- ⚠️ **Infra/Secrets**: @sec-oncall (obligatorio)
- ⚠️ **Firebase config**: @backend-lead
- ⚠️ **Monetización/Premium/Pricing**: @product-owner (ver `docs/BUSINESS_INFO.md`)
- ⚠️ **Breaking changes**: @tech-lead

---

## 🚀 CI/CD y Automation

### GitHub Actions (Configurado)
```yaml
# .github/workflows/claude-ci.yml
name: CI for Claude PRs
on:
  pull_request:
    branches: ['claude/**']
jobs:
  validate:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter gen-l10n
```

---

## ✅ Checklist de PR (Auto-generar)

```markdown
## Checklist
- [ ] Tests unitarios agregados/actualizados
- [ ] Lint warnings resueltos (flutter analyze)
- [ ] Traducciones actualizadas (EN + ES)
- [ ] Documentación actualizada (si aplica)
- [ ] No expone datos sensibles
- [ ] Performance validado
- [ ] Accessibility verificado
- [ ] Design constants aplicados
- [ ] CI pasa (verde)

## Evidencia
- Tests: X/X passed
- Coverage: XX%
- Build: ✅ Success
```

---

## 🔄 Evolución de Principios

⚠️ **PROTOCOLO OBLIGATORIO - DETECCIÓN BASADA EN EVIDENCIA**

**⚠️ RESTRICCIÓN CRÍTICA**: Solo notificar principios nuevos si se basan en **evidencia de cambios realizados y probados**, no en especulación.

**Criterios obligatorios** (TODOS deben cumplirse):
1. ✅ **Evidencia concreta**: El principio se aplicó en código real (con rutas de archivos y líneas)
2. ✅ **Problema resuelto**: Solucionó un bug, mejoró performance o simplificó código (medible)
3. ✅ **Verificado**: El cambio fue probado (tests pasando, CI verde, o validado manualmente)
4. ✅ **Generalizable**: Aplica a más de 1 caso de uso (no es solución única/específica)

Cuando detectes/descubras durante el trabajo:
- ✨ Nuevo patrón útil o best practice **que aplicaste en el código**
- ❌ Anti-patrón que causó problemas **que corregiste con evidencia**
- 🎯 Solución elegante a problema común **que implementaste y probaste**

**DEBES notificar con formato:**
```
💡 **NUEVO PRINCIPIO DETECTADO (Basado en Evidencia)**

**Contexto**: [Dónde se descubrió - sesión, archivo, líneas]
**Principio**: [Descripción concisa]
**Beneficio**: [Por qué es útil - con métricas si aplica]
**Aplicabilidad**: [RITMO / Universal / Flutter-específico]

**📊 Evidencia** (OBLIGATORIO):
- **Archivo modificado**: `path/to/file.ext:100-150`
- **Problema resuelto**: [Descripción específica]
- **Solución aplicada**: [Qué cambió exactamente]
- **Verificación**: [Tests pasando / CI verde / Validado]
- **Impacto medible**: [Ej: -26 warnings, +30 tests, 60% ↑]

**Propuesta**: ¿Agregarlo a CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md?
```

**Frecuencia**: Máximo 3 por sesión, al final de tareas (no interrumpir flujo)
**Documentación completa**: Ver sección "Evolución Continua de Principios" en `CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md`

---

## 🚨 Troubleshooting Común

### Error: "AppLocalizations not found"
```powershell
flutter clean
flutter pub get
flutter gen-l10n
# Restart IDE
```

### Error: Overflow en widgets
```dart
// Usar LayoutBuilder pattern
LayoutBuilder(
  builder: (context, constraints) {
    final adaptiveHeight = constraints.maxHeight != double.infinity
        ? constraints.maxHeight - offset
        : fallbackHeight;
    return SizedBox(height: adaptiveHeight, child: ...);
  },
)
```

### Error: Tests fallan después de refactor
```powershell
# Ejecutar tests específicos
flutter test test/specific_test.dart
```

---

## 🪟 Comandos Windows Útiles

### PowerShell - Análisis de Código
```powershell
# Buscar strings hardcoded
Get-ChildItem -Path lib -Recurse -Filter *.dart | Select-String 'Text\(' | Where-Object { $_ -notmatch 'AppLocalizations' }

# Contar archivos por tipo
Get-ChildItem -Path lib -Recurse | Group-Object Extension | Select-Object Name, Count

# Ver archivos modificados recientemente
Get-ChildItem -Path lib -Recurse -Filter *.dart | Sort-Object LastWriteTime -Descending | Select-Object -First 10 Name, LastWriteTime
```

### CMD - Comandos Básicos
```cmd
:: Buscar texto en archivos
findstr /s /i "TODO" lib\*.dart

:: Listar archivos Dart
dir /s /b lib\*.dart
```

---

## 📊 WORKFLOW DE SESIÓN (PLAN MAESTRO)

### ⚠️ AL FINALIZAR CADA SESIÓN

**IMPORTANTE**: Registrar métricas para tracking de eficiencia:

```powershell
# 1. Registrar sesión completa
.\scripts\log-session.ps1 `
  -SessionId "XX" `
  -DurationMinutes 90 `
  -TasksCompleted 3 `
  -TotalTokens 48000 `
  -Notes "Descripción breve de lo logrado"

# 2. Actualizar CONTEXT_LAST_SESSION.md con resultados

# 3. Verificar KPIs (opcional)
Get-ChildItem telemetry\sessions\session-*.json | ForEach-Object {
    $s = Get-Content $_.FullName | ConvertFrom-Json
    Write-Host "Sesión $($s.session_id): $($s.tokens_used) tokens, $($s.tasks_completed) tareas"
}
```

**Checklist post-sesión**:
- [ ] Métricas registradas con `log-session.ps1`
- [ ] `CONTEXT_LAST_SESSION.md` actualizado
- [ ] Commits pusheados (si aplica)
- [ ] PR creado/actualizado (si aplica)

---

## 🎯 Estado Actual del Proyecto

**Fase**: ✅ FASE 4 COMPLETADA (Monetización) + Fase 1 Plan Maestro COMPLETADA
**Branch**: master
**Último commit**: adb19a7 "refactor(ui): Optimize layout spacing"
**Plataforma desarrollo**: Windows

**Pendientes inmediatos**:
1. ✅ ~~Fix overflow GamificationCard~~ COMPLETADO (PR #26)
2. ✅ ~~Completar traducciones ES~~ COMPLETADO (100%)
3. ✅ ~~Implementar telemetría~~ COMPLETADO (Sesión 54)
4. 🔄 ACI Formal + SAST en CI (Sesión 55)

---

**FIN DE CLAUDE.md v3.0**

> 📌 **Versión 3.0.0**: Merged ACTUAL + ENHANCED + Plan Maestro (Windows optimizado)
