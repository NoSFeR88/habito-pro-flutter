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
