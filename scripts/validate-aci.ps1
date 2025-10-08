# Validate ACI (Agent-Computer Interface)
# Verifica que tools.json sea valido y muestra herramientas disponibles

Write-Host "Validating ACI (tools.json)..." -ForegroundColor Cyan
Write-Host ""

$toolsFile = Join-Path $PSScriptRoot "..\tools.json"

if (-not (Test-Path $toolsFile)) {
    Write-Host "ERROR: tools.json not found" -ForegroundColor Red
    exit 1
}

try {
    $tools = Get-Content $toolsFile -Raw | ConvertFrom-Json
    Write-Host "Valid JSON structure" -ForegroundColor Green
    Write-Host ""

    # List tools by category
    Write-Host "Available Tools:" -ForegroundColor Cyan
    Write-Host "================" -ForegroundColor Gray
    Write-Host ""

    # Flutter tools
    Write-Host "FLUTTER:" -ForegroundColor Yellow
    $tools.tools.flutter | Get-Member -MemberType NoteProperty | ForEach-Object {
        $toolName = $_.Name
        $command = $tools.tools.flutter.$toolName.command
        Write-Host "  - $toolName : $command" -ForegroundColor White
    }
    Write-Host ""

    # Git tools
    Write-Host "GIT:" -ForegroundColor Yellow
    $tools.tools.git | Get-Member -MemberType NoteProperty | ForEach-Object {
        $toolName = $_.Name
        $command = $tools.tools.git.$toolName.command
        $safe = $tools.tools.git.$toolName.safe
        $safeIcon = if ($safe) { "[SAFE]" } else { "[APPROVAL]" }
        Write-Host "  - $toolName $safeIcon : $command" -ForegroundColor White
    }
    Write-Host ""

    # Scripts
    Write-Host "SCRIPTS:" -ForegroundColor Yellow
    $tools.tools.scripts | Get-Member -MemberType NoteProperty | ForEach-Object {
        $toolName = $_.Name
        $command = $tools.tools.scripts.$toolName.command
        Write-Host "  - $toolName : powershell scripts/$toolName.ps1" -ForegroundColor White
    }
    Write-Host ""

    # GitHub
    Write-Host "GITHUB:" -ForegroundColor Yellow
    $tools.tools.github | Get-Member -MemberType NoteProperty | ForEach-Object {
        $toolName = $_.Name
        $command = $tools.tools.github.$toolName.command
        Write-Host "  - $toolName : $command" -ForegroundColor White
    }
    Write-Host ""

    # Policies
    Write-Host "POLICIES:" -ForegroundColor Cyan
    Write-Host "==========" -ForegroundColor Gray
    Write-Host ""

    Write-Host "Safe Operations (no approval):" -ForegroundColor Green
    $tools.policies.safe_operations | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor White
    }
    Write-Host ""

    Write-Host "Require Approval:" -ForegroundColor Yellow
    $tools.policies.require_approval | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor White
    }
    Write-Host ""

    Write-Host "Forbidden:" -ForegroundColor Red
    $tools.policies.forbidden | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor White
    }
    Write-Host ""

    # Workflows
    Write-Host "WORKFLOWS:" -ForegroundColor Cyan
    Write-Host "==========" -ForegroundColor Gray
    Write-Host ""

    $tools.workflows | Get-Member -MemberType NoteProperty | ForEach-Object {
        $workflowName = $_.Name
        $steps = $tools.workflows.$workflowName.steps
        Write-Host "$workflowName ($($steps.Count) steps):" -ForegroundColor Yellow
        $steps | ForEach-Object {
            $stepNum = $_.step
            $tool = $_.tool
            $action = $_.action
            $required = if ($_.required) { "[REQUIRED]" } else { "[OPTIONAL]" }

            if ($tool) {
                Write-Host "  $stepNum. $tool $required" -ForegroundColor White
            } else {
                Write-Host "  $stepNum. $action $required" -ForegroundColor White
            }
        }
        Write-Host ""
    }

    Write-Host "ACI Validation: SUCCESS" -ForegroundColor Green
    Write-Host ""
    Write-Host "Total tools defined: $($tools.tools.PSObject.Properties.Count) categories" -ForegroundColor Cyan

} catch {
    Write-Host "ERROR: Invalid JSON structure" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
