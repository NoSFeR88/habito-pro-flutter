# ⚡ QUICK START GUIDE - OPTIMIZED WORKFLOWS

**Versión**: 1.0.0
**Creado**: 2025-10-08 (Sesión 57)
**Propósito**: Inicio rápido en <5 minutos con máxima eficiencia

---

## 🚀 INICIO RÁPIDO (30 SEGUNDOS)

### 1. **Cargar Contexto Esencial** (16.5k tokens)
```powershell
# Opción A: Bootstrap automático (RECOMENDADO)
powershell -File scripts/optimized-bootstrap.ps1

# Opción B: Cache system (si ya calentado)
python scripts/context-cache.py --warm
```

### 2. **Verificar Estado Proyecto**
```powershell
# Ver últimas 10 líneas de contexto
Get-Content docs/CONTEXT_LAST_SESSION.md | Select-Object -Last 10

# Ver progreso Plan Maestro
Get-Content docs/PLAN_MAESTRO_COMPLETE.md | Select-String "Progreso Total"
```

### 3. **Listo para trabajar!** ✅
- Contexto cargado
- Estado sincronizado
- Templates disponibles

**Tokens consumidos**: ~16.5k (vs 50k+ sin optimización)

---

## 📋 WORKFLOW POR TIPO DE TAREA

### 🆕 AGREGAR FEATURE (Template 1)

**Comando Quick**:
```
Add feature: [NAME]
Location: [FILE]
i18n: [YES/NO]
Tests: [YES/NO]
```

**Pasos (8k tokens estimados)**:
1. `docs/PROJECT_INDEX.md` → Buscar ubicación
2. `Read [file]` → Entender código actual
3. `Edit [file]` → Implementar feature
4. Si i18n: `Edit app_en.arb + app_es.arb` → Agregar strings
5. `Bash: flutter gen-l10n` → Regenerar
6. Si tests: `Write test/[file]_test.dart`
7. `Bash: flutter test` → Validar
8. `Bash: git add + commit`

**Ejemplo**:
```
Add feature: Export statistics to PDF
Location: lib/screens/stats_screen.dart
i18n: YES (exportPdf, exportSuccess)
Tests: NO

Tokens: ~8k (vs 20k sin template)
```

---

### 🐛 FIX BUG (Template 2)

**Comando Quick**:
```
Fix: [DESCRIPTION]
Severity: [CRITICAL/HIGH/MEDIUM/LOW]
Location: [FILE:LINE or Unknown]
```

**Pasos (5k tokens estimados)**:
1. Si conocido: `Read [file]:[lines]`
2. Si desconocido: `Grep [keyword]` → Top 3 results
3. `Edit [file]` → Apply fix
4. `Bash: flutter test [affected]` → Regression check
5. `Bash: git commit -m "fix: [description]"`

**Ejemplo**:
```
Fix: Notification title always in English
Severity: CRITICAL
Location: lib/services/notification_service.dart:145

Tokens: ~5k (vs 15k explorando codebase)
```

---

### 🌍 ADD TRANSLATION (Template 3)

**Comando Quick**:
```
Translate: [FEATURE]
Strings: [key1, key2, ...]
Context: [WHERE_USED]
```

**Pasos (6k tokens estimados)**:
1. `docs/BILINGUAL_GUIDE.md:1-100` → Protocol reminder
2. `Edit app_en.arb` → Add keys
3. `Edit app_es.arb` → Add translations
4. `Bash: flutter gen-l10n`
5. `Edit [files]` → Replace hardcoded
6. `Bash: git commit`

**Ejemplo**:
```
Translate: Export feature
Strings: exportPdf, exportSuccess, exportError
Context: StatsScreen export button

Tokens: ~6k (vs 12k sin protocolo)
```

---

## 🎯 BEST PRACTICES DE EFICIENCIA

### 1. **Siempre Usar PROJECT_INDEX.md Primero**
```
❌ ANTES: Grep entire codebase
✅ DESPUÉS: Check INDEX → Direct read

Savings: 10k tokens
```

### 2. **Read con Line Ranges Específicos**
```
❌ ANTES: Read file (500 líneas)
✅ DESPUÉS: Read file:100-150

Savings: 8k tokens
```

### 3. **Batch Related Operations**
```
❌ ANTES: 3 commits separados
✅ DESPUÉS: 1 workflow completo

Savings: 5k tokens (evita re-load context)
```

### 4. **Cache Context Frecuente**
```
# Warm cache al inicio de sesión
python scripts/context-cache.py --warm

# Uso subsecuente es instantáneo
Hit rate >80% = Major savings
```

### 5. **Workflow Templates**
```
# Usar template para tarea común
Ver docs/WORKFLOW_TEMPLATES.md

Average savings: 60% tokens
```

---

## 📊 MONITORING & TELEMETRY

### Durante la Sesión:

**Ver Dashboard**:
```powershell
python scripts/telemetry-dashboard.py
```

**Ver Insights**:
```powershell
python scripts/automated-insights.py
```

**Ver ROI**:
```powershell
python scripts/roi-analysis.py
```

### Al Final de Sesión:

**Log Session**:
```powershell
.\scripts\log-session.ps1 `
  -SessionId "XX" `
  -DurationMinutes 90 `
  -TasksCompleted 5 `
  -TotalTokens 45000 `
  -Notes "Brief description"
```

**Save Context**:
```powershell
# Actualizar docs/CONTEXT_LAST_SESSION.md manualmente
# O usar /save command si disponible
```

---

## 🚨 TROUBLESHOOTING RÁPIDO

### Error: "AppLocalizations not found"
```powershell
flutter clean
flutter pub get
flutter gen-l10n
# Restart IDE
```

### Cache no funciona
```powershell
python scripts/context-cache.py --clear
python scripts/context-cache.py --warm
```

### Tests fallan después de cambio
```powershell
flutter test test/specific_test.dart --verbose
```

### High token usage en sesión
```powershell
# Ver qué operaciones consumieron más
python scripts/analyze-patterns.py

# Ver recomendaciones
python scripts/automated-insights.py
```

---

## 🎯 CHEAT SHEET - COMANDOS MÁS USADOS

### Git & PR
```powershell
git status
git add [files]
git commit -m "type(scope): message"
gh pr create --title "..." --body "..."
gh pr status
```

### Flutter
```powershell
flutter test
flutter analyze
flutter gen-l10n
flutter pub get
flutter build apk --debug
```

### Telemetría
```powershell
# Dashboard
python scripts/telemetry-dashboard.py

# ROI
python scripts/roi-analysis.py

# Insights
python scripts/automated-insights.py

# Cache
python scripts/context-cache.py --warm
```

### Bootstrap
```powershell
# Context loading rápido
powershell -File scripts/optimized-bootstrap.ps1

# Ver índice
Get-Content docs/PROJECT_INDEX.md | Select-String "BÚSQUEDA"
```

---

## 💡 TIPS PRO

### 1. **Pre-warm Cache al Inicio**
```powershell
# Al comenzar sesión
python scripts/context-cache.py --warm
```
**Benefit**: Reads subsecuentes son instantáneos

### 2. **Use Templates Religiosamente**
```
# Siempre referirse a WORKFLOW_TEMPLATES.md
# 60% token savings promedio
```

### 3. **Monitor Efficiency en Tiempo Real**
```powershell
# Cada 30 min aprox
python scripts/telemetry-dashboard.py

# Target: >5.0 tasks/10k tokens
```

### 4. **Combine Independent Operations**
```
# ✅ GOOD: Read 3 files in parallel (single message)
# ❌ BAD: Read file 1, then file 2, then file 3
```

### 5. **Keep CONTEXT_LAST_SESSION.md Updated**
```
# Al final de cada milestone importante
# Facilita /remember en próxima sesión
```

---

## 📈 MÉTRICAS DE ÉXITO

### Per Session:
- **Target Efficiency**: >5.0 tasks/10k tokens
- **Target Tokens**: <60k per session
- **Target Throughput**: >6 tasks/session
- **Cache Hit Rate**: >60%

### Cumulative:
- **ROI Payback**: <20 sessions
- **Cost Reduction**: >30%
- **Time Savings**: >40%

---

## 🎓 LEARNING PATH

### Día 1: Basics
1. Load context con bootstrap
2. Use PROJECT_INDEX.md
3. Apply 1 template

### Día 2: Intermediate
1. Warm cache
2. Use 3+ templates
3. Monitor efficiency

### Día 3: Advanced
1. Optimize workflows
2. Hit >5.0 efficiency
3. Save >50% tokens

### Día 7: Expert
1. Consistent >8.0 efficiency
2. >80% cache hit rate
3. Templates customizados

---

## 🔗 QUICK LINKS

### Documentation:
- 📂 `docs/PROJECT_INDEX.md` - File locator
- 📊 `docs/PROJECT_STATUS.md` - Current state
- 🚀 `docs/WORKFLOW_TEMPLATES.md` - 8 templates
- 📋 `docs/PLAN_MAESTRO_COMPLETE.md` - Full roadmap

### Scripts:
- ⚡ `scripts/optimized-bootstrap.ps1` - Fast startup
- 💾 `scripts/context-cache.py` - Smart caching
- 📊 `scripts/telemetry-dashboard.py` - Analytics
- 💰 `scripts/roi-analysis.py` - ROI calculator

### Essential:
- 🌍 `docs/BILINGUAL_GUIDE.md` - i18n protocol
- 🧪 `docs/TESTING_STRATEGY.md` - Testing guide
- 🔐 `docs/SECURITY.md` - SAST best practices

---

## ✅ SESSION CHECKLIST

### Start of Session:
- [ ] Run optimized-bootstrap.ps1
- [ ] Warm cache (context-cache.py --warm)
- [ ] Check CONTEXT_LAST_SESSION.md
- [ ] Review pending tasks

### During Session:
- [ ] Use templates for common tasks
- [ ] Monitor token usage
- [ ] Batch related operations
- [ ] Read with specific line ranges

### End of Session:
- [ ] Log session (log-session.ps1)
- [ ] Update CONTEXT_LAST_SESSION.md
- [ ] Check efficiency (dashboard.py)
- [ ] Commit and save

---

**Created by**: Claude (Sesión 57)
**Part of**: Plan Maestro Phase 4 - Optimize
**Expected Impact**: <10k tokens setup, >5.0 efficiency consistently
**Status**: ✅ READY FOR USE

---

*Para más detalles, ver `docs/WORKFLOW_TEMPLATES.md` y `docs/PLAN_MAESTRO_COMPLETE.md`*
