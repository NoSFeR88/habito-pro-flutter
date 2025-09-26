// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عادة برو';

  @override
  String get homeAppBarTitle => 'عادة برو';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get today => 'اليوم';

  @override
  String todayWithDate(String date) {
    return 'اليوم • $date';
  }

  @override
  String get allDoneToday => 'تم الانتهاء من كل شيء لليوم!';

  @override
  String get noProgrammedHabits =>
      'ليس لديك عادات مجدولة لليوم أو أنك أكملتها جميعاً.';

  @override
  String get createFirstHabit => 'إنشاء عادتي الأولى';

  @override
  String get habitUpdated => 'تم تحديث العادة!';

  @override
  String get edit => 'تحرير';

  @override
  String get viewStatistics => 'عرض الإحصائيات';

  @override
  String get delete => 'حذف';

  @override
  String get deleteHabit => 'حذف العادة';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'هل أنت متأكد من أنك تريد حذف \"$habitName\"؟';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String habitDeleted(String habitName) {
    return 'تم حذف العادة \"$habitName\"';
  }

  @override
  String get mondayShort => 'الإث';

  @override
  String get tuesdayShort => 'الثلا';

  @override
  String get wednesdayShort => 'الأرب';

  @override
  String get thursdayShort => 'الخم';

  @override
  String get fridayShort => 'الجم';

  @override
  String get saturdayShort => 'السب';

  @override
  String get sundayShort => 'الأحد';

  @override
  String get januaryShort => 'يناير';

  @override
  String get februaryShort => 'فبراير';

  @override
  String get marchShort => 'مارس';

  @override
  String get aprilShort => 'أبريل';

  @override
  String get mayShort => 'مايو';

  @override
  String get juneShort => 'يونيو';

  @override
  String get julyShort => 'يوليو';

  @override
  String get augustShort => 'أغسطس';

  @override
  String get septemberShort => 'سبتمبر';

  @override
  String get octoberShort => 'أكتوبر';

  @override
  String get novemberShort => 'نوفمبر';

  @override
  String get decemberShort => 'ديسمبر';

  @override
  String get newHabit => 'عادة جديدة';

  @override
  String get save => 'حفظ';

  @override
  String get statsToday => 'اليوم';

  @override
  String get statsWeek => 'الأسبوع';

  @override
  String get statsMonth => 'الشهر';

  @override
  String get notificationTests => 'اختبارات الإشعارات';

  @override
  String get immediateNotification => 'إشعار فوري';

  @override
  String get showNotificationNow => 'إظهار الإشعار الآن';

  @override
  String get scheduledNotification => 'إشعار مجدول';

  @override
  String get scheduleIn5Seconds => 'جدولة الإشعار خلال 5 ثوان';

  @override
  String get rescheduleAllHabits => 'إعادة جدولة جميع العادات';

  @override
  String get updateAllNotifications => 'تحديث جميع الإشعارات';

  @override
  String get viewPendingNotifications => 'عرض الإشعارات المعلقة';

  @override
  String get showScheduledNotifications => 'إظهار الإشعارات المجدولة';

  @override
  String get notificationSent => 'تم إرسال الإشعار! تحقق من شريط الإشعارات';

  @override
  String get notificationScheduled => 'تم جدولة الإشعار لمدة 5 ثوان';

  @override
  String get notificationsRescheduled => 'تم إعادة جدولة الإشعارات بنجاح';

  @override
  String get pendingNotifications => 'الإشعارات المعلقة';

  @override
  String get noPendingNotifications => 'لا توجد إشعارات معلقة';

  @override
  String get close => 'إغلاق';
}
