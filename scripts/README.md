# 🛡️ Scripts de Seguridad - RITMO

Wrappers seguros para operaciones de desarrollo, parte del **Plan Maestro Claude Code + Agents**.

---

## 📁 Scripts Disponibles

### 1. `safe-test.ps1` - Tests con Output JSON

**Propósito**: Ejecutar tests de Flutter con validación y output estructurado.

```powershell
# Uso básico
.\scripts\safe-test.ps1

# Con coverage
.\scripts\safe-test.ps1 -Coverage

# Tests específicos
.\scripts\safe-test.ps1 -TestPath test/unit/

# Modo verbose
.\scripts\safe-test.ps1 -Verbose -Coverage
```

**Output JSON**:
```json
{
  "timestamp": "2025-10-05T15:30:00Z",
  "status": "success",
  "total_tests": 45,
  "passed": 45,
  "failed": 0,
  "coverage": "Ver coverage/lcov.info",
  "duration_ms": 3200,
  "failures": [],
  "log_file": "logs/test_2025-10-05_15-30-00.log"
}
```

**Características**:
- ✅ Validación de entorno Flutter
- ✅ Output JSON parseable
- ✅ Logs detallados en `logs/`
- ✅ Captura de fallos individuales
- ✅ Cálculo de coverage opcional

---

### 2. `safe-build.ps1` - Build con Validación

**Propósito**: Validar y construir APK/AAB/Web con confirmaciones de seguridad.

```powershell
# Dry-run (solo validación - DEFAULT)
.\scripts\safe-build.ps1 -DryRun

# Build debug APK
.\scripts\safe-build.ps1 -Target apk -Mode debug

# Build release (requiere confirmación)
.\scripts\safe-build.ps1 -Target apk -Mode release

# Build web
.\scripts\safe-build.ps1 -Target web -Verbose
```

**Output JSON**:
```json
{
  "timestamp": "2025-10-05T15:35:00Z",
  "status": "success",
  "target": "apk",
  "mode": "debug",
  "duration_ms": 45000,
  "output_path": "build/app/outputs/flutter-apk/app-debug.apk",
  "error": "",
  "log_file": "logs/build_2025-10-05_15-35-00.log",
  "dry_run": false
}
```

**Características**:
- ✅ Dry-run por defecto (seguro)
- ✅ Confirmación manual para release builds
- ✅ Análisis estático pre-build
- ✅ Validación de dependencies
- ✅ Output path detallado

---

### 3. `safe-lint.ps1` - Linting y Formateo

**Propósito**: Análisis estático, formateo y detección de strings hardcoded.

```powershell
# Solo análisis
.\scripts\safe-lint.ps1

# Con formateo automático
.\scripts\safe-lint.ps1 -Format

# Verbose
.\scripts\safe-lint.ps1 -Verbose
```

**Output JSON**:
```json
{
  "timestamp": "2025-10-05T15:40:00Z",
  "status": "success",
  "errors": 0,
  "warnings": 2,
  "infos": 5,
  "issues": [
    {
      "type": "warning",
      "message": "warning • Unused import 'package:flutter/material.dart'"
    }
  ],
  "hardcoded_strings": 3,
  "formatted": true,
  "log_file": "logs/lint_2025-10-05_15-40-00.log"
}
```

**Características**:
- ✅ `flutter analyze` completo
- ✅ Formateo con `dart format` (opcional)
- ✅ Detección de strings hardcoded (i18n)
- ✅ Categorización: errors/warnings/infos
- ✅ Logs con ubicación de issues

---

## 🔐 Seguridad

### Validaciones Implementadas
1. ✅ **Dry-run por defecto** en builds
2. ✅ **Confirmación manual** para release builds
3. ✅ **Verificación de entorno** (Flutter, pubspec.yaml)
4. ✅ **Logs auditables** en `logs/`
5. ✅ **Output JSON** para parsing automático

### Reglas de Uso
- 🚨 **NUNCA** ejecutar release builds sin revisión
- 🚨 **SIEMPRE** revisar logs en caso de fallo
- 🚨 **Validar** que estás en el directorio correcto
- ✅ **Usar** `-DryRun` para validar antes de ejecutar

---

## 📊 Logs y Telemetría

### Ubicación de Logs
```
logs/
├── test_2025-10-05_15-30-00.log
├── build_2025-10-05_15-35-00.log
└── lint_2025-10-05_15-40-00.log
```

### Formato de Logs
```
[15:30:00] === SAFE-TEST INICIADO ===
[15:30:00] Proyecto: RITMO Habit Tracker
[15:30:00] Test path: Todos los tests
[15:30:00] Coverage: False
[15:30:05] Tests completados en 5000 ms
[15:30:05] === SAFE-TEST COMPLETADO ===
```

---

## 🚀 Integración con CI/CD

### GitHub Actions
```yaml
- name: Run Safe Tests
  run: |
    $result = .\scripts\safe-test.ps1 -Coverage | ConvertFrom-Json
    if ($result.status -ne "success") {
      exit 1
    }

- name: Run Safe Lint
  run: |
    $result = .\scripts\safe-lint.ps1 | ConvertFrom-Json
    if ($result.errors -gt 0) {
      exit 1
    }
```

### Uso Local por Agentes
Los agentes de Claude Code pueden ejecutar estos scripts de forma segura:

```powershell
# Agente ejecuta test
$testResult = .\scripts\safe-test.ps1 | ConvertFrom-Json

if ($testResult.status -eq "success") {
    Write-Host "✅ Tests pasaron: $($testResult.passed)/$($testResult.total_tests)"
} else {
    Write-Host "❌ Tests fallaron: $($testResult.failures)"
}
```

---

## 🛠️ Troubleshooting

### Error: "No se encontró pubspec.yaml"
```powershell
# Asegúrate de estar en el directorio del proyecto
cd "C:\Users\shill\AppData\Local\Android\Sdk\Proyectos\Aplicaciones Play Store\habito_pro_clean"
```

### Error: "Flutter no reconocido"
```powershell
# Verificar que Flutter está en PATH
flutter --version
```

### Error: "Execution Policy"
```powershell
# Permitir ejecución de scripts (una vez)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📝 Desarrollo

### Agregar Nuevo Wrapper
1. Crear `safe-<nombre>.ps1` en `scripts/`
2. Seguir estructura de scripts existentes:
   - Parámetros con validación
   - Función `Show-Help`
   - Logging en `logs/`
   - Output JSON estructurado
3. Documentar en este README

### Ejemplo Template
```powershell
# safe-custom.ps1
param(
    [switch]$Verbose,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$LogFile = Join-Path $ProjectRoot "logs\custom_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"

function Show-Help { ... }
function Write-Log { ... }
function New-ResultJson { ... }

try {
    # Lógica principal
} catch {
    # Error handling
}
```

---

## 📚 Referencias

- [CLAUDE.md](../CLAUDE.md) - Instrucciones completas del proyecto
- [Plan Maestro](../Plan%20Maestro%20—%20Claude%20Code%20+%20Agents.pdf) - Documentación completa
- [Flutter Docs](https://docs.flutter.dev) - Documentación oficial

---

## 📊 Telemetría y Métricas

### 4. `log-agent-operation.ps1` - Sistema de Telemetría

**Propósito**: Registrar operaciones de agentes con métricas detalladas.

```powershell
# Iniciar tarea
.\scripts\log-agent-operation.ps1 -Task "fix-overflow" -Status "in_progress"

# Completar tarea
.\scripts\log-agent-operation.ps1 `
  -Task "fix-overflow" `
  -Tokens 2048 `
  -Status "success" `
  -FilesChanged 2 `
  -PRNumber "123"

# Registrar error
.\scripts\log-agent-operation.ps1 `
  -Task "complex-refactor" `
  -Status "error" `
  -Notes "Timeout exceeded"
```

**Output**:
- `telemetry/agent_operations.json` - Registro completo de operaciones
- `telemetry/metrics_summary.json` - Métricas agregadas

**Métricas Trackeadas**:
- ✅ Total de operaciones
- ✅ Tasa de éxito (%)
- ✅ Tokens consumidos (total, promedio, max, min)
- ✅ Tareas más comunes
- ✅ PRs generados

---

### 5. `count-tokens.ps1` - Contador de Tokens

**Propósito**: Estimar tokens de archivos para optimización.

```powershell
# Contar tokens de un archivo
.\scripts\count-tokens.ps1 -Path lib\main.dart

# Contar todos los archivos Dart
.\scripts\count-tokens.ps1 -Pattern "*.dart" -Recursive

# Resumen de lib/
.\scripts\count-tokens.ps1 -Path lib -Recursive -Summary

# Archivos de traducción
.\scripts\count-tokens.ps1 -Path lib\l10n -Pattern "*.arb" -Recursive
```

**Output JSON**:
```json
{
  "timestamp": "2025-10-05T16:00:00Z",
  "pattern": "*.dart",
  "files_analyzed": 39,
  "totals": {
    "estimated_tokens": 15234,
    "characters": 60936,
    "lines": 2847,
    "size_kb": 59.5
  },
  "files": [...]
}
```

**Uso**:
- Estimar consumo de tokens antes de tareas
- Identificar archivos grandes que necesitan optimización
- Priorizar qué archivos resumir con RAG

---

### 6. `generate-dashboard.ps1` - Dashboard de Métricas

**Propósito**: Generar dashboard HTML con visualización de métricas.

```powershell
# Generar dashboard
.\scripts\generate-dashboard.ps1

# Generar y abrir en navegador
.\scripts\generate-dashboard.ps1 -Open
```

**Dashboard Incluye**:
- 📊 Total de operaciones
- ✅ Tasa de éxito (%)
- 🎯 Tokens consumidos
- 📈 Operaciones por status
- 📋 Tabla de últimas 20 operaciones

**Output**: `telemetry/dashboard.html`

---

## 📈 Workflow Completo con Telemetría

### Ejemplo: Refactor con Tracking

```powershell
# 1. Iniciar operación
.\scripts\log-agent-operation.ps1 -Task "refactor-gamification" -Status "in_progress"

# 2. Estimar tokens del archivo
$tokens = (.\scripts\count-tokens.ps1 -Path lib\widgets\gamification_card.dart | ConvertFrom-Json).totals.estimated_tokens

# 3. Ejecutar tests
.\scripts\safe-test.ps1

# 4. Hacer cambios...

# 5. Ejecutar lint
.\scripts\safe-lint.ps1 -Format

# 6. Completar operación
.\scripts\log-agent-operation.ps1 `
  -Task "refactor-gamification" `
  -Status "success" `
  -Tokens $tokens `
  -FilesChanged 1

# 7. Generar dashboard
.\scripts\generate-dashboard.ps1 -Open
```

---

## 📁 Estructura de Telemetría

```
telemetry/
├── agent_operations.json    # Registro completo de operaciones
├── metrics_summary.json     # Métricas agregadas
└── dashboard.html          # Dashboard visual
```

### agent_operations.json (Ejemplo)
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "timestamp": "2025-10-05T15:30:00Z",
    "task": "fix-overflow",
    "agent": "claude-code",
    "status": "success",
    "tokens": 2048,
    "files_changed": 2,
    "pr_number": "123",
    "duration_ms": 45000,
    "notes": ""
  }
]
```

### metrics_summary.json (Ejemplo)
```json
{
  "last_updated": "2025-10-05T16:00:00Z",
  "total_operations": 15,
  "operations_by_status": {
    "success": 12,
    "failed": 2,
    "error": 1,
    "in_progress": 0
  },
  "success_rate_percent": 80.0,
  "tokens": {
    "total": 30720,
    "average": 2048,
    "max": 4096,
    "min": 512
  }
}
```

---

**Versión**: 1.0.0
**Última actualización**: 2025-10-05
**Parte de**: Plan Maestro Claude Code + Agents para RITMO
