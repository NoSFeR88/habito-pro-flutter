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
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Ritmo!';

  @override
  String get onboardingWelcomeSubtitle =>
      'The only habit app that adapts to YOUR real life';

  @override
  String get onboardingFeatureFlexible => 'Flexible habits adapted to you';

  @override
  String get onboardingFeatureMotivating => 'Motivating design that inspires';

  @override
  String get onboardingFeature26Languages => '26 languages - Market leader';

  @override
  String get onboardingDiscoverDifference => 'Discover the difference';

  @override
  String get onboardingProblemTitle => 'Tired of overly rigid apps?';

  @override
  String get onboardingOtherApps => 'Other apps';

  @override
  String get onboardingProblemExample => 'Gym EVERY day ❌';

  @override
  String get onboardingSolutionExample => 'Gym Mon-Wed-Fri ✅ (YOUR rhythm)';

  @override
  String get onboardingFlexibilityMessage =>
      'Your life is unique. Your habits should be too.';

  @override
  String get onboardingThisSounds => 'This sounds familiar';

  @override
  String get onboardingSetupTitle => 'Create your first flexible habit';

  @override
  String get onboardingFlexibilityTip =>
      '💡 Tip: Choose realistic days for your lifestyle';

  @override
  String get onboardingCreateFirstHabit => 'Create my first habit';

  @override
  String get onboardingCelebrationTitle => 'Perfect! You have your rhythm';

  @override
  String get onboardingCelebrationSubtitle =>
      'Your first flexible habit is ready to begin';

  @override
  String get onboardingDefaultHabitName => 'My first habit';

  @override
  String get onboardingNoDaysSelected => 'No days selected';

  @override
  String get onboardingBenefitFlexibility => 'Total flexibility';

  @override
  String get onboardingBenefitMotivation => 'Constant motivation';

  @override
  String get onboardingBenefit26Languages => '26 languages available';

  @override
  String get onboardingStartMyRhythm => 'Start my rhythm';

  @override
  String get habitName => 'Habit name';

  @override
  String get habitNameHint => 'E.g: Exercise, Read, Meditate...';

  @override
  String get selectDays => 'Select days';

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
