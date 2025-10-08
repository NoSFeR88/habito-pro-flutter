# 📊 GUÍA DE TELEMETRÍA - Claude Code

**Versión**: 1.0.0
**Creado**: 2025-10-08 (Sesión 54)
**Parte de**: Plan Maestro Claude Code - Fase 2 (Pilot)

---

## 🎯 PROPÓSITO

Capturar métricas de uso de Claude Code para:
- ✅ Medir ROI (retorno de inversión)
- ✅ Optimizar consumo de tokens
- ✅ Identificar cuellos de botella
- ✅ Mejorar eficiencia en sesiones futuras
- ✅ Justificar uso de Claude Code con datos objetivos

---

## 📁 ESTRUCTURA DE ARCHIVOS

```
telemetry/
├── sessions/              # Logs de sesiones completas
│   ├── session-50.json
│   ├── session-51.json
│   └── ...
├── tokens/               # Logs diarios de operaciones
│   ├── tokens-2025-10-08.json
│   └── ...
├── .gitignore            # Excluir datos (no commitear)
└── README.md             # Documentación básica
```

**⚠️ IMPORTANTE**: Los archivos JSON NO se commitean a git (están en `.gitignore`). Son solo para análisis local.

---

## 🔧 SCRIPTS DISPONIBLES

### 1. `log-tokens.ps1` - Tracking de Operaciones

**Propósito**: Registrar consumo de tokens por operación individual.

**Uso**:
```powershell
.\scripts\log-tokens.ps1 -Operation "Descripción de la operación" -TokensUsed 1250 -SessionId "54" -Notes "Notas opcionales"
```

**Parámetros**:
- `Operation` (requerido): Descripción de lo que se hizo (ej: "Read habit_provider.dart")
- `TokensUsed` (requerido): Número de tokens consumidos
- `SessionId` (opcional): ID de la sesión actual
- `Notes` (opcional): Notas adicionales

**Ejemplo**:
```powershell
.\scripts\log-tokens.ps1 -Operation "Read habit_provider.dart + edit toggleCompletion" -TokensUsed 2350 -SessionId "54"
```

**Output**:
```
✅ Token log registered:
   Operation: Read habit_provider.dart + edit toggleCompletion
   Tokens: 2350
   Total today: 5600
   File: telemetry\tokens\tokens-2025-10-08.json
```

---

### 2. `log-session.ps1` - Resumen de Sesión

**Propósito**: Registrar metadata completa de una sesión de trabajo.

**Uso**:
```powershell
.\scripts\log-session.ps1 `
  -SessionId "54" `
  -DurationMinutes 120 `
  -TasksCompleted 5 `
  -TotalTokens 45000 `
  -Outcome "success" `
  -Notes "Descripción de lo logrado"
```

**Parámetros**:
- `SessionId` (requerido): ID numérico de la sesión
- `DurationMinutes` (requerido): Duración total en minutos
- `TasksCompleted` (opcional): Número de tareas completadas
- `TotalTokens` (opcional): Total de tokens usados
- `TokensBudget` (opcional, default: 200000): Budget disponible
- `Outcome` (opcional, default: "success"): Resultado (success/partial/failed)
- `Notes` (opcional): Resumen de la sesión
- `StartTime` (opcional): Hora de inicio (se calcula automáticamente)
- `EndTime` (opcional): Hora de fin (se calcula automáticamente)

**Ejemplo**:
```powershell
.\scripts\log-session.ps1 -SessionId "54" -DurationMinutes 120 -TasksCompleted 7 -TotalTokens 65000 -Notes "Implementación telemetría completa"
```

**Output**:
```
✅ Session log registered:
   Session ID: 54
   Date: 2025-10-08
   Duration: 120 min
   Tasks: 7 completed
   Tokens: 65000 / 200000 (32.5%)
   Outcome: success
   Operations tracked: 12
   File: telemetry\sessions\session-54.json

📊 Top operations by tokens:
   - Read CONTEXT_LAST_SESSION.md : 5800 tokens
   - Write TELEMETRY_GUIDE.md : 3200 tokens
   - Edit CLAUDE.md : 1850 tokens
```

---

## 📊 SCHEMAS DE DATOS

### Session Log (`sessions/session-{id}.json`)

```json
{
  "session_id": "54",
  "date": "2025-10-08",
  "start_time": "15:30:00",
  "end_time": "17:30:00",
  "duration_minutes": 120,
  "tasks_completed": 7,
  "tokens_used": 65000,
  "tokens_budget": 200000,
  "percentage_used": 32.5,
  "operations": [
    {
      "time": "15:35:00",
      "operation": "Read CONTEXT_LAST_SESSION.md",
      "tokens": 5800,
      "session_id": "54",
      "notes": ""
    }
  ],
  "outcome": "success",
  "notes": "Implementación telemetría completa"
}
```

### Token Log (`tokens/tokens-{date}.json`)

```json
{
  "date": "2025-10-08",
  "total_tokens": 65000,
  "operations": [
    {
      "time": "15:35:00",
      "operation": "Read CONTEXT_LAST_SESSION.md",
      "tokens": 5800,
      "session_id": "54",
      "notes": ""
    },
    {
      "time": "16:20:00",
      "operation": "Write TELEMETRY_GUIDE.md",
      "tokens": 3200,
      "session_id": "54",
      "notes": ""
    }
  ]
}
```

---

## 📈 ANÁLISIS DE DATOS

### Ver Resumen de Sesiones

```powershell
# Tabla resumida
Get-Content telemetry\sessions\*.json | ConvertFrom-Json |
  Select-Object session_id, date, duration_minutes, tasks_completed, tokens_used, percentage_used, outcome |
  Format-Table -AutoSize

# Output:
# session_id date       duration_minutes tasks_completed tokens_used percentage_used outcome
# ---------- ----       ---------------- --------------- ----------- --------------- -------
# 50         2025-10-08               90               3       42000            21.0 success
# 51         2025-10-08               75               4       38000            19.0 success
# 52         2025-10-08              120               2       97000            48.5 success
# 53         2025-10-08               90               4       52000            26.0 success
```

### Calcular Promedios

```powershell
# Tokens promedio por sesión
$sessions = Get-Content telemetry\sessions\*.json | ConvertFrom-Json
$avgTokens = ($sessions | Measure-Object -Property tokens_used -Average).Average
Write-Host "Promedio tokens/sesión: $avgTokens"

# Eficiencia (tareas por 10k tokens)
$sessions | ForEach-Object {
    $efficiency = ($_.tasks_completed / $_.tokens_used) * 10000
    [PSCustomObject]@{
        SessionId = $_.session_id
        Efficiency = [math]::Round($efficiency, 2)
    }
} | Format-Table
```

### Ver Operaciones del Día

```powershell
$today = Get-Date -Format "yyyy-MM-dd"
$tokensFile = "telemetry\tokens\tokens-$today.json"

if (Test-Path $tokensFile) {
    $data = Get-Content $tokensFile | ConvertFrom-Json
    Write-Host "Total tokens hoy: $($data.total_tokens)"
    Write-Host "`nOperaciones:"
    $data.operations | Select-Object time, operation, tokens | Format-Table -AutoSize
}
```

---

## 🎯 KPIs Y OBJETIVOS

### KPIs Principales

| Métrica | Objetivo | Bueno | Excelente |
|---------|----------|-------|-----------|
| **Tokens/sesión** | < 50k | < 40k | < 30k |
| **Duración/sesión** | < 120 min | < 90 min | < 60 min |
| **Tareas/sesión** | > 3 | > 5 | > 7 |
| **Eficiencia** | > 5 | > 10 | > 15 |
| **% Budget usado** | < 50% | < 30% | < 20% |

**Eficiencia** = (Tareas completadas / Tokens usados) × 10,000

### Baseline Actual (Sesiones 50-53)

```
Sesión 50: 42k tokens, 90 min, 3 tareas → Eficiencia: 7.1
Sesión 51: 38k tokens, 75 min, 4 tareas → Eficiencia: 10.5
Sesión 52: 97k tokens, 120 min, 2 tareas → Eficiencia: 2.1  ⚠️
Sesión 53: 52k tokens, 90 min, 4 tareas → Eficiencia: 7.7

Promedio: 57.25k tokens, 93.75 min, 3.25 tareas → Eficiencia: 6.85
```

**Análisis**:
- ✅ Sesión 51 fue la más eficiente (10.5)
- ⚠️ Sesión 52 consumió casi 50% del budget (necesita optimización)
- 🎯 Objetivo: Llegar a eficiencia promedio de 10+

---

## 🚀 WORKFLOW RECOMENDADO

### Durante la Sesión

**Opción 1: Tracking Manual** (más preciso)
```powershell
# Al completar operación importante
.\scripts\log-tokens.ps1 -Operation "Fix test failures" -TokensUsed 8500 -SessionId "54"
```

**Opción 2: Tracking al Final** (más simple)
```powershell
# Solo al terminar sesión
.\scripts\log-session.ps1 -SessionId "54" -DurationMinutes 120 -TasksCompleted 5 -TotalTokens 45000
```

### Al Finalizar Sesión

```powershell
# 1. Registrar sesión completa
.\scripts\log-session.ps1 -SessionId "54" -DurationMinutes 120 -TasksCompleted 7 -TotalTokens 65000 -Notes "Implementación telemetría"

# 2. Ver resumen del día
$today = Get-Date -Format "yyyy-MM-dd"
Get-Content "telemetry\tokens\tokens-$today.json" | ConvertFrom-Json | Select-Object total_tokens

# 3. Actualizar CONTEXT_LAST_SESSION.md con métricas
```

---

## 📋 CHECKLIST DE TELEMETRÍA

### Por Sesión
- [ ] Registrar sesión con `log-session.ps1` al finalizar
- [ ] Incluir número de tareas completadas
- [ ] Agregar notas descriptivas
- [ ] Verificar que outcome sea correcto (success/partial/failed)

### Semanal
- [ ] Analizar tendencias de consumo
- [ ] Identificar sesiones ineficientes
- [ ] Optimizar operaciones que consumen más tokens
- [ ] Actualizar KPIs en documentación

### Mensual
- [ ] Calcular ROI (tiempo ahorrado vs costo tokens)
- [ ] Reportar métricas a stakeholders
- [ ] Ajustar estrategias según datos

---

## 💡 TIPS DE OPTIMIZACIÓN

### Reducir Consumo de Tokens

1. **Usar índices**: Buscar en `PROJECT_INDEX.md` antes de Grep/Glob
2. **Leer archivos específicos**: Evitar reads innecesarios
3. **Dividir tareas grandes**: Consumo más predecible
4. **Usar /save + /bootstrap**: Limpiar contexto periódicamente

### Aumentar Eficiencia

1. **Definir tareas claras**: Menos iteraciones
2. **Usar TODO list**: Tracking de progreso
3. **Aprovechar baseline**: Reutilizar código previo
4. **Documentar bien**: Menos tiempo buscando información

---

## 🔄 PRÓXIMOS PASOS

### Fase 2 (Actual)
- ✅ Sistema de telemetría básico implementado
- ✅ Baseline capturada (sesiones 50-53)
- 🔄 Integrar en workflow diario

### Fase 3 (Futuro)
- 📊 Dashboard de métricas (HTML/JS)
- 🤖 Análisis automático de tendencias
- 📈 Predicción de consumo por tipo de tarea
- 💰 Cálculo automático de ROI

---

## ❓ FAQ

### ¿Los logs se commitean a git?
**No**. Están en `.gitignore` para mantener privacidad y evitar inflar repo.

### ¿Qué hacer si olvido registrar tokens?
Puedes estimar basándote en el budget mostrado al final de la sesión en Claude Code.

### ¿Cómo medir tokens de operación manual?
Aproximación: Leer archivo ~1k tokens por cada 500 líneas, Edit ~500 tokens por cambio.

### ¿Puedo borrar logs antiguos?
Sí, pero se recomienda archivar (comprimir en ZIP) antes de borrar para mantener histórico.

---

## 📚 REFERENCIAS

- Plan Maestro Claude Code: `docs/PLAN_MAESTRO_EVALUATION.md`
- Contexto sesiones: `docs/CONTEXT_LAST_SESSION.md`
- Instrucciones generales: `CLAUDE.md`

---

**🎯 OBJETIVO**: Medir para mejorar. Datos objetivos para decisiones inteligentes.

---

*Creado: 2025-10-08 (Sesión 54)*
*Autor: Claude Code + Human Developer*
