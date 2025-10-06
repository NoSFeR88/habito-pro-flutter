import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RITMO'**
  String get appTitle;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'RITMO'**
  String get homeAppBarTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingApp.
  ///
  /// In en, this message translates to:
  /// **'Starting Ritmo...'**
  String get loadingApp;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @todayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Today • {date}'**
  String todayWithDate(Object date);

  /// No description provided for @allDoneToday.
  ///
  /// In en, this message translates to:
  /// **'All done for today!'**
  String get allDoneToday;

  /// No description provided for @noProgrammedHabits.
  ///
  /// In en, this message translates to:
  /// **'You have no rhythms scheduled for today or you\'ve completed them all.'**
  String get noProgrammedHabits;

  /// No description provided for @createFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Create my first rhythm'**
  String get createFirstHabit;

  /// No description provided for @rhythmUpdated.
  ///
  /// In en, this message translates to:
  /// **'Habit updated!'**
  String get rhythmUpdated;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @viewStatistics.
  ///
  /// In en, this message translates to:
  /// **'View statistics'**
  String get viewStatistics;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Delete rhythm'**
  String get deleteHabit;

  /// No description provided for @confirmDeleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{rhythmName}\"?'**
  String confirmDeleteHabit(Object habitName, Object rhythmName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @rhythmDeleted.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" deleted'**
  String rhythmDeleted(Object rhythmName);

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ritmo!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The only rhythm app that adapts to YOUR real life'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingFeatureFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible rhythms adapted to you'**
  String get onboardingFeatureFlexible;

  /// No description provided for @onboardingFeatureMotivating.
  ///
  /// In en, this message translates to:
  /// **'Motivating design that inspires'**
  String get onboardingFeatureMotivating;

  /// No description provided for @onboardingFeature26Languages.
  ///
  /// In en, this message translates to:
  /// **'26 languages - Market leader'**
  String get onboardingFeature26Languages;

  /// No description provided for @onboardingDiscoverDifference.
  ///
  /// In en, this message translates to:
  /// **'Discover the difference'**
  String get onboardingDiscoverDifference;

  /// No description provided for @onboardingProblemTitle.
  ///
  /// In en, this message translates to:
  /// **'Tired of overly rigid apps?'**
  String get onboardingProblemTitle;

  /// No description provided for @onboardingOtherApps.
  ///
  /// In en, this message translates to:
  /// **'Other apps'**
  String get onboardingOtherApps;

  /// No description provided for @onboardingProblemExample.
  ///
  /// In en, this message translates to:
  /// **'Gym EVERY day ❌'**
  String get onboardingProblemExample;

  /// No description provided for @onboardingSolutionExample.
  ///
  /// In en, this message translates to:
  /// **'Gym Mon-Wed-Fri ✅ (YOUR rhythm)'**
  String get onboardingSolutionExample;

  /// No description provided for @onboardingFlexibilityMessage.
  ///
  /// In en, this message translates to:
  /// **'Your life is unique. Your rhythms should be too.'**
  String get onboardingFlexibilityMessage;

  /// No description provided for @onboardingThisSounds.
  ///
  /// In en, this message translates to:
  /// **'This sounds familiar'**
  String get onboardingThisSounds;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first flexible rhythm'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingFlexibilityTip.
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: Choose realistic days for your lifestyle'**
  String get onboardingFlexibilityTip;

  /// No description provided for @onboardingCreateFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Create my first rhythm'**
  String get onboardingCreateFirstHabit;

  /// No description provided for @onboardingExampleHabitName.
  ///
  /// In en, this message translates to:
  /// **'Go to the gym'**
  String get onboardingExampleHabitName;

  /// No description provided for @onboardingCelebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect! You have your rhythm'**
  String get onboardingCelebrationTitle;

  /// No description provided for @onboardingCelebrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your first flexible rhythm is ready to begin'**
  String get onboardingCelebrationSubtitle;

  /// No description provided for @onboardingDefaultHabitName.
  ///
  /// In en, this message translates to:
  /// **'My first rhythm'**
  String get onboardingDefaultHabitName;

  /// No description provided for @onboardingNoDaysSelected.
  ///
  /// In en, this message translates to:
  /// **'No days selected'**
  String get onboardingNoDaysSelected;

  /// No description provided for @onboardingBenefitFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Total flexibility'**
  String get onboardingBenefitFlexibility;

  /// No description provided for @onboardingBenefitMotivation.
  ///
  /// In en, this message translates to:
  /// **'Constant motivation'**
  String get onboardingBenefitMotivation;

  /// No description provided for @onboardingBenefit26Languages.
  ///
  /// In en, this message translates to:
  /// **'26 languages available'**
  String get onboardingBenefit26Languages;

  /// No description provided for @onboardingStartMyRhythm.
  ///
  /// In en, this message translates to:
  /// **'Start my rhythm'**
  String get onboardingStartMyRhythm;

  /// No description provided for @rhythmName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get rhythmName;

  /// No description provided for @rhythmNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Exercise, Read, Meditate...'**
  String get rhythmNameHint;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Select days'**
  String get selectDays;

  /// No description provided for @januaryShort.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get januaryShort;

  /// No description provided for @februaryShort.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get februaryShort;

  /// No description provided for @marchShort.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get marchShort;

  /// No description provided for @aprilShort.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get aprilShort;

  /// No description provided for @mayShort.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get mayShort;

  /// No description provided for @juneShort.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get juneShort;

  /// No description provided for @julyShort.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get julyShort;

  /// No description provided for @augustShort.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get augustShort;

  /// No description provided for @septemberShort.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get septemberShort;

  /// No description provided for @octoberShort.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get octoberShort;

  /// No description provided for @novemberShort.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get novemberShort;

  /// No description provided for @decemberShort.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get decemberShort;

  /// No description provided for @newHabit.
  ///
  /// In en, this message translates to:
  /// **'New Rhythm'**
  String get newHabit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @statsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsToday;

  /// No description provided for @statsWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsWeek;

  /// No description provided for @statsMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsMonth;

  /// No description provided for @notificationTests.
  ///
  /// In en, this message translates to:
  /// **'Notification Tests'**
  String get notificationTests;

  /// No description provided for @immediateNotification.
  ///
  /// In en, this message translates to:
  /// **'Immediate Notification'**
  String get immediateNotification;

  /// No description provided for @showNotificationNow.
  ///
  /// In en, this message translates to:
  /// **'Show notification right now'**
  String get showNotificationNow;

  /// No description provided for @scheduledNotification.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Notification'**
  String get scheduledNotification;

  /// No description provided for @scheduleIn5Seconds.
  ///
  /// In en, this message translates to:
  /// **'Schedule notification in 5 seconds'**
  String get scheduleIn5Seconds;

  /// No description provided for @rescheduleAllHabits.
  ///
  /// In en, this message translates to:
  /// **'Reschedule All Habits'**
  String get rescheduleAllHabits;

  /// No description provided for @updateAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Update all notifications'**
  String get updateAllNotifications;

  /// No description provided for @viewPendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'View Pending Notifications'**
  String get viewPendingNotifications;

  /// No description provided for @showScheduledNotifications.
  ///
  /// In en, this message translates to:
  /// **'Show scheduled notifications'**
  String get showScheduledNotifications;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Notification sent! Check your notification bar'**
  String get notificationSent;

  /// No description provided for @notificationScheduled.
  ///
  /// In en, this message translates to:
  /// **'✅ Notification scheduled: {rhythmName} - {dateTime}'**
  String notificationScheduled(Object dateTime, Object rhythmName);

  /// No description provided for @notificationsRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Notifications rescheduled successfully'**
  String get notificationsRescheduled;

  /// No description provided for @pendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Pending Notifications'**
  String get pendingNotifications;

  /// No description provided for @noPendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'No pending notifications'**
  String get noPendingNotifications;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @rhythmStreaks.
  ///
  /// In en, this message translates to:
  /// **'Habit Streaks'**
  String get rhythmStreaks;

  /// No description provided for @monthlyCalendar.
  ///
  /// In en, this message translates to:
  /// **'Monthly Calendar'**
  String get monthlyCalendar;

  /// No description provided for @monthlyStats.
  ///
  /// In en, this message translates to:
  /// **'Monthly Statistics'**
  String get monthlyStats;

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get activeDays;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @averageCompletion.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averageCompletion;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @themeBasicBlue.
  ///
  /// In en, this message translates to:
  /// **'Basic Blue'**
  String get themeBasicBlue;

  /// No description provided for @themeBasicGreen.
  ///
  /// In en, this message translates to:
  /// **'Basic Green'**
  String get themeBasicGreen;

  /// No description provided for @themeBasicPurple.
  ///
  /// In en, this message translates to:
  /// **'Basic Purple'**
  String get themeBasicPurple;

  /// No description provided for @themeCyberNeon.
  ///
  /// In en, this message translates to:
  /// **'🌟 Cyber Neon'**
  String get themeCyberNeon;

  /// No description provided for @themeAuroraInspiration.
  ///
  /// In en, this message translates to:
  /// **'🎨 Aurora Inspiration'**
  String get themeAuroraInspiration;

  /// No description provided for @themeZenGarden.
  ///
  /// In en, this message translates to:
  /// **'🧘 Zen Garden'**
  String get themeZenGarden;

  /// No description provided for @premiumThemes.
  ///
  /// In en, this message translates to:
  /// **'Premium Themes'**
  String get premiumThemes;

  /// No description provided for @activatePremium.
  ///
  /// In en, this message translates to:
  /// **'Activate Premium (Testing)'**
  String get activatePremium;

  /// No description provided for @premiumPrice.
  ///
  /// In en, this message translates to:
  /// **'\$2.99/month'**
  String get premiumPrice;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageHabits.
  ///
  /// In en, this message translates to:
  /// **'Manage Rhythms'**
  String get manageHabits;

  /// No description provided for @noActiveHabits.
  ///
  /// In en, this message translates to:
  /// **'No active rhythms'**
  String get noActiveHabits;

  /// No description provided for @createFirstHabitToStart.
  ///
  /// In en, this message translates to:
  /// **'Create your first rhythm to get started'**
  String get createFirstHabitToStart;

  /// No description provided for @noPausedHabits.
  ///
  /// In en, this message translates to:
  /// **'No paused rhythms'**
  String get noPausedHabits;

  /// No description provided for @pausedHabitsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Paused rhythms will appear here'**
  String get pausedHabitsWillAppearHere;

  /// No description provided for @noHabits.
  ///
  /// In en, this message translates to:
  /// **'You have no rhythms'**
  String get noHabits;

  /// No description provided for @startJourneyCreatingFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Start your journey by creating your first rhythm'**
  String get startJourneyCreatingFirstHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this rhythm?'**
  String get deleteHabitConfirm;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit Rhythm'**
  String get editHabit;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @rhythmNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get rhythmNameLabel;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'E.g: 8 glasses per day, 30 minutes...'**
  String get descriptionHint;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @allDays.
  ///
  /// In en, this message translates to:
  /// **'All days'**
  String get allDays;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @deleteHabitButton.
  ///
  /// In en, this message translates to:
  /// **'Delete rhythm'**
  String get deleteHabitButton;

  /// No description provided for @deleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All rhythm data including completion history will be deleted.'**
  String get deleteWarning;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one day of the week'**
  String get selectAtLeastOneDay;

  /// No description provided for @rhythmUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" updated successfully'**
  String rhythmUpdatedSuccess(Object rhythmName);

  /// No description provided for @errorUpdatingHabit.
  ///
  /// In en, this message translates to:
  /// **'Error updating rhythm: {error}'**
  String errorUpdatingHabit(Object error);

  /// No description provided for @deleteHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete rhythm'**
  String get deleteHabitTitle;

  /// No description provided for @deleteHabitConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{rhythmName}\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.'**
  String deleteHabitConfirmation(Object rhythmName);

  /// No description provided for @rhythmDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" deleted'**
  String rhythmDeletedSuccess(Object rhythmName);

  /// No description provided for @errorDeletingHabit.
  ///
  /// In en, this message translates to:
  /// **'Error deleting rhythm: {error}'**
  String errorDeletingHabit(Object error);

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit reached: maximum {maxHabits} rhythms in free plan.'**
  String limitReached(Object maxHabits);

  /// No description provided for @premiumThemesOnly.
  ///
  /// In en, this message translates to:
  /// **'Premium themes are only available in Ritmo PRO.'**
  String get premiumThemesOnly;

  /// No description provided for @advancedStatsOnly.
  ///
  /// In en, this message translates to:
  /// **'Advanced statistics available in Ritmo PRO.'**
  String get advancedStatsOnly;

  /// No description provided for @exportDataOnly.
  ///
  /// In en, this message translates to:
  /// **'Export data is available in Ritmo PRO.'**
  String get exportDataOnly;

  /// No description provided for @aiInsightsOnly.
  ///
  /// In en, this message translates to:
  /// **'AI Insights are available in Ritmo PRO.'**
  String get aiInsightsOnly;

  /// No description provided for @featureOnlyInPro.
  ///
  /// In en, this message translates to:
  /// **'This feature is available in Ritmo PRO.'**
  String get featureOnlyInPro;

  /// No description provided for @loadingYourHabits.
  ///
  /// In en, this message translates to:
  /// **'Loading your rhythms...'**
  String get loadingYourHabits;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest mode - Your data will not be saved'**
  String get guestMode;

  /// No description provided for @createAccountToSave.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save your rhythms and sync them across devices.'**
  String get createAccountToSave;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error: {error}'**
  String loginError(Object error);

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String logoutError(Object error);

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password.'**
  String get wrongPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Email is not valid.'**
  String get invalidEmail;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get tooManyAttempts;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Check your internet.'**
  String get connectionError;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error: {message}'**
  String authError(Object message);

  /// No description provided for @champion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get champion;

  /// No description provided for @hero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get hero;

  /// No description provided for @mythic.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get mythic;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @completeFirstHabit3Days.
  ///
  /// In en, this message translates to:
  /// **'Complete your first rhythm 3 days in a row'**
  String get completeFirstHabit3Days;

  /// No description provided for @maintain7DayStreak.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 7-day streak'**
  String get maintain7DayStreak;

  /// No description provided for @maintain30DayStreak.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 30-day streak'**
  String get maintain30DayStreak;

  /// No description provided for @completeFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Complete your first rhythm'**
  String get completeFirstHabit;

  /// No description provided for @complete100Habits.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 rhythms total'**
  String get complete100Habits;

  /// No description provided for @complete500Habits.
  ///
  /// In en, this message translates to:
  /// **'Complete 500 rhythms total'**
  String get complete500Habits;

  /// No description provided for @completeAllHabitsWeek.
  ///
  /// In en, this message translates to:
  /// **'Complete all your rhythms during a week'**
  String get completeAllHabitsWeek;

  /// No description provided for @create5DifferentHabits.
  ///
  /// In en, this message translates to:
  /// **'Create 5 different rhythms'**
  String get create5DifferentHabits;

  /// No description provided for @reachLevel5.
  ///
  /// In en, this message translates to:
  /// **'Reach level 5'**
  String get reachLevel5;

  /// No description provided for @noHabitsToday.
  ///
  /// In en, this message translates to:
  /// **'You have no rhythms scheduled for today or you\'ve completed them all.'**
  String get noHabitsToday;

  /// No description provided for @allHabitsPaused.
  ///
  /// In en, this message translates to:
  /// **'All your habits are paused. Reactivate one or create a new one.'**
  String get allHabitsPaused;

  /// No description provided for @startJourneyBetterHabits.
  ///
  /// In en, this message translates to:
  /// **'Start your journey towards better rhythms by creating your first daily rhythm.'**
  String get startJourneyBetterHabits;

  /// No description provided for @createNewHabit.
  ///
  /// In en, this message translates to:
  /// **'Create new habit'**
  String get createNewHabit;

  /// No description provided for @createMyFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Create my first habit'**
  String get createMyFirstHabit;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @receiveRemindersForHabits.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders for your rhythms'**
  String get receiveRemindersForHabits;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings to manage notifications'**
  String get openSystemSettings;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @rhythmReminders.
  ///
  /// In en, this message translates to:
  /// **'Habit Reminders'**
  String get rhythmReminders;

  /// No description provided for @notificationsToRemind.
  ///
  /// In en, this message translates to:
  /// **'Notifications to remind you to complete your daily rhythms'**
  String get notificationsToRemind;

  /// No description provided for @reminderTicker.
  ///
  /// In en, this message translates to:
  /// **'Habit reminder'**
  String get reminderTicker;

  /// No description provided for @timeToWorkOnHabit.
  ///
  /// In en, this message translates to:
  /// **'Time to work on your rhythm!'**
  String get timeToWorkOnHabit;

  /// No description provided for @notificationsCancelled.
  ///
  /// In en, this message translates to:
  /// **'✅ Cancelled notifications for rhythm {rhythmId}'**
  String notificationsCancelled(Object rhythmId);

  /// No description provided for @errorCancellingNotifications.
  ///
  /// In en, this message translates to:
  /// **'❌ Error cancelling notifications for rhythm {rhythmId}: {error}'**
  String errorCancellingNotifications(Object error, Object rhythmId);

  /// No description provided for @instantNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'✅ Instant notification sent: {title}'**
  String instantNotificationSent(Object title);

  /// No description provided for @errorSendingNotification.
  ///
  /// In en, this message translates to:
  /// **'❌ Error sending instant notification: {error}'**
  String errorSendingNotification(Object error);

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'🧪 Test Notification'**
  String get testNotificationTitle;

  /// No description provided for @scheduledNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ Scheduled Notification'**
  String get scheduledNotificationTitle;

  /// No description provided for @scheduledNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This notification was scheduled 5 seconds ago'**
  String get scheduledNotificationBody;

  /// No description provided for @testNotificationScheduled.
  ///
  /// In en, this message translates to:
  /// **'✅ Test notification scheduled for 5 seconds'**
  String get testNotificationScheduled;

  /// No description provided for @errorSchedulingTestNotification.
  ///
  /// In en, this message translates to:
  /// **'❌ Error scheduling test notification: {error}'**
  String errorSchedulingTestNotification(Object error);

  /// No description provided for @localizationInitialized.
  ///
  /// In en, this message translates to:
  /// **'✅ Localization initialized: {languageCode}'**
  String localizationInitialized(Object languageCode);

  /// No description provided for @notificationReceivediOS.
  ///
  /// In en, this message translates to:
  /// **'📱 Notification received on iOS: {title}'**
  String notificationReceivediOS(Object title);

  /// No description provided for @userTappedNotification.
  ///
  /// In en, this message translates to:
  /// **'📱 User tapped notification: {payload}'**
  String userTappedNotification(Object payload);

  /// No description provided for @rhythmUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" updated successfully'**
  String rhythmUpdatedSuccessfully(Object rhythmName);

  /// No description provided for @confirmDeleteHabitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{rhythmName}\"?\\n\\nThis action cannot be undone. All rhythm data including completion history will be deleted.'**
  String confirmDeleteHabitMessage(Object rhythmName);

  /// No description provided for @rhythmDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" deleted'**
  String rhythmDeletedSuccessfully(Object rhythmName);

  /// No description provided for @rhythmCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Habit \"{rhythmName}\" created successfully'**
  String rhythmCreatedSuccessfully(Object rhythmName);

  /// No description provided for @confirmDeleteHabitShort.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{rhythmName}\"?'**
  String confirmDeleteHabitShort(Object rhythmName);

  /// No description provided for @ensureAppNotInDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'• Make sure the app is not in \"Do Not Disturb\" mode\\n'**
  String get ensureAppNotInDoNotDisturb;

  /// No description provided for @firstStreak.
  ///
  /// In en, this message translates to:
  /// **'First Streak'**
  String get firstStreak;

  /// No description provided for @firstStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first rhythm 3 days in a row'**
  String get firstStreakDescription;

  /// No description provided for @weekWarrior.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get weekWarrior;

  /// No description provided for @weekWarriorDescription.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 7-day streak'**
  String get weekWarriorDescription;

  /// No description provided for @monthMaster.
  ///
  /// In en, this message translates to:
  /// **'Month Master'**
  String get monthMaster;

  /// No description provided for @monthMasterDescription.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 30-day streak'**
  String get monthMasterDescription;

  /// No description provided for @firstStep.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get firstStep;

  /// No description provided for @firstStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first rhythm'**
  String get firstStepDescription;

  /// No description provided for @centuryClub.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get centuryClub;

  /// No description provided for @centuryClubDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 rhythms total'**
  String get centuryClubDescription;

  /// No description provided for @marathonRunner.
  ///
  /// In en, this message translates to:
  /// **'Marathon Runner'**
  String get marathonRunner;

  /// No description provided for @marathonRunnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete 500 rhythms total'**
  String get marathonRunnerDescription;

  /// No description provided for @perfectWeek.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get perfectWeek;

  /// No description provided for @perfectWeekDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete all your rhythms during a week'**
  String get perfectWeekDescription;

  /// No description provided for @rhythmCreator.
  ///
  /// In en, this message translates to:
  /// **'Habit Creator'**
  String get rhythmCreator;

  /// No description provided for @rhythmCreatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Create 5 different rhythms'**
  String get rhythmCreatorDescription;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @totalAccumulated.
  ///
  /// In en, this message translates to:
  /// **'Total accumulated'**
  String get totalAccumulated;

  /// No description provided for @achievementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsLabel;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @maxDays.
  ///
  /// In en, this message translates to:
  /// **'Max days'**
  String get maxDays;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @pointsToNext.
  ///
  /// In en, this message translates to:
  /// **'Points to next'**
  String get pointsToNext;

  /// No description provided for @allAchievements.
  ///
  /// In en, this message translates to:
  /// **'All Achievements'**
  String get allAchievements;

  /// No description provided for @progressToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'Progress to Next Level'**
  String get progressToNextLevel;

  /// No description provided for @paywallMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywallMonthly;

  /// No description provided for @paywallAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get paywallAnnual;

  /// No description provided for @paywallLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get paywallLifetime;

  /// No description provided for @paywallPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get paywallPerMonth;

  /// No description provided for @paywallPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get paywallPerYear;

  /// No description provided for @paywallOneTimePayment.
  ///
  /// In en, this message translates to:
  /// **'one-time payment'**
  String get paywallOneTimePayment;

  /// No description provided for @paywallDiscount.
  ///
  /// In en, this message translates to:
  /// **'37% OFF'**
  String get paywallDiscount;

  /// No description provided for @paywallLimitedOffer.
  ///
  /// In en, this message translates to:
  /// **'LIMITED OFFER'**
  String get paywallLimitedOffer;

  /// No description provided for @paywallUnlimitedHabits.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Habits'**
  String get paywallUnlimitedHabits;

  /// No description provided for @paywallUnlimitedHabitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create all the habits you want'**
  String get paywallUnlimitedHabitsDesc;

  /// No description provided for @paywallAdvancedStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced Statistics'**
  String get paywallAdvancedStats;

  /// No description provided for @paywallAdvancedStatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep analysis and trends'**
  String get paywallAdvancedStatsDesc;

  /// No description provided for @paywallPremiumThemes.
  ///
  /// In en, this message translates to:
  /// **'5 Premium Themes'**
  String get paywallPremiumThemes;

  /// No description provided for @paywallPremiumThemesDesc.
  ///
  /// In en, this message translates to:
  /// **'Ocean, Sunset, Forest and more'**
  String get paywallPremiumThemesDesc;

  /// No description provided for @paywallNoAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get paywallNoAds;

  /// No description provided for @paywallNoAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Completely clean experience'**
  String get paywallNoAdsDesc;

  /// No description provided for @paywallAutoBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic Backup'**
  String get paywallAutoBackup;

  /// No description provided for @paywallAutoBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Your data safe in the cloud'**
  String get paywallAutoBackupDesc;

  /// No description provided for @paywallAiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get paywallAiInsights;

  /// No description provided for @paywallAiInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart recommendations'**
  String get paywallAiInsightsDesc;

  /// No description provided for @paywallErrorCreatingHabit.
  ///
  /// In en, this message translates to:
  /// **'Error creating habit'**
  String get paywallErrorCreatingHabit;

  /// No description provided for @paywallErrorLogin.
  ///
  /// In en, this message translates to:
  /// **'Anonymous login error'**
  String get paywallErrorLogin;

  /// No description provided for @paywallErrorGoogleLogin.
  ///
  /// In en, this message translates to:
  /// **'Google login error'**
  String get paywallErrorGoogleLogin;

  /// No description provided for @paywallErrorEmailLogin.
  ///
  /// In en, this message translates to:
  /// **'Email login error'**
  String get paywallErrorEmailLogin;

  /// No description provided for @paywallErrorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get paywallErrorRegistration;

  /// No description provided for @paywallErrorLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout error'**
  String get paywallErrorLogout;

  /// No description provided for @paywallErrorPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Error sending password reset email'**
  String get paywallErrorPasswordReset;

  /// No description provided for @paywallErrorDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account'**
  String get paywallErrorDeleteAccount;

  /// No description provided for @paywallErrorUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get paywallErrorUpdateProfile;

  /// No description provided for @paywallErrorGetUserData.
  ///
  /// In en, this message translates to:
  /// **'Error getting user data'**
  String get paywallErrorGetUserData;

  /// No description provided for @paywallErrorUpdatePreferences.
  ///
  /// In en, this message translates to:
  /// **'Error updating preferences'**
  String get paywallErrorUpdatePreferences;

  /// No description provided for @paywallErrorUpdatePremium.
  ///
  /// In en, this message translates to:
  /// **'Error updating premium status'**
  String get paywallErrorUpdatePremium;

  /// No description provided for @paywallErrorLinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Error linking account'**
  String get paywallErrorLinkAccount;

  /// No description provided for @paywallErrorGetHabits.
  ///
  /// In en, this message translates to:
  /// **'Error getting habits'**
  String get paywallErrorGetHabits;

  /// No description provided for @paywallErrorUpdateHabit.
  ///
  /// In en, this message translates to:
  /// **'Error updating habit'**
  String get paywallErrorUpdateHabit;

  /// No description provided for @paywallErrorDeleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Error deleting habit'**
  String get paywallErrorDeleteHabit;

  /// No description provided for @paywallErrorHabitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Habit not found'**
  String get paywallErrorHabitNotFound;

  /// No description provided for @paywallErrorUpdateCompletion.
  ///
  /// In en, this message translates to:
  /// **'Error updating completion'**
  String get paywallErrorUpdateCompletion;

  /// No description provided for @paywallErrorGetStats.
  ///
  /// In en, this message translates to:
  /// **'Error getting statistics'**
  String get paywallErrorGetStats;

  /// No description provided for @paywallErrorBackup.
  ///
  /// In en, this message translates to:
  /// **'Error performing backup'**
  String get paywallErrorBackup;

  /// No description provided for @paywallErrorGetPeriodData.
  ///
  /// In en, this message translates to:
  /// **'Error getting period data'**
  String get paywallErrorGetPeriodData;

  /// No description provided for @paywallErrorCleanOldData.
  ///
  /// In en, this message translates to:
  /// **'Error cleaning old data'**
  String get paywallErrorCleanOldData;

  /// No description provided for @paywallErrorLoadingHabits.
  ///
  /// In en, this message translates to:
  /// **'Error loading habits'**
  String get paywallErrorLoadingHabits;

  /// No description provided for @pointsToLevel.
  ///
  /// In en, this message translates to:
  /// **'{points} points to level {level}'**
  String pointsToLevel(Object level, Object points);

  /// No description provided for @unlockedCount.
  ///
  /// In en, this message translates to:
  /// **'Unlocked ({count})'**
  String unlockedCount(Object count);

  /// No description provided for @lockedCount.
  ///
  /// In en, this message translates to:
  /// **'Locked ({count})'**
  String lockedCount(Object count);

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @premiumTestingActivated.
  ///
  /// In en, this message translates to:
  /// **'🎉 Premium activated for testing'**
  String get premiumTestingActivated;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @removePermanentAds.
  ///
  /// In en, this message translates to:
  /// **'Remove advertising'**
  String get removePermanentAds;

  /// No description provided for @noAdvertising.
  ///
  /// In en, this message translates to:
  /// **'No advertising'**
  String get noAdvertising;

  /// No description provided for @premiumThemesFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium themes'**
  String get premiumThemesFeature;

  /// No description provided for @startPro.
  ///
  /// In en, this message translates to:
  /// **'Start PRO'**
  String get startPro;

  /// No description provided for @drinkWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get drinkWater;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @mondayFull.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get mondayFull;

  /// No description provided for @tuesdayFull.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesdayFull;

  /// No description provided for @wednesdayFull.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesdayFull;

  /// No description provided for @thursdayFull.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursdayFull;

  /// No description provided for @fridayFull.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get fridayFull;

  /// No description provided for @saturdayFull.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturdayFull;

  /// No description provided for @sundayFull.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sundayFull;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pro;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @supportedLanguages.
  ///
  /// In en, this message translates to:
  /// **'Supported Languages'**
  String get supportedLanguages;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// No description provided for @limitedOffer.
  ///
  /// In en, this message translates to:
  /// **'LIMITED OFFER'**
  String get limitedOffer;

  /// No description provided for @unlockFullPotential.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full potential of Ritmo'**
  String get unlockFullPotential;

  /// No description provided for @startWithRitmoPro.
  ///
  /// In en, this message translates to:
  /// **'Start with Ritmo PRO'**
  String get startWithRitmoPro;

  /// No description provided for @noAdvertisingFeature.
  ///
  /// In en, this message translates to:
  /// **'No advertising'**
  String get noAdvertisingFeature;

  /// No description provided for @completelyCleanExperience.
  ///
  /// In en, this message translates to:
  /// **'Completely clean experience'**
  String get completelyCleanExperience;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get cloudBackup;

  /// No description provided for @yourDataSafeInCloud.
  ///
  /// In en, this message translates to:
  /// **'Your data safe in the cloud'**
  String get yourDataSafeInCloud;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @intelligentRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Intelligent recommendations'**
  String get intelligentRecommendations;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get chooseYourPlan;

  /// No description provided for @beginnerlevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginnerlevel;

  /// No description provided for @apprenticeLevel.
  ///
  /// In en, this message translates to:
  /// **'Apprentice'**
  String get apprenticeLevel;

  /// No description provided for @dedicatedLevel.
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get dedicatedLevel;

  /// No description provided for @consistentLevel.
  ///
  /// In en, this message translates to:
  /// **'Consistent'**
  String get consistentLevel;

  /// No description provided for @expertLevel.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expertLevel;

  /// No description provided for @masterLevel.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get masterLevel;

  /// No description provided for @legendLevel.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legendLevel;

  /// No description provided for @championLevel.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get championLevel;

  /// No description provided for @heroLevel.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get heroLevel;

  /// No description provided for @mythicLevel.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get mythicLevel;

  /// No description provided for @maximumLevel.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximumLevel;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// No description provided for @activateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Activate Notifications'**
  String get activateNotifications;

  /// No description provided for @updateAllNotificationsText.
  ///
  /// In en, this message translates to:
  /// **'Update all notifications'**
  String get updateAllNotificationsText;

  /// No description provided for @notificationsRescheduledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Notifications rescheduled successfully'**
  String get notificationsRescheduledSuccessfully;

  /// No description provided for @notificationHelp.
  ///
  /// In en, this message translates to:
  /// **'Notification Help'**
  String get notificationHelp;

  /// No description provided for @helpWithNotifications.
  ///
  /// In en, this message translates to:
  /// **'Help with Notifications'**
  String get helpWithNotifications;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @languagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} languages'**
  String languagesCount(Object count);

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @nameMinTwoCharacters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinTwoCharacters;

  /// No description provided for @basicInformationLabel.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformationLabel;

  /// No description provided for @deleteWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All habit data including completion history will be deleted.'**
  String get deleteWarningMessage;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'total points'**
  String get totalPoints;

  /// No description provided for @progressToLevel.
  ///
  /// In en, this message translates to:
  /// **'Progress to level {level}'**
  String progressToLevel(Object level);

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Max level reached!'**
  String get maxLevelReached;

  /// No description provided for @maxStreak.
  ///
  /// In en, this message translates to:
  /// **'Max Streak'**
  String get maxStreak;

  /// No description provided for @tapToViewMore.
  ///
  /// In en, this message translates to:
  /// **'Tap to view more'**
  String get tapToViewMore;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get excellent;

  /// No description provided for @pointsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String pointsWithCount(Object count);

  /// No description provided for @unlockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlockedLabel;

  /// No description provided for @percentCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Completed'**
  String percentCompleted(Object percent);

  /// No description provided for @totalHabits.
  ///
  /// In en, this message translates to:
  /// **'Total Habits'**
  String get totalHabits;

  /// No description provided for @percentThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{percent}% This week'**
  String percentThisWeek(Object percent);

  /// No description provided for @percentThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{percent}% This month'**
  String percentThisMonth(Object percent);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @twoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 wks'**
  String get twoWeeks;

  /// No description provided for @oneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get oneMonth;

  /// No description provided for @weekNumber.
  ///
  /// In en, this message translates to:
  /// **'Week {number} of {year}'**
  String weekNumber(Object number, Object year);

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String dayOfMonth(Object day, Object total);

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'{day} {month}'**
  String dateFormat(Object day, Object month);

  /// No description provided for @dateRangeFormat.
  ///
  /// In en, this message translates to:
  /// **'{startDay} {startMonth} - {endDay} {endMonth}'**
  String dateRangeFormat(
      Object endDay, Object endMonth, Object startDay, Object startMonth);

  /// No description provided for @monthYear.
  ///
  /// In en, this message translates to:
  /// **'{month} {year}'**
  String monthYear(Object month, Object year);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @motivationPerfectDay.
  ///
  /// In en, this message translates to:
  /// **'PERFECT! 🎆\\nYou completed EVERYTHING today.\\nYou\'re unstoppable!'**
  String get motivationPerfectDay;

  /// No description provided for @motivationAlmostPerfect.
  ///
  /// In en, this message translates to:
  /// **'Almost perfect! 🌟\\nJust a little bit left.\\nYou can do it!'**
  String get motivationAlmostPerfect;

  /// No description provided for @motivationExcellentDay.
  ///
  /// In en, this message translates to:
  /// **'Excellent day! 💪\\nYou\'re doing great.\\nKeep it up!'**
  String get motivationExcellentDay;

  /// No description provided for @motivationGoodProgress.
  ///
  /// In en, this message translates to:
  /// **'Good progress! 🚀\\nYou\'re on the right track.\\nDon\'t stop!'**
  String get motivationGoodProgress;

  /// No description provided for @motivationStarted.
  ///
  /// In en, this message translates to:
  /// **'You started! 🌱\\nEvery step counts.\\nContinue!'**
  String get motivationStarted;

  /// No description provided for @motivationFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First step! ⭐\\nThe hardest part is over.\\nKeep going!'**
  String get motivationFirstStep;

  /// No description provided for @motivationYourMoment.
  ///
  /// In en, this message translates to:
  /// **'Your moment! 🌅\\nStart now.\\nMake it happen!'**
  String get motivationYourMoment;

  /// No description provided for @motivationPerfectWeek.
  ///
  /// In en, this message translates to:
  /// **'PERFECT WEEK! 🏆\\nYou mastered all your rhythms.\\nYou\'re incredible!'**
  String get motivationPerfectWeek;

  /// No description provided for @motivationBrutalWeek.
  ///
  /// In en, this message translates to:
  /// **'Brutal week! 🔥\\nAlmost perfect.\\nYou\'re a champion!'**
  String get motivationBrutalWeek;

  /// No description provided for @motivationGreatWeek.
  ///
  /// In en, this message translates to:
  /// **'Great week! 💪\\nYour discipline pays off.\\nWell done!'**
  String get motivationGreatWeek;

  /// No description provided for @motivationGoodRhythm.
  ///
  /// In en, this message translates to:
  /// **'Good rhythm! 📈\\nYou\'re building.\\nKeep it up!'**
  String get motivationGoodRhythm;

  /// No description provided for @motivationProgressing.
  ///
  /// In en, this message translates to:
  /// **'Progressing! 🌱\\nEvery week counts.\\nDon\'t stop!'**
  String get motivationProgressing;

  /// No description provided for @motivationStartedWeek.
  ///
  /// In en, this message translates to:
  /// **'Started! ✨\\nYou took the first step.\\nLet\'s improve!'**
  String get motivationStartedWeek;

  /// No description provided for @motivationNewWeek.
  ///
  /// In en, this message translates to:
  /// **'New week! 🌟\\nFresh start.\\nMake it epic!'**
  String get motivationNewWeek;

  /// No description provided for @motivationLegendaryMonth.
  ///
  /// In en, this message translates to:
  /// **'LEGENDARY MONTH! 👑\\nTotal perfection.\\nYou\'re inspiration!'**
  String get motivationLegendaryMonth;

  /// No description provided for @motivationEpicMonth.
  ///
  /// In en, this message translates to:
  /// **'Epic month! 🎆\\nIncredible results.\\nUnstoppable!'**
  String get motivationEpicMonth;

  /// No description provided for @motivationSolidMonth.
  ///
  /// In en, this message translates to:
  /// **'Solid month! 💪\\nYour consistency pays off.\\nGreat work!'**
  String get motivationSolidMonth;

  /// No description provided for @motivationGoodMonth.
  ///
  /// In en, this message translates to:
  /// **'Good month! 📊\\nYou\'re progressing.\\nKeep improving!'**
  String get motivationGoodMonth;

  /// No description provided for @motivationBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building! 🏗️\\nEvery month counts.\\nKeep going!'**
  String get motivationBuilding;

  /// No description provided for @motivationSeedsPlanted.
  ///
  /// In en, this message translates to:
  /// **'Seeds planted! 🌱\\nYou\'ve started.\\nYou\'ll grow!'**
  String get motivationSeedsPlanted;

  /// No description provided for @motivationNewMonth.
  ///
  /// In en, this message translates to:
  /// **'New month! 🚀\\nInfinite possibilities.\\nMake it yours!'**
  String get motivationNewMonth;

  /// No description provided for @motivationPerfectShort.
  ///
  /// In en, this message translates to:
  /// **'PERFECT! You completed everything today'**
  String get motivationPerfectShort;

  /// No description provided for @motivationAlmostPerfectShort.
  ///
  /// In en, this message translates to:
  /// **'Almost perfect! Just a little bit left'**
  String get motivationAlmostPerfectShort;

  /// No description provided for @motivationExcellentShort.
  ///
  /// In en, this message translates to:
  /// **'Excellent day! You\'re doing great'**
  String get motivationExcellentShort;

  /// No description provided for @motivationGoodProgressShort.
  ///
  /// In en, this message translates to:
  /// **'Good progress! You\'re on the right track'**
  String get motivationGoodProgressShort;

  /// No description provided for @motivationStartedShort.
  ///
  /// In en, this message translates to:
  /// **'You started! Every step counts'**
  String get motivationStartedShort;

  /// No description provided for @motivationFirstStepShort.
  ///
  /// In en, this message translates to:
  /// **'First step! The hardest part is over'**
  String get motivationFirstStepShort;

  /// No description provided for @motivationYourMomentShort.
  ///
  /// In en, this message translates to:
  /// **'Your moment! Start now'**
  String get motivationYourMomentShort;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @completedHabits.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedHabits;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @progressToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get progressToday;

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedCount;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingCount;

  /// No description provided for @noHabitsToShow.
  ///
  /// In en, this message translates to:
  /// **'No rhythms to show'**
  String get noHabitsToShow;

  /// No description provided for @todaysHabits.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Habits'**
  String get todaysHabits;

  /// No description provided for @noHabitsScheduledToday.
  ///
  /// In en, this message translates to:
  /// **'You have no habits scheduled for today or you\'ve completed them all.'**
  String get noHabitsScheduledToday;

  /// No description provided for @weeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// No description provided for @dayShortMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayShortMon;

  /// No description provided for @dayShortTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayShortTue;

  /// No description provided for @dayShortWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayShortWed;

  /// No description provided for @dayShortThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayShortThu;

  /// No description provided for @dayShortFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayShortFri;

  /// No description provided for @dayShortSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayShortSat;

  /// No description provided for @dayShortSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayShortSun;

  /// No description provided for @weeklyHeatMap.
  ///
  /// In en, this message translates to:
  /// **'Weekly Heat Map'**
  String get weeklyHeatMap;

  /// No description provided for @legend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legend;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// No description provided for @week1.
  ///
  /// In en, this message translates to:
  /// **'W1'**
  String get week1;

  /// No description provided for @week2.
  ///
  /// In en, this message translates to:
  /// **'W2'**
  String get week2;

  /// No description provided for @week3.
  ///
  /// In en, this message translates to:
  /// **'W3'**
  String get week3;

  /// No description provided for @week4.
  ///
  /// In en, this message translates to:
  /// **'W4'**
  String get week4;

  /// No description provided for @weekHabits.
  ///
  /// In en, this message translates to:
  /// **'Week Habits'**
  String get weekHabits;

  /// No description provided for @weekProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} days'**
  String weekProgress(Object completed, Object total);

  /// No description provided for @habitLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Habit Limit Reached'**
  String get habitLimitReached;

  /// No description provided for @habitLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the limit of {limit} habits in the free plan.\n\nUpgrade to Ritmo PRO for unlimited habits and premium features!'**
  String habitLimitMessage(Object limit);

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to PRO'**
  String get upgradeToPro;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders for your habits'**
  String get notificationsDescription;

  /// No description provided for @defaultReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Default Reminder Time'**
  String get defaultReminderTime;

  /// No description provided for @reminderSound.
  ///
  /// In en, this message translates to:
  /// **'Reminder Sound'**
  String get reminderSound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @soundDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get soundDefault;

  /// No description provided for @soundNone.
  ///
  /// In en, this message translates to:
  /// **'None (Silent)'**
  String get soundNone;

  /// No description provided for @soundChime.
  ///
  /// In en, this message translates to:
  /// **'Chime'**
  String get soundChime;

  /// No description provided for @soundBell.
  ///
  /// In en, this message translates to:
  /// **'Bell'**
  String get soundBell;

  /// No description provided for @loadingHabits.
  ///
  /// In en, this message translates to:
  /// **'Loading your rhythms...'**
  String get loadingHabits;

  /// No description provided for @guestModeWarning.
  ///
  /// In en, this message translates to:
  /// **'Guest mode - Your data will not be saved'**
  String get guestModeWarning;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @saveYourProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get saveYourProgressTitle;

  /// No description provided for @createAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save your rhythms and sync them across devices.'**
  String get createAccountDescription;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @rhythmoPro.
  ///
  /// In en, this message translates to:
  /// **'HábitoPro'**
  String get rhythmoPro;

  /// No description provided for @productivityCoach.
  ///
  /// In en, this message translates to:
  /// **'Your productivity coach'**
  String get productivityCoach;

  /// No description provided for @enjoyRitmoInterruptions.
  ///
  /// In en, this message translates to:
  /// **'Enjoy Ritmo without interruptions with Ritmo PRO:'**
  String get enjoyRitmoInterruptions;

  /// No description provided for @unlimitedHabits.
  ///
  /// In en, this message translates to:
  /// **'Unlimited rhythms'**
  String get unlimitedHabits;

  /// No description provided for @advancedStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced statistics'**
  String get advancedStats;

  /// No description provided for @pricingText.
  ///
  /// In en, this message translates to:
  /// **'Only \$3.99/month - 20% less than competition'**
  String get pricingText;

  /// No description provided for @paywallComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Paywall coming soon'**
  String get paywallComingSoon;

  /// No description provided for @paywallNotImplementedTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get paywallNotImplementedTitle;

  /// No description provided for @paywallNotImplementedMessage.
  ///
  /// In en, this message translates to:
  /// **'The payment system is under development. For now, you can activate Ritmo PRO from Settings > \"Activate Premium (Testing)\".'**
  String get paywallNotImplementedMessage;

  /// No description provided for @paywallMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Ritmo\'s full potential'**
  String get paywallMainTitle;

  /// No description provided for @paywallChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get paywallChoosePlan;

  /// No description provided for @paywallStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start with Ritmo PRO'**
  String get paywallStartButton;

  /// No description provided for @paywallTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you accept our Terms of Service and Privacy Policy'**
  String get paywallTermsAndConditions;

  /// No description provided for @manageHabitsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Manage habits'**
  String get manageHabitsTooltip;

  /// No description provided for @notificationTroubleshootingTips.
  ///
  /// In en, this message translates to:
  /// **'• Verify that notifications are enabled in system settings\n• Make sure the app is not in \"Do Not Disturb\" mode\n• Check that habits have reminder times configured'**
  String get notificationTroubleshootingTips;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'HabitPro'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build better habits, day by day'**
  String get loginSubtitle;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailValidationError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequiredError;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @signInOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInOrCreateAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @statsGoodMonth.
  ///
  /// In en, this message translates to:
  /// **'Good month! 📊\nYou\'re progressing.\nKeep improving!'**
  String get statsGoodMonth;

  /// No description provided for @statsBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building! 🏗️\nEvery month counts.\nKeep going!'**
  String get statsBuilding;

  /// No description provided for @statsSeedsPlanted.
  ///
  /// In en, this message translates to:
  /// **'Seeds planted! 🌱\nYou\'ve started.\nYou\'ll grow!'**
  String get statsSeedsPlanted;

  /// No description provided for @statsNewMonth.
  ///
  /// In en, this message translates to:
  /// **'New month! 🚀\nInfinite possibilities.\nMake it yours!'**
  String get statsNewMonth;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequiredError;

  /// No description provided for @emailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequiredError;

  /// No description provided for @firstStreakAchievement.
  ///
  /// In en, this message translates to:
  /// **'First Streak'**
  String get firstStreakAchievement;

  /// No description provided for @weekWarriorAchievement.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get weekWarriorAchievement;

  /// No description provided for @monthMasterAchievement.
  ///
  /// In en, this message translates to:
  /// **'Month Master'**
  String get monthMasterAchievement;

  /// No description provided for @firstStepAchievement.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get firstStepAchievement;

  /// No description provided for @centuryClubAchievement.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get centuryClubAchievement;

  /// No description provided for @marathonRunnerAchievement.
  ///
  /// In en, this message translates to:
  /// **'Marathon Runner'**
  String get marathonRunnerAchievement;

  /// No description provided for @perfectWeekAchievement.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get perfectWeekAchievement;

  /// No description provided for @rhythmCollectorAchievement.
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get rhythmCollectorAchievement;

  /// No description provided for @rhythmMasterAchievement.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Master'**
  String get rhythmMasterAchievement;

  /// No description provided for @streakFormat.
  ///
  /// In en, this message translates to:
  /// **'{streak} days'**
  String streakFormat(Object streak);

  /// No description provided for @notificationsToRemindHabits.
  ///
  /// In en, this message translates to:
  /// **'Notifications to remind you to complete your daily rhythms'**
  String get notificationsToRemindHabits;

  /// No description provided for @rhythmReminderTicker.
  ///
  /// In en, this message translates to:
  /// **'Habit reminder'**
  String get rhythmReminderTicker;

  /// No description provided for @defaultHabitReminder.
  ///
  /// In en, this message translates to:
  /// **'Time to work on your rhythm!'**
  String get defaultHabitReminder;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Notification system working correctly!'**
  String get testNotificationBody;

  /// No description provided for @rhythmUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Habit updated!'**
  String get rhythmUpdatedMessage;

  /// No description provided for @openSystemSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Open system settings to manage notifications'**
  String get openSystemSettingsMessage;

  /// No description provided for @notReceivingReminders.
  ///
  /// In en, this message translates to:
  /// **'Not receiving reminders?'**
  String get notReceivingReminders;

  /// No description provided for @rhythmDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Habit deleted'**
  String get rhythmDeletedMessage;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating rhythm'**
  String get updateError;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting rhythm'**
  String get deleteError;

  /// No description provided for @habitUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Rhythm updated!'**
  String get habitUpdatedMessage;

  /// No description provided for @habitDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Rhythm deleted'**
  String get habitDeletedMessage;

  /// No description provided for @habitNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Name'**
  String get habitNameLabel;

  /// No description provided for @habitReminders.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Reminders'**
  String get habitReminders;

  /// No description provided for @habitReminderTicker.
  ///
  /// In en, this message translates to:
  /// **'Rhythm reminder'**
  String get habitReminderTicker;

  /// No description provided for @habitStreaks.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Streaks'**
  String get habitStreaks;

  /// No description provided for @habitCollectorAchievement.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Collector'**
  String get habitCollectorAchievement;

  /// No description provided for @habitCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rhythm created successfully'**
  String get habitCreatedSuccessfully;

  /// No description provided for @habitNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Exercise, Read, Meditate...'**
  String get habitNameHint;

  /// No description provided for @welcomeToRitmoPro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ritmo PRO! 🎉'**
  String get welcomeToRitmoPro;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase error'**
  String get purchaseError;

  /// No description provided for @googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get googleLogin;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @passwordResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get passwordResetMessage;

  /// No description provided for @errorCreatingHabit.
  ///
  /// In en, this message translates to:
  /// **'Error creating habit'**
  String get errorCreatingHabit;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {languageName}'**
  String languageChangedTo(Object languageName);

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get genericError;

  /// No description provided for @themeExecutiveMinimalist.
  ///
  /// In en, this message translates to:
  /// **'💼 Executive Minimalist'**
  String get themeExecutiveMinimalist;

  /// No description provided for @themeGlassmorphism.
  ///
  /// In en, this message translates to:
  /// **'✨ Glassmorphism'**
  String get themeGlassmorphism;

  /// No description provided for @themeNeumorphism.
  ///
  /// In en, this message translates to:
  /// **'🎭 Neumorphism'**
  String get themeNeumorphism;

  /// No description provided for @allDoneForToday.
  ///
  /// In en, this message translates to:
  /// **'All done for today!'**
  String get allDoneForToday;

  /// No description provided for @welcomeToRitmo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ritmo!'**
  String get welcomeToRitmo;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your journey to better habits by creating your first daily habit.'**
  String get startYourJourney;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @continuingAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continuing as guest'**
  String get continuingAsGuest;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @frequencyType.
  ///
  /// In en, this message translates to:
  /// **'Frequency Type'**
  String get frequencyType;

  /// No description provided for @frequencyTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get frequencyTypeDaily;

  /// No description provided for @frequencyTypeWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays only'**
  String get frequencyTypeWeekdays;

  /// No description provided for @frequencyTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom days'**
  String get frequencyTypeCustom;

  /// No description provided for @frequencyTypeWeekly.
  ///
  /// In en, this message translates to:
  /// **'X days per week'**
  String get frequencyTypeWeekly;

  /// No description provided for @selectFrequencyType.
  ///
  /// In en, this message translates to:
  /// **'Select how often you want to do this habit'**
  String get selectFrequencyType;

  /// No description provided for @dailyDescription.
  ///
  /// In en, this message translates to:
  /// **'Do this habit every single day'**
  String get dailyDescription;

  /// No description provided for @weekdaysDescription.
  ///
  /// In en, this message translates to:
  /// **'Monday through Friday only'**
  String get weekdaysDescription;

  /// No description provided for @customDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose specific days of the week'**
  String get customDescription;

  /// No description provided for @weeklyDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how many days per week (flexible)'**
  String get weeklyDescription;

  /// No description provided for @daysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Days per week'**
  String get daysPerWeek;

  /// No description provided for @selectDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'How many days per week?'**
  String get selectDaysPerWeek;

  /// No description provided for @timesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{time} other{times}} per week'**
  String timesPerWeek(num count);

  /// No description provided for @atLeastOncePerWeek.
  ///
  /// In en, this message translates to:
  /// **'At least once per week'**
  String get atLeastOncePerWeek;

  /// No description provided for @targetDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} days per week'**
  String targetDaysPerWeek(Object count);

  /// No description provided for @weeklyTargetMet.
  ///
  /// In en, this message translates to:
  /// **'✓ Weekly target met!'**
  String get weeklyTargetMet;

  /// No description provided for @weeklyTargetProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {target} days this week'**
  String weeklyTargetProgress(Object completed, Object target);

  /// No description provided for @weeklyStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{week} other{weeks}} streak'**
  String weeklyStreakLabel(num count);

  /// No description provided for @dailyStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}} streak'**
  String dailyStreakLabel(num count);

  /// No description provided for @bonusPoints.
  ///
  /// In en, this message translates to:
  /// **'+{points} bonus points!'**
  String bonusPoints(Object points);

  /// No description provided for @weeklyBonusEarned.
  ///
  /// In en, this message translates to:
  /// **'Weekly target completed! +10 bonus points'**
  String get weeklyBonusEarned;

  /// No description provided for @frequencyTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a frequency type'**
  String get frequencyTypeRequired;

  /// No description provided for @weeklyTargetRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select how many days per week'**
  String get weeklyTargetRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'cs',
        'da',
        'de',
        'en',
        'es',
        'fi',
        'fr',
        'hi',
        'id',
        'it',
        'ja',
        'ko',
        'nl',
        'no',
        'pl',
        'pt',
        'ro',
        'ru',
        'sv',
        'th',
        'tl',
        'tr',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
