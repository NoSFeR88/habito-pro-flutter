// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '习惯专家';

  @override
  String get homeAppBarTitle => '习惯专家';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get today => '今天';

  @override
  String todayWithDate(String date) {
    return '今天 • $date';
  }

  @override
  String get allDoneToday => '今天全部完成！';

  @override
  String get noProgrammedHabits => '您今天没有安排的习惯或已全部完成。';

  @override
  String get createFirstHabit => '创建我的第一个习惯';

  @override
  String get habitUpdated => '习惯已更新！';

  @override
  String get edit => '编辑';

  @override
  String get viewStatistics => '查看统计';

  @override
  String get delete => '删除';

  @override
  String get deleteHabit => '删除习惯';

  @override
  String confirmDeleteHabit(String habitName) {
    return '您确定要删除\"$habitName\"吗？';
  }

  @override
  String get cancel => '取消';

  @override
  String habitDeleted(String habitName) {
    return '习惯\"$habitName\"已删除';
  }

  @override
  String get mondayShort => '周一';

  @override
  String get tuesdayShort => '周二';

  @override
  String get wednesdayShort => '周三';

  @override
  String get thursdayShort => '周四';

  @override
  String get fridayShort => '周五';

  @override
  String get saturdayShort => '周六';

  @override
  String get sundayShort => '周日';

  @override
  String get januaryShort => '1月';

  @override
  String get februaryShort => '2月';

  @override
  String get marchShort => '3月';

  @override
  String get aprilShort => '4月';

  @override
  String get mayShort => '5月';

  @override
  String get juneShort => '6月';

  @override
  String get julyShort => '7月';

  @override
  String get augustShort => '8月';

  @override
  String get septemberShort => '9月';

  @override
  String get octoberShort => '10月';

  @override
  String get novemberShort => '11月';

  @override
  String get decemberShort => '12月';

  @override
  String get newHabit => '新习惯';

  @override
  String get save => '保存';

  @override
  String get statsToday => '今天';

  @override
  String get statsWeek => '本周';

  @override
  String get statsMonth => '本月';

  @override
  String get notificationTests => '通知测试';

  @override
  String get immediateNotification => '即时通知';

  @override
  String get showNotificationNow => '立即显示通知';

  @override
  String get scheduledNotification => '定时通知';

  @override
  String get scheduleIn5Seconds => '5秒后安排通知';

  @override
  String get rescheduleAllHabits => '重新安排所有习惯';

  @override
  String get updateAllNotifications => '更新所有通知';

  @override
  String get viewPendingNotifications => '查看待处理通知';

  @override
  String get showScheduledNotifications => '显示已安排的通知';

  @override
  String get notificationSent => '通知已发送！请查看您的通知栏';

  @override
  String get notificationScheduled => '通知已安排在5秒后';

  @override
  String get notificationsRescheduled => '通知重新安排成功';

  @override
  String get pendingNotifications => '待处理通知';

  @override
  String get noPendingNotifications => '没有待处理的通知';

  @override
  String get close => '关闭';
}
