// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Obicei Pro';

  @override
  String get homeAppBarTitle => 'Obicei Pro';

  @override
  String get loading => 'Se încarcă...';

  @override
  String get retry => 'Încearcă din nou';

  @override
  String get today => 'Azi';

  @override
  String todayWithDate(String date) {
    return 'Azi • $date';
  }

  @override
  String get allDoneToday => 'Totul gata pentru azi!';

  @override
  String get noProgrammedHabits =>
      'Nu ai obiceiuri programate pentru azi sau le-ai completat pe toate.';

  @override
  String get createFirstHabit => 'Creează primul meu obicei';

  @override
  String get habitUpdated => 'Obicei actualizat!';

  @override
  String get edit => 'Editează';

  @override
  String get viewStatistics => 'Vezi statistici';

  @override
  String get delete => 'Șterge';

  @override
  String get deleteHabit => 'Șterge obiceiul';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Ești sigur că vrei să ștergi \"$habitName\"?';
  }

  @override
  String get cancel => 'Anulează';

  @override
  String habitDeleted(String habitName) {
    return 'Obiceiul \"$habitName\" șters';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Mie';

  @override
  String get thursdayShort => 'Joi';

  @override
  String get fridayShort => 'Vin';

  @override
  String get saturdayShort => 'Sâm';

  @override
  String get sundayShort => 'Dum';

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
  String get januaryShort => 'Ian';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Mai';

  @override
  String get juneShort => 'Iun';

  @override
  String get julyShort => 'Iul';

  @override
  String get augustShort => 'Aug';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Oct';

  @override
  String get novemberShort => 'Noi';

  @override
  String get decemberShort => 'Dec';

  @override
  String get newHabit => 'Obicei Nou';

  @override
  String get save => 'Salvează';

  @override
  String get statsToday => 'Azi';

  @override
  String get statsWeek => 'Săptămână';

  @override
  String get statsMonth => 'Lună';

  @override
  String get notificationTests => 'Teste Notificări';

  @override
  String get immediateNotification => 'Notificare Imediată';

  @override
  String get showNotificationNow => 'Arată notificarea acum';

  @override
  String get scheduledNotification => 'Notificare Programată';

  @override
  String get scheduleIn5Seconds => 'Programează notificare în 5 secunde';

  @override
  String get rescheduleAllHabits => 'Reprogramează Toate Obiceiurile';

  @override
  String get updateAllNotifications => 'Actualizează toate notificările';

  @override
  String get viewPendingNotifications => 'Vezi Notificările În Așteptare';

  @override
  String get showScheduledNotifications => 'Arată notificările programate';

  @override
  String get notificationSent =>
      'Notificare trimisă! Verifică bara de notificări';

  @override
  String get notificationScheduled => 'Notificare programată pentru 5 secunde';

  @override
  String get notificationsRescheduled => 'Notificări reprogramate cu succes';

  @override
  String get pendingNotifications => 'Notificări În Așteptare';

  @override
  String get noPendingNotifications => 'Nicio notificare în așteptare';

  @override
  String get close => 'Închide';
}
