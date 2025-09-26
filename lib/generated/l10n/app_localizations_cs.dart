// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Návyk Pro';

  @override
  String get homeAppBarTitle => 'Návyk Pro';

  @override
  String get loading => 'Načítání...';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get today => 'Dnes';

  @override
  String todayWithDate(String date) {
    return 'Dnes • $date';
  }

  @override
  String get allDoneToday => 'Vše hotovo na dnešek!';

  @override
  String get noProgrammedHabits =>
      'Nemáte naplánované žádné návyky na dnešek nebo jste je všechny dokončili.';

  @override
  String get createFirstHabit => 'Vytvořit můj první návyk';

  @override
  String get habitUpdated => 'Návyk aktualizován!';

  @override
  String get edit => 'Upravit';

  @override
  String get viewStatistics => 'Zobrazit statistiky';

  @override
  String get delete => 'Smazat';

  @override
  String get deleteHabit => 'Smazat návyk';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Jste si jisti, že chcete smazat \"$habitName\"?';
  }

  @override
  String get cancel => 'Zrušit';

  @override
  String habitDeleted(String habitName) {
    return 'Návyk \"$habitName\" smazán';
  }

  @override
  String get mondayShort => 'Po';

  @override
  String get tuesdayShort => 'Út';

  @override
  String get wednesdayShort => 'St';

  @override
  String get thursdayShort => 'Čt';

  @override
  String get fridayShort => 'Pá';

  @override
  String get saturdayShort => 'So';

  @override
  String get sundayShort => 'Ne';

  @override
  String get januaryShort => 'Led';

  @override
  String get februaryShort => 'Úno';

  @override
  String get marchShort => 'Bře';

  @override
  String get aprilShort => 'Dub';

  @override
  String get mayShort => 'Kvě';

  @override
  String get juneShort => 'Čer';

  @override
  String get julyShort => 'Čvc';

  @override
  String get augustShort => 'Srp';

  @override
  String get septemberShort => 'Zář';

  @override
  String get octoberShort => 'Říj';

  @override
  String get novemberShort => 'Lis';

  @override
  String get decemberShort => 'Pro';

  @override
  String get newHabit => 'Nový Návyk';

  @override
  String get save => 'Uložit';

  @override
  String get statsToday => 'Dnes';

  @override
  String get statsWeek => 'Týden';

  @override
  String get statsMonth => 'Měsíc';

  @override
  String get notificationTests => 'Testy Oznámení';

  @override
  String get immediateNotification => 'Okamžité Oznámení';

  @override
  String get showNotificationNow => 'Zobrazit oznámení nyní';

  @override
  String get scheduledNotification => 'Naplánované Oznámení';

  @override
  String get scheduleIn5Seconds => 'Naplánovat oznámení za 5 sekund';

  @override
  String get rescheduleAllHabits => 'Přeplánovat Všechny Návyky';

  @override
  String get updateAllNotifications => 'Aktualizovat všechna oznámení';

  @override
  String get viewPendingNotifications => 'Zobrazit Čekající Oznámení';

  @override
  String get showScheduledNotifications => 'Zobrazit naplánovaná oznámení';

  @override
  String get notificationSent =>
      'Oznámení odesláno! Zkontrolujte panel oznámení';

  @override
  String get notificationScheduled => 'Oznámení naplánováno na 5 sekund';

  @override
  String get notificationsRescheduled => 'Oznámení úspěšně přeplánována';

  @override
  String get pendingNotifications => 'Čekající Oznámení';

  @override
  String get noPendingNotifications => 'Žádná čekající oznámení';

  @override
  String get close => 'Zavřít';
}
