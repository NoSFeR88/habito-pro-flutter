// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Nawyk Pro';

  @override
  String get homeAppBarTitle => 'Nawyk Pro';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get today => 'Dzisiaj';

  @override
  String todayWithDate(String date) {
    return 'Dzisiaj • $date';
  }

  @override
  String get allDoneToday => 'Wszystko zrobione na dzisiaj!';

  @override
  String get noProgrammedHabits =>
      'Nie masz zaplanowanych nawyków na dziś lub już wszystkie wykonałeś.';

  @override
  String get createFirstHabit => 'Stwórz mój pierwszy nawyk';

  @override
  String get habitUpdated => 'Nawyk zaktualizowany!';

  @override
  String get edit => 'Edytuj';

  @override
  String get viewStatistics => 'Zobacz statystyki';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteHabit => 'Usuń nawyk';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Czy na pewno chcesz usunąć \"$habitName\"?';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String habitDeleted(String habitName) {
    return 'Nawyk \"$habitName\" usunięty';
  }

  @override
  String get mondayShort => 'Pon';

  @override
  String get tuesdayShort => 'Wt';

  @override
  String get wednesdayShort => 'Śr';

  @override
  String get thursdayShort => 'Czw';

  @override
  String get fridayShort => 'Pt';

  @override
  String get saturdayShort => 'Sob';

  @override
  String get sundayShort => 'Ndz';

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
  String get januaryShort => 'Sty';

  @override
  String get februaryShort => 'Lut';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Kwi';

  @override
  String get mayShort => 'Maj';

  @override
  String get juneShort => 'Cze';

  @override
  String get julyShort => 'Lip';

  @override
  String get augustShort => 'Sie';

  @override
  String get septemberShort => 'Wrz';

  @override
  String get octoberShort => 'Paź';

  @override
  String get novemberShort => 'Lis';

  @override
  String get decemberShort => 'Gru';

  @override
  String get newHabit => 'Nowy Nawyk';

  @override
  String get save => 'Zapisz';

  @override
  String get statsToday => 'Dzisiaj';

  @override
  String get statsWeek => 'Tydzień';

  @override
  String get statsMonth => 'Miesiąc';

  @override
  String get notificationTests => 'Testy Powiadomień';

  @override
  String get immediateNotification => 'Natychmiastowe Powiadomienie';

  @override
  String get showNotificationNow => 'Pokaż powiadomienie teraz';

  @override
  String get scheduledNotification => 'Zaplanowane Powiadomienie';

  @override
  String get scheduleIn5Seconds => 'Zaplanuj powiadomienie za 5 sekund';

  @override
  String get rescheduleAllHabits => 'Przełóż Wszystkie Nawyki';

  @override
  String get updateAllNotifications => 'Zaktualizuj wszystkie powiadomienia';

  @override
  String get viewPendingNotifications => 'Zobacz Oczekujące Powiadomienia';

  @override
  String get showScheduledNotifications => 'Pokaż zaplanowane powiadomienia';

  @override
  String get notificationSent =>
      'Powiadomienie wysłane! Sprawdź pasek powiadomień';

  @override
  String get notificationScheduled => 'Powiadomienie zaplanowane na 5 sekund';

  @override
  String get notificationsRescheduled => 'Powiadomienia przełożone pomyślnie';

  @override
  String get pendingNotifications => 'Oczekujące Powiadomienia';

  @override
  String get noPendingNotifications => 'Brak oczekujących powiadomień';

  @override
  String get close => 'Zamknij';
}
