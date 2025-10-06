# Script para corregir warnings automáticamente
# Fecha: 2025-10-06

Write-Host "🔧 Corrigiendo warnings automáticamente..." -ForegroundColor Cyan

# Fix 1: Eliminar import '../widgets/habit_card.dart' de all_habits_screen.dart
$file = "lib\screens\all_habits_screen.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import '../widgets/habit_card.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 2: Eliminar import 'home_screen.dart' de onboarding_screen.dart
$file = "lib\screens\onboarding_screen.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import 'home_screen.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 3: Eliminar imports de paywall_screen.dart
$file = "lib\screens\paywall_screen.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import 'package:provider/provider.dart';\r?\n", ""
    $content = $content -replace "import '../providers/premium_provider.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused imports)" -ForegroundColor Green
}

# Fix 4: Eliminar import '../core/theme.dart' de settings_screen.dart
$file = "lib\screens\settings_screen.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import '../core/theme.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 5: Eliminar import 'dart:io' de ads_service.dart
$file = "lib\services\ads_service.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import 'dart:io';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 6: Eliminar import 'package:flutter/services.dart' de notification_service.dart
$file = "lib\services\notification_service.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import 'package:flutter/services.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 7: Eliminar import '../services/notification_service.dart' de home_screen.dart
$file = "lib\screens\home_screen.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import '../services/notification_service.dart';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

# Fix 8: Eliminar import 'dart:math' de stats_overview.dart
$file = "lib\widgets\stats_overview.dart"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $content = $content -replace "import 'dart:math';\r?\n", ""
    Set-Content $file -Value $content -NoNewline
    Write-Host "✅ Fixed: $file (removed unused import)" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Warnings corregidos. Ejecuta 'flutter analyze' para verificar." -ForegroundColor Green
