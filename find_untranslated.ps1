$en = Get-Content 'lib\l10n\app_en.arb' -Raw | ConvertFrom-Json
$es = Get-Content 'lib\l10n\app_es.arb' -Raw | ConvertFrom-Json

$untranslated = @()

$en.PSObject.Properties | Where-Object { $_.Name -notlike '@@*' -and $_.Name -notlike '@*' } | ForEach-Object {
    $key = $_.Name
    $enVal = $_.Value
    $esVal = $es.$key

    if ($enVal -eq $esVal -and $enVal -match '[a-zA-Z]' -and $enVal -notmatch '^\s*$') {
        $untranslated += [PSCustomObject]@{
            Key = $key
            EN = $enVal
        }
    }
}

Write-Host "=== UNTRANSLATED STRINGS: $($untranslated.Count) ===" -ForegroundColor Yellow
Write-Host ""

$untranslated | ForEach-Object {
    Write-Host "$($_.Key)" -ForegroundColor Cyan
    Write-Host "  EN: $($_.EN)" -ForegroundColor Gray
    Write-Host ""
}
