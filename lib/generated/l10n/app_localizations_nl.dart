// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Gewoonte Pro';

  @override
  String get homeAppBarTitle => 'Gewoonte Pro';

  @override
  String get loading => 'Laden...';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get today => 'Vandaag';

  @override
  String todayWithDate(String date) {
    return 'Vandaag • $date';
  }

  @override
  String get allDoneToday => 'Alles klaar voor vandaag!';

  @override
  String get noProgrammedHabits =>
      'Je hebt geen gewoontes gepland voor vandaag of je hebt ze allemaal voltooid.';

  @override
  String get createFirstHabit => 'Mijn eerste gewoonte maken';

  @override
  String get habitUpdated => 'Gewoonte bijgewerkt!';

  @override
  String get edit => 'Bewerken';

  @override
  String get viewStatistics => 'Statistieken bekijken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteHabit => 'Gewoonte verwijderen';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Weet je zeker dat je \"$habitName\" wilt verwijderen?';
  }

  @override
  String get cancel => 'Annuleren';

  @override
  String habitDeleted(String habitName) {
    return 'Gewoonte \"$habitName\" verwijdered';
  }

  @override
  String get mondayShort => 'Ma';

  @override
  String get tuesdayShort => 'Di';

  @override
  String get wednesdayShort => 'Wo';

  @override
  String get thursdayShort => 'Do';

  @override
  String get fridayShort => 'Vr';

  @override
  String get saturdayShort => 'Za';

  @override
  String get sundayShort => 'Zo';

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
  String get marchShort => 'Mrt';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Mei';

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
  String get newHabit => 'Nieuwe Gewoonte';

  @override
  String get save => 'Opslaan';

  @override
  String get statsToday => 'Vandaag';

  @override
  String get statsWeek => 'Week';

  @override
  String get statsMonth => 'Maand';

  @override
  String get notificationTests => 'Notificatie Tests';

  @override
  String get immediateNotification => 'Directe Notificatie';

  @override
  String get showNotificationNow => 'Toon notificatie nu';

  @override
  String get scheduledNotification => 'Geplande Notificatie';

  @override
  String get scheduleIn5Seconds => 'Plan notificatie over 5 seconden';

  @override
  String get rescheduleAllHabits => 'Alle Gewoontes Herplannen';

  @override
  String get updateAllNotifications => 'Alle notificaties bijwerken';

  @override
  String get viewPendingNotifications => 'Wachtende Notificaties Bekijken';

  @override
  String get showScheduledNotifications => 'Geplande notificaties tonen';

  @override
  String get notificationSent =>
      'Notificatie verzonden! Controleer je notificatiebalk';

  @override
  String get notificationScheduled => 'Notificatie gepland voor 5 seconden';

  @override
  String get notificationsRescheduled => 'Notificaties succesvol hergepland';

  @override
  String get pendingNotifications => 'Wachtende Notificaties';

  @override
  String get noPendingNotifications => 'Geen wachtende notificaties';

  @override
  String get close => 'Sluiten';
}
