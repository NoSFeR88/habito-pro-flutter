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
  String get rhythmUpdated => 'Habit updated!';

  @override
  String get edit => 'Editează';

  @override
  String get viewStatistics => 'Vezi statistici';

  @override
  String get delete => 'Șterge';

  @override
  String get deleteHabit => 'Șterge obiceiul';

  @override
  String confirmDeleteHabit(String rhythmName, Object habitName) {
    return 'Ești sigur că vrei să ștergi \"$habitName\"?';
  }

  @override
  String get cancel => 'Anulează';

  @override
  String rhythmDeleted(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
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
  String notificationScheduled(String rhythmName, String dateTime) {
    return 'Notificare programată pentru 5 secunde';
  }

  @override
  String get notificationsRescheduled => 'Notificări reprogramate cu succes';

  @override
  String get pendingNotifications => 'Notificări În Așteptare';

  @override
  String get noPendingNotifications => 'Nicio notificare în așteptare';

  @override
  String get close => 'Închide';

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
  String get manageHabits => 'Manage Habits';

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
  String get editHabit => 'Edit Habit';

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
  String rhythmUpdatedSuccess(String rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String errorUpdatingHabit(String error) {
    return 'Error updating rhythm: $error';
  }

  @override
  String get deleteHabitTitle => 'Delete rhythm';

  @override
  String deleteHabitConfirmation(String rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.';
  }

  @override
  String rhythmDeletedSuccess(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String errorDeletingHabit(String error) {
    return 'Error deleting rhythm: $error';
  }

  @override
  String limitReached(int maxHabits) {
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
  String loginError(String error) {
    return 'Login error: $error';
  }

  @override
  String logoutError(String error) {
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
  String authError(String message) {
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
      'All your rhythms are paused. Reactivate some or create a new one.';

  @override
  String get startJourneyBetterHabits =>
      'Start your journey towards better rhythms by creating your first daily rhythm.';

  @override
  String get createNewHabit => 'Create new rhythm';

  @override
  String get createMyFirstHabit => 'Create my first rhythm';

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
  String notificationsCancelled(String rhythmId) {
    return '✅ Cancelled notifications for rhythm $rhythmId';
  }

  @override
  String errorCancellingNotifications(String rhythmId, String error) {
    return '❌ Error cancelling notifications for rhythm $rhythmId: $error';
  }

  @override
  String instantNotificationSent(String title) {
    return '✅ Instant notification sent: $title';
  }

  @override
  String errorSendingNotification(String error) {
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
  String errorSchedulingTestNotification(String error) {
    return '❌ Error scheduling test notification: $error';
  }

  @override
  String localizationInitialized(String languageCode) {
    return '✅ Localization initialized: $languageCode';
  }

  @override
  String notificationReceivediOS(String title) {
    return '📱 Notification received on iOS: $title';
  }

  @override
  String userTappedNotification(String payload) {
    return '📱 User tapped notification: $payload';
  }

  @override
  String rhythmUpdatedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String confirmDeleteHabitMessage(String rhythmName) {
    return 'Are you sure you want to delete \"$rhythmName\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.';
  }

  @override
  String rhythmDeletedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String rhythmCreatedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" created successfully';
  }

  @override
  String confirmDeleteHabitShort(String rhythmName) {
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
  String pointsToLevel(int points, int level) {
    return '$points points to level $level';
  }

  @override
  String unlockedCount(int count) {
    return 'Unlocked ($count)';
  }

  @override
  String lockedCount(int count) {
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
  String languagesCount(int count) {
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
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get nameMinTwoCharacters => 'Name must be at least 2 characters';

  @override
  String get totalPoints => 'total points';

  @override
  String progressToLevel(int level) {
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
  String pointsWithCount(int count) {
    return '$count points';
  }

  @override
  String get unlockedLabel => 'Unlocked';

  @override
  String percentCompleted(int percent) {
    return '$percent% Completed';
  }

  @override
  String get totalHabits => 'Total Habits';

  @override
  String percentThisWeek(int percent) {
    return '$percent% This week';
  }

  @override
  String percentThisMonth(int percent) {
    return '$percent% This month';
  }

  @override
  String get days => 'days';

  @override
  String get twoWeeks => '2 wks';

  @override
  String get oneMonth => '1 month';

  @override
  String weekNumber(int number, int year) {
    return 'Week $number of $year';
  }

  @override
  String dayOfMonth(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String dateFormat(int day, String month) {
    return '$day $month';
  }

  @override
  String dateRangeFormat(
      int startDay, String startMonth, int endDay, String endMonth) {
    return '$startDay $startMonth - $endDay $endMonth';
  }

  @override
  String monthYear(String month, int year) {
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
  String get noHabitsScheduledToday => 'No rhythms scheduled for today';

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
  String get loadingHabits => 'Loading your rhythms...';

  @override
  String get guestModeWarning => 'Guest mode - Your data will not be saved';

  @override
  String get createAccount => 'Create account';

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
  String streakFormat(int streak) {
    return '$streak days';
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
}
