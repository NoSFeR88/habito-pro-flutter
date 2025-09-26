// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Tottuma Pro';

  @override
  String get homeAppBarTitle => 'Tottuma Pro';

  @override
  String get loading => 'Ladataan...';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get today => 'Tänään';

  @override
  String todayWithDate(String date) {
    return 'Tänään • $date';
  }

  @override
  String get allDoneToday => 'Kaikki valmista tänään!';

  @override
  String get noProgrammedHabits =>
      'Sinulla ei ole tottumuksia suunniteltuna tänään tai olet suorittanut kaikki.';

  @override
  String get createFirstHabit => 'Luo ensimmäinen tottumukseni';

  @override
  String get habitUpdated => 'Tottuma päivitetty!';

  @override
  String get edit => 'Muokkaa';

  @override
  String get viewStatistics => 'Näytä tilastot';

  @override
  String get delete => 'Poista';

  @override
  String get deleteHabit => 'Poista tottuma';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Oletko varma, että haluat poistaa \"$habitName\"?';
  }

  @override
  String get cancel => 'Peruuta';

  @override
  String habitDeleted(String habitName) {
    return 'Tottuma \"$habitName\" poistettu';
  }

  @override
  String get mondayShort => 'Ma';

  @override
  String get tuesdayShort => 'Ti';

  @override
  String get wednesdayShort => 'Ke';

  @override
  String get thursdayShort => 'To';

  @override
  String get fridayShort => 'Pe';

  @override
  String get saturdayShort => 'La';

  @override
  String get sundayShort => 'Su';

  @override
  String get januaryShort => 'Tam';

  @override
  String get februaryShort => 'Hel';

  @override
  String get marchShort => 'Maa';

  @override
  String get aprilShort => 'Huh';

  @override
  String get mayShort => 'Tou';

  @override
  String get juneShort => 'Kes';

  @override
  String get julyShort => 'Hei';

  @override
  String get augustShort => 'Elo';

  @override
  String get septemberShort => 'Syy';

  @override
  String get octoberShort => 'Lok';

  @override
  String get novemberShort => 'Mar';

  @override
  String get decemberShort => 'Jou';

  @override
  String get newHabit => 'Uusi Tottuma';

  @override
  String get save => 'Tallenna';

  @override
  String get statsToday => 'Tänään';

  @override
  String get statsWeek => 'Viikko';

  @override
  String get statsMonth => 'Kuukausi';

  @override
  String get notificationTests => 'Ilmoitustestit';

  @override
  String get immediateNotification => 'Välitön Ilmoitus';

  @override
  String get showNotificationNow => 'Näytä ilmoitus nyt';

  @override
  String get scheduledNotification => 'Ajastettu Ilmoitus';

  @override
  String get scheduleIn5Seconds => 'Ajasta ilmoitus 5 sekunnin kuluttua';

  @override
  String get rescheduleAllHabits => 'Aikatauluta Kaikki Tottumukset Uudelleen';

  @override
  String get updateAllNotifications => 'Päivitä kaikki ilmoitukset';

  @override
  String get viewPendingNotifications => 'Näytä Odottavat Ilmoitukset';

  @override
  String get showScheduledNotifications => 'Näytä ajastetut ilmoitukset';

  @override
  String get notificationSent => 'Ilmoitus lähetetty! Tarkista ilmoituspalkki';

  @override
  String get notificationScheduled => 'Ilmoitus ajastettu 5 sekuntiin';

  @override
  String get notificationsRescheduled =>
      'Ilmoitukset aikataulutettu uudelleen onnistuneesti';

  @override
  String get pendingNotifications => 'Odottavat Ilmoitukset';

  @override
  String get noPendingNotifications => 'Ei odottavia ilmoituksia';

  @override
  String get close => 'Sulje';
}
