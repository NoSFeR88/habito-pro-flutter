// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Привычка Про';

  @override
  String get homeAppBarTitle => 'Привычка Про';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Повторить';

  @override
  String get today => 'Сегодня';

  @override
  String todayWithDate(String date) {
    return 'Сегодня • $date';
  }

  @override
  String get allDoneToday => 'На сегодня всё готово!';

  @override
  String get noProgrammedHabits =>
      'У вас нет запланированных привычек на сегодня или вы выполнили их все.';

  @override
  String get createFirstHabit => 'Создать мою первую привычку';

  @override
  String get habitUpdated => 'Привычка обновлена!';

  @override
  String get edit => 'Редактировать';

  @override
  String get viewStatistics => 'Посмотреть статистику';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteHabit => 'Удалить привычку';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Вы уверены, что хотите удалить \"$habitName\"?';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String habitDeleted(String habitName) {
    return 'Привычка \"$habitName\" удалена';
  }

  @override
  String get mondayShort => 'Пн';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get wednesdayShort => 'Ср';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get fridayShort => 'Пт';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get sundayShort => 'Вс';

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
  String get januaryShort => 'Янв';

  @override
  String get februaryShort => 'Фев';

  @override
  String get marchShort => 'Мар';

  @override
  String get aprilShort => 'Апр';

  @override
  String get mayShort => 'Май';

  @override
  String get juneShort => 'Июн';

  @override
  String get julyShort => 'Июл';

  @override
  String get augustShort => 'Авг';

  @override
  String get septemberShort => 'Сен';

  @override
  String get octoberShort => 'Окт';

  @override
  String get novemberShort => 'Ноя';

  @override
  String get decemberShort => 'Дек';

  @override
  String get newHabit => 'Новая Привычка';

  @override
  String get save => 'Сохранить';

  @override
  String get statsToday => 'Сегодня';

  @override
  String get statsWeek => 'Неделя';

  @override
  String get statsMonth => 'Месяц';

  @override
  String get notificationTests => 'Тесты Уведомлений';

  @override
  String get immediateNotification => 'Немедленное Уведомление';

  @override
  String get showNotificationNow => 'Показать уведомление сейчас';

  @override
  String get scheduledNotification => 'Запланированное Уведомление';

  @override
  String get scheduleIn5Seconds => 'Запланировать уведомление через 5 секунд';

  @override
  String get rescheduleAllHabits => 'Перепланировать Все Привычки';

  @override
  String get updateAllNotifications => 'Обновить все уведомления';

  @override
  String get viewPendingNotifications => 'Посмотреть Ожидающие Уведомления';

  @override
  String get showScheduledNotifications =>
      'Показать запланированные уведомления';

  @override
  String get notificationSent =>
      'Уведомление отправлено! Проверьте панель уведомлений';

  @override
  String get notificationScheduled => 'Уведомление запланировано на 5 секунд';

  @override
  String get notificationsRescheduled => 'Уведомления успешно перепланированы';

  @override
  String get pendingNotifications => 'Ожидающие Уведомления';

  @override
  String get noPendingNotifications => 'Нет ожидающих уведомлений';

  @override
  String get close => 'Закрыть';
}
