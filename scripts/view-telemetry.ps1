# Telemetry Dashboard - Session Viewer
# Part of Plan Maestro Phase 3: Scale

param(
    [switch]$Summary,      # Show summary only
    [switch]$Detailed,     # Show detailed per-session info
    [switch]$Export,       # Export to markdown
    [string]$ExportPath = "telemetry/reports/dashboard-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
)

# Configuration
$SessionsPath = "telemetry/sessions"
$MinEfficiency = 5.0  # tasks per 10k tokens
$MaxTokensPerSession = 100000  # Alert threshold

# Colors
$ColorGood = "Green"
$ColorWarning = "Yellow"
$ColorBad = "Red"
$ColorInfo = "Cyan"

function Read-Sessions {
    $sessions = Get-ChildItem -Path $SessionsPath -Filter "session-*.json" |
                Sort-Object Name |
                ForEach-Object {
                    $content = Get-Content $_.FullName | ConvertFrom-Json
                    $content | Add-Member -NotePropertyName "file" -NotePropertyValue $_.Name -PassThru
                }
    return $sessions
}

function Calculate-Metrics {
    param($sessions)

    $total = @{
        sessions = $sessions.Count
        tokens = ($sessions | Measure-Object -Property tokens_used -Sum).Sum
        duration = ($sessions | Measure-Object -Property duration_minutes -Sum).Sum
        tasks = ($sessions | Measure-Object -Property tasks_completed -Sum).Sum
    }

    $total.avg_tokens = [math]::Round($total.tokens / $total.sessions, 0)
    $total.avg_duration = [math]::Round($total.duration / $total.sessions, 0)
    $total.avg_tasks = [math]::Round($total.tasks / $total.sessions, 1)
    $total.efficiency = [math]::Round(($total.tasks / ($total.tokens / 10000)), 1)

    return $total
}

function Show-Header {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $ColorInfo
    Write-Host "  📊 TELEMETRY DASHBOARD - Claude Code Sessions" -ForegroundColor $ColorInfo
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $ColorInfo
    Write-Host ""
}

function Show-Summary {
    param($sessions, $metrics)

    Write-Host "📈 SUMMARY" -ForegroundColor White
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "Total Sessions:       $($metrics.sessions)" -ForegroundColor White
    Write-Host "Total Tokens Used:    $($metrics.tokens.ToString('N0'))" -ForegroundColor White
    $hoursCalc = [math]::Round($metrics.duration / 60, 1)
    Write-Host "Total Duration:       $($metrics.duration) min / $hoursCalc h" -ForegroundColor White
    Write-Host "Total Tasks:          $($metrics.tasks)" -ForegroundColor White
    Write-Host ""

    Write-Host "📊 AVERAGES" -ForegroundColor White
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "Avg Tokens/Session:   $($metrics.avg_tokens.ToString('N0'))" -ForegroundColor White
    Write-Host "Avg Duration/Session: $($metrics.avg_duration) minutes" -ForegroundColor White
    Write-Host "Avg Tasks/Session:    $($metrics.avg_tasks)" -ForegroundColor White
    Write-Host ""

    $effColor = if ($metrics.efficiency -ge $MinEfficiency) { $ColorGood } else { $ColorWarning }
    Write-Host "⚡ EFFICIENCY" -ForegroundColor White
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "Tasks per 10k tokens: " -NoNewline -ForegroundColor White
    Write-Host "$($metrics.efficiency)" -ForegroundColor $effColor
    Write-Host "Target:               $MinEfficiency+ ($(if ($metrics.efficiency -ge $MinEfficiency) { '✅ GOOD' } else { '⚠️ NEEDS IMPROVEMENT' }))" -ForegroundColor $effColor
    Write-Host ""
}

function Show-SessionDetails {
    param($sessions)

    Write-Host "📋 SESSION DETAILS" -ForegroundColor White
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""

    $sessions | ForEach-Object {
        $efficiency = [math]::Round(($_.tasks_completed / ($_.tokens_used / 10000)), 1)
        $effColor = if ($efficiency -ge $MinEfficiency) { $ColorGood } else { $ColorWarning }

        Write-Host "Session $($_.session_id)" -ForegroundColor White -NoNewline
        Write-Host " ($($_.date))" -ForegroundColor DarkGray
        Write-Host "  Duration: $($_.duration_minutes) min | Tokens: $($_.tokens_used.ToString('N0')) | Tasks: $($_.tasks_completed)" -ForegroundColor Gray
        Write-Host "  Efficiency: " -NoNewline -ForegroundColor Gray
        Write-Host "$efficiency tasks/10k" -ForegroundColor $effColor
        if ($_.notes) {
            Write-Host "  Notes: $($_.notes)" -ForegroundColor DarkGray
        }

        # Alerts
        if ($_.tokens_used -gt $MaxTokensPerSession) {
            Write-Host "  ⚠️ HIGH TOKEN USAGE" -ForegroundColor $ColorWarning
        }
        if ($efficiency -lt $MinEfficiency) {
            Write-Host "  ⚠️ LOW EFFICIENCY" -ForegroundColor $ColorWarning
        }

        Write-Host ""
    }
}

function Export-Report {
    param($sessions, $metrics, $path)

    $report = @"
# 📊 Telemetry Dashboard Report

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

---

## 📈 Summary

| Metric | Value |
|--------|-------|
| **Total Sessions** | $($metrics.sessions) |
| **Total Tokens Used** | $($metrics.tokens.ToString('N0')) |
| **Total Duration** | $($metrics.duration) min ($([math]::Round($metrics.duration / 60, 1)) hours) |
| **Total Tasks** | $($metrics.tasks) |

## 📊 Averages

| Metric | Value |
|--------|-------|
| **Tokens/Session** | $($metrics.avg_tokens.ToString('N0')) |
| **Duration/Session** | $($metrics.avg_duration) min |
| **Tasks/Session** | $($metrics.avg_tasks) |

## ⚡ Efficiency

| Metric | Value | Status |
|--------|-------|--------|
| **Tasks per 10k tokens** | $($metrics.efficiency) | $(if ($metrics.efficiency -ge $MinEfficiency) { '✅ GOOD' } else { '⚠️ NEEDS IMPROVEMENT' }) |
| **Target** | $MinEfficiency+ | - |

---

## 📋 Session Details

| Session | Date | Duration | Tokens | Tasks | Efficiency |
|---------|------|----------|--------|-------|------------|
"@

    $sessions | ForEach-Object {
        $efficiency = [math]::Round(($_.tasks_completed / ($_.tokens_used / 10000)), 1)
        $report += "| $($_.session_id) | $($_.date) | $($_.duration_minutes) min | $($_.tokens_used.ToString('N0')) | $($_.tasks_completed) | $efficiency |`n"
    }

    $report += @"

---

**Notes**:
- Efficiency Target: $MinEfficiency+ tasks per 10k tokens
- Token Alert Threshold: $MaxTokensPerSession tokens per session
- Sessions with low efficiency or high token usage should be reviewed for optimization opportunities

---

*Generated by: view-telemetry.ps1*
*Part of: Plan Maestro Phase 3 - Scale*
"@

    # Ensure directory exists
    $dir = Split-Path $path
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $report | Out-File -FilePath $path -Encoding UTF8
    Write-Host "✅ Report exported to: $path" -ForegroundColor $ColorGood
}

# Main execution
try {
    Show-Header

    $sessions = Read-Sessions

    if ($sessions.Count -eq 0) {
        Write-Host "⚠️ No session data found in $SessionsPath" -ForegroundColor $ColorWarning
        exit 1
    }

    $metrics = Calculate-Metrics -sessions $sessions

    Show-Summary -sessions $sessions -metrics $metrics

    if ($Detailed) {
        Show-SessionDetails -sessions $sessions
    }

    if ($Export) {
        Export-Report -sessions $sessions -metrics $metrics -path $ExportPath
    }

    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $ColorInfo
    Write-Host ""
    Write-Host "💡 TIP: Use -Detailed for per-session breakdown" -ForegroundColor DarkGray
    Write-Host "💡 TIP: Use -Export to generate markdown report" -ForegroundColor DarkGray
    Write-Host ""

} catch {
    Write-Host "❌ Error: $_" -ForegroundColor $ColorBad
    exit 1
}
