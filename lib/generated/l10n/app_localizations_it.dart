// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Abitudine Pro';

  @override
  String get homeAppBarTitle => 'Abitudine Pro';

  @override
  String get loading => 'Caricamento...';

  @override
  String get retry => 'Riprova';

  @override
  String get today => 'Oggi';

  @override
  String todayWithDate(String date) {
    return 'Oggi • $date';
  }

  @override
  String get allDoneToday => 'Tutto fatto per oggi!';

  @override
  String get noProgrammedHabits =>
      'Non hai abitudini programmate per oggi o le hai già completate tutte.';

  @override
  String get createFirstHabit => 'Crea la mia prima abitudine';

  @override
  String get habitUpdated => 'Abitudine aggiornata!';

  @override
  String get edit => 'Modifica';

  @override
  String get viewStatistics => 'Visualizza statistiche';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteHabit => 'Elimina abitudine';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Sei sicuro di voler eliminare \"$habitName\"?';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String habitDeleted(String habitName) {
    return 'Abitudine \"$habitName\" eliminata';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Mer';

  @override
  String get thursdayShort => 'Gio';

  @override
  String get fridayShort => 'Ven';

  @override
  String get saturdayShort => 'Sab';

  @override
  String get sundayShort => 'Dom';

  @override
  String get januaryShort => 'Gen';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Mag';

  @override
  String get juneShort => 'Giu';

  @override
  String get julyShort => 'Lug';

  @override
  String get augustShort => 'Ago';

  @override
  String get septemberShort => 'Set';

  @override
  String get octoberShort => 'Ott';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dic';

  @override
  String get newHabit => 'Nuova Abitudine';

  @override
  String get save => 'Salva';

  @override
  String get statsToday => 'Oggi';

  @override
  String get statsWeek => 'Settimana';

  @override
  String get statsMonth => 'Mese';

  @override
  String get notificationTests => 'Test Notifiche';

  @override
  String get immediateNotification => 'Notifica Immediata';

  @override
  String get showNotificationNow => 'Mostra notifica ora';

  @override
  String get scheduledNotification => 'Notifica Programmata';

  @override
  String get scheduleIn5Seconds => 'Programma notifica tra 5 secondi';

  @override
  String get rescheduleAllHabits => 'Riprogramma Tutte le Abitudini';

  @override
  String get updateAllNotifications => 'Aggiorna tutte le notifiche';

  @override
  String get viewPendingNotifications => 'Visualizza Notifiche in Attesa';

  @override
  String get showScheduledNotifications => 'Mostra notifiche programmate';

  @override
  String get notificationSent =>
      'Notifica inviata! Controlla la barra delle notifiche';

  @override
  String get notificationScheduled => 'Notifica programmata per 5 secondi';

  @override
  String get notificationsRescheduled => 'Notifiche riprogrammate con successo';

  @override
  String get pendingNotifications => 'Notifiche in Attesa';

  @override
  String get noPendingNotifications => 'Nessuna notifica in attesa';

  @override
  String get close => 'Chiudi';
}
