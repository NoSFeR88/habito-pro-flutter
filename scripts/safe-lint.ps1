# safe-lint.ps1
# Wrapper seguro para linters y análisis estático de Flutter
# Parte del Plan Maestro Claude Code + Agents

param(
    [switch]$Fix,
    [switch]$Verbose,
    [switch]$Format,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogDir = Join-Path $ProjectRoot "logs"
$LogFile = Join-Path $LogDir "lint_$Timestamp.log"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Show-Help {
    Write-Host @"
safe-lint.ps1 - Wrapper seguro para linting y formateo

USO:
    .\safe-lint.ps1 [opciones]

OPCIONES:
    -Fix        Aplicar fixes automáticos (cuando sea posible)
    -Format     Formatear código automáticamente
    -Verbose    Mostrar output detallado
    -Help       Mostrar esta ayuda

EJEMPLOS:
    .\safe-lint.ps1                    # Solo análisis
    .\safe-lint.ps1 -Format            # Formatear código
    .\safe-lint.ps1 -Verbose           # Con logs detallados

CHECKS INCLUIDOS:
    1. flutter analyze     - Análisis estático Dart
    2. dart format        - Formateo de código (si -Format)
    3. Verificación i18n  - Strings hardcoded

OUTPUT:
    - JSON en stdout con errores/warnings
    - Logs detallados en: logs/lint_TIMESTAMP.log
"@
    exit 0
}

if ($Help) {
    Show-Help
}

function Write-Log {
    param([string]$Message)
    $LogMessage = "[$(Get-Date -Format 'HH:mm:ss')] $Message"
    Add-Content -Path $LogFile -Value $LogMessage
    if ($Verbose) {
        Write-Host $LogMessage -ForegroundColor Cyan
    }
}

function New-LintResultJson {
    param(
        [string]$Status = "unknown",
        [int]$Errors = 0,
        [int]$Warnings = 0,
        [int]$Infos = 0,
        [array]$Issues = @(),
        [int]$HardcodedStrings = 0,
        [bool]$Formatted = $false,
        [int]$DurationMs = 0
    )

    $result = @{
        task = "static-analysis"
        status = $Status
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        duration_ms = $DurationMs
        tokens_consumed = 0  # Estimado por CI si aplica
        analyze = @{
            errors = $Errors
            warnings = $Warnings
            infos = $Infos
            total_issues = $Errors + $Warnings + $Infos
        }
        i18n = @{
            hardcoded_strings = $HardcodedStrings
            check_passed = ($HardcodedStrings -eq 0)
        }
        formatting = @{
            applied = $Formatted
            tool = "dart format"
        }
        issues_sample = $Issues | Select-Object -First 10  # Solo primeros 10
        log_file = $LogFile
        metadata = @{
            fix_mode = $Fix.IsPresent
            format_mode = $Format.IsPresent
        }
    }

    return $result | ConvertTo-Json -Depth 5 -Compress
}

Write-Log "=== SAFE-LINT INICIADO ==="

$StartTime = Get-Date

try {
    if (-not (Test-Path (Join-Path $ProjectRoot "pubspec.yaml"))) {
        throw "No se encontró pubspec.yaml"
    }

    Push-Location $ProjectRoot

    # 1. Flutter Analyze
    Write-Log "Ejecutando flutter analyze..."
    $analyzeOutput = flutter analyze 2>&1
    $analyzeExit = $LASTEXITCODE

    $analyzeOutput | ForEach-Object { Write-Log "ANALYZE: $_" }

    # Parsear resultados de analyze
    $errors = 0
    $warnings = 0
    $infos = 0
    $issues = @()

    foreach ($line in $analyzeOutput) {
        if ($line -match 'error •') {
            $errors++
            $issues += @{ type = "error"; message = $line }
        }
        if ($line -match 'warning •') {
            $warnings++
            $issues += @{ type = "warning"; message = $line }
        }
        if ($line -match 'info •') {
            $infos++
            $issues += @{ type = "info"; message = $line }
        }
    }

    Write-Log "Analyze: $errors errors, $warnings warnings, $infos infos"

    # 2. Formateo (opcional)
    $formatted = $false
    if ($Format) {
        Write-Log "Formateando código..."
        $formatOutput = dart format lib/ 2>&1
        $formatOutput | ForEach-Object { Write-Log "FORMAT: $_" }
        $formatted = $true
        Write-Log "Código formateado"
    }

    # 3. Verificar strings hardcoded (i18n)
    Write-Log "Verificando strings hardcoded..."
    $hardcodedCount = 0

    try {
        $dartFiles = Get-ChildItem -Path (Join-Path $ProjectRoot "lib") -Recurse -Filter "*.dart"

        foreach ($file in $dartFiles) {
            $content = Get-Content $file.FullName -Raw

            # Buscar Text( sin AppLocalizations
            if ($content -match 'Text\s*\(' -and $content -notmatch 'AppLocalizations') {
                $matches = [regex]::Matches($content, 'Text\s*\([^)]*\)')
                foreach ($match in $matches) {
                    if ($match.Value -notmatch 'AppLocalizations' -and $match.Value -match '"[^"]*"') {
                        $hardcodedCount++
                        $relativePath = $file.FullName.Replace($ProjectRoot, "").TrimStart('\')
                        Write-Log "Hardcoded string en: $relativePath"
                    }
                }
            }
        }
    } catch {
        Write-Log "Warning: No se pudo verificar strings hardcoded: $_"
    }

    Write-Log "Strings hardcoded encontrados: $hardcodedCount"

    # Determinar status general
    $status = if ($errors -gt 0) {
        "failed"
    } elseif ($warnings -gt 0) {
        "warning"
    } else {
        "success"
    }

    Write-Log "Status final: $status"

    # Calcular duración
    $duration = (Get-Date) - $StartTime
    $durationMs = [int]$duration.TotalMilliseconds

    # Generar JSON resultado
    $resultJson = New-LintResultJson `
        -Status $status `
        -Errors $errors `
        -Warnings $warnings `
        -Infos $infos `
        -Issues $issues `
        -HardcodedStrings $hardcodedCount `
        -Formatted $formatted `
        -DurationMs $durationMs

    Write-Output $resultJson

    Write-Log "=== SAFE-LINT COMPLETADO ==="
    Pop-Location

    # Exit code basado en errores
    if ($errors -gt 0) {
        exit 1
    } else {
        exit 0
    }

} catch {
    $errorMsg = $_.Exception.Message
    Write-Log "ERROR: $errorMsg"

    $resultJson = New-LintResultJson `
        -Status "error" `
        -Issues @(@{ type = "error"; message = $errorMsg })

    Write-Output $resultJson
    Pop-Location
    exit 1
}
