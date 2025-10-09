/// Script para generar traducciones estáticas de notificaciones desde archivos ARB
/// Uso: dart scripts/generate_notification_translations.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔄 Generando traducciones estáticas para notificaciones...\n');

  // Keys que necesitamos para notificaciones
  final requiredKeys = [
    'habitReminders',
    'notificationsToRemindHabits',
    'habitReminderTicker',
    'defaultHabitReminder',
    'testNotificationTitle',
    'testNotificationBody',
    'scheduledNotificationTitle',
    'scheduledNotificationBody',
  ];

  // Directorio de archivos ARB
  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir.listSync().where((f) => f.path.endsWith('.arb')).toList();

  final Map<String, Map<String, String>> translations = {};

  for (final file in arbFiles) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final match = RegExp(r'app_(\w+)\.arb').firstMatch(fileName);

    if (match == null) continue;

    final locale = match.group(1)!;
    final content = await File(file.path).readAsString();
    final Map<String, dynamic> arb = json.decode(content);

    translations[locale] = {};

    for (final key in requiredKeys) {
      if (arb.containsKey(key)) {
        translations[locale]![key] = arb[key] as String;
      }
    }

    print('✅ Procesado: $locale (${translations[locale]!.length} strings)');
  }

  // Generar código Dart
  final output = StringBuffer();
  output.writeln('  // AUTO-GENERATED: Run `dart scripts/generate_notification_translations.dart` to update');
  output.writeln('  // Traducciones estáticas para notificaciones en background (sin BuildContext)');
  output.writeln('  static const Map<String, Map<String, String>> _staticTranslations = {');

  for (final entry in translations.entries) {
    output.writeln("    '${entry.key}': {");
    for (final translation in entry.value.entries) {
      final escapedValue = translation.value.replaceAll("'", "\\'").replaceAll('\n', '\\n');
      output.writeln("      '${translation.key}': '$escapedValue',");
    }
    output.writeln('    },');
  }

  output.writeln('  };');

  // Guardar en archivo temporal
  final outputFile = File('lib/services/_generated_notification_translations.dart.txt');
  await outputFile.writeAsString(output.toString());

  print('\n✅ Traducciones generadas para ${translations.length} idiomas');
  print('📁 Output: ${outputFile.path}');
  print('\n📋 INSTRUCCIONES:');
  print('1. Copia el contenido del archivo generado');
  print('2. Reemplaza el Map `_staticTranslations` en lib/services/notification_service.dart');
  print('3. ¡Listo! Todas las traducciones se actualizarán automáticamente');
}
