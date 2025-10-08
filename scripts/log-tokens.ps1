# 📊 LOG TOKENS - Claude Code Telemetry
# Registra consumo de tokens por operación

param(
    [Parameter(Mandatory=$true)]
    [string]$Operation,

    [Parameter(Mandatory=$true)]
    [int]$TokensUsed,

    [string]$SessionId = "",

    [string]$Notes = ""
)

# Configuración
$TelemetryDir = Join-Path $PSScriptRoot "..\telemetry"
$TokensDir = Join-Path $TelemetryDir "tokens"
$Date = Get-Date -Format "yyyy-MM-dd"
$Time = Get-Date -Format "HH:mm:ss"
$LogFile = Join-Path $TokensDir "tokens-$Date.json"

# Crear directorio si no existe
if (-not (Test-Path $TokensDir)) {
    New-Item -ItemType Directory -Path $TokensDir -Force | Out-Null
}

# Crear entrada de operación
$OperationEntry = @{
    time = $Time
    operation = $Operation
    tokens = $TokensUsed
    session_id = $SessionId
    notes = $Notes
}

# Leer archivo existente o crear nuevo
if (Test-Path $LogFile) {
    $LogData = Get-Content $LogFile -Raw | ConvertFrom-Json
    $LogData.operations += $OperationEntry
    $LogData.total_tokens += $TokensUsed
} else {
    $LogData = @{
        date = $Date
        total_tokens = $TokensUsed
        operations = @($OperationEntry)
    }
}

# Guardar
$LogData | ConvertTo-Json -Depth 10 | Set-Content $LogFile

# Output
Write-Host "✅ Token log registered:" -ForegroundColor Green
Write-Host "   Operation: $Operation" -ForegroundColor Cyan
Write-Host "   Tokens: $TokensUsed" -ForegroundColor Yellow
Write-Host "   Total today: $($LogData.total_tokens)" -ForegroundColor Magenta
Write-Host "   File: $LogFile" -ForegroundColor Gray
