import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/habit.dart';
import '../generated/l10n/app_localizations.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  BuildContext? _context;

  String _getLocalizedString(String key, [String fallback = '']) {
    if (_context == null) return fallback;
    final l10n = AppLocalizations.of(_context!);
    if (l10n == null) return fallback;

    switch (key) {
      case 'habitReminders':
        return l10n.habitReminders;
      case 'notificationsToRemindHabits':
        return l10n.notificationsToRemindHabits;
      case 'habitReminderTicker':
        return l10n.habitReminderTicker;
      case 'defaultHabitReminder':
        return l10n.defaultHabitReminder;
      case 'testNotificationTitle':
        return l10n.testNotificationTitle;
      case 'testNotificationBody':
        return l10n.testNotificationBody;
      case 'scheduledNotificationTitle':
        return l10n.scheduledNotificationTitle;
      case 'scheduledNotificationBody':
        return l10n.scheduledNotificationBody;
      default:
        return fallback;
    }
  }

  Future<void> initialize([BuildContext? context]) async {
    if (_initialized) return;
    _context = context;

    try {
      // Inicializar timezone
      tz.initializeTimeZones();

      // Configuración Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración iOS
      final darwinSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );

      final initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      // Inicializar plugin
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      // Solicitar permisos específicos para Android 13+
      await _requestPermissions();

      // Crear canal de notificación para Android
      await _createNotificationChannel();

      _initialized = true;
      debugPrint('✅ NotificationService: Inicializado exitosamente');

    } catch (e) {
      debugPrint('❌ NotificationService Error: $e');
      // Fallback: marcar como inicializado pero sin funcionalidad
      _initialized = true;
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Solicitar permisos para Android 13+ (API 33+)
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }

      // Solicitar permisos para iOS
      final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error solicitando permisos: $e');
    }
  }

  Future<void> _createNotificationChannel() async {
    final androidChannel = AndroidNotificationChannel(
      'habit_reminders',
      _getLocalizedString('habitReminders', 'Habit Reminders'),
      description: _getLocalizedString('notificationsToRemindHabits', 'Notifications to remind you to complete your daily habits'),
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
    }
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    debugPrint('📱 Notificación recibida en iOS: $title');
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('📱 Usuario tocó notificación: ${response.payload}');
    // Aquí puedes navegar a una pantalla específica
  }

  Future<void> scheduleHabitReminder(Habit habit, [BuildContext? context]) async {
    if (!_initialized) {
      await initialize(context);
    }
    if (context != null) _context = context;

    try {
      // Cancelar notificaciones previas para este hábito
      await cancelHabitReminders(habit.id);

      // Programar notificaciones reales para cada día
      for (final dayOfWeek in habit.frequency) {
        final notificationId = _generateNotificationId(habit.id, dayOfWeek);
        final nextDate = _getNextDateForDay(dayOfWeek, habit.reminderTime);

        // Configurar detalles de notificación Android
        final androidDetails = AndroidNotificationDetails(
          'habit_reminders',
          _getLocalizedString('habitReminders', 'Habit Reminders'),
          channelDescription: _getLocalizedString('notificationsToRemindHabits', 'Notifications to remind you to complete your daily habits'),
          importance: Importance.high,
          priority: Priority.high,
          ticker: _getLocalizedString('habitReminderTicker', 'Habit reminder'),
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          autoCancel: true,
        );

        // Configurar detalles para iOS
        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        final notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
          macOS: iosDetails,
        );

        // Programar notificación
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          '🎯 ${habit.name}',
          habit.description.isNotEmpty
              ? habit.description
              : _getLocalizedString('defaultHabitReminder', 'Time to work on your habit!'),
          tz.TZDateTime.from(nextDate, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: habit.id,
        );

        debugPrint('✅ Notificación programada: ${habit.name} - ${_formatDateTime(nextDate)}');
      }

      debugPrint('✅ Total notificaciones programadas para ${habit.name}: ${habit.frequency.length}');

    } catch (e) {
      debugPrint('❌ Error programando notificaciones para ${habit.name}: $e');
      // En caso de error, no fallar silenciosamente
      rethrow;
    }
  }

  DateTime _getNextDateForDay(int dayOfWeek, TimeOfDay time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Encontrar el próximo día que coincida con dayOfWeek
    int daysToAdd = dayOfWeek - now.weekday;
    if (daysToAdd < 0) {
      daysToAdd += 7; // Próxima semana
    } else if (daysToAdd == 0) {
      // Es hoy, verificar si ya pasó la hora
      final scheduledToday = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledToday.isBefore(now)) {
        daysToAdd = 7; // Próxima semana
      }
    }

    return today.add(Duration(days: daysToAdd)).add(
      Duration(hours: time.hour, minutes: time.minute),
    );
  }

  int _generateNotificationId(String habitId, int dayOfWeek) {
    // Genera un ID único combinando el hash del habitId con el día
    return (habitId.hashCode % 100000) * 10 + dayOfWeek;
  }

  Future<void> cancelHabitReminders(String habitId) async {
    try {
      // Cancelar notificaciones específicas de este hábito
      for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
        final notificationId = _generateNotificationId(habitId, dayOfWeek);
        await _notificationsPlugin.cancel(notificationId);
      }
      debugPrint('✅ Canceladas notificaciones para hábito $habitId');
    } catch (e) {
      debugPrint('❌ Error cancelando notificaciones para hábito $habitId: $e');
    }
  }

  /// Programa notificaciones SOLO desde la próxima ocurrencia del hábito
  /// (excluye el día de hoy - usado cuando se completa un hábito)
  Future<void> scheduleFromNextOccurrence(Habit habit, [BuildContext? context]) async {
    if (!habit.isReminderEnabled) {
      debugPrint('⏭️ Recordatorios deshabilitados para: ${habit.name}');
      return;
    }
    if (context != null) _context = context;

    try {
      // Cancelar TODAS las notificaciones previas
      await cancelHabitReminders(habit.id);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int notificationCount = 0;

      // Encontrar la PRÓXIMA ocurrencia (no hoy)
      for (int daysAhead = 1; daysAhead <= 7; daysAhead++) {
        final futureDate = today.add(Duration(days: daysAhead));
        final futureDayOfWeek = futureDate.weekday;

        if (habit.frequency.contains(futureDayOfWeek)) {
          // Esta es la próxima ocurrencia
          final scheduledDateTime = DateTime(
            futureDate.year,
            futureDate.month,
            futureDate.day,
            habit.reminderTime.hour,
            habit.reminderTime.minute,
          );

          final notificationId = _generateNotificationId(habit.id, futureDayOfWeek);

          final androidDetails = AndroidNotificationDetails(
            'habit_reminders',
            _getLocalizedString('habitReminders', 'Habit Reminders'),
            channelDescription: _getLocalizedString('notificationsToRemindHabits', 'Notifications to remind you to complete your daily habits'),
            importance: Importance.high,
            priority: Priority.high,
            ticker: _getLocalizedString('habitReminderTicker', 'Habit reminder'),
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            autoCancel: true,
          );

          const iosDetails = DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

          final notificationDetails = NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
            macOS: iosDetails,
          );

          // Programar con repetición semanal desde esta fecha
          await _notificationsPlugin.zonedSchedule(
            notificationId,
            '🎯 ${habit.name}',
            habit.description.isNotEmpty
                ? habit.description
                : _getLocalizedString('defaultHabitReminder', 'Time to work on your habit!'),
            tz.TZDateTime.from(scheduledDateTime, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // Repetición semanal
            payload: habit.id,
          );

          notificationCount++;
          debugPrint('✅ Notificación programada desde próxima ocurrencia: ${habit.name} - ${_formatDateTime(scheduledDateTime)}');
          break; // Solo programar desde la primera próxima ocurrencia
        }
      }

      if (notificationCount == 0) {
        debugPrint('⚠️ No se encontró próxima ocurrencia para ${habit.name}');
      } else {
        debugPrint('✅ Total notificaciones desde próxima ocurrencia: $notificationCount');
      }

    } catch (e) {
      debugPrint('❌ Error programando desde próxima ocurrencia: $e');
      rethrow;
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('✅ Canceladas todas las notificaciones');
    } catch (e) {
      debugPrint('❌ Error cancelando todas las notificaciones: $e');
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
    BuildContext? context,
  }) async {
    if (!_initialized) {
      await initialize(context);
    }
    if (context != null) _context = context;

    try {
      final androidDetails = AndroidNotificationDetails(
        'habit_reminders',
        _getLocalizedString('habitReminders', 'Habit Reminders'),
        channelDescription: _getLocalizedString('notificationsToRemindHabits', 'Notifications to remind you to complete your daily habits'),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        autoCancel: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      debugPrint('✅ Notificación instantánea enviada: $title');
    } catch (e) {
      debugPrint('❌ Error enviando notificación instantánea: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('❌ Error obteniendo notificaciones pendientes: $e');
      return [];
    }
  }

  // Método para probar notificaciones inmediatas
  Future<void> testNotification([BuildContext? context]) async {
    await showInstantNotification(
      title: _getLocalizedString('testNotificationTitle', '🧪 Test Notification'),
      body: _getLocalizedString('testNotificationBody', 'Notification system working correctly!'),
      payload: 'test',
      context: context,
    );
  }

  // Método para programar una notificación de prueba en 5 segundos
  Future<void> testScheduledNotification([BuildContext? context]) async {
    if (!_initialized) {
      await initialize(context);
    }
    if (context != null) _context = context;

    try {
      final scheduledDate = DateTime.now().add(const Duration(seconds: 5));

      final androidDetails = AndroidNotificationDetails(
        'habit_reminders',
        _getLocalizedString('habitReminders', 'Habit Reminders'),
        channelDescription: _getLocalizedString('notificationsToRemindHabits', 'Notifications to remind you to complete your daily habits'),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        autoCancel: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        99999,
        _getLocalizedString('scheduledNotificationTitle', '⏰ Scheduled Notification'),
        _getLocalizedString('scheduledNotificationBody', 'This notification was scheduled 5 seconds ago'),
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'test_scheduled',
      );

      debugPrint('✅ Notificación de prueba programada para 5 segundos');
    } catch (e) {
      debugPrint('❌ Error programando notificación de prueba: $e');
    }
  }

  // Utilidad para formatear fechas
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

