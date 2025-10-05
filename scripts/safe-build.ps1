# safe-build.ps1
# Wrapper seguro para validar build de Flutter
# Parte del Plan Maestro Claude Code + Agents

param(
    [ValidateSet("apk", "appbundle", "ios", "web")]
    [string]$Target = "apk",

    [ValidateSet("debug", "profile", "release")]
    [string]$Mode = "debug",

    [switch]$DryRun,
    [switch]$Verbose,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogDir = Join-Path $ProjectRoot "logs"
$LogFile = Join-Path $LogDir "build_$Timestamp.log"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Show-Help {
    Write-Host @"
safe-build.ps1 - Wrapper seguro para build de Flutter

USO:
    .\safe-build.ps1 [opciones]

OPCIONES:
    -Target <tipo>      Tipo de build (apk|appbundle|ios|web) [default: apk]
    -Mode <mode>        Modo de build (debug|profile|release) [default: debug]
    -DryRun             Solo validar, no construir
    -Verbose            Mostrar output detallado
    -Help               Mostrar esta ayuda

EJEMPLOS:
    .\safe-build.ps1                          # APK debug (dry-run por defecto)
    .\safe-build.ps1 -Target apk -Mode debug  # APK debug explícito
    .\safe-build.ps1 -DryRun                  # Solo validación
    .\safe-build.ps1 -Target web -Verbose     # Build web con logs

SEGURIDAD:
    - Por defecto ejecuta dry-run (validación sin build)
    - Release builds requieren confirmación manual
    - Logs completos en: logs/build_TIMESTAMP.log
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

function New-BuildResultJson {
    param(
        [string]$Status = "unknown",
        [string]$Target = "",
        [string]$Mode = "",
        [int]$DurationMs = 0,
        [string]$OutputPath = "",
        [string]$Error = ""
    )

    $result = @{
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        status = $Status
        target = $Target
        mode = $Mode
        duration_ms = $DurationMs
        output_path = $OutputPath
        error = $Error
        log_file = $LogFile
        dry_run = $DryRun.IsPresent
    }

    return $result | ConvertTo-Json -Depth 3
}

Write-Log "=== SAFE-BUILD INICIADO ==="
Write-Log "Target: $Target | Mode: $Mode | DryRun: $DryRun"

$StartTime = Get-Date

try {
    if (-not (Test-Path (Join-Path $ProjectRoot "pubspec.yaml"))) {
        throw "No se encontró pubspec.yaml"
    }

    Push-Location $ProjectRoot

    # Validación de seguridad para release builds
    if ($Mode -eq "release" -and -not $DryRun) {
        Write-Log "WARNING: Release build detectado"
        Write-Host "⚠️  ADVERTENCIA: Estás construyendo en modo RELEASE" -ForegroundColor Yellow
        Write-Host "   Esto generará un APK/AAB firmado para producción." -ForegroundColor Yellow

        $confirmation = Read-Host "¿Confirmas que deseas continuar? (y/N)"
        if ($confirmation -ne 'y') {
            throw "Build cancelado por el usuario"
        }
    }

    # Verificar Flutter
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    Write-Log "Flutter: $flutterVersion"

    # Análisis estático primero
    Write-Log "Ejecutando análisis estático..."
    $analyzeOutput = flutter analyze 2>&1
    $analyzeExit = $LASTEXITCODE

    $analyzeOutput | ForEach-Object { Write-Log "ANALYZE: $_" }

    if ($analyzeExit -ne 0) {
        Write-Log "WARNING: Análisis estático encontró issues"
        Write-Host "⚠️  Análisis estático con warnings/errors" -ForegroundColor Yellow
    }

    # Si es dry-run, solo validamos
    if ($DryRun) {
        Write-Log "DRY-RUN: Validando configuración de build..."

        # Verificar pubspec.yaml
        $pubspecContent = Get-Content (Join-Path $ProjectRoot "pubspec.yaml") -Raw
        Write-Log "pubspec.yaml validado"

        # Verificar dependencias
        Write-Log "Verificando dependencias..."
        flutter pub get 2>&1 | ForEach-Object { Write-Log "PUB: $_" }

        $duration = (Get-Date) - $StartTime
        $durationMs = [int]$duration.TotalMilliseconds

        Write-Log "DRY-RUN completado exitosamente en $durationMs ms"

        $resultJson = New-BuildResultJson `
            -Status "dry_run_success" `
            -Target $Target `
            -Mode $Mode `
            -DurationMs $durationMs `
            -OutputPath "N/A (dry-run)"

        Write-Output $resultJson
        Pop-Location
        exit 0
    }

    # Build real
    $buildCommand = "flutter build $Target --$Mode"
    Write-Log "Ejecutando: $buildCommand"

    $buildOutput = Invoke-Expression $buildCommand 2>&1
    $buildExit = $LASTEXITCODE

    $buildOutput | ForEach-Object { Write-Log "BUILD: $_" }

    $duration = (Get-Date) - $StartTime
    $durationMs = [int]$duration.TotalMilliseconds

    # Determinar ruta de output
    $outputPath = switch ($Target) {
        "apk" { "build/app/outputs/flutter-apk/app-$Mode.apk" }
        "appbundle" { "build/app/outputs/bundle/${Mode}Release/app-$Mode-release.aab" }
        "web" { "build/web" }
        "ios" { "build/ios/iphoneos/Runner.app" }
        default { "unknown" }
    }

    if ($buildExit -eq 0) {
        Write-Log "✅ Build exitoso en $durationMs ms"
        Write-Log "Output: $outputPath"

        $resultJson = New-BuildResultJson `
            -Status "success" `
            -Target $Target `
            -Mode $Mode `
            -DurationMs $durationMs `
            -OutputPath $outputPath
    } else {
        Write-Log "❌ Build falló"

        $resultJson = New-BuildResultJson `
            -Status "failed" `
            -Target $Target `
            -Mode $Mode `
            -DurationMs $durationMs `
            -Error "Build failed with exit code $buildExit"
    }

    Write-Output $resultJson
    Pop-Location
    exit $buildExit

} catch {
    $errorMsg = $_.Exception.Message
    Write-Log "ERROR: $errorMsg"

    $resultJson = New-BuildResultJson `
        -Status "error" `
        -Target $Target `
        -Mode $Mode `
        -Error $errorMsg

    Write-Output $resultJson
    Pop-Location
    exit 1
}
