# 📊 LOG SESSION - Claude Code Telemetry
# Registra metadata completa de sesión

param(
    [Parameter(Mandatory=$true)]
    [string]$SessionId,

    [Parameter(Mandatory=$true)]
    [int]$DurationMinutes,

    [int]$TasksCompleted = 0,

    [int]$TotalTokens = 0,

    [int]$TokensBudget = 200000,

    [string]$Outcome = "success",

    [string]$Notes = "",

    [string]$StartTime = "",

    [string]$EndTime = ""
)

# Configuración
$TelemetryDir = Join-Path $PSScriptRoot "..\telemetry"
$SessionsDir = Join-Path $TelemetryDir "sessions"
$TokensDir = Join-Path $TelemetryDir "tokens"
$Date = Get-Date -Format "yyyy-MM-dd"
$SessionFile = Join-Path $SessionsDir "session-$SessionId.json"
$TokensFile = Join-Path $TokensDir "tokens-$Date.json"

# Crear directorios si no existen
if (-not (Test-Path $SessionsDir)) {
    New-Item -ItemType Directory -Path $SessionsDir -Force | Out-Null
}

# Auto-calcular start/end time si no se proporcionan
if (-not $StartTime) {
    $EndTimeObj = Get-Date
    $StartTimeObj = $EndTimeObj.AddMinutes(-$DurationMinutes)
    $StartTime = $StartTimeObj.ToString("HH:mm:ss")
    $EndTime = $EndTimeObj.ToString("HH:mm:ss")
}

# Leer operaciones del archivo de tokens (si existe)
$Operations = @()
if (Test-Path $TokensFile) {
    $TokensData = Get-Content $TokensFile -Raw | ConvertFrom-Json
    $Operations = $TokensData.operations | Where-Object { $_.session_id -eq $SessionId }
}

# Calcular porcentaje usado
$PercentageUsed = [math]::Round(($TotalTokens / $TokensBudget) * 100, 2)

# Crear entrada de sesión
$SessionData = @{
    session_id = $SessionId
    date = $Date
    start_time = $StartTime
    end_time = $EndTime
    duration_minutes = $DurationMinutes
    tasks_completed = $TasksCompleted
    tokens_used = $TotalTokens
    tokens_budget = $TokensBudget
    percentage_used = $PercentageUsed
    operations = $Operations
    outcome = $Outcome
    notes = $Notes
}

# Guardar
$SessionData | ConvertTo-Json -Depth 10 | Set-Content $SessionFile

# Output
Write-Host "✅ Session log registered:" -ForegroundColor Green
Write-Host "   Session ID: $SessionId" -ForegroundColor Cyan
Write-Host "   Date: $Date" -ForegroundColor Gray
Write-Host "   Duration: $DurationMinutes min" -ForegroundColor Yellow
Write-Host "   Tasks: $TasksCompleted completed" -ForegroundColor Magenta
Write-Host "   Tokens: $TotalTokens / $TokensBudget ($PercentageUsed%)" -ForegroundColor $(if ($PercentageUsed -lt 25) { "Green" } elseif ($PercentageUsed -lt 50) { "Yellow" } else { "Red" })
Write-Host "   Outcome: $Outcome" -ForegroundColor $(if ($Outcome -eq "success") { "Green" } else { "Red" })
if ($Operations.Count -gt 0) {
    Write-Host "   Operations tracked: $($Operations.Count)" -ForegroundColor Cyan
}
Write-Host "   File: $SessionFile" -ForegroundColor Gray

# Mostrar resumen si hay operaciones
if ($Operations.Count -gt 0) {
    Write-Host ""
    Write-Host "Top operations by tokens:" -ForegroundColor Cyan
    $Operations | Sort-Object -Property tokens -Descending | Select-Object -First 5 | ForEach-Object {
        $opTokens = $_.tokens
        $opName = $_.operation
        Write-Host "   - $opName : $opTokens tokens" -ForegroundColor Gray
    }
}
