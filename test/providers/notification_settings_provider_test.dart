import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/providers/notification_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationSettingsProvider - Initialization', () {
    test('should initialize with default values', () {
      final provider = NotificationSettingsProvider();

      expect(provider.notificationsEnabled, true);
      expect(provider.defaultReminderTime.hour, 9);
      expect(provider.defaultReminderTime.minute, 0);
      expect(provider.reminderSound, 'default');
      expect(provider.vibrationEnabled, true);
    });

    test('should load settings from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'notifications_enabled': false,
        'reminder_hour': 14,
        'reminder_minute': 30,
        'reminder_sound': 'chime',
        'vibration_enabled': false,
      });

      final provider = NotificationSettingsProvider();
      await provider.loadSettings();

      expect(provider.notificationsEnabled, false);
      expect(provider.defaultReminderTime.hour, 14);
      expect(provider.defaultReminderTime.minute, 30);
      expect(provider.reminderSound, 'chime');
      expect(provider.vibrationEnabled, false);
    });

    test('should use defaults when SharedPreferences is empty', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = NotificationSettingsProvider();
      await provider.loadSettings();

      expect(provider.notificationsEnabled, true);
      expect(provider.defaultReminderTime.hour, 9);
      expect(provider.defaultReminderTime.minute, 0);
      expect(provider.reminderSound, 'default');
      expect(provider.vibrationEnabled, true);
    });

    test('should handle partial data in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'notifications_enabled': false,
        'reminder_hour': 12,
        // Missing minute, sound, vibration
      });

      final provider = NotificationSettingsProvider();
      await provider.loadSettings();

      expect(provider.notificationsEnabled, false);
      expect(provider.defaultReminderTime.hour, 12);
      expect(provider.defaultReminderTime.minute, 0); // Default
      expect(provider.reminderSound, 'default'); // Default
      expect(provider.vibrationEnabled, true); // Default
    });

    test('should notify listeners after loading settings', () async {
      SharedPreferences.setMockInitialValues({
        'notifications_enabled': false,
      });

      final provider = NotificationSettingsProvider();
      var notified = false;
      provider.addListener(() => notified = true);

      await provider.loadSettings();

      expect(notified, true);
    });
  });

  group('NotificationSettingsProvider - Notifications Enabled', () {
    test('should enable notifications and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setNotificationsEnabled(true);

      expect(provider.notificationsEnabled, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), true);
    });

    test('should disable notifications and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setNotificationsEnabled(false);

      expect(provider.notificationsEnabled, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), false);
    });

    test('should notify listeners when toggling notifications', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.setNotificationsEnabled(false);
      await provider.setNotificationsEnabled(true);

      expect(notificationCount, 2);
    });

    test('should update state immediately before persisting', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      // State should update synchronously
      provider.setNotificationsEnabled(false);
      expect(provider.notificationsEnabled, false);

      // Then persist asynchronously
      await Future.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), false);
    });
  });

  group('NotificationSettingsProvider - Default Reminder Time', () {
    test('should set reminder time and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      const newTime = TimeOfDay(hour: 14, minute: 30);
      await provider.setDefaultReminderTime(newTime);

      expect(provider.defaultReminderTime.hour, 14);
      expect(provider.defaultReminderTime.minute, 30);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('reminder_hour'), 14);
      expect(prefs.getInt('reminder_minute'), 30);
    });

    test('should handle midnight time (00:00)', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      const midnight = TimeOfDay(hour: 0, minute: 0);
      await provider.setDefaultReminderTime(midnight);

      expect(provider.defaultReminderTime.hour, 0);
      expect(provider.defaultReminderTime.minute, 0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('reminder_hour'), 0);
      expect(prefs.getInt('reminder_minute'), 0);
    });

    test('should handle end of day time (23:59)', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      const endOfDay = TimeOfDay(hour: 23, minute: 59);
      await provider.setDefaultReminderTime(endOfDay);

      expect(provider.defaultReminderTime.hour, 23);
      expect(provider.defaultReminderTime.minute, 59);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('reminder_hour'), 23);
      expect(prefs.getInt('reminder_minute'), 59);
    });

    test('should notify listeners when changing reminder time', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var notified = false;
      provider.addListener(() => notified = true);

      const newTime = TimeOfDay(hour: 15, minute: 45);
      await provider.setDefaultReminderTime(newTime);

      expect(notified, true);
    });

    test('should allow rapid time changes', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      const time1 = TimeOfDay(hour: 8, minute: 0);
      const time2 = TimeOfDay(hour: 12, minute: 30);
      const time3 = TimeOfDay(hour: 18, minute: 0);

      await provider.setDefaultReminderTime(time1);
      await provider.setDefaultReminderTime(time2);
      await provider.setDefaultReminderTime(time3);

      expect(provider.defaultReminderTime.hour, 18);
      expect(provider.defaultReminderTime.minute, 0);
    });
  });

  group('NotificationSettingsProvider - Reminder Sound', () {
    test('should set reminder sound and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setReminderSound('chime');

      expect(provider.reminderSound, 'chime');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('reminder_sound'), 'chime');
    });

    test('should handle different sound options', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      final sounds = ['default', 'chime', 'bell', 'gentle'];

      for (final sound in sounds) {
        await provider.setReminderSound(sound);
        expect(provider.reminderSound, sound);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('reminder_sound'), sound);
      }
    });

    test('should notify listeners when changing sound', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var notified = false;
      provider.addListener(() => notified = true);

      await provider.setReminderSound('bell');

      expect(notified, true);
    });

    test('should handle empty string sound', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setReminderSound('');

      expect(provider.reminderSound, '');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('reminder_sound'), '');
    });
  });

  group('NotificationSettingsProvider - Vibration Enabled', () {
    test('should enable vibration and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setVibrationEnabled(true);

      expect(provider.vibrationEnabled, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('vibration_enabled'), true);
    });

    test('should disable vibration and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      await provider.setVibrationEnabled(false);

      expect(provider.vibrationEnabled, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('vibration_enabled'), false);
    });

    test('should notify listeners when toggling vibration', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.setVibrationEnabled(false);
      await provider.setVibrationEnabled(true);

      expect(notificationCount, 2);
    });
  });

  group('NotificationSettingsProvider - Complete Settings Persistence', () {
    test('should persist all settings correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      // Set all settings
      await provider.setNotificationsEnabled(false);
      await provider.setDefaultReminderTime(const TimeOfDay(hour: 16, minute: 15));
      await provider.setReminderSound('chime');
      await provider.setVibrationEnabled(false);

      // Verify persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), false);
      expect(prefs.getInt('reminder_hour'), 16);
      expect(prefs.getInt('reminder_minute'), 15);
      expect(prefs.getString('reminder_sound'), 'chime');
      expect(prefs.getBool('vibration_enabled'), false);
    });

    test('should load all persisted settings on initialization', () async {
      SharedPreferences.setMockInitialValues({
        'notifications_enabled': false,
        'reminder_hour': 16,
        'reminder_minute': 15,
        'reminder_sound': 'chime',
        'vibration_enabled': false,
      });

      final provider = NotificationSettingsProvider();
      await provider.loadSettings();

      expect(provider.notificationsEnabled, false);
      expect(provider.defaultReminderTime.hour, 16);
      expect(provider.defaultReminderTime.minute, 15);
      expect(provider.reminderSound, 'chime');
      expect(provider.vibrationEnabled, false);
    });

    test('should handle settings reset to defaults', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      // Change all settings
      await provider.setNotificationsEnabled(false);
      await provider.setDefaultReminderTime(const TimeOfDay(hour: 22, minute: 0));
      await provider.setReminderSound('bell');
      await provider.setVibrationEnabled(false);

      // Reset to defaults
      await provider.setNotificationsEnabled(true);
      await provider.setDefaultReminderTime(const TimeOfDay(hour: 9, minute: 0));
      await provider.setReminderSound('default');
      await provider.setVibrationEnabled(true);

      expect(provider.notificationsEnabled, true);
      expect(provider.defaultReminderTime.hour, 9);
      expect(provider.defaultReminderTime.minute, 0);
      expect(provider.reminderSound, 'default');
      expect(provider.vibrationEnabled, true);
    });
  });

  group('NotificationSettingsProvider - Edge Cases', () {
    test('should handle multiple rapid setting changes', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      // Rapid changes
      for (int i = 0; i < 10; i++) {
        await provider.setNotificationsEnabled(i % 2 == 0);
        await provider.setVibrationEnabled(i % 3 == 0);
      }

      // Final state should be consistent
      // Last iteration: i=9
      // 9 % 2 = 1 (false) - notificationsEnabled = false
      // 9 % 3 = 0 (true) - vibrationEnabled = true
      expect(provider.notificationsEnabled, false);
      expect(provider.vibrationEnabled, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), false);
      expect(prefs.getBool('vibration_enabled'), true);
    });

    test('should handle dispose correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var listenerCalled = false;
      provider.addListener(() => listenerCalled = true);

      try {
        provider.dispose();
        await provider.setNotificationsEnabled(false);
        // Should not crash or throw
      } catch (e) {
        // Expect possible error after dispose, which is acceptable
      }
    });

    test('should handle settings with special characters in sound name', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      const specialSound = 'sound_@#\$%_name';
      await provider.setReminderSound(specialSound);

      expect(provider.reminderSound, specialSound);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('reminder_sound'), specialSound);
    });

    test('should handle very long sound name', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      final longSound = 'a' * 1000;
      await provider.setReminderSound(longSound);

      expect(provider.reminderSound, longSound);
      expect(provider.reminderSound.length, 1000);
    });
  });

  group('NotificationSettingsProvider - Listener Notifications', () {
    test('should notify on each setting change', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.setNotificationsEnabled(false);
      await provider.setDefaultReminderTime(const TimeOfDay(hour: 10, minute: 0));
      await provider.setReminderSound('chime');
      await provider.setVibrationEnabled(false);

      expect(notificationCount, 4);
    });

    test('should allow multiple listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = NotificationSettingsProvider();

      var listener1Called = 0;
      var listener2Called = 0;
      var listener3Called = 0;

      provider.addListener(() => listener1Called++);
      provider.addListener(() => listener2Called++);
      provider.addListener(() => listener3Called++);

      await provider.setNotificationsEnabled(false);

      expect(listener1Called, 1);
      expect(listener2Called, 1);
      expect(listener3Called, 1);
    });
  });
}
