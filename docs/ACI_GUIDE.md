# 🤖 ACI GUIDE - Agent-Computer Interface

**Versión**: 1.0.0
**Creado**: 2025-10-08 (Sesión 55)
**Parte de**: Plan Maestro Claude Code - Fase 2 (Pilot)

---

## 🎯 PROPÓSITO

**ACI (Agent-Computer Interface)** es la especificación formal de herramientas y operaciones disponibles para Claude Code en este proyecto.

**Objetivos**:
- ✅ Contratos claros entre Claude y herramientas
- ✅ Validación automática de operaciones
- ✅ Prevención de errores comunes
- ✅ Workflows documentados y reproducibles
- ✅ Base para automatización futura

---

## 📁 ARCHIVO PRINCIPAL: `tools.json`

### **Ubicación**: `tools.json` (raíz del proyecto)

### **Estructura**:

```json
{
  "tools": {
    "flutter": { ... },
    "git": { ... },
    "scripts": { ... },
    "github": { ... }
  },
  "policies": { ... },
  "workflows": { ... },
  "validation_rules": { ... }
}
```

---

## 🔧 HERRAMIENTAS DEFINIDAS

### **1. Flutter Tools**

#### `flutter.test`
```json
{
  "command": "flutter test",
  "args": {
    "coverage": "--coverage (opcional)",
    "file": "test/specific_test.dart (opcional)"
  },
  "validation": {
    "pre": ["Ensure flutter pub get was run"],
    "post": ["Verify exit code 0"]
  }
}
```

**Uso**:
```powershell
flutter test                    # Run all tests
flutter test --coverage         # With coverage
flutter test test/models/habit_test.dart  # Specific file
```

#### `flutter.analyze`
```json
{
  "command": "flutter analyze",
  "validation": {
    "post": ["Check against baseline in BASELINE_WARNINGS.md"]
  }
}
```

**Uso**:
```powershell
flutter analyze
# Compare output with .github/BASELINE_WARNINGS.md
```

#### `flutter.gen-l10n`
```json
{
  "command": "flutter gen-l10n",
  "validation": {
    "pre": ["Verify app_en.arb and app_es.arb are valid JSON"],
    "post": ["Check generated files exist in lib/generated/l10n/"]
  }
}
```

**Uso**:
```powershell
flutter gen-l10n
# Verify: lib/generated/l10n/app_localizations*.dart created
```

---

### **2. Git Tools**

#### `git.status` (SAFE)
```json
{
  "command": "git status",
  "safe": true
}
```

#### `git.commit` (REQUIRES VALIDATION)
```json
{
  "command": "git commit -m \"message\"",
  "validation": {
    "pre": ["Verify tests pass", "Run flutter analyze"],
    "message_pattern": "^(feat|fix|docs|style|refactor|perf|test|chore)(\\(.+\\))?: .{1,100}$"
  }
}
```

**Ejemplos válidos**:
```
feat(telemetry): add session logging
fix(tests): resolve widget test failures
docs(readme): update installation steps
```

#### `git.push` (REQUIRES APPROVAL)
```json
{
  "command": "git push",
  "require_approval": true,
  "validation": {
    "pre": ["Verify CI is green", "Not pushing to main/master directly"]
  }
}
```

---

### **3. Scripts (Telemetría)**

#### `scripts.log-session`
```json
{
  "command": "powershell -File scripts/log-session.ps1",
  "args": {
    "SessionId": "required (string)",
    "DurationMinutes": "required (int)",
    "TasksCompleted": "optional (int)",
    "TotalTokens": "optional (int)",
    "Notes": "optional (string)"
  },
  "output": "telemetry/sessions/session-{id}.json"
}
```

**Uso**:
```powershell
.\scripts\log-session.ps1 -SessionId "55" -DurationMinutes 90 -TasksCompleted 3 -TotalTokens 48000 -Notes "ACI implementation"
```

#### `scripts.log-tokens`
```json
{
  "command": "powershell -File scripts/log-tokens.ps1",
  "args": {
    "Operation": "required (string)",
    "TokensUsed": "required (int)",
    "SessionId": "optional (string)"
  },
  "output": "telemetry/tokens/tokens-{date}.json"
}
```

---

### **4. GitHub CLI Tools**

#### `github.pr-create` (REQUIRES APPROVAL)
```json
{
  "command": "gh pr create",
  "validation": {
    "pre": ["Tests pass", "CI is green", "Telemetry logged"],
    "template": ".github/PULL_REQUEST_TEMPLATE.md"
  }
}
```

**Workflow**:
```powershell
# 1. Tests pass
flutter test

# 2. Lint pass
flutter analyze

# 3. Telemetry logged
.\scripts\log-session.ps1 ...

# 4. Create PR
gh pr create --title "feat: description" --body "$(cat .github/PULL_REQUEST_TEMPLATE.md)"
```

---

## 🛡️ POLÍTICAS DE SEGURIDAD

### **Operaciones Seguras** (sin aprobación)
```json
[
  "git status",
  "git diff",
  "flutter analyze",
  "flutter test",
  "gh pr status"
]
```

### **Requieren Aprobación**
```json
[
  "git push",
  "gh pr create",
  "flutter build --release"
]
```

### **Prohibidas**
```json
[
  "rm -rf",
  "git push --force",
  "flutter clean (without backup)"
]
```

---

## 🔄 WORKFLOWS DEFINIDOS

### **Workflow 1: Crear PR**

```json
{
  "create_pr": {
    "steps": [
      {"step": 1, "tool": "flutter.test", "required": true},
      {"step": 2, "tool": "flutter.analyze", "required": true},
      {"step": 3, "tool": "git.commit", "required": true},
      {"step": 4, "tool": "scripts.log-session", "required": true},
      {"step": 5, "tool": "github.pr-create", "required": true}
    ]
  }
}
```

**Ejecución**:
```powershell
# Step 1: Tests
flutter test
# → Verify: All tests pass

# Step 2: Lint
flutter analyze
# → Verify: 0 errors, warnings <= baseline

# Step 3: Commit
git add .
git commit -m "feat(aci): implement formal tool contracts"
# → Verify: Commit message follows convention

# Step 4: Telemetry
.\scripts\log-session.ps1 -SessionId "55" -DurationMinutes 90 -TasksCompleted 3 -TotalTokens 48000
# → Verify: Session logged in telemetry/

# Step 5: Create PR
gh pr create --title "feat(aci): implement formal tool contracts" --body-file .github/PULL_REQUEST_TEMPLATE.md
# → Verify: PR created successfully
```

---

### **Workflow 2: Finalizar Sesión**

```json
{
  "end_session": {
    "steps": [
      {"step": 1, "tool": "scripts.log-session", "required": true},
      {"step": 2, "action": "Update CONTEXT_LAST_SESSION.md", "required": true},
      {"step": 3, "action": "Verify all commits pushed", "required": false}
    ]
  }
}
```

**Ejecución**:
```powershell
# Step 1: Log session
.\scripts\log-session.ps1 -SessionId "55" ...

# Step 2: Update context (manual)
# Edit docs/CONTEXT_LAST_SESSION.md

# Step 3: Verify pushes (optional)
git status
git push
```

---

## ✅ REGLAS DE VALIDACIÓN

### **Mensajes de Commit**

**Pattern**:
```regex
^(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?: .{1,100}$
```

**Ejemplos válidos**:
```
✅ feat(telemetry): add session logging
✅ fix(tests): resolve widget test failures
✅ docs(readme): update installation steps
✅ refactor(ui): optimize layout spacing
✅ test(models): add habit model tests
```

**Ejemplos inválidos**:
```
❌ added telemetry (no tipo)
❌ feat telemetry (falta ":")
❌ feat(telemetry) add session logging (falta ":")
❌ FEAT(telemetry): add logging (mayúsculas)
```

---

### **Cambios de Archivos**

**Límites**:
```json
{
  "max_files_per_commit": 10,
  "excluded_paths": [
    "firebase_options.dart",
    "google-services.json",
    ".env"
  ]
}
```

**Reglas**:
- ⚠️ Si commit modifica > 10 archivos → Dividir en múltiples commits
- 🔒 Archivos en `excluded_paths` NO deben modificarse (contienen secrets)

---

### **Pull Requests**

**Requisitos**:
```json
{
  "min_description_length": 50,
  "require_telemetry": true,
  "require_tests": true
}
```

**Validación**:
- ✅ Descripción del PR >= 50 caracteres
- ✅ Sección de telemetría completada
- ✅ Tests agregados/actualizados (si aplica)
- ✅ CI verde antes de merge

---

## 🔍 VALIDACIÓN AUTOMÁTICA

### **Pre-commit Checks** (futuro)

Script `.git/hooks/pre-commit`:
```bash
#!/bin/bash
# Validate commit message
# Run tests
# Verify no secrets
```

### **Validación de tools.json**

```powershell
# Verificar sintaxis JSON
Get-Content tools.json | ConvertFrom-Json

# Output esperado: No errors
```

---

## 📊 INTEGRACIÓN CON TELEMETRÍA

**ACI + Telemetría** = Tracking automático de operaciones

### **Ejemplo**:

```powershell
# Operación: Ejecutar tests
flutter test --coverage

# Registrar en telemetría
.\scripts\log-tokens.ps1 -Operation "flutter test --coverage" -TokensUsed 1500 -SessionId "55"
```

**Resultado**: `telemetry/tokens/tokens-2025-10-08.json`
```json
{
  "operations": [
    {
      "time": "16:30:00",
      "operation": "flutter test --coverage",
      "tokens": 1500,
      "session_id": "55"
    }
  ]
}
```

---

## 🚀 PRÓXIMOS PASOS

### **Fase 2 (Actual)**:
- ✅ `tools.json` creado
- 🔄 Documentación ACI completa (este archivo)
- 🔄 Validación manual en workflows

### **Fase 3 (Futuro)**:
- 🔮 Validación automática pre-commit
- 🔮 Dashboard web de métricas
- 🔮 AI-assisted tool selection

---

## 💡 TIPS DE USO

### **Para Claude Code**:
1. Consultar `tools.json` antes de ejecutar herramientas
2. Validar parámetros contra schemas
3. Verificar pre/post conditions
4. Registrar operaciones en telemetría

### **Para Desarrollador Humano**:
1. Revisar `tools.json` para entender herramientas disponibles
2. Usar workflows definidos como checklists
3. Validar commits contra `validation_rules`
4. Actualizar `tools.json` al agregar nuevas herramientas

---

## 📚 REFERENCIAS

- Especificación completa: `tools.json`
- Telemetría: `docs/TELEMETRY_GUIDE.md`
- Workflows: `CLAUDE.md` (sección "WORKFLOW DE SESIÓN")
- PR Template: `.github/PULL_REQUEST_TEMPLATE.md`

---

**🎯 OBJETIVO**: Contratos formales entre agente y herramientas para operaciones seguras, validadas y rastreables.

---

*Creado: 2025-10-08 (Sesión 55)*
*Autor: Claude Code + Human Developer*
