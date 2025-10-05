# safe-test.ps1
# Wrapper seguro para ejecutar tests de Flutter con output JSON
# Parte del Plan Maestro Claude Code + Agents

param(
    [switch]$Verbose,
    [switch]$Coverage,
    [string]$TestPath = "",
    [switch]$Help
)

# Configuración
$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogDir = Join-Path $ProjectRoot "logs"
$LogFile = Join-Path $LogDir "test_$Timestamp.log"

# Crear directorio de logs si no existe
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# Función de ayuda
function Show-Help {
    Write-Host @"
safe-test.ps1 - Wrapper seguro para tests de Flutter

USO:
    .\safe-test.ps1 [opciones]

OPCIONES:
    -Verbose        Mostrar output detallado
    -Coverage       Generar reporte de coverage
    -TestPath       Ejecutar tests específicos (ej: test/unit/habit_test.dart)
    -Help           Mostrar esta ayuda

EJEMPLOS:
    .\safe-test.ps1                           # Ejecutar todos los tests
    .\safe-test.ps1 -Coverage                 # Con coverage
    .\safe-test.ps1 -TestPath test/unit/      # Solo tests unitarios
    .\safe-test.ps1 -Verbose -Coverage        # Detallado + coverage

OUTPUT:
    - JSON en stdout (para parsing automático)
    - Logs en: logs/test_TIMESTAMP.log
"@
    exit 0
}

if ($Help) {
    Show-Help
}

# Función para escribir log
function Write-Log {
    param([string]$Message)
    $LogMessage = "[$(Get-Date -Format 'HH:mm:ss')] $Message"
    Add-Content -Path $LogFile -Value $LogMessage
    if ($Verbose) {
        Write-Host $LogMessage -ForegroundColor Cyan
    }
}

# Función para crear JSON de resultado (Schema Plan Maestro)
function New-ResultJson {
    param(
        [int]$TotalTests = 0,
        [int]$Passed = 0,
        [int]$Failed = 0,
        [string]$Coverage = "N/A",
        [int]$DurationMs = 0,
        [array]$Failures = @(),
        [string]$Status = "unknown"
    )

    $result = @{
        task = "unit-tests"
        status = $Status
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        duration_ms = $DurationMs
        tokens_consumed = 0  # Estimado por CI si aplica
        tests = @{
            total = $TotalTests
            passed = $Passed
            failed = $Failed
            skipped = 0
        }
        coverage = $Coverage
        failures = $Failures
        log_file = $LogFile
        metadata = @{
            test_path = if ($TestPath) { $TestPath } else { "all" }
            coverage_enabled = $Coverage.IsPresent
            flutter_version = "unknown"  # Se actualiza en ejecución
        }
    }

    return $result | ConvertTo-Json -Depth 5 -Compress
}

# Inicio
Write-Log "=== SAFE-TEST INICIADO ==="
Write-Log "Proyecto: RITMO Habit Tracker"
Write-Log "Test path: $(if ($TestPath) { $TestPath } else { 'Todos los tests' })"
Write-Log "Coverage: $Coverage"

$StartTime = Get-Date

try {
    # Validar que estamos en el directorio correcto
    if (-not (Test-Path (Join-Path $ProjectRoot "pubspec.yaml"))) {
        throw "No se encontró pubspec.yaml. ¿Estás en el directorio correcto?"
    }

    Write-Log "Verificando dependencias..."

    # Cambiar al directorio del proyecto
    Push-Location $ProjectRoot

    # Verificar que flutter está disponible
    $flutterVersionRaw = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    $flutterVersion = $flutterVersionRaw -replace '.*Flutter\s+([\d.]+).*', '$1'
    Write-Log "Flutter detectado: $flutterVersionRaw"

    # Construir comando de test
    $testCommand = "flutter test"

    if ($TestPath) {
        $testCommand += " $TestPath"
    }

    if ($Coverage) {
        $testCommand += " --coverage"
    }

    Write-Log "Ejecutando: $testCommand"

    # Ejecutar tests y capturar output
    $testOutput = Invoke-Expression $testCommand 2>&1
    $exitCode = $LASTEXITCODE

    # Guardar output en log
    $testOutput | ForEach-Object { Write-Log $_ }

    # Parsear resultados
    $totalTests = 0
    $passed = 0
    $failed = 0
    $failures = @()

    foreach ($line in $testOutput) {
        # Detectar línea de resumen: "All tests passed!" o "Some tests failed"
        if ($line -match '(\d+) tests? passed') {
            $passed = [int]$matches[1]
            $totalTests = $passed
        }

        if ($line -match '(\d+) tests? failed') {
            $failed = [int]$matches[1]
            $totalTests += $failed
        }

        # Capturar fallos
        if ($line -match 'FAILED:(.+)') {
            $failures += $matches[1].Trim()
        }
    }

    # Calcular coverage si se solicitó
    $coveragePercent = "N/A"
    if ($Coverage -and (Test-Path (Join-Path $ProjectRoot "coverage\lcov.info"))) {
        Write-Log "Procesando coverage..."
        # Aquí se podría parsear el lcov.info para obtener porcentaje exacto
        # Por ahora, indicamos que existe
        $coveragePercent = "Ver coverage/lcov.info"
    }

    # Calcular duración
    $duration = (Get-Date) - $StartTime
    $durationMs = [int]$duration.TotalMilliseconds

    Write-Log "Tests completados en $durationMs ms"
    Write-Log "Total: $totalTests | Passed: $passed | Failed: $failed"

    # Determinar status
    $status = if ($exitCode -eq 0) { "success" } else { "failed" }

    # Generar JSON resultado (actualizar metadata)
    $resultJson = New-ResultJson `
        -TotalTests $totalTests `
        -Passed $passed `
        -Failed $failed `
        -Coverage $coveragePercent `
        -DurationMs $durationMs `
        -Failures $failures `
        -Status $status

    # Actualizar flutter_version en metadata
    $resultObj = $resultJson | ConvertFrom-Json
    $resultObj.metadata.flutter_version = $flutterVersion
    $resultJson = $resultObj | ConvertTo-Json -Depth 5 -Compress

    # Output JSON a stdout
    Write-Output $resultJson

    Write-Log "=== SAFE-TEST COMPLETADO ==="

    # Restaurar ubicación
    Pop-Location

    # Exit con código correcto
    exit $exitCode

} catch {
    $errorMsg = $_.Exception.Message
    Write-Log "ERROR: $errorMsg"

    $resultJson = New-ResultJson -Status "error" -Failures @($errorMsg)
    Write-Output $resultJson

    Pop-Location
    exit 1
}
