// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '習慣プロ';

  @override
  String get homeAppBarTitle => '習慣プロ';

  @override
  String get loading => '読み込み中...';

  @override
  String get retry => '再試行';

  @override
  String get today => '今日';

  @override
  String todayWithDate(String date) {
    return '今日 • $date';
  }

  @override
  String get allDoneToday => '今日はすべて完了！';

  @override
  String get noProgrammedHabits => '今日予定されている習慣がないか、すべて完了しています。';

  @override
  String get createFirstHabit => '最初の習慣を作成';

  @override
  String get habitUpdated => '習慣を更新しました！';

  @override
  String get edit => '編集';

  @override
  String get viewStatistics => '統計を見る';

  @override
  String get delete => '削除';

  @override
  String get deleteHabit => '習慣を削除';

  @override
  String confirmDeleteHabit(String habitName) {
    return '本当に「$habitName」を削除しますか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String habitDeleted(String habitName) {
    return '習慣「$habitName」を削除しました';
  }

  @override
  String get mondayShort => '月';

  @override
  String get tuesdayShort => '火';

  @override
  String get wednesdayShort => '水';

  @override
  String get thursdayShort => '木';

  @override
  String get fridayShort => '金';

  @override
  String get saturdayShort => '土';

  @override
  String get sundayShort => '日';

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
  String get newHabit => '新しい習慣';

  @override
  String get save => '保存';

  @override
  String get statsToday => '今日';

  @override
  String get statsWeek => '週';

  @override
  String get statsMonth => '月';

  @override
  String get notificationTests => '通知テスト';

  @override
  String get immediateNotification => '即座の通知';

  @override
  String get showNotificationNow => '今すぐ通知を表示';

  @override
  String get scheduledNotification => 'スケジュールされた通知';

  @override
  String get scheduleIn5Seconds => '5秒後に通知をスケジュール';

  @override
  String get rescheduleAllHabits => 'すべての習慣を再スケジュール';

  @override
  String get updateAllNotifications => 'すべての通知を更新';

  @override
  String get viewPendingNotifications => '保留中の通知を表示';

  @override
  String get showScheduledNotifications => 'スケジュールされた通知を表示';

  @override
  String get notificationSent => '通知を送信しました！通知バーを確認してください';

  @override
  String get notificationScheduled => '5秒後に通知をスケジュールしました';

  @override
  String get notificationsRescheduled => '通知の再スケジュールが完了しました';

  @override
  String get pendingNotifications => '保留中の通知';

  @override
  String get noPendingNotifications => '保留中の通知はありません';

  @override
  String get close => '閉じる';
}
