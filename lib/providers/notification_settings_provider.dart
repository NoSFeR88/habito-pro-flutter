import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  TimeOfDay _defaultReminderTime = const TimeOfDay(hour: 9, minute: 0);
  String _reminderSound = 'default';
  bool _vibrationEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay get defaultReminderTime => _defaultReminderTime;
  String get reminderSound => _reminderSound;
  bool get vibrationEnabled => _vibrationEnabled;

  static const String _notificationsKey = 'notifications_enabled';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';
  static const String _reminderSoundKey = 'reminder_sound';
  static const String _vibrationKey = 'vibration_enabled';

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;

      final hour = prefs.getInt(_reminderHourKey) ?? 9;
      final minute = prefs.getInt(_reminderMinuteKey) ?? 0;
      _defaultReminderTime = TimeOfDay(hour: hour, minute: minute);

      _reminderSound = prefs.getString(_reminderSoundKey) ?? 'default';
      _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;

      debugPrint('✅ Notification settings loaded');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading notification settings: $e');
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, enabled);
      debugPrint('✅ Notifications ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('❌ Error saving notification enabled state: $e');
    }
  }

  Future<void> setDefaultReminderTime(TimeOfDay time) async {
    _defaultReminderTime = time;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_reminderHourKey, time.hour);
      await prefs.setInt(_reminderMinuteKey, time.minute);
      debugPrint('✅ Default reminder time set to ${time.hour}:${time.minute}');
    } catch (e) {
      debugPrint('❌ Error saving default reminder time: $e');
    }
  }

  Future<void> setReminderSound(String sound) async {
    _reminderSound = sound;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_reminderSoundKey, sound);
      debugPrint('✅ Reminder sound set to $sound');
    } catch (e) {
      debugPrint('❌ Error saving reminder sound: $e');
    }
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_vibrationKey, enabled);
      debugPrint('✅ Vibration ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('❌ Error saving vibration state: $e');
    }
  }
}
