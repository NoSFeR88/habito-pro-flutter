// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RITMO';

  @override
  String get homeAppBarTitle => 'RITMO';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get today => 'Today';

  @override
  String todayWithDate(String date) {
    return 'Today • $date';
  }

  @override
  String get allDoneToday => 'All done for today!';

  @override
  String get noProgrammedHabits =>
      'You have no habits scheduled for today or you\'ve completed them all.';

  @override
  String get createFirstHabit => 'Create my first habit';

  @override
  String get habitUpdated => 'Habit updated!';

  @override
  String get edit => 'Edit';

  @override
  String get viewStatistics => 'View statistics';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHabit => 'Delete habit';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Are you sure you want to delete \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String habitDeleted(String habitName) {
    return 'Habit \"$habitName\" deleted';
  }

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

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
  String get mayShort => 'May';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Aug';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Oct';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dec';

  @override
  String get newHabit => 'New Habit';

  @override
  String get save => 'Save';

  @override
  String get statsToday => 'Today';

  @override
  String get statsWeek => 'Week';

  @override
  String get statsMonth => 'Month';

  @override
  String get notificationTests => 'Notification Tests';

  @override
  String get immediateNotification => 'Immediate Notification';

  @override
  String get showNotificationNow => 'Show notification right now';

  @override
  String get scheduledNotification => 'Scheduled Notification';

  @override
  String get scheduleIn5Seconds => 'Schedule notification in 5 seconds';

  @override
  String get rescheduleAllHabits => 'Reschedule All Habits';

  @override
  String get updateAllNotifications => 'Update all notifications';

  @override
  String get viewPendingNotifications => 'View Pending Notifications';

  @override
  String get showScheduledNotifications => 'Show scheduled notifications';

  @override
  String get notificationSent =>
      'Notification sent! Check your notification bar';

  @override
  String get notificationScheduled => 'Notification scheduled for 5 seconds';

  @override
  String get notificationsRescheduled =>
      'Notifications rescheduled successfully';

  @override
  String get pendingNotifications => 'Pending Notifications';

  @override
  String get noPendingNotifications => 'No pending notifications';

  @override
  String get close => 'Close';
}
