# count-tokens.ps1
# Contador de tokens para archivos (estimación GPT-3 encoding)
# Parte del Plan Maestro Claude Code + Agents

param(
    [Parameter(Mandatory=$false)]
    [string]$Path = "",

    [Parameter(Mandatory=$false)]
    [string]$Pattern = "*.dart",

    [switch]$Recursive,
    [switch]$Summary,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

function Show-Help {
    Write-Host @"
count-tokens.ps1 - Contador de tokens para archivos

USO:
    .\count-tokens.ps1 [opciones]

OPCIONES:
    -Path           Ruta al archivo o directorio (default: proyecto completo)
    -Pattern        Patrón de archivos (default: "*.dart")
    -Recursive      Buscar recursivamente
    -Summary        Mostrar solo resumen
    -Help           Mostrar esta ayuda

EJEMPLOS:
    # Contar tokens de un archivo
    .\count-tokens.ps1 -Path lib\main.dart

    # Contar tokens de todos los archivos Dart
    .\count-tokens.ps1 -Pattern "*.dart" -Recursive

    # Resumen de lib/
    .\count-tokens.ps1 -Path lib -Recursive -Summary

    # Archivos de traducción
    .\count-tokens.ps1 -Path lib\l10n -Pattern "*.arb" -Recursive

NOTA:
    La estimación usa ~4 caracteres por token (aproximación GPT-3).
    Para conteo exacto, usar tiktoken library de Python.

OUTPUT:
    - JSON con conteo por archivo y total
    - Si -Summary: solo totales
"@
    exit 0
}

if ($Help) {
    Show-Help
}

# Función para estimar tokens
function Get-TokenCount {
    param([string]$Content)

    # Estimación: ~4 caracteres por token (GPT-3/Claude aproximado)
    $charCount = $Content.Length
    $estimatedTokens = [math]::Ceiling($charCount / 4.0)

    return $estimatedTokens
}

# Función para procesar archivo
function Get-FileTokens {
    param([System.IO.FileInfo]$File)

    try {
        $content = Get-Content $File.FullName -Raw -ErrorAction Stop
        $tokens = Get-TokenCount -Content $content

        return @{
            path = $File.FullName.Replace($ProjectRoot, "").TrimStart('\')
            size_bytes = $File.Length
            chars = $content.Length
            lines = ($content -split "`n").Count
            estimated_tokens = $tokens
        }
    } catch {
        Write-Warning "Error procesando $($File.Name): $_"
        return $null
    }
}

# Determinar archivos a procesar
$files = @()

if ($Path -and (Test-Path $Path)) {
    $item = Get-Item $Path

    if ($item.PSIsContainer) {
        # Es un directorio
        if ($Recursive) {
            $files = Get-ChildItem -Path $Path -Filter $Pattern -Recurse -File
        } else {
            $files = Get-ChildItem -Path $Path -Filter $Pattern -File
        }
    } else {
        # Es un archivo
        $files = @($item)
    }
} else {
    # Path no especificado o no existe, usar proyecto completo
    if ($Recursive) {
        $files = Get-ChildItem -Path $ProjectRoot -Filter $Pattern -Recurse -File
    } else {
        $files = Get-ChildItem -Path $ProjectRoot -Filter $Pattern -File
    }
}

Write-Host "📊 Contando tokens..." -ForegroundColor Cyan
Write-Host "   Patrón: $Pattern" -ForegroundColor Yellow
Write-Host "   Archivos encontrados: $($files.Count)" -ForegroundColor Yellow

$results = @()
$totalTokens = 0
$totalChars = 0
$totalLines = 0
$totalSize = 0

foreach ($file in $files) {
    $fileResult = Get-FileTokens -File $file

    if ($fileResult) {
        $results += $fileResult
        $totalTokens += $fileResult.estimated_tokens
        $totalChars += $fileResult.chars
        $totalLines += $fileResult.lines
        $totalSize += $fileResult.size_bytes
    }
}

# Crear resultado
$output = @{
    timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    pattern = $Pattern
    files_analyzed = $results.Count
    totals = @{
        estimated_tokens = $totalTokens
        characters = $totalChars
        lines = $totalLines
        size_bytes = $totalSize
        size_kb = [math]::Round($totalSize / 1024, 2)
    }
    files = if (-not $Summary) { $results } else { @() }
    estimation_method = "~4 chars per token (GPT-3 approximation)"
}

# Mostrar resumen
Write-Host "`n✅ Análisis completado:" -ForegroundColor Green
Write-Host "   Archivos: $($results.Count)" -ForegroundColor White
Write-Host "   Tokens estimados: $totalTokens" -ForegroundColor Cyan
Write-Host "   Caracteres: $totalChars" -ForegroundColor White
Write-Host "   Líneas: $totalLines" -ForegroundColor White
Write-Host "   Tamaño: $([math]::Round($totalSize / 1024, 2)) KB" -ForegroundColor White

# Mostrar top 10 archivos más grandes (si no es summary)
if (-not $Summary -and $results.Count -gt 0) {
    Write-Host "`n📈 Top 10 archivos con más tokens:" -ForegroundColor Magenta
    $top10 = $results | Sort-Object estimated_tokens -Descending | Select-Object -First 10

    foreach ($item in $top10) {
        $relativePath = $item.path
        if ($relativePath.Length -gt 50) {
            $relativePath = "..." + $relativePath.Substring($relativePath.Length - 47)
        }
        Write-Host ("   {0,-50} {1,8} tokens" -f $relativePath, $item.estimated_tokens) -ForegroundColor Yellow
    }
}

# Output JSON
Write-Output ($output | ConvertTo-Json -Depth 5)

exit 0
