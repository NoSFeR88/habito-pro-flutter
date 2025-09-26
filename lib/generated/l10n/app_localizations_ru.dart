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
