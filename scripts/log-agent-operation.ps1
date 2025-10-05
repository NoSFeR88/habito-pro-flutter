# log-agent-operation.ps1
# Sistema de telemetria para operaciones de agentes
# Parte del Plan Maestro Claude Code + Agents

param(
    [Parameter(Mandatory=$true)]
    [string]$Task,

    [Parameter(Mandatory=$false)]
    [int]$Tokens = 0,

    [Parameter(Mandatory=$false)]
    [ValidateSet("success", "failed", "error", "in_progress")]
    [string]$Status = "in_progress",

    [Parameter(Mandatory=$false)]
    [string]$PRNumber = "",

    [Parameter(Mandatory=$false)]
    [int]$FilesChanged = 0,

    [Parameter(Mandatory=$false)]
    [string]$Agent = "claude-code",

    [Parameter(Mandatory=$false)]
    [string]$Notes = "",

    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TelemetryDir = Join-Path $ProjectRoot "telemetry"
$TelemetryFile = Join-Path $TelemetryDir "agent_operations.json"
$MetricsFile = Join-Path $TelemetryDir "metrics_summary.json"

function Show-Help {
    Write-Host @"
log-agent-operation.ps1 - Sistema de telemetria para agentes

USO:
    .\log-agent-operation.ps1 -Task <nombre> [opciones]

PARAMETROS REQUERIDOS:
    -Task           Nombre de la tarea (ej: "refactor-gamification")

PARAMETROS OPCIONALES:
    -Tokens         Tokens consumidos (default: 0)
    -Status         Estado (success|failed|error|in_progress) [default: in_progress]
    -PRNumber       Numero de PR asociado
    -FilesChanged   Cantidad de archivos modificados
    -Agent          Nombre del agente (default: "claude-code")
    -Notes          Notas adicionales

EJEMPLOS:
    # Log de tarea completada
    .\log-agent-operation.ps1 ``
      -Task "fix-overflow" ``
      -Tokens 2048 ``
      -Status "success" ``
      -FilesChanged 2 ``
      -PRNumber "123"

OUTPUT:
    - Registro agregado a: telemetry/agent_operations.json
    - Metricas actualizadas en: telemetry/metrics_summary.json
"@
    exit 0
}

if ($Help) {
    Show-Help
}

# Crear directorio de telemetria si no existe
if (-not (Test-Path $TelemetryDir)) {
    New-Item -ItemType Directory -Path $TelemetryDir -Force | Out-Null
    Write-Host "[*] Directorio de telemetria creado: $TelemetryDir" -ForegroundColor Green
}

# Cargar operaciones existentes
$operations = @()
if (Test-Path $TelemetryFile) {
    try {
        $json = Get-Content $TelemetryFile -Raw
        $loaded = $json | ConvertFrom-Json
        # Convertir a array si es un solo objeto
        if ($loaded -is [array]) {
            $operations = $loaded
        } else {
            $operations = @($loaded)
        }
    } catch {
        Write-Warning "Error leyendo telemetria existente. Creando nuevo archivo."
        $operations = @()
    }
}

# Crear registro de operacion
$operation = [PSCustomObject]@{
    id = [guid]::NewGuid().ToString()
    timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    task = $Task
    agent = $Agent
    status = $Status
    tokens = $Tokens
    files_changed = $FilesChanged
    pr_number = $PRNumber
    notes = $Notes
    duration_ms = 0
}

# Buscar si existe una operacion in_progress para esta tarea
$existingIndex = -1
for ($i = 0; $i -lt $operations.Count; $i++) {
    if ($operations[$i].task -eq $Task -and $operations[$i].status -eq "in_progress") {
        $existingIndex = $i
        break
    }
}

if ($existingIndex -ge 0 -and $Status -ne "in_progress") {
    # Actualizar operacion existente
    $existing = $operations[$existingIndex]
    $startTime = [DateTime]::Parse($existing.timestamp)
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalMilliseconds

    $operations[$existingIndex].status = $Status
    $operations[$existingIndex].tokens = $Tokens
    $operations[$existingIndex].files_changed = $FilesChanged
    $operations[$existingIndex].pr_number = $PRNumber
    $operations[$existingIndex].notes = $Notes
    $operations[$existingIndex].duration_ms = [int]$duration
    $operations[$existingIndex] | Add-Member -NotePropertyName "completed_at" -NotePropertyValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -Force

    Write-Host "[~] Operacion actualizada: $Task" -ForegroundColor Cyan
    Write-Host "   Status: in_progress -> $Status" -ForegroundColor Yellow
    Write-Host "   Duracion: $([int]($duration/1000))s" -ForegroundColor Yellow
    Write-Host "   Tokens: $Tokens" -ForegroundColor Yellow
} else {
    # Agregar nueva operacion
    $operations += $operation

    Write-Host "[+] Operacion registrada: $Task" -ForegroundColor Green
    Write-Host "   Status: $Status" -ForegroundColor Yellow
    Write-Host "   Agent: $Agent" -ForegroundColor Yellow
    if ($Tokens -gt 0) {
        Write-Host "   Tokens: $Tokens" -ForegroundColor Yellow
    }
}

# Guardar operaciones
$json = $operations | ConvertTo-Json -Depth 5
Set-Content -Path $TelemetryFile -Value $json -Encoding UTF8

# Calcular metricas
$totalOps = $operations.Count
$successOps = ($operations | Where-Object { $_.status -eq "success" }).Count
$failedOps = ($operations | Where-Object { $_.status -eq "failed" }).Count
$errorOps = ($operations | Where-Object { $_.status -eq "error" }).Count
$inProgressOps = ($operations | Where-Object { $_.status -eq "in_progress" }).Count

$totalTokens = ($operations | ForEach-Object { $_.tokens } | Measure-Object -Sum).Sum
$avgTokens = if ($totalOps -gt 0) { [int]($totalTokens / $totalOps) } else { 0 }

$successRate = if ($totalOps -gt 0) {
    [math]::Round(($successOps / $totalOps) * 100, 2)
} else {
    0
}

$maxTokens = if ($totalOps -gt 0) { ($operations | ForEach-Object { $_.tokens } | Measure-Object -Maximum).Maximum } else { 0 }
$minTokens = if ($totalOps -gt 0) { ($operations | ForEach-Object { $_.tokens } | Measure-Object -Minimum).Minimum } else { 0 }

$metrics = [PSCustomObject]@{
    last_updated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    total_operations = $totalOps
    operations_by_status = [PSCustomObject]@{
        success = $successOps
        failed = $failedOps
        error = $errorOps
        in_progress = $inProgressOps
    }
    success_rate_percent = $successRate
    tokens = [PSCustomObject]@{
        total = $totalTokens
        average = $avgTokens
        max = $maxTokens
        min = $minTokens
    }
}

# Guardar metricas
$metricsJson = $metrics | ConvertTo-Json -Depth 5
Set-Content -Path $MetricsFile -Value $metricsJson -Encoding UTF8

# Mostrar resumen de metricas
Write-Host "`n[*] METRICAS ACTUALES:" -ForegroundColor Magenta
Write-Host "   Total operaciones: $($metrics.total_operations)" -ForegroundColor White
Write-Host "   Tasa de exito: $($metrics.success_rate_percent)%" -ForegroundColor $(if ($metrics.success_rate_percent -ge 60) { "Green" } else { "Red" })
Write-Host "   Tokens totales: $($metrics.tokens.total)" -ForegroundColor White
Write-Host "   Tokens promedio: $($metrics.tokens.average)" -ForegroundColor White

# Output JSON para parsing automatico
$output = [PSCustomObject]@{
    operation_id = $operation.id
    task = $Task
    status = $Status
    metrics_updated = $true
    telemetry_file = $TelemetryFile
    metrics_file = $MetricsFile
}

Write-Output ($output | ConvertTo-Json -Depth 3)

exit 0
