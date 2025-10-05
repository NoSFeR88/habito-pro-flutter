# find-missing-translations.ps1
# Script para identificar claves faltantes en app_es.arb

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

$enFile = Join-Path $ProjectRoot "lib/l10n/app_en.arb"
$esFile = Join-Path $ProjectRoot "lib/l10n/app_es.arb"

Write-Host "[*] Leyendo archivos ARB..." -ForegroundColor Cyan

$enContent = Get-Content $enFile -Raw | ConvertFrom-Json
$esContent = Get-Content $esFile -Raw | ConvertFrom-Json

# Extraer claves (excluir metadatos que empiezan con @)
$enKeys = @($enContent.PSObject.Properties | Where-Object { -not $_.Name.StartsWith('@') } | Select-Object -ExpandProperty Name)
$esKeys = @($esContent.PSObject.Properties | Where-Object { -not $_.Name.StartsWith('@') } | Select-Object -ExpandProperty Name)

# Encontrar claves faltantes
$missing = $enKeys | Where-Object { $esKeys -notcontains $_ }

Write-Host "`n[*] RESULTADOS:" -ForegroundColor Magenta
Write-Host "   Total EN keys: $($enKeys.Count)" -ForegroundColor White
Write-Host "   Total ES keys: $($esKeys.Count)" -ForegroundColor White
Write-Host "   Missing in ES: $($missing.Count)" -ForegroundColor Yellow
Write-Host "   Cobertura ES: $([math]::Round(($esKeys.Count / $enKeys.Count) * 100, 2))%" -ForegroundColor $(if (($esKeys.Count / $enKeys.Count) -ge 0.8) { "Green" } else { "Yellow" })

if ($missing.Count -gt 0) {
    Write-Host "`n[*] Claves faltantes en ES:" -ForegroundColor Yellow

    if ($Verbose) {
        # Mostrar todas con sus valores EN
        $missing | ForEach-Object {
            $key = $_
            $value = $enContent.$key
            Write-Host "   - $key : `"$value`"" -ForegroundColor Gray
        }
    } else {
        # Mostrar solo las primeras 50
        $missing | Select-Object -First 50 | ForEach-Object {
            Write-Host "   - $_" -ForegroundColor Gray
        }

        if ($missing.Count -gt 50) {
            Write-Host "`n   ... y $($missing.Count - 50) más" -ForegroundColor DarkGray
            Write-Host "   Usa -Verbose para ver todas" -ForegroundColor DarkGray
        }
    }

    # Generar archivo JSON con claves faltantes
    $outputFile = Join-Path $ProjectRoot "missing_es_keys.json"
    $missingWithValues = @{}
    $missing | ForEach-Object {
        $key = $_
        $missingWithValues[$key] = $enContent.$key
    }

    $missingWithValues | ConvertTo-Json -Depth 5 | Set-Content $outputFile -Encoding UTF8
    Write-Host "`n[+] Archivo generado: missing_es_keys.json" -ForegroundColor Green
} else {
    Write-Host "`n[+] ¡Todas las claves están traducidas!" -ForegroundColor Green
}

exit 0
