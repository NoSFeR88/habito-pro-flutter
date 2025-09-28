// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Gewohnheit Pro';

  @override
  String get homeAppBarTitle => 'Gewohnheit Pro';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get retry => 'Wiederholen';

  @override
  String get today => 'Heute';

  @override
  String todayWithDate(String date) {
    return 'Heute • $date';
  }

  @override
  String get allDoneToday => 'Alles für heute erledigt!';

  @override
  String get noProgrammedHabits =>
      'Sie haben keine Gewohnheiten für heute geplant oder alle bereits abgeschlossen.';

  @override
  String get createFirstHabit => 'Meine erste Gewohnheit erstellen';

  @override
  String get habitUpdated => 'Gewohnheit aktualisiert!';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get viewStatistics => 'Statistiken anzeigen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteHabit => 'Gewohnheit löschen';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Sind Sie sicher, dass Sie \"$habitName\" löschen möchten?';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String habitDeleted(String habitName) {
    return 'Gewohnheit \"$habitName\" gelöscht';
  }

  @override
  String get mondayShort => 'Mo';

  @override
  String get tuesdayShort => 'Di';

  @override
  String get wednesdayShort => 'Mi';

  @override
  String get thursdayShort => 'Do';

  @override
  String get fridayShort => 'Fr';

  @override
  String get saturdayShort => 'Sa';

  @override
  String get sundayShort => 'So';

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
  String get marchShort => 'Mär';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Mai';

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
  String get decemberShort => 'Dez';

  @override
  String get newHabit => 'Neue Gewohnheit';

  @override
  String get save => 'Speichern';

  @override
  String get statsToday => 'Heute';

  @override
  String get statsWeek => 'Woche';

  @override
  String get statsMonth => 'Monat';

  @override
  String get notificationTests => 'Benachrichtigungstests';

  @override
  String get immediateNotification => 'Sofortige Benachrichtigung';

  @override
  String get showNotificationNow => 'Benachrichtigung jetzt anzeigen';

  @override
  String get scheduledNotification => 'Geplante Benachrichtigung';

  @override
  String get scheduleIn5Seconds => 'Benachrichtigung in 5 Sekunden planen';

  @override
  String get rescheduleAllHabits => 'Alle Gewohnheiten neu planen';

  @override
  String get updateAllNotifications => 'Alle Benachrichtigungen aktualisieren';

  @override
  String get viewPendingNotifications =>
      'Ausstehende Benachrichtigungen anzeigen';

  @override
  String get showScheduledNotifications =>
      'Geplante Benachrichtigungen anzeigen';

  @override
  String get notificationSent =>
      'Benachrichtigung gesendet! Überprüfen Sie Ihre Benachrichtigungsleiste';

  @override
  String get notificationScheduled => 'Benachrichtigung für 5 Sekunden geplant';

  @override
  String get notificationsRescheduled =>
      'Benachrichtigungen erfolgreich neu geplant';

  @override
  String get pendingNotifications => 'Ausstehende Benachrichtigungen';

  @override
  String get noPendingNotifications => 'Keine ausstehenden Benachrichtigungen';

  @override
  String get close => 'Schließen';
}
