// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Alışkanlık Pro';

  @override
  String get homeAppBarTitle => 'Alışkanlık Pro';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get today => 'Bugün';

  @override
  String todayWithDate(String date) {
    return 'Bugün • $date';
  }

  @override
  String get allDoneToday => 'Bugün için her şey tamam!';

  @override
  String get noProgrammedHabits =>
      'Bugün için programlanmış alışkanlığınız yok veya hepsini tamamladınız.';

  @override
  String get createFirstHabit => 'İlk alışkanlığımı oluştur';

  @override
  String get habitUpdated => 'Alışkanlık güncellendi!';

  @override
  String get edit => 'Düzenle';

  @override
  String get viewStatistics => 'İstatistikleri görüntüle';

  @override
  String get delete => 'Sil';

  @override
  String get deleteHabit => 'Alışkanlığı sil';

  @override
  String confirmDeleteHabit(String habitName) {
    return '\"$habitName\"i silmek istediğinizden emin misiniz?';
  }

  @override
  String get cancel => 'İptal';

  @override
  String habitDeleted(String habitName) {
    return '\"$habitName\" alışkanlığı silindi';
  }

  @override
  String get mondayShort => 'Pzt';

  @override
  String get tuesdayShort => 'Sal';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get thursdayShort => 'Per';

  @override
  String get fridayShort => 'Cum';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get sundayShort => 'Paz';

  @override
  String get januaryShort => 'Oca';

  @override
  String get februaryShort => 'Şub';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Nis';

  @override
  String get mayShort => 'May';

  @override
  String get juneShort => 'Haz';

  @override
  String get julyShort => 'Tem';

  @override
  String get augustShort => 'Ağu';

  @override
  String get septemberShort => 'Eyl';

  @override
  String get octoberShort => 'Eki';

  @override
  String get novemberShort => 'Kas';

  @override
  String get decemberShort => 'Ara';

  @override
  String get newHabit => 'Yeni Alışkanlık';

  @override
  String get save => 'Kaydet';

  @override
  String get statsToday => 'Bugün';

  @override
  String get statsWeek => 'Hafta';

  @override
  String get statsMonth => 'Ay';

  @override
  String get notificationTests => 'Bildirim Testleri';

  @override
  String get immediateNotification => 'Anında Bildirim';

  @override
  String get showNotificationNow => 'Bildirimi şimdi göster';

  @override
  String get scheduledNotification => 'Zamanlanmış Bildirim';

  @override
  String get scheduleIn5Seconds => '5 saniye içinde bildirim zamanla';

  @override
  String get rescheduleAllHabits => 'Tüm Alışkanlıkları Yeniden Zamanla';

  @override
  String get updateAllNotifications => 'Tüm bildirimleri güncelle';

  @override
  String get viewPendingNotifications => 'Bekleyen Bildirimleri Görüntüle';

  @override
  String get showScheduledNotifications => 'Zamanlanmış bildirimleri göster';

  @override
  String get notificationSent =>
      'Bildirim gönderildi! Bildirim çubuğunuzu kontrol edin';

  @override
  String get notificationScheduled => '5 saniye için bildirim zamanlandı';

  @override
  String get notificationsRescheduled =>
      'Bildirimler başarıyla yeniden zamanlandı';

  @override
  String get pendingNotifications => 'Bekleyen Bildirimler';

  @override
  String get noPendingNotifications => 'Bekleyen bildirim yok';

  @override
  String get close => 'Kapat';
}
