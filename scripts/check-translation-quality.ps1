# check-translation-quality.ps1
# Verificar calidad de traducciones ES

param(
    [switch]$Detailed
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

$enFile = Join-Path $ProjectRoot "lib/l10n/app_en.arb"
$esFile = Join-Path $ProjectRoot "lib/l10n/app_es.arb"

Write-Host "[*] Verificando calidad de traducciones..." -ForegroundColor Cyan

$enContent = Get-Content $enFile -Raw | ConvertFrom-Json
$esContent = Get-Content $esFile -Raw | ConvertFrom-Json

$enKeys = @($enContent.PSObject.Properties | Where-Object { -not $_.Name.StartsWith('@') } | Select-Object -ExpandProperty Name)

# Verificar diferentes tipos de problemas
$emptyTranslations = @()
$sameAsEnglish = @()
$suspiciousShort = @()

foreach ($key in $enKeys) {
    $enValue = $enContent.$key
    $esValue = $esContent.$key

    # Vacíos o null
    if ([string]::IsNullOrWhiteSpace($esValue)) {
        $emptyTranslations += @{ Key = $key; EnValue = $enValue }
        continue
    }

    # Exactamente igual al inglés (posible falta de traducción)
    if ($esValue -eq $enValue) {
        # Excepciones: números, símbolos, o palabras muy cortas que pueden ser iguales
        if ($enValue.Length -gt 5 -and $enValue -notmatch '^\d+$') {
            $sameAsEnglish += @{ Key = $key; Value = $enValue }
        }
    }

    # Traducciones sospechosamente cortas comparadas con el original
    if ($esValue.Length -lt ($enValue.Length * 0.5) -and $enValue.Length -gt 20) {
        $suspiciousShort += @{ Key = $key; EnValue = $enValue; EsValue = $esValue }
    }
}

Write-Host "`n[*] RESULTADOS:" -ForegroundColor Magenta
Write-Host "   Total keys: $($enKeys.Count)" -ForegroundColor White
Write-Host "   Vacías/Null: $($emptyTranslations.Count)" -ForegroundColor $(if ($emptyTranslations.Count -gt 0) { "Red" } else { "Green" })
Write-Host "   Iguales a EN: $($sameAsEnglish.Count)" -ForegroundColor $(if ($sameAsEnglish.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host "   Sospechosas (muy cortas): $($suspiciousShort.Count)" -ForegroundColor $(if ($suspiciousShort.Count -gt 0) { "Yellow" } else { "Green" })

$totalIssues = $emptyTranslations.Count + $sameAsEnglish.Count + $suspiciousShort.Count
$quality = [math]::Round((($enKeys.Count - $totalIssues) / $enKeys.Count) * 100, 2)

Write-Host "   Calidad estimada: $quality%" -ForegroundColor $(if ($quality -ge 95) { "Green" } elseif ($quality -ge 80) { "Yellow" } else { "Red" })

if ($emptyTranslations.Count -gt 0) {
    Write-Host "`n[!] Traducciones vacías:" -ForegroundColor Red
    $emptyTranslations | Select-Object -First 20 | ForEach-Object {
        Write-Host "   - $($_.Key) : (vacío) <- EN: `"$($_.EnValue)`"" -ForegroundColor Gray
    }
}

if ($sameAsEnglish.Count -gt 0) {
    Write-Host "`n[!] Traducciones iguales a inglés (posiblemente sin traducir):" -ForegroundColor Yellow
    $sameAsEnglish | Select-Object -First 20 | ForEach-Object {
        Write-Host "   - $($_.Key) : `"$($_.Value)`"" -ForegroundColor Gray
    }

    if ($sameAsEnglish.Count -gt 20) {
        Write-Host "   ... y $($sameAsEnglish.Count - 20) más" -ForegroundColor DarkGray
    }
}

if ($Detailed -and $suspiciousShort.Count -gt 0) {
    Write-Host "`n[?] Traducciones sospechosamente cortas:" -ForegroundColor Yellow
    $suspiciousShort | Select-Object -First 10 | ForEach-Object {
        Write-Host "   - $($_.Key)" -ForegroundColor Gray
        Write-Host "     EN: `"$($_.EnValue)`"" -ForegroundColor DarkGray
        Write-Host "     ES: `"$($_.EsValue)`"" -ForegroundColor DarkGray
    }
}

# Generar reporte
$report = @{
    total_keys = $enKeys.Count
    empty_translations = $emptyTranslations.Count
    same_as_english = $sameAsEnglish.Count
    suspicious_short = $suspiciousShort.Count
    quality_percent = $quality
    issues = @{
        empty = $emptyTranslations
        same = $sameAsEnglish
        short = $suspiciousShort
    }
}

$reportFile = Join-Path $ProjectRoot "translation_quality_report.json"
$report | ConvertTo-Json -Depth 5 | Set-Content $reportFile -Encoding UTF8

Write-Host "`n[+] Reporte generado: translation_quality_report.json" -ForegroundColor Green

exit 0
