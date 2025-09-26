// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Thói Quen Pro';

  @override
  String get homeAppBarTitle => 'Thói Quen Pro';

  @override
  String get loading => 'Đang tải...';

  @override
  String get retry => 'Thử lại';

  @override
  String get today => 'Hôm nay';

  @override
  String todayWithDate(String date) {
    return 'Hôm nay • $date';
  }

  @override
  String get allDoneToday => 'Hoàn thành tất cả cho hôm nay!';

  @override
  String get noProgrammedHabits =>
      'Bạn không có thói quen nào được lập trình cho hôm nay hoặc đã hoàn thành tất cả.';

  @override
  String get createFirstHabit => 'Tạo thói quen đầu tiên của tôi';

  @override
  String get habitUpdated => 'Thói quen đã được cập nhật!';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get viewStatistics => 'Xem thống kê';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteHabit => 'Xóa thói quen';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Bạn có chắc chắn muốn xóa \"$habitName\" không?';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String habitDeleted(String habitName) {
    return 'Thói quen \"$habitName\" đã được xóa';
  }

  @override
  String get mondayShort => 'T2';

  @override
  String get tuesdayShort => 'T3';

  @override
  String get wednesdayShort => 'T4';

  @override
  String get thursdayShort => 'T5';

  @override
  String get fridayShort => 'T6';

  @override
  String get saturdayShort => 'T7';

  @override
  String get sundayShort => 'CN';

  @override
  String get januaryShort => 'T1';

  @override
  String get februaryShort => 'T2';

  @override
  String get marchShort => 'T3';

  @override
  String get aprilShort => 'T4';

  @override
  String get mayShort => 'T5';

  @override
  String get juneShort => 'T6';

  @override
  String get julyShort => 'T7';

  @override
  String get augustShort => 'T8';

  @override
  String get septemberShort => 'T9';

  @override
  String get octoberShort => 'T10';

  @override
  String get novemberShort => 'T11';

  @override
  String get decemberShort => 'T12';

  @override
  String get newHabit => 'Thói Quen Mới';

  @override
  String get save => 'Lưu';

  @override
  String get statsToday => 'Hôm nay';

  @override
  String get statsWeek => 'Tuần';

  @override
  String get statsMonth => 'Tháng';

  @override
  String get notificationTests => 'Kiểm Tra Thông Báo';

  @override
  String get immediateNotification => 'Thông Báo Ngay Lập Tức';

  @override
  String get showNotificationNow => 'Hiển thị thông báo ngay bây giờ';

  @override
  String get scheduledNotification => 'Thông Báo Đã Lên Lịch';

  @override
  String get scheduleIn5Seconds => 'Lên lịch thông báo trong 5 giây';

  @override
  String get rescheduleAllHabits => 'Lên Lịch Lại Tất Cả Thói Quen';

  @override
  String get updateAllNotifications => 'Cập nhật tất cả thông báo';

  @override
  String get viewPendingNotifications => 'Xem Thông Báo Đang Chờ';

  @override
  String get showScheduledNotifications => 'Hiển thị thông báo đã lên lịch';

  @override
  String get notificationSent =>
      'Thông báo đã được gửi! Kiểm tra thanh thông báo của bạn';

  @override
  String get notificationScheduled => 'Thông báo được lên lịch trong 5 giây';

  @override
  String get notificationsRescheduled =>
      'Thông báo đã được lên lịch lại thành công';

  @override
  String get pendingNotifications => 'Thông Báo Đang Chờ';

  @override
  String get noPendingNotifications => 'Không có thông báo đang chờ';

  @override
  String get close => 'Đóng';
}
