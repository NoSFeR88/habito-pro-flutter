// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Vana Pro';

  @override
  String get homeAppBarTitle => 'Vana Pro';

  @override
  String get loading => 'Laddar...';

  @override
  String get retry => 'Försök igen';

  @override
  String get today => 'Idag';

  @override
  String todayWithDate(String date) {
    return 'Idag • $date';
  }

  @override
  String get allDoneToday => 'Allt klart för idag!';

  @override
  String get noProgrammedHabits =>
      'Du har inga vanor planerade för idag eller du har slutfört dem alla.';

  @override
  String get createFirstHabit => 'Skapa min första vana';

  @override
  String get habitUpdated => 'Vana uppdaterad!';

  @override
  String get edit => 'Redigera';

  @override
  String get viewStatistics => 'Visa statistik';

  @override
  String get delete => 'Ta bort';

  @override
  String get deleteHabit => 'Ta bort vana';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Är du säker på att du vill ta bort \"$habitName\"?';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String habitDeleted(String habitName) {
    return 'Vana \"$habitName\" borttagen';
  }

  @override
  String get mondayShort => 'Mån';

  @override
  String get tuesdayShort => 'Tis';

  @override
  String get wednesdayShort => 'Ons';

  @override
  String get thursdayShort => 'Tor';

  @override
  String get fridayShort => 'Fre';

  @override
  String get saturdayShort => 'Lör';

  @override
  String get sundayShort => 'Sön';

  @override
  String get januaryShort => 'Jan';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Maj';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Aug';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Okt';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dec';

  @override
  String get newHabit => 'Ny Vana';

  @override
  String get save => 'Spara';

  @override
  String get statsToday => 'Idag';

  @override
  String get statsWeek => 'Vecka';

  @override
  String get statsMonth => 'Månad';

  @override
  String get notificationTests => 'Notifikationstester';

  @override
  String get immediateNotification => 'Omedelbar Notifikation';

  @override
  String get showNotificationNow => 'Visa notifikation nu';

  @override
  String get scheduledNotification => 'Schemalagd Notifikation';

  @override
  String get scheduleIn5Seconds => 'Schemalägg notifikation om 5 sekunder';

  @override
  String get rescheduleAllHabits => 'Omschemalägg Alla Vanor';

  @override
  String get updateAllNotifications => 'Uppdatera alla notifikationer';

  @override
  String get viewPendingNotifications => 'Visa Väntande Notifikationer';

  @override
  String get showScheduledNotifications => 'Visa schemalagda notifikationer';

  @override
  String get notificationSent =>
      'Notifikation skickad! Kontrollera din notifikationsbar';

  @override
  String get notificationScheduled => 'Notifikation schemalagd för 5 sekunder';

  @override
  String get notificationsRescheduled =>
      'Notifikationer omschemalagda framgångsrikt';

  @override
  String get pendingNotifications => 'Väntande Notifikationer';

  @override
  String get noPendingNotifications => 'Inga väntande notifikationer';

  @override
  String get close => 'Stäng';
}
