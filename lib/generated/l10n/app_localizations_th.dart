// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'นิสัยโปร';

  @override
  String get homeAppBarTitle => 'นิสัยโปร';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get today => 'วันนี้';

  @override
  String todayWithDate(String date) {
    return 'วันนี้ • $date';
  }

  @override
  String get allDoneToday => 'เสร็จสิ้นทุกอย่างสำหรับวันนี้!';

  @override
  String get noProgrammedHabits =>
      'คุณไม่มีนิสัยที่กำหนดไว้สำหรับวันนี้ หรือคุณทำครบทุกอย่างแล้ว';

  @override
  String get createFirstHabit => 'สร้างนิสัยแรกของฉน';

  @override
  String get habitUpdated => 'อัปเดตนิสัยแล้ว!';

  @override
  String get edit => 'แก้ไข';

  @override
  String get viewStatistics => 'ดูสถิติ';

  @override
  String get delete => 'ลบ';

  @override
  String get deleteHabit => 'ลบนิสัย';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ \"$habitName\"?';
  }

  @override
  String get cancel => 'ยกเลิก';

  @override
  String habitDeleted(String habitName) {
    return 'ลบนิสัย \"$habitName\" แล้ว';
  }

  @override
  String get mondayShort => 'จ.';

  @override
  String get tuesdayShort => 'อ.';

  @override
  String get wednesdayShort => 'พ.';

  @override
  String get thursdayShort => 'พฤ.';

  @override
  String get fridayShort => 'ศ.';

  @override
  String get saturdayShort => 'ส.';

  @override
  String get sundayShort => 'อา.';

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
  String get januaryShort => 'ม.ค.';

  @override
  String get februaryShort => 'ก.พ.';

  @override
  String get marchShort => 'มี.ค.';

  @override
  String get aprilShort => 'เม.ย.';

  @override
  String get mayShort => 'พ.ค.';

  @override
  String get juneShort => 'มิ.ย.';

  @override
  String get julyShort => 'ก.ค.';

  @override
  String get augustShort => 'ส.ค.';

  @override
  String get septemberShort => 'ก.ย.';

  @override
  String get octoberShort => 'ต.ค.';

  @override
  String get novemberShort => 'พ.ย.';

  @override
  String get decemberShort => 'ธ.ค.';

  @override
  String get newHabit => 'นิสัยใหม่';

  @override
  String get save => 'บันทึก';

  @override
  String get statsToday => 'วันนี้';

  @override
  String get statsWeek => 'สัปดาห์';

  @override
  String get statsMonth => 'เดือน';

  @override
  String get notificationTests => 'ทดสอบการแจ้งเตือน';

  @override
  String get immediateNotification => 'การแจ้งเตือนทันที';

  @override
  String get showNotificationNow => 'แสดงการแจ้งเตือนตอนนี้';

  @override
  String get scheduledNotification => 'การแจ้งเตือนที่กำหนดไว้';

  @override
  String get scheduleIn5Seconds => 'กำหนดการแจ้งเตือนใน 5 วินาที';

  @override
  String get rescheduleAllHabits => 'กำหนดนิสัยทั้งหมดใหม่';

  @override
  String get updateAllNotifications => 'อัปเดตการแจ้งเตือนทั้งหมด';

  @override
  String get viewPendingNotifications => 'ดูการแจ้งเตือนที่รอดำเนินการ';

  @override
  String get showScheduledNotifications => 'แสดงการแจ้งเตือนที่กำหนดไว้';

  @override
  String get notificationSent =>
      'ส่งการแจ้งเตือนแล้ว! ตรวจสอบแถบแจ้งเตือนของคุณ';

  @override
  String get notificationScheduled => 'กำหนดการแจ้งเตือนสำหรับ 5 วินาที';

  @override
  String get notificationsRescheduled => 'กำหนดการแจ้งเตือนใหม่สำเร็จแล้ว';

  @override
  String get pendingNotifications => 'การแจ้งเตือนที่รอดำเนินการ';

  @override
  String get noPendingNotifications => 'ไม่มีการแจ้งเตือนที่รอดำเนินการ';

  @override
  String get close => 'ปิด';
}
