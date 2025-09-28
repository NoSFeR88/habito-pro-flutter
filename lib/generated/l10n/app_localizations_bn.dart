// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'অভ্যাস প্রো';

  @override
  String get homeAppBarTitle => 'অভ্যাস প্রো';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get today => 'আজ';

  @override
  String todayWithDate(String date) {
    return 'আজ • $date';
  }

  @override
  String get allDoneToday => 'আজকের সব কাজ শেষ!';

  @override
  String get noProgrammedHabits =>
      'আপনার আজকের জন্য কোনো অভ্যাস নির্ধারিত নেই বা আপনি সবগুলো সম্পন্ন করেছেন।';

  @override
  String get createFirstHabit => 'আমার প্রথম অভ্যাস তৈরি করুন';

  @override
  String get habitUpdated => 'অভ্যাস আপডেট হয়েছে!';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get viewStatistics => 'পরিসংখ্যান দেখুন';

  @override
  String get delete => 'মুছুন';

  @override
  String get deleteHabit => 'অভ্যাস মুছুন';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'আপনি কি সত্যিই \"$habitName\" মুছতে চান?';
  }

  @override
  String get cancel => 'বাতিল';

  @override
  String habitDeleted(String habitName) {
    return 'অভ্যাস \"$habitName\" মুছে ফেলা হয়েছে';
  }

  @override
  String get mondayShort => 'সোম';

  @override
  String get tuesdayShort => 'মঙ্গল';

  @override
  String get wednesdayShort => 'বুধ';

  @override
  String get thursdayShort => 'বৃহ';

  @override
  String get fridayShort => 'শুক্র';

  @override
  String get saturdayShort => 'শনি';

  @override
  String get sundayShort => 'রবি';

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
  String get januaryShort => 'জানু';

  @override
  String get februaryShort => 'ফেব';

  @override
  String get marchShort => 'মার্চ';

  @override
  String get aprilShort => 'এপ্রিল';

  @override
  String get mayShort => 'মে';

  @override
  String get juneShort => 'জুন';

  @override
  String get julyShort => 'জুলাই';

  @override
  String get augustShort => 'আগস্ট';

  @override
  String get septemberShort => 'সেপ্টে';

  @override
  String get octoberShort => 'অক্টো';

  @override
  String get novemberShort => 'নভে';

  @override
  String get decemberShort => 'ডিসে';

  @override
  String get newHabit => 'নতুন অভ্যাস';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get statsToday => 'আজ';

  @override
  String get statsWeek => 'সপ্তাহ';

  @override
  String get statsMonth => 'মাস';

  @override
  String get notificationTests => 'বিজ্ঞপ্তি পরীক্ষা';

  @override
  String get immediateNotification => 'তাৎক্ষণিক বিজ্ঞপ্তি';

  @override
  String get showNotificationNow => 'এখনই বিজ্ঞপ্তি দেখান';

  @override
  String get scheduledNotification => 'নির্ধারিত বিজ্ঞপ্তি';

  @override
  String get scheduleIn5Seconds => '৫ সেকেন্ডে বিজ্ঞপ্তি নির্ধারণ করুন';

  @override
  String get rescheduleAllHabits => 'সব অভ্যাস পুনঃনির্ধারণ করুন';

  @override
  String get updateAllNotifications => 'সব বিজ্ঞপ্তি আপডেট করুন';

  @override
  String get viewPendingNotifications => 'অমীমাংসিত বিজ্ঞপ্তি দেখুন';

  @override
  String get showScheduledNotifications => 'নির্ধারিত বিজ্ঞপ্তি দেখান';

  @override
  String get notificationSent =>
      'বিজ্ঞপ্তি পাঠানো হয়েছে! আপনার বিজ্ঞপ্তি বার চেক করুন';

  @override
  String get notificationScheduled => '৫ সেকেন্ডের জন্য বিজ্ঞপ্তি নির্ধারিত';

  @override
  String get notificationsRescheduled =>
      'বিজ্ঞপ্তি সফলভাবে পুনঃনির্ধারিত হয়েছে';

  @override
  String get pendingNotifications => 'অমীমাংসিত বিজ্ঞপ্তি';

  @override
  String get noPendingNotifications => 'কোনো অমীমাংসিত বিজ্ঞপ্তি নেই';

  @override
  String get close => 'বন্ধ';
}
