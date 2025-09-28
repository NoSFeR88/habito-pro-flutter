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

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'RITMO'**
  String get appTitle;

  /// Title in the home screen app bar
  ///
  /// In en, this message translates to:
  /// **'RITMO'**
  String get homeAppBarTitle;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Today label with date
  ///
  /// In en, this message translates to:
  /// **'Today • {date}'**
  String todayWithDate(String date);

  /// Empty state title when no habits for today
  ///
  /// In en, this message translates to:
  /// **'All done for today!'**
  String get allDoneToday;

  /// Empty state description
  ///
  /// In en, this message translates to:
  /// **'You have no habits scheduled for today or you\'ve completed them all.'**
  String get noProgrammedHabits;

  /// Create first habit button text
  ///
  /// In en, this message translates to:
  /// **'Create my first habit'**
  String get createFirstHabit;

  /// Snackbar message when habit is toggled
  ///
  /// In en, this message translates to:
  /// **'Habit updated!'**
  String get habitUpdated;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// View statistics button text
  ///
  /// In en, this message translates to:
  /// **'View statistics'**
  String get viewStatistics;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Delete habit dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete habit'**
  String get deleteHabit;

  /// Delete habit confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{habitName}\"?'**
  String confirmDeleteHabit(String habitName);

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Habit deleted confirmation message
  ///
  /// In en, this message translates to:
  /// **'Habit \"{habitName}\" deleted'**
  String habitDeleted(String habitName);

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
  /// **'The only habit app that adapts to YOUR real life'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingFeatureFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible habits adapted to you'**
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
  /// **'Your life is unique. Your habits should be too.'**
  String get onboardingFlexibilityMessage;

  /// No description provided for @onboardingThisSounds.
  ///
  /// In en, this message translates to:
  /// **'This sounds familiar'**
  String get onboardingThisSounds;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first flexible habit'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingFlexibilityTip.
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: Choose realistic days for your lifestyle'**
  String get onboardingFlexibilityTip;

  /// No description provided for @onboardingCreateFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Create my first habit'**
  String get onboardingCreateFirstHabit;

  /// No description provided for @onboardingCelebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect! You have your rhythm'**
  String get onboardingCelebrationTitle;

  /// No description provided for @onboardingCelebrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your first flexible habit is ready to begin'**
  String get onboardingCelebrationSubtitle;

  /// No description provided for @onboardingDefaultHabitName.
  ///
  /// In en, this message translates to:
  /// **'My first habit'**
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

  /// Label for habit name field
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// Hint text for habit name field
  ///
  /// In en, this message translates to:
  /// **'E.g: Exercise, Read, Meditate...'**
  String get habitNameHint;

  /// Label for day selection
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

  /// New habit screen title
  ///
  /// In en, this message translates to:
  /// **'New Habit'**
  String get newHabit;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Today tab in statistics
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsToday;

  /// Week tab in statistics
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsWeek;

  /// Month tab in statistics
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsMonth;

  /// Notification tests modal title
  ///
  /// In en, this message translates to:
  /// **'Notification Tests'**
  String get notificationTests;

  /// Immediate notification test title
  ///
  /// In en, this message translates to:
  /// **'Immediate Notification'**
  String get immediateNotification;

  /// Immediate notification test description
  ///
  /// In en, this message translates to:
  /// **'Show notification right now'**
  String get showNotificationNow;

  /// Scheduled notification test title
  ///
  /// In en, this message translates to:
  /// **'Scheduled Notification'**
  String get scheduledNotification;

  /// Scheduled notification test description
  ///
  /// In en, this message translates to:
  /// **'Schedule notification in 5 seconds'**
  String get scheduleIn5Seconds;

  /// Reschedule all habits button
  ///
  /// In en, this message translates to:
  /// **'Reschedule All Habits'**
  String get rescheduleAllHabits;

  /// Update all notifications description
  ///
  /// In en, this message translates to:
  /// **'Update all notifications'**
  String get updateAllNotifications;

  /// View pending notifications button
  ///
  /// In en, this message translates to:
  /// **'View Pending Notifications'**
  String get viewPendingNotifications;

  /// Show scheduled notifications description
  ///
  /// In en, this message translates to:
  /// **'Show scheduled notifications'**
  String get showScheduledNotifications;

  /// Notification sent confirmation
  ///
  /// In en, this message translates to:
  /// **'Notification sent! Check your notification bar'**
  String get notificationSent;

  /// Notification scheduled confirmation
  ///
  /// In en, this message translates to:
  /// **'Notification scheduled for 5 seconds'**
  String get notificationScheduled;

  /// Notifications rescheduled confirmation
  ///
  /// In en, this message translates to:
  /// **'Notifications rescheduled successfully'**
  String get notificationsRescheduled;

  /// Pending notifications dialog title
  ///
  /// In en, this message translates to:
  /// **'Pending Notifications'**
  String get pendingNotifications;

  /// No pending notifications message
  ///
  /// In en, this message translates to:
  /// **'No pending notifications'**
  String get noPendingNotifications;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
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
