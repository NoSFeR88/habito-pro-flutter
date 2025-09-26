// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Vane Pro';

  @override
  String get homeAppBarTitle => 'Vane Pro';

  @override
  String get loading => 'Indlæser...';

  @override
  String get retry => 'Prøv igen';

  @override
  String get today => 'I dag';

  @override
  String todayWithDate(String date) {
    return 'I dag • $date';
  }

  @override
  String get allDoneToday => 'Alt færdigt i dag!';

  @override
  String get noProgrammedHabits =>
      'Du har ingen vaner planlagt for i dag eller du har fuldført dem alle.';

  @override
  String get createFirstHabit => 'Opret min første vane';

  @override
  String get habitUpdated => 'Vane opdateret!';

  @override
  String get edit => 'Rediger';

  @override
  String get viewStatistics => 'Se statistikker';

  @override
  String get delete => 'Slet';

  @override
  String get deleteHabit => 'Slet vane';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Er du sikker på, at du vil slette \"$habitName\"?';
  }

  @override
  String get cancel => 'Annuller';

  @override
  String habitDeleted(String habitName) {
    return 'Vane \"$habitName\" slettet';
  }

  @override
  String get mondayShort => 'Man';

  @override
  String get tuesdayShort => 'Tir';

  @override
  String get wednesdayShort => 'Ons';

  @override
  String get thursdayShort => 'Tor';

  @override
  String get fridayShort => 'Fre';

  @override
  String get saturdayShort => 'Lør';

  @override
  String get sundayShort => 'Søn';

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
  String get newHabit => 'Ny Vane';

  @override
  String get save => 'Gem';

  @override
  String get statsToday => 'I dag';

  @override
  String get statsWeek => 'Uge';

  @override
  String get statsMonth => 'Måned';

  @override
  String get notificationTests => 'Notifikationstest';

  @override
  String get immediateNotification => 'Øjeblikkelig Notifikation';

  @override
  String get showNotificationNow => 'Vis notifikation nu';

  @override
  String get scheduledNotification => 'Planlagt Notifikation';

  @override
  String get scheduleIn5Seconds => 'Planlæg notifikation om 5 sekunder';

  @override
  String get rescheduleAllHabits => 'Genplanlæg Alle Vaner';

  @override
  String get updateAllNotifications => 'Opdater alle notifikationer';

  @override
  String get viewPendingNotifications => 'Se Ventende Notifikationer';

  @override
  String get showScheduledNotifications => 'Vis planlagte notifikationer';

  @override
  String get notificationSent =>
      'Notifikation sendt! Tjek din notifikationsbjælke';

  @override
  String get notificationScheduled => 'Notifikation planlagt om 5 sekunder';

  @override
  String get notificationsRescheduled =>
      'Notifikationer genplanlagt succesfuldt';

  @override
  String get pendingNotifications => 'Ventende Notifikationer';

  @override
  String get noPendingNotifications => 'Ingen ventende notifikationer';

  @override
  String get close => 'Luk';
}
