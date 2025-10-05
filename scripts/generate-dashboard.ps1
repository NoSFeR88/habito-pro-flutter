# generate-dashboard.ps1
# Genera dashboard de métricas en formato HTML
# Parte del Plan Maestro Claude Code + Agents

param(
    [switch]$Open,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TelemetryDir = Join-Path $ProjectRoot "telemetry"
$MetricsFile = Join-Path $TelemetryDir "metrics_summary.json"
$OperationsFile = Join-Path $TelemetryDir "agent_operations.json"
$DashboardFile = Join-Path $TelemetryDir "dashboard.html"

function Show-Help {
    Write-Host @"
generate-dashboard.ps1 - Genera dashboard de métricas

USO:
    .\generate-dashboard.ps1 [opciones]

OPCIONES:
    -Open       Abrir dashboard en navegador después de generar
    -Help       Mostrar esta ayuda

EJEMPLOS:
    .\generate-dashboard.ps1           # Generar dashboard
    .\generate-dashboard.ps1 -Open     # Generar y abrir

OUTPUT:
    - Dashboard HTML en: telemetry/dashboard.html
"@
    exit 0
}

if ($Help) {
    Show-Help
}

# Verificar que existan archivos de telemetría
if (-not (Test-Path $MetricsFile)) {
    Write-Host "❌ No se encontró archivo de métricas: $MetricsFile" -ForegroundColor Red
    Write-Host "   Ejecuta primero: .\log-agent-operation.ps1" -ForegroundColor Yellow
    exit 1
}

# Cargar métricas
Write-Host "📊 Generando dashboard..." -ForegroundColor Cyan

$metrics = Get-Content $MetricsFile -Raw | ConvertFrom-Json
$operations = if (Test-Path $OperationsFile) {
    @(Get-Content $OperationsFile -Raw | ConvertFrom-Json)
} else {
    @()
}

# Generar HTML
$html = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - RITMO Agent Metrics</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .header h1 {
            color: #667eea;
            margin-bottom: 10px;
        }
        .header p {
            color: #666;
        }
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .metric-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .metric-card h3 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
        }
        .metric-value {
            font-size: 36px;
            font-weight: bold;
            color: #333;
        }
        .metric-label {
            color: #999;
            font-size: 12px;
            margin-top: 5px;
        }
        .success { color: #10b981; }
        .warning { color: #f59e0b; }
        .error { color: #ef4444; }
        .table-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #667eea;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: #f9fafb;
        }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-error { background: #fee2e2; color: #991b1b; }
        .badge-warning { background: #fef3c7; color: #92400e; }
        .badge-info { background: #dbeafe; color: #1e40af; }
        .footer {
            text-align: center;
            color: white;
            margin-top: 30px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 RITMO - Agent Metrics Dashboard</h1>
            <p>Última actualización: $($metrics.last_updated)</p>
        </div>

        <div class="metrics-grid">
            <div class="metric-card">
                <h3>Total Operaciones</h3>
                <div class="metric-value">$($metrics.total_operations)</div>
                <div class="metric-label">Desde el inicio</div>
            </div>

            <div class="metric-card">
                <h3>Tasa de Éxito</h3>
                <div class="metric-value success">$($metrics.success_rate_percent)%</div>
                <div class="metric-label">Meta: 60%+</div>
            </div>

            <div class="metric-card">
                <h3>Tokens Totales</h3>
                <div class="metric-value">$($metrics.tokens.total)</div>
                <div class="metric-label">Promedio: $($metrics.tokens.average)</div>
            </div>

            <div class="metric-card">
                <h3>Operaciones Exitosas</h3>
                <div class="metric-value success">$($metrics.operations_by_status.success)</div>
                <div class="metric-label">Completadas sin errores</div>
            </div>

            <div class="metric-card">
                <h3>Operaciones Fallidas</h3>
                <div class="metric-value error">$($metrics.operations_by_status.failed)</div>
                <div class="metric-label">Requieren revisión</div>
            </div>

            <div class="metric-card">
                <h3>En Progreso</h3>
                <div class="metric-value warning">$($metrics.operations_by_status.in_progress)</div>
                <div class="metric-label">Actualmente ejecutando</div>
            </div>
        </div>

        <div class="table-container">
            <h2 style="margin-bottom: 20px; color: #667eea;">📋 Últimas Operaciones</h2>
            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Tarea</th>
                        <th>Agente</th>
                        <th>Status</th>
                        <th>Tokens</th>
                        <th>Archivos</th>
                        <th>PR</th>
                    </tr>
                </thead>
                <tbody>
"@

# Agregar últimas 20 operaciones
$lastOps = $operations | Sort-Object timestamp -Descending | Select-Object -First 20

foreach ($op in $lastOps) {
    $statusBadge = switch ($op.status) {
        "success" { "badge-success" }
        "failed" { "badge-error" }
        "error" { "badge-error" }
        "in_progress" { "badge-info" }
        default { "badge-warning" }
    }

    $timestamp = ([DateTime]$op.timestamp).ToString("yyyy-MM-dd HH:mm")
    $prLink = if ($op.pr_number) { "#$($op.pr_number)" } else { "-" }

    $html += @"
                    <tr>
                        <td>$timestamp</td>
                        <td>$($op.task)</td>
                        <td>$($op.agent)</td>
                        <td><span class="badge $statusBadge">$($op.status)</span></td>
                        <td>$($op.tokens)</td>
                        <td>$($op.files_changed)</td>
                        <td>$prLink</td>
                    </tr>
"@
}

$html += @"
                </tbody>
            </table>
        </div>

        <div class="footer">
            <p>📊 Dashboard generado automáticamente | Plan Maestro Claude Code + Agents</p>
            <p>RITMO - Habit Tracker App</p>
        </div>
    </div>
</body>
</html>
"@

# Guardar dashboard
Set-Content -Path $DashboardFile -Value $html -Encoding UTF8

Write-Host "✅ Dashboard generado exitosamente" -ForegroundColor Green
Write-Host "   Ubicación: $DashboardFile" -ForegroundColor Yellow

# Abrir en navegador si se solicita
if ($Open) {
    Write-Host "🌐 Abriendo dashboard en navegador..." -ForegroundColor Cyan
    Start-Process $DashboardFile
}

# Output JSON
$output = @{
    dashboard_file = $DashboardFile
    metrics = $metrics
    operations_count = $operations.Count
}

Write-Output ($output | ConvertTo-Json -Depth 3)

exit 0
