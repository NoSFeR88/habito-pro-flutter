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
  String get loadingApp => 'Starting Ritmo...';

  @override
  String get retry => 'Retry';

  @override
  String get today => 'Today';

  @override
  String todayWithDate(Object date) {
    return 'Today • $date';
  }

  @override
  String get allDoneToday => 'All done for today!';

  @override
  String get noProgrammedHabits =>
      'You have no rhythms scheduled for today or you\'ve completed them all.';

  @override
  String get createFirstHabit => 'Create my first rhythm';

  @override
  String get rhythmUpdated => 'Habit updated!';

  @override
  String get edit => 'Edit';

  @override
  String get viewStatistics => 'View statistics';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHabit => 'Delete rhythm';

  @override
  String confirmDeleteHabit(Object habitName, Object rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String rhythmDeleted(Object rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
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
      'The only rhythm app that adapts to YOUR real life';

  @override
  String get onboardingFeatureFlexible => 'Flexible rhythms adapted to you';

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
      'Your life is unique. Your rhythms should be too.';

  @override
  String get onboardingThisSounds => 'This sounds familiar';

  @override
  String get onboardingSetupTitle => 'Create your first flexible rhythm';

  @override
  String get onboardingFlexibilityTip =>
      '💡 Tip: Choose realistic days for your lifestyle';

  @override
  String get onboardingCreateFirstHabit => 'Create my first rhythm';

  @override
  String get onboardingExampleHabitName => 'Go to the gym';

  @override
  String get onboardingCelebrationTitle => 'Perfect! You have your rhythm';

  @override
  String get onboardingCelebrationSubtitle =>
      'Your first flexible rhythm is ready to begin';

  @override
  String get onboardingDefaultHabitName => 'My first rhythm';

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
  String get rhythmName => 'Habit name';

  @override
  String get rhythmNameHint => 'E.g: Exercise, Read, Meditate...';

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
  String get newHabit => 'New Rhythm';

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
  String notificationScheduled(Object dateTime, Object rhythmName) {
    return '✅ Notification scheduled: $rhythmName - $dateTime';
  }

  @override
  String get notificationsRescheduled =>
      'Notifications rescheduled successfully';

  @override
  String get pendingNotifications => 'Pending Notifications';

  @override
  String get noPendingNotifications => 'No pending notifications';

  @override
  String get close => 'Close';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get rhythmStreaks => 'Habit Streaks';

  @override
  String get monthlyCalendar => 'Monthly Calendar';

  @override
  String get monthlyStats => 'Monthly Statistics';

  @override
  String get activeDays => 'Active Days';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get averageCompletion => 'Average';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get themes => 'Themes';

  @override
  String get themeBasicBlue => 'Basic Blue';

  @override
  String get themeBasicGreen => 'Basic Green';

  @override
  String get themeBasicPurple => 'Basic Purple';

  @override
  String get themeCyberNeon => '🌟 Cyber Neon';

  @override
  String get themeAuroraInspiration => '🎨 Aurora Inspiration';

  @override
  String get themeZenGarden => '🧘 Zen Garden';

  @override
  String get premiumThemes => 'Premium Themes';

  @override
  String get activatePremium => 'Activate Premium (Testing)';

  @override
  String get premiumPrice => '\$2.99/month';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageHabits => 'Manage Rhythms';

  @override
  String get noActiveHabits => 'No active rhythms';

  @override
  String get createFirstHabitToStart =>
      'Create your first rhythm to get started';

  @override
  String get noPausedHabits => 'No paused rhythms';

  @override
  String get pausedHabitsWillAppearHere => 'Paused rhythms will appear here';

  @override
  String get noHabits => 'You have no rhythms';

  @override
  String get startJourneyCreatingFirstHabit =>
      'Start your journey by creating your first rhythm';

  @override
  String get deleteHabitConfirm =>
      'Are you sure you want to delete this rhythm?';

  @override
  String get editHabit => 'Edit Rhythm';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get rhythmNameLabel => 'Habit name';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'E.g: 8 glasses per day, 30 minutes...';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get allDays => 'All days';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get deleteHabitButton => 'Delete rhythm';

  @override
  String get deleteWarning =>
      'This action cannot be undone. All rhythm data including completion history will be deleted.';

  @override
  String get selectAtLeastOneDay => 'Select at least one day of the week';

  @override
  String rhythmUpdatedSuccess(Object rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String errorUpdatingHabit(Object error) {
    return 'Error updating rhythm: $error';
  }

  @override
  String get deleteHabitTitle => 'Delete rhythm';

  @override
  String deleteHabitConfirmation(Object rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.';
  }

  @override
  String rhythmDeletedSuccess(Object rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String errorDeletingHabit(Object error) {
    return 'Error deleting rhythm: $error';
  }

  @override
  String limitReached(Object maxHabits) {
    return 'Limit reached: maximum $maxHabits rhythms in free plan.';
  }

  @override
  String get premiumThemesOnly =>
      'Premium themes are only available in Ritmo PRO.';

  @override
  String get advancedStatsOnly => 'Advanced statistics available in Ritmo PRO.';

  @override
  String get exportDataOnly => 'Export data is available in Ritmo PRO.';

  @override
  String get aiInsightsOnly => 'AI Insights are available in Ritmo PRO.';

  @override
  String get featureOnlyInPro => 'This feature is available in Ritmo PRO.';

  @override
  String get loadingYourHabits => 'Loading your rhythms...';

  @override
  String get guestMode => 'Guest mode - Your data will not be saved';

  @override
  String get createAccountToSave =>
      'Create an account to save your rhythms and sync them across devices.';

  @override
  String get later => 'Later';

  @override
  String loginError(Object error) {
    return 'Login error: $error';
  }

  @override
  String logoutError(Object error) {
    return 'Error logging out: $error';
  }

  @override
  String get wrongPassword => 'Wrong password.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get invalidEmail => 'Email is not valid.';

  @override
  String get tooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get connectionError => 'Connection error. Check your internet.';

  @override
  String authError(Object message) {
    return 'Authentication error: $message';
  }

  @override
  String get champion => 'Champion';

  @override
  String get hero => 'Hero';

  @override
  String get mythic => 'Mythic';

  @override
  String get maximum => 'Maximum';

  @override
  String get completeFirstHabit3Days =>
      'Complete your first rhythm 3 days in a row';

  @override
  String get maintain7DayStreak => 'Maintain a 7-day streak';

  @override
  String get maintain30DayStreak => 'Maintain a 30-day streak';

  @override
  String get completeFirstHabit => 'Complete your first rhythm';

  @override
  String get complete100Habits => 'Complete 100 rhythms total';

  @override
  String get complete500Habits => 'Complete 500 rhythms total';

  @override
  String get completeAllHabitsWeek => 'Complete all your rhythms during a week';

  @override
  String get create5DifferentHabits => 'Create 5 different rhythms';

  @override
  String get reachLevel5 => 'Reach level 5';

  @override
  String get noHabitsToday =>
      'You have no rhythms scheduled for today or you\'ve completed them all.';

  @override
  String get allHabitsPaused =>
      'All your habits are paused. Reactivate one or create a new one.';

  @override
  String get startJourneyBetterHabits =>
      'Start your journey towards better rhythms by creating your first daily rhythm.';

  @override
  String get createNewHabit => 'Create new habit';

  @override
  String get createMyFirstHabit => 'Create my first habit';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get receiveRemindersForHabits => 'Receive reminders for your rhythms';

  @override
  String get openSystemSettings =>
      'Open system settings to manage notifications';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get rhythmReminders => 'Habit Reminders';

  @override
  String get notificationsToRemind =>
      'Notifications to remind you to complete your daily rhythms';

  @override
  String get reminderTicker => 'Habit reminder';

  @override
  String get timeToWorkOnHabit => 'Time to work on your rhythm!';

  @override
  String notificationsCancelled(Object rhythmId) {
    return '✅ Cancelled notifications for rhythm $rhythmId';
  }

  @override
  String errorCancellingNotifications(Object error, Object rhythmId) {
    return '❌ Error cancelling notifications for rhythm $rhythmId: $error';
  }

  @override
  String instantNotificationSent(Object title) {
    return '✅ Instant notification sent: $title';
  }

  @override
  String errorSendingNotification(Object error) {
    return '❌ Error sending instant notification: $error';
  }

  @override
  String get testNotificationTitle => '🧪 Test Notification';

  @override
  String get scheduledNotificationTitle => '⏰ Scheduled Notification';

  @override
  String get scheduledNotificationBody =>
      'This notification was scheduled 5 seconds ago';

  @override
  String get testNotificationScheduled =>
      '✅ Test notification scheduled for 5 seconds';

  @override
  String errorSchedulingTestNotification(Object error) {
    return '❌ Error scheduling test notification: $error';
  }

  @override
  String localizationInitialized(Object languageCode) {
    return '✅ Localization initialized: $languageCode';
  }

  @override
  String notificationReceivediOS(Object title) {
    return '📱 Notification received on iOS: $title';
  }

  @override
  String userTappedNotification(Object payload) {
    return '📱 User tapped notification: $payload';
  }

  @override
  String rhythmUpdatedSuccessfully(Object rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String confirmDeleteHabitMessage(Object rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.';
  }

  @override
  String rhythmDeletedSuccessfully(Object rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String rhythmCreatedSuccessfully(Object rhythmName) {
    return 'Habit \"$rhythmName\" created successfully';
  }

  @override
  String confirmDeleteHabitShort(Object rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?';
  }

  @override
  String get ensureAppNotInDoNotDisturb =>
      '• Make sure the app is not in \"Do Not Disturb\" mode\\n';

  @override
  String get firstStreak => 'First Streak';

  @override
  String get firstStreakDescription =>
      'Complete your first rhythm 3 days in a row';

  @override
  String get weekWarrior => 'Week Warrior';

  @override
  String get weekWarriorDescription => 'Maintain a 7-day streak';

  @override
  String get monthMaster => 'Month Master';

  @override
  String get monthMasterDescription => 'Maintain a 30-day streak';

  @override
  String get firstStep => 'First Step';

  @override
  String get firstStepDescription => 'Complete your first rhythm';

  @override
  String get centuryClub => 'Century Club';

  @override
  String get centuryClubDescription => 'Complete 100 rhythms total';

  @override
  String get marathonRunner => 'Marathon Runner';

  @override
  String get marathonRunnerDescription => 'Complete 500 rhythms total';

  @override
  String get perfectWeek => 'Perfect Week';

  @override
  String get perfectWeekDescription =>
      'Complete all your rhythms during a week';

  @override
  String get rhythmCreator => 'Habit Creator';

  @override
  String get rhythmCreatorDescription => 'Create 5 different rhythms';

  @override
  String get achievements => 'Achievements';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get level => 'Level';

  @override
  String get points => 'Points';

  @override
  String get totalAccumulated => 'Total accumulated';

  @override
  String get achievementsLabel => 'Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get streak => 'Streak';

  @override
  String get maxDays => 'Max days';

  @override
  String get currentLevel => 'Current Level';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get pointsToNext => 'Points to next';

  @override
  String get allAchievements => 'All Achievements';

  @override
  String get progressToNextLevel => 'Progress to Next Level';

  @override
  String get paywallMonthly => 'Monthly';

  @override
  String get paywallAnnual => 'Annual';

  @override
  String get paywallLifetime => 'Lifetime';

  @override
  String get paywallPerMonth => '/month';

  @override
  String get paywallPerYear => '/year';

  @override
  String get paywallOneTimePayment => 'one-time payment';

  @override
  String get paywallDiscount => '37% OFF';

  @override
  String get paywallLimitedOffer => 'LIMITED OFFER';

  @override
  String get paywallUnlimitedHabits => 'Unlimited Habits';

  @override
  String get paywallUnlimitedHabitsDesc => 'Create all the habits you want';

  @override
  String get paywallAdvancedStats => 'Advanced Statistics';

  @override
  String get paywallAdvancedStatsDesc => 'Deep analysis and trends';

  @override
  String get paywallPremiumThemes => '5 Premium Themes';

  @override
  String get paywallPremiumThemesDesc => 'Ocean, Sunset, Forest and more';

  @override
  String get paywallNoAds => 'No Ads';

  @override
  String get paywallNoAdsDesc => 'Completely clean experience';

  @override
  String get paywallAutoBackup => 'Automatic Backup';

  @override
  String get paywallAutoBackupDesc => 'Your data safe in the cloud';

  @override
  String get paywallAiInsights => 'AI Insights';

  @override
  String get paywallAiInsightsDesc => 'Smart recommendations';

  @override
  String get paywallErrorCreatingHabit => 'Error creating habit';

  @override
  String get paywallErrorLogin => 'Anonymous login error';

  @override
  String get paywallErrorGoogleLogin => 'Google login error';

  @override
  String get paywallErrorEmailLogin => 'Email login error';

  @override
  String get paywallErrorRegistration => 'Registration error';

  @override
  String get paywallErrorLogout => 'Logout error';

  @override
  String get paywallErrorPasswordReset => 'Error sending password reset email';

  @override
  String get paywallErrorDeleteAccount => 'Error deleting account';

  @override
  String get paywallErrorUpdateProfile => 'Error updating profile';

  @override
  String get paywallErrorGetUserData => 'Error getting user data';

  @override
  String get paywallErrorUpdatePreferences => 'Error updating preferences';

  @override
  String get paywallErrorUpdatePremium => 'Error updating premium status';

  @override
  String get paywallErrorLinkAccount => 'Error linking account';

  @override
  String get paywallErrorGetHabits => 'Error getting habits';

  @override
  String get paywallErrorUpdateHabit => 'Error updating habit';

  @override
  String get paywallErrorDeleteHabit => 'Error deleting habit';

  @override
  String get paywallErrorHabitNotFound => 'Habit not found';

  @override
  String get paywallErrorUpdateCompletion => 'Error updating completion';

  @override
  String get paywallErrorGetStats => 'Error getting statistics';

  @override
  String get paywallErrorBackup => 'Error performing backup';

  @override
  String get paywallErrorGetPeriodData => 'Error getting period data';

  @override
  String get paywallErrorCleanOldData => 'Error cleaning old data';

  @override
  String get paywallErrorLoadingHabits => 'Error loading habits';

  @override
  String pointsToLevel(Object level, Object points) {
    return '$points points to level $level';
  }

  @override
  String unlockedCount(Object count) {
    return 'Unlocked ($count)';
  }

  @override
  String lockedCount(Object count) {
    return 'Locked ($count)';
  }

  @override
  String get active => 'Active';

  @override
  String get paused => 'Paused';

  @override
  String get all => 'All';

  @override
  String get premiumTestingActivated => '🎉 Premium activated for testing';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removePermanentAds => 'Remove advertising';

  @override
  String get noAdvertising => 'No advertising';

  @override
  String get premiumThemesFeature => 'Premium themes';

  @override
  String get startPro => 'Start PRO';

  @override
  String get drinkWater => 'Drink water';

  @override
  String get exercise => 'Exercise';

  @override
  String get read => 'Read';

  @override
  String get completed => 'Completed';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get mondayFull => 'Monday';

  @override
  String get tuesdayFull => 'Tuesday';

  @override
  String get wednesdayFull => 'Wednesday';

  @override
  String get thursdayFull => 'Thursday';

  @override
  String get fridayFull => 'Friday';

  @override
  String get saturdayFull => 'Saturday';

  @override
  String get sundayFull => 'Sunday';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get pro => 'PRO';

  @override
  String get appInformation => 'App Information';

  @override
  String get appName => 'App Name';

  @override
  String get version => 'Version';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get supportedLanguages => 'Supported Languages';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get pending => 'Pending';

  @override
  String get monthly => 'Monthly';

  @override
  String get annual => 'Annual';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get limitedOffer => 'LIMITED OFFER';

  @override
  String get unlockFullPotential => 'Unlock the full potential of Ritmo';

  @override
  String get startWithRitmoPro => 'Start with Ritmo PRO';

  @override
  String get noAdvertisingFeature => 'No advertising';

  @override
  String get completelyCleanExperience => 'Completely clean experience';

  @override
  String get cloudBackup => 'Cloud backup';

  @override
  String get yourDataSafeInCloud => 'Your data safe in the cloud';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get intelligentRecommendations => 'Intelligent recommendations';

  @override
  String get chooseYourPlan => 'Choose your plan';

  @override
  String get beginnerlevel => 'Beginner';

  @override
  String get apprenticeLevel => 'Apprentice';

  @override
  String get dedicatedLevel => 'Dedicated';

  @override
  String get consistentLevel => 'Consistent';

  @override
  String get expertLevel => 'Expert';

  @override
  String get masterLevel => 'Master';

  @override
  String get legendLevel => 'Legend';

  @override
  String get championLevel => 'Champion';

  @override
  String get heroLevel => 'Hero';

  @override
  String get mythicLevel => 'Mythic';

  @override
  String get maximumLevel => 'Maximum';

  @override
  String get defaultUser => 'User';

  @override
  String get activateNotifications => 'Activate Notifications';

  @override
  String get updateAllNotificationsText => 'Update all notifications';

  @override
  String get notificationsRescheduledSuccessfully =>
      'Notifications rescheduled successfully';

  @override
  String get notificationHelp => 'Notification Help';

  @override
  String get helpWithNotifications => 'Help with Notifications';

  @override
  String get understood => 'Understood';

  @override
  String languagesCount(Object count) {
    return '$count languages';
  }

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get frequency => 'Frequency';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get nameMinTwoCharacters => 'Name must be at least 2 characters';

  @override
  String get basicInformationLabel => 'Basic Information';

  @override
  String get deleteWarningMessage =>
      'This action cannot be undone. All habit data including completion history will be deleted.';

  @override
  String get totalPoints => 'total points';

  @override
  String progressToLevel(Object level) {
    return 'Progress to level $level';
  }

  @override
  String get maxLevelReached => 'Max level reached!';

  @override
  String get maxStreak => 'Max Streak';

  @override
  String get tapToViewMore => 'Tap to view more';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get excellent => 'Excellent!';

  @override
  String pointsWithCount(Object count) {
    return '$count points';
  }

  @override
  String get unlockedLabel => 'Unlocked';

  @override
  String percentCompleted(Object percent) {
    return '$percent% Completed';
  }

  @override
  String get totalHabits => 'Total Habits';

  @override
  String percentThisWeek(Object percent) {
    return '$percent% This week';
  }

  @override
  String percentThisMonth(Object percent) {
    return '$percent% This month';
  }

  @override
  String get days => 'days';

  @override
  String get twoWeeks => '2 wks';

  @override
  String get oneMonth => '1 month';

  @override
  String weekNumber(Object number, Object year) {
    return 'Week $number of $year';
  }

  @override
  String dayOfMonth(Object day, Object total) {
    return 'Day $day of $total';
  }

  @override
  String dateFormat(Object day, Object month) {
    return '$day $month';
  }

  @override
  String dateRangeFormat(
      Object endDay, Object endMonth, Object startDay, Object startMonth) {
    return '$startDay $startMonth - $endDay $endMonth';
  }

  @override
  String monthYear(Object month, Object year) {
    return '$month $year';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get motivationPerfectDay =>
      'PERFECT! 🎆\\nYou completed EVERYTHING today.\\nYou\'re unstoppable!';

  @override
  String get motivationAlmostPerfect =>
      'Almost perfect! 🌟\\nJust a little bit left.\\nYou can do it!';

  @override
  String get motivationExcellentDay =>
      'Excellent day! 💪\\nYou\'re doing great.\\nKeep it up!';

  @override
  String get motivationGoodProgress =>
      'Good progress! 🚀\\nYou\'re on the right track.\\nDon\'t stop!';

  @override
  String get motivationStarted =>
      'You started! 🌱\\nEvery step counts.\\nContinue!';

  @override
  String get motivationFirstStep =>
      'First step! ⭐\\nThe hardest part is over.\\nKeep going!';

  @override
  String get motivationYourMoment =>
      'Your moment! 🌅\\nStart now.\\nMake it happen!';

  @override
  String get motivationPerfectWeek =>
      'PERFECT WEEK! 🏆\\nYou mastered all your rhythms.\\nYou\'re incredible!';

  @override
  String get motivationBrutalWeek =>
      'Brutal week! 🔥\\nAlmost perfect.\\nYou\'re a champion!';

  @override
  String get motivationGreatWeek =>
      'Great week! 💪\\nYour discipline pays off.\\nWell done!';

  @override
  String get motivationGoodRhythm =>
      'Good rhythm! 📈\\nYou\'re building.\\nKeep it up!';

  @override
  String get motivationProgressing =>
      'Progressing! 🌱\\nEvery week counts.\\nDon\'t stop!';

  @override
  String get motivationStartedWeek =>
      'Started! ✨\\nYou took the first step.\\nLet\'s improve!';

  @override
  String get motivationNewWeek => 'New week! 🌟\\nFresh start.\\nMake it epic!';

  @override
  String get motivationLegendaryMonth =>
      'LEGENDARY MONTH! 👑\\nTotal perfection.\\nYou\'re inspiration!';

  @override
  String get motivationEpicMonth =>
      'Epic month! 🎆\\nIncredible results.\\nUnstoppable!';

  @override
  String get motivationSolidMonth =>
      'Solid month! 💪\\nYour consistency pays off.\\nGreat work!';

  @override
  String get motivationGoodMonth =>
      'Good month! 📊\\nYou\'re progressing.\\nKeep improving!';

  @override
  String get motivationBuilding =>
      'Building! 🏗️\\nEvery month counts.\\nKeep going!';

  @override
  String get motivationSeedsPlanted =>
      'Seeds planted! 🌱\\nYou\'ve started.\\nYou\'ll grow!';

  @override
  String get motivationNewMonth =>
      'New month! 🚀\\nInfinite possibilities.\\nMake it yours!';

  @override
  String get motivationPerfectShort =>
      'PERFECT! You completed everything today';

  @override
  String get motivationAlmostPerfectShort =>
      'Almost perfect! Just a little bit left';

  @override
  String get motivationExcellentShort => 'Excellent day! You\'re doing great';

  @override
  String get motivationGoodProgressShort =>
      'Good progress! You\'re on the right track';

  @override
  String get motivationStartedShort => 'You started! Every step counts';

  @override
  String get motivationFirstStepShort => 'First step! The hardest part is over';

  @override
  String get motivationYourMomentShort => 'Your moment! Start now';

  @override
  String get statistics => 'Statistics';

  @override
  String get week => 'Week';

  @override
  String get trends => 'Trends';

  @override
  String get completedHabits => 'Completed';

  @override
  String get percentage => 'Percentage';

  @override
  String get progressToday => 'Today\'s Progress';

  @override
  String get completedCount => 'Completed';

  @override
  String get pendingCount => 'Pending';

  @override
  String get noHabitsToShow => 'No rhythms to show';

  @override
  String get todaysHabits => 'Today\'s Habits';

  @override
  String get noHabitsScheduledToday =>
      'You have no habits scheduled for today or you\'ve completed them all.';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get dayShortMon => 'M';

  @override
  String get dayShortTue => 'T';

  @override
  String get dayShortWed => 'W';

  @override
  String get dayShortThu => 'T';

  @override
  String get dayShortFri => 'F';

  @override
  String get dayShortSat => 'S';

  @override
  String get dayShortSun => 'S';

  @override
  String get weeklyHeatMap => 'Weekly Heat Map';

  @override
  String get legend => 'Legend';

  @override
  String get notScheduled => 'Not scheduled';

  @override
  String get week1 => 'W1';

  @override
  String get week2 => 'W2';

  @override
  String get week3 => 'W3';

  @override
  String get week4 => 'W4';

  @override
  String get weekHabits => 'Week Habits';

  @override
  String weekProgress(Object completed, Object total) {
    return '$completed of $total days';
  }

  @override
  String get habitLimitReached => 'Habit Limit Reached';

  @override
  String habitLimitMessage(Object limit) {
    return 'You\'ve reached the limit of $limit habits in the free plan.\n\nUpgrade to Ritmo PRO for unlimited habits and premium features!';
  }

  @override
  String get upgradeToPro => 'Upgrade to PRO';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationsDescription => 'Receive reminders for your habits';

  @override
  String get defaultReminderTime => 'Default Reminder Time';

  @override
  String get reminderSound => 'Reminder Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get soundDefault => 'Default';

  @override
  String get soundDefaultDesc => 'System default sound';

  @override
  String get soundNone => 'None (Silent)';

  @override
  String get soundNoneDesc => 'No sound';

  @override
  String get soundChime => 'Chime';

  @override
  String get soundChimeDesc => 'Soft bell chime';

  @override
  String get soundBell => 'Bell';

  @override
  String get soundBellDesc => 'Classic bell sound';

  @override
  String get loadingHabits => 'Loading your rhythms...';

  @override
  String get guestModeWarning => 'Guest mode - Your data will not be saved';

  @override
  String get createAccount => 'Create Account';

  @override
  String get saveYourProgressTitle => 'Save your progress';

  @override
  String get createAccountDescription =>
      'Create an account to save your rhythms and sync them across devices.';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get rhythmoPro => 'HábitoPro';

  @override
  String get productivityCoach => 'Your productivity coach';

  @override
  String get enjoyRitmoInterruptions =>
      'Enjoy Ritmo without interruptions with Ritmo PRO:';

  @override
  String get unlimitedHabits => 'Unlimited rhythms';

  @override
  String get advancedStats => 'Advanced statistics';

  @override
  String get pricingText => 'Only \$3.99/month - 20% less than competition';

  @override
  String get paywallComingSoon => 'Paywall coming soon';

  @override
  String get paywallNotImplementedTitle => 'Coming Soon';

  @override
  String get paywallNotImplementedMessage =>
      'The payment system is under development. For now, you can activate Ritmo PRO from Settings > \"Activate Premium (Testing)\".';

  @override
  String get paywallMainTitle => 'Unlock Ritmo\'s full potential';

  @override
  String get paywallChoosePlan => 'Choose your plan';

  @override
  String get paywallStartButton => 'Start with Ritmo PRO';

  @override
  String get paywallTermsAndConditions =>
      'By continuing, you accept our Terms of Service and Privacy Policy';

  @override
  String get manageHabitsTooltip => 'Manage habits';

  @override
  String get notificationTroubleshootingTips =>
      '• Verify that notifications are enabled in system settings\n• Make sure the app is not in \"Do Not Disturb\" mode\n• Check that habits have reminder times configured';

  @override
  String get loginTitle => 'HabitPro';

  @override
  String get loginSubtitle => 'Build better habits, day by day';

  @override
  String get signInButton => 'Sign In';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailValidationError => 'Please enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequiredError => 'Please enter your password';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get signInOrCreateAccount => 'Sign In';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get statsGoodMonth =>
      'Good month! 📊\nYou\'re progressing.\nKeep improving!';

  @override
  String get statsBuilding => 'Building! 🏗️\nEvery month counts.\nKeep going!';

  @override
  String get statsSeedsPlanted =>
      'Seeds planted! 🌱\nYou\'ve started.\nYou\'ll grow!';

  @override
  String get statsNewMonth =>
      'New month! 🚀\nInfinite possibilities.\nMake it yours!';

  @override
  String get signUp => 'Sign Up';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get nameRequiredError => 'Please enter your name';

  @override
  String get emailRequiredError => 'Please enter your email';

  @override
  String get firstStreakAchievement => 'First Streak';

  @override
  String get weekWarriorAchievement => 'Week Warrior';

  @override
  String get monthMasterAchievement => 'Month Master';

  @override
  String get firstStepAchievement => 'First Step';

  @override
  String get centuryClubAchievement => 'Century Club';

  @override
  String get marathonRunnerAchievement => 'Marathon Runner';

  @override
  String get perfectWeekAchievement => 'Perfect Week';

  @override
  String get rhythmCollectorAchievement => 'Collector';

  @override
  String get rhythmMasterAchievement => 'Rhythm Master';

  @override
  String streakFormat(num streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get notificationsToRemindHabits =>
      'Notifications to remind you to complete your daily rhythms';

  @override
  String get rhythmReminderTicker => 'Habit reminder';

  @override
  String get defaultHabitReminder => 'Time to work on your rhythm!';

  @override
  String get testNotificationBody => 'Notification system working correctly!';

  @override
  String get rhythmUpdatedMessage => 'Habit updated!';

  @override
  String get openSystemSettingsMessage =>
      'Open system settings to manage notifications';

  @override
  String get notReceivingReminders => 'Not receiving reminders?';

  @override
  String get rhythmDeletedMessage => 'Habit deleted';

  @override
  String get updateError => 'Error updating rhythm';

  @override
  String get deleteError => 'Error deleting rhythm';

  @override
  String get habitUpdatedMessage => 'Rhythm updated!';

  @override
  String get habitDeletedMessage => 'Rhythm deleted';

  @override
  String get habitNameLabel => 'Rhythm Name';

  @override
  String get habitReminders => 'Rhythm Reminders';

  @override
  String get habitReminderTicker => 'Rhythm reminder';

  @override
  String get habitStreaks => 'Rhythm Streaks';

  @override
  String get habitCollectorAchievement => 'Rhythm Collector';

  @override
  String get habitCreatedSuccessfully => 'Rhythm created successfully';

  @override
  String get habitNameHint => 'E.g: Exercise, Read, Meditate...';

  @override
  String get welcomeToRitmoPro => 'Welcome to Ritmo PRO! 🎉';

  @override
  String get purchaseError => 'Purchase error';

  @override
  String get googleLogin => 'Google';

  @override
  String get send => 'Send';

  @override
  String get passwordResetMessage =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get errorCreatingHabit => 'Error creating habit';

  @override
  String languageChangedTo(Object languageName) {
    return 'Language changed to $languageName';
  }

  @override
  String get genericError => 'Error';

  @override
  String get themeExecutiveMinimalist => '💼 Executive Minimalist';

  @override
  String get themeGlassmorphism => '✨ Glassmorphism';

  @override
  String get themeNeumorphism => '🎭 Neumorphism';

  @override
  String get allDoneForToday => 'All done for today!';

  @override
  String get welcomeToRitmo => 'Welcome to Ritmo!';

  @override
  String get startYourJourney =>
      'Start your journey to better habits by creating your first daily habit.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get continuingAsGuest => 'Continuing as guest';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get frequencyType => 'Frequency Type';

  @override
  String get frequencyTypeDaily => 'Every day';

  @override
  String get frequencyTypeWeekdays => 'Weekdays only';

  @override
  String get frequencyTypeCustom => 'Custom days';

  @override
  String get frequencyTypeWeekly => 'X days per week';

  @override
  String get selectFrequencyType =>
      'Select how often you want to do this habit';

  @override
  String get dailyDescription => 'Do this habit every single day';

  @override
  String get weekdaysDescription => 'Monday through Friday only';

  @override
  String get customDescription => 'Choose specific days of the week';

  @override
  String get weeklyDescription => 'Choose how many days per week (flexible)';

  @override
  String get daysPerWeek => 'Days per week';

  @override
  String get selectDaysPerWeek => 'How many days per week?';

  @override
  String timesPerWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'times',
      one: 'time',
    );
    return '$count $_temp0 per week';
  }

  @override
  String get atLeastOncePerWeek => 'At least once per week';

  @override
  String targetDaysPerWeek(Object count) {
    return '$count days per week';
  }

  @override
  String get weeklyTargetMet => '✓ Weekly target met!';

  @override
  String weeklyTargetProgress(Object completed, Object target) {
    return '$completed of $target days this week';
  }

  @override
  String weeklyStreakLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$count $_temp0 streak';
  }

  @override
  String dailyStreakLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$count $_temp0 streak';
  }

  @override
  String bonusPoints(Object points) {
    return '+$points bonus points!';
  }

  @override
  String get weeklyBonusEarned => 'Weekly target completed! +10 bonus points';

  @override
  String get frequencyTypeRequired => 'Please select a frequency type';

  @override
  String get weeklyTargetRequired => 'Please select how many days per week';

  @override
  String get notificationTroubleshootingTitle => 'Not receiving notifications?';

  @override
  String get notificationTroubleshootingBullet1 =>
      '• Verify that notifications are enabled in system settings';

  @override
  String get notificationTroubleshootingBullet2 =>
      '• Make sure the app has notification permissions';

  @override
  String get notificationTroubleshootingBullet3 =>
      '• Check that \'Do Not Disturb\' mode is off';

  @override
  String get notificationTroubleshootingBullet4 =>
      '• Try rescheduling notifications with the button above';

  @override
  String get errorOccurred => 'Error';
}
