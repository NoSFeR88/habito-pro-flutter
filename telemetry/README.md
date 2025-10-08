# 📊 TELEMETRY - Claude Code Metrics

**Propósito**: Capturar métricas de uso de Claude Code para medir ROI y optimizar consumo de tokens.

## 📁 Estructura

```
telemetry/
├── sessions/          # Logs de sesiones (JSON)
├── tokens/           # Logs de consumo tokens (JSON)
├── .gitignore        # Excluir datos locales
└── README.md         # Este archivo
```

## 🔧 Scripts Disponibles

### `scripts/log-tokens.ps1`
Registra consumo de tokens después de operación.

**Uso**:
```powershell
.\scripts\log-tokens.ps1 -Operation "Read habit_provider.dart" -TokensUsed 1250
```

### `scripts/log-session.ps1`
Registra metadata de sesión completa.

**Uso**:
```powershell
.\scripts\log-session.ps1 -SessionId 54 -Duration 120 -TasksCompleted 5 -TotalTokens 45000
```

## 📊 Schemas

### Session Log (`sessions/session-{id}.json`)
```json
{
  "session_id": "54",
  "date": "2025-10-08",
  "start_time": "15:30:00",
  "end_time": "17:30:00",
  "duration_minutes": 120,
  "tasks_completed": 5,
  "tokens_used": 45000,
  "tokens_budget": 200000,
  "percentage_used": 22.5,
  "operations": [
    {
      "operation": "Read habit_provider.dart",
      "tokens": 1250,
      "timestamp": "15:35:00"
    }
  ],
  "outcome": "success",
  "notes": "Implemented telemetry system"
}
```

### Token Log (`tokens/tokens-{date}.json`)
```json
{
  "date": "2025-10-08",
  "total_tokens": 45000,
  "operations": [
    {
      "time": "15:35:00",
      "operation": "Read habit_provider.dart",
      "tokens": 1250,
      "session_id": "54"
    }
  ]
}
```

## 📈 Análisis

Para generar reportes:
```powershell
# Ver consumo por sesión
Get-Content telemetry\sessions\*.json | ConvertFrom-Json | Select-Object session_id, tokens_used, duration_minutes

# Ver total tokens últimos 7 días
Get-ChildItem telemetry\tokens\*.json | Get-Content | ConvertFrom-Json | Measure-Object -Property total_tokens -Sum
```

## 🎯 KPIs Objetivo

- **Tokens/sesión**: < 50k promedio
- **Duración/sesión**: < 2 horas promedio
- **Tareas/sesión**: > 3 completadas
- **Eficiencia**: > 10 tareas/100k tokens

---

**Creado**: 2025-10-08 (Sesión 54)
**Parte de**: Plan Maestro Claude Code - Fase 2 (Pilot)
