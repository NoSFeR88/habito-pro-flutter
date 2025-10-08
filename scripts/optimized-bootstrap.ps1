# Optimized Bootstrap Script
# Part of Plan Maestro Phase 4: Optimize
#
# Loads essential context efficiently with minimal token usage
# Use this instead of manual file reads for common startup

param(
    [switch]$Verbose
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " OPTIMIZED CONTEXT BOOTSTRAP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date

# Essential files (ordered by priority)
$essentialFiles = @(
    @{
        Path = "CLAUDE.md"
        Description = "Project instructions"
        Critical = $true
    },
    @{
        Path = "docs/CONTEXT_LAST_SESSION.md"
        Description = "Last session state"
        Critical = $true
    },
    @{
        Path = "docs/PROJECT_INDEX.md"
        Description = "Quick reference index"
        Critical = $true
    },
    @{
        Path = "docs/PROJECT_STATUS.md"
        Description = "Current status"
        Critical = $false
    }
)

# Optional files (load only if needed)
$optionalFiles = @(
    @{
        Path = "docs/BILINGUAL_GUIDE.md"
        Description = "i18n protocol"
        LoadIf = "i18n"
    },
    @{
        Path = "docs/TESTING_STRATEGY.md"
        Description = "Testing guidelines"
        LoadIf = "testing"
    },
    @{
        Path = "docs/TELEMETRY_GUIDE.md"
        Description = "Telemetry usage"
        LoadIf = "telemetry"
    }
)

Write-Host "Loading essential context..." -ForegroundColor Yellow
Write-Host ""

$loadedFiles = 0
$totalSize = 0

foreach ($file in $essentialFiles) {
    $fullPath = Join-Path (Get-Location) $file.Path

    if (Test-Path $fullPath) {
        $fileInfo = Get-Item $fullPath
        $sizeKB = [math]::Round($fileInfo.Length / 1KB, 1)
        $totalSize += $sizeKB

        Write-Host " [OK] $($file.Description)" -ForegroundColor Green -NoNewline
        Write-Host " ($($file.Path) - $sizeKB KB)"

        $loadedFiles++
    } else {
        if ($file.Critical) {
            Write-Host " [!] MISSING: $($file.Path)" -ForegroundColor Red
        } else {
            Write-Host " [~] SKIPPED: $($file.Path)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""

# Calculate estimated token usage
# Rough estimate: 1 token ~ 4 characters, 1KB ~ 250 tokens
$estimatedTokens = [math]::Round($totalSize * 250)

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BOOTSTRAP COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files loaded:      $loadedFiles / $($essentialFiles.Count)" -ForegroundColor White
Write-Host "Total size:        $totalSize KB" -ForegroundColor White
Write-Host "Estimated tokens:  ~$estimatedTokens tokens" -ForegroundColor White
Write-Host "Time elapsed:      $([math]::Round($duration, 2)) seconds" -ForegroundColor White
Write-Host ""

if ($Verbose) {
    Write-Host "OPTIONAL FILES (use specific commands to load):" -ForegroundColor Yellow
    Write-Host ""
    foreach ($file in $optionalFiles) {
        Write-Host "  - $($file.Path)" -ForegroundColor Gray
        Write-Host "    Load when: $($file.LoadIf)" -ForegroundColor Gray
        Write-Host ""
    }
}

Write-Host "[TIP] Context loaded efficiently. Ready to work!" -ForegroundColor Green
Write-Host "[TIP] Use PROJECT_INDEX.md for quick file lookups" -ForegroundColor Green
Write-Host ""

# Return summary for telemetry
$summary = @{
    FilesLoaded = $loadedFiles
    TotalSize = $totalSize
    EstimatedTokens = $estimatedTokens
    DurationSeconds = [math]::Round($duration, 2)
}

return $summary
