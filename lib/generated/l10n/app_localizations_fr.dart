// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Habitude Pro';

  @override
  String get homeAppBarTitle => 'Habitude Pro';

  @override
  String get loading => 'Chargement...';

  @override
  String get retry => 'Réessayer';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String todayWithDate(String date) {
    return 'Aujourd\'hui • $date';
  }

  @override
  String get allDoneToday => 'Tout est fait pour aujourd\'hui !';

  @override
  String get noProgrammedHabits =>
      'Vous n\'avez pas d\'habitudes programmées pour aujourd\'hui ou vous les avez toutes accomplies.';

  @override
  String get createFirstHabit => 'Créer ma première habitude';

  @override
  String get habitUpdated => 'Habitude mise à jour !';

  @override
  String get edit => 'Modifier';

  @override
  String get viewStatistics => 'Voir les statistiques';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteHabit => 'Supprimer l\'habitude';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$habitName\" ?';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String habitDeleted(String habitName) {
    return 'Habitude \"$habitName\" supprimée';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Mer';

  @override
  String get thursdayShort => 'Jeu';

  @override
  String get fridayShort => 'Ven';

  @override
  String get saturdayShort => 'Sam';

  @override
  String get sundayShort => 'Dim';

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
  String get februaryShort => 'Fév';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Avr';

  @override
  String get mayShort => 'Mai';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Aoû';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Oct';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Déc';

  @override
  String get newHabit => 'Nouvelle Habitude';

  @override
  String get save => 'Enregistrer';

  @override
  String get statsToday => 'Aujourd\'hui';

  @override
  String get statsWeek => 'Semaine';

  @override
  String get statsMonth => 'Mois';

  @override
  String get notificationTests => 'Tests de Notifications';

  @override
  String get immediateNotification => 'Notification Immédiate';

  @override
  String get showNotificationNow => 'Afficher la notification maintenant';

  @override
  String get scheduledNotification => 'Notification Programmée';

  @override
  String get scheduleIn5Seconds => 'Programmer la notification dans 5 secondes';

  @override
  String get rescheduleAllHabits => 'Reprogrammer Toutes les Habitudes';

  @override
  String get updateAllNotifications => 'Mettre à jour toutes les notifications';

  @override
  String get viewPendingNotifications => 'Voir les Notifications en Attente';

  @override
  String get showScheduledNotifications =>
      'Afficher les notifications programmées';

  @override
  String get notificationSent =>
      'Notification envoyée ! Vérifiez votre barre de notifications';

  @override
  String get notificationScheduled => 'Notification programmée pour 5 secondes';

  @override
  String get notificationsRescheduled =>
      'Notifications reprogrammées avec succès';

  @override
  String get pendingNotifications => 'Notifications en Attente';

  @override
  String get noPendingNotifications => 'Aucune notification en attente';

  @override
  String get close => 'Fermer';
}
