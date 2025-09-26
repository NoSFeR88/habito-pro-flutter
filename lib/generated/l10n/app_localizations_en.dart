// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Habit Pro';

  @override
  String get homeAppBarTitle => 'Habit Pro';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get today => 'Today';

  @override
  String todayWithDate(String date) {
    return 'Today • $date';
  }

  @override
  String get allDoneToday => 'All done for today!';

  @override
  String get noProgrammedHabits =>
      'You have no habits scheduled for today or you\'ve completed them all.';

  @override
  String get createFirstHabit => 'Create my first habit';

  @override
  String get habitUpdated => 'Habit updated!';

  @override
  String get edit => 'Edit';

  @override
  String get viewStatistics => 'View statistics';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHabit => 'Delete habit';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Are you sure you want to delete \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String habitDeleted(String habitName) {
    return 'Habit \"$habitName\" deleted';
  }

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get januaryShort => 'Jan';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'May';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Aug';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Oct';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dec';

  @override
  String get newHabit => 'New Habit';

  @override
  String get save => 'Save';

  @override
  String get statsToday => 'Today';

  @override
  String get statsWeek => 'Week';

  @override
  String get statsMonth => 'Month';

  @override
  String get notificationTests => 'Notification Tests';

  @override
  String get immediateNotification => 'Immediate Notification';

  @override
  String get showNotificationNow => 'Show notification right now';

  @override
  String get scheduledNotification => 'Scheduled Notification';

  @override
  String get scheduleIn5Seconds => 'Schedule notification in 5 seconds';

  @override
  String get rescheduleAllHabits => 'Reschedule All Habits';

  @override
  String get updateAllNotifications => 'Update all notifications';

  @override
  String get viewPendingNotifications => 'View Pending Notifications';

  @override
  String get showScheduledNotifications => 'Show scheduled notifications';

  @override
  String get notificationSent =>
      'Notification sent! Check your notification bar';

  @override
  String get notificationScheduled => 'Notification scheduled for 5 seconds';

  @override
  String get notificationsRescheduled =>
      'Notifications rescheduled successfully';

  @override
  String get pendingNotifications => 'Pending Notifications';

  @override
  String get noPendingNotifications => 'No pending notifications';

  @override
  String get close => 'Close';
}
