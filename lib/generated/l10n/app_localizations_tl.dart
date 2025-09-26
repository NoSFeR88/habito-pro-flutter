// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get appTitle => 'Gawi Pro';

  @override
  String get homeAppBarTitle => 'Gawi Pro';

  @override
  String get loading => 'Naglo-load...';

  @override
  String get retry => 'Subukan muli';

  @override
  String get today => 'Ngayon';

  @override
  String todayWithDate(String date) {
    return 'Ngayon • $date';
  }

  @override
  String get allDoneToday => 'Tapos na lahat para sa ngayon!';

  @override
  String get noProgrammedHabits =>
      'Wala kayong nakaskedyul na gawi para ngayon o natapos na lahat.';

  @override
  String get createFirstHabit => 'Gumawa ng aking unang gawi';

  @override
  String get habitUpdated => 'Na-update ang gawi!';

  @override
  String get edit => 'I-edit';

  @override
  String get viewStatistics => 'Tingnan ang statistics';

  @override
  String get delete => 'Tanggalin';

  @override
  String get deleteHabit => 'Tanggalin ang gawi';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Sigurado ka ba na gusto mong tanggalin ang \"$habitName\"?';
  }

  @override
  String get cancel => 'Kanselahin';

  @override
  String habitDeleted(String habitName) {
    return 'Natanggal ang gawi na \"$habitName\"';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Miy';

  @override
  String get thursdayShort => 'Huw';

  @override
  String get fridayShort => 'Biy';

  @override
  String get saturdayShort => 'Sab';

  @override
  String get sundayShort => 'Lin';

  @override
  String get januaryShort => 'Ene';

  @override
  String get februaryShort => 'Peb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Abr';

  @override
  String get mayShort => 'May';

  @override
  String get juneShort => 'Hun';

  @override
  String get julyShort => 'Hul';

  @override
  String get augustShort => 'Ago';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Okt';

  @override
  String get novemberShort => 'Nob';

  @override
  String get decemberShort => 'Dis';

  @override
  String get newHabit => 'Bagong Gawi';

  @override
  String get save => 'I-save';

  @override
  String get statsToday => 'Ngayon';

  @override
  String get statsWeek => 'Linggo';

  @override
  String get statsMonth => 'Buwan';

  @override
  String get notificationTests => 'Notification Tests';

  @override
  String get immediateNotification => 'Agarang Notification';

  @override
  String get showNotificationNow => 'Ipakita ang notification ngayon';

  @override
  String get scheduledNotification => 'Naka-schedule na Notification';

  @override
  String get scheduleIn5Seconds => 'I-schedule ang notification sa 5 segundo';

  @override
  String get rescheduleAllHabits => 'I-reschedule ang Lahat ng Gawi';

  @override
  String get updateAllNotifications => 'I-update ang lahat ng notification';

  @override
  String get viewPendingNotifications => 'Tingnan ang Pending Notifications';

  @override
  String get showScheduledNotifications =>
      'Ipakita ang naka-schedule na notifications';

  @override
  String get notificationSent =>
      'Naipadala ang notification! Tignan ang inyong notification bar';

  @override
  String get notificationScheduled =>
      'Naka-schedule ang notification para sa 5 segundo';

  @override
  String get notificationsRescheduled =>
      'Matagumpay na na-reschedule ang mga notification';

  @override
  String get pendingNotifications => 'Pending Notifications';

  @override
  String get noPendingNotifications => 'Walang pending notifications';

  @override
  String get close => 'Isara';
}
