// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '습관 프로';

  @override
  String get homeAppBarTitle => '습관 프로';

  @override
  String get loading => '로딩 중...';

  @override
  String get retry => '다시 시도';

  @override
  String get today => '오늘';

  @override
  String todayWithDate(String date) {
    return '오늘 • $date';
  }

  @override
  String get allDoneToday => '오늘 할 일을 모두 완료했습니다!';

  @override
  String get noProgrammedHabits => '오늘 예정된 습관이 없거나 모든 습관을 완료했습니다.';

  @override
  String get createFirstHabit => '첫 번째 습관 만들기';

  @override
  String get habitUpdated => '습관이 업데이트되었습니다!';

  @override
  String get edit => '편집';

  @override
  String get viewStatistics => '통계 보기';

  @override
  String get delete => '삭제';

  @override
  String get deleteHabit => '습관 삭제';

  @override
  String confirmDeleteHabit(String habitName) {
    return '정말로 \"$habitName\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get cancel => '취소';

  @override
  String habitDeleted(String habitName) {
    return '습관 \"$habitName\"이(가) 삭제되었습니다';
  }

  @override
  String get mondayShort => '월';

  @override
  String get tuesdayShort => '화';

  @override
  String get wednesdayShort => '수';

  @override
  String get thursdayShort => '목';

  @override
  String get fridayShort => '금';

  @override
  String get saturdayShort => '토';

  @override
  String get sundayShort => '일';

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
  String get januaryShort => '1월';

  @override
  String get februaryShort => '2월';

  @override
  String get marchShort => '3월';

  @override
  String get aprilShort => '4월';

  @override
  String get mayShort => '5월';

  @override
  String get juneShort => '6월';

  @override
  String get julyShort => '7월';

  @override
  String get augustShort => '8월';

  @override
  String get septemberShort => '9월';

  @override
  String get octoberShort => '10월';

  @override
  String get novemberShort => '11월';

  @override
  String get decemberShort => '12월';

  @override
  String get newHabit => '새로운 습관';

  @override
  String get save => '저장';

  @override
  String get statsToday => '오늘';

  @override
  String get statsWeek => '주';

  @override
  String get statsMonth => '월';

  @override
  String get notificationTests => '알림 테스트';

  @override
  String get immediateNotification => '즉시 알림';

  @override
  String get showNotificationNow => '지금 알림 표시';

  @override
  String get scheduledNotification => '예약된 알림';

  @override
  String get scheduleIn5Seconds => '5초 후 알림 예약';

  @override
  String get rescheduleAllHabits => '모든 습관 일정 변경';

  @override
  String get updateAllNotifications => '모든 알림 업데이트';

  @override
  String get viewPendingNotifications => '대기 중인 알림 보기';

  @override
  String get showScheduledNotifications => '예약된 알림 표시';

  @override
  String get notificationSent => '알림이 전송되었습니다! 알림 표시줄을 확인하세요';

  @override
  String get notificationScheduled => '5초 후 알림이 예약되었습니다';

  @override
  String get notificationsRescheduled => '알림 일정이 성공적으로 변경되었습니다';

  @override
  String get pendingNotifications => '대기 중인 알림';

  @override
  String get noPendingNotifications => '대기 중인 알림이 없습니다';

  @override
  String get close => '닫기';
}
