// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kebiasaan Pro';

  @override
  String get homeAppBarTitle => 'Kebiasaan Pro';

  @override
  String get loading => 'Memuat...';

  @override
  String get retry => 'Coba lagi';

  @override
  String get today => 'Hari ini';

  @override
  String todayWithDate(String date) {
    return 'Hari ini • $date';
  }

  @override
  String get allDoneToday => 'Semua selesai untuk hari ini!';

  @override
  String get noProgrammedHabits =>
      'Anda tidak memiliki kebiasaan yang dijadwalkan untuk hari ini atau sudah menyelesaikan semuanya.';

  @override
  String get createFirstHabit => 'Buat kebiasaan pertama saya';

  @override
  String get habitUpdated => 'Kebiasaan diperbarui!';

  @override
  String get edit => 'Edit';

  @override
  String get viewStatistics => 'Lihat statistik';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteHabit => 'Hapus kebiasaan';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Apakah Anda yakin ingin menghapus \"$habitName\"?';
  }

  @override
  String get cancel => 'Batal';

  @override
  String habitDeleted(String habitName) {
    return 'Kebiasaan \"$habitName\" dihapus';
  }

  @override
  String get mondayShort => 'Sen';

  @override
  String get tuesdayShort => 'Sel';

  @override
  String get wednesdayShort => 'Rab';

  @override
  String get thursdayShort => 'Kam';

  @override
  String get fridayShort => 'Jum';

  @override
  String get saturdayShort => 'Sab';

  @override
  String get sundayShort => 'Min';

  @override
  String get januaryShort => 'Jan';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Apr';

  @override
  String get mayShort => 'Mei';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Agu';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Okt';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Des';

  @override
  String get newHabit => 'Kebiasaan Baru';

  @override
  String get save => 'Simpan';

  @override
  String get statsToday => 'Hari ini';

  @override
  String get statsWeek => 'Minggu';

  @override
  String get statsMonth => 'Bulan';

  @override
  String get notificationTests => 'Tes Notifikasi';

  @override
  String get immediateNotification => 'Notifikasi Langsung';

  @override
  String get showNotificationNow => 'Tampilkan notifikasi sekarang';

  @override
  String get scheduledNotification => 'Notifikasi Terjadwal';

  @override
  String get scheduleIn5Seconds => 'Jadwalkan notifikasi dalam 5 detik';

  @override
  String get rescheduleAllHabits => 'Jadwalkan Ulang Semua Kebiasaan';

  @override
  String get updateAllNotifications => 'Perbarui semua notifikasi';

  @override
  String get viewPendingNotifications => 'Lihat Notifikasi Tertunda';

  @override
  String get showScheduledNotifications => 'Tampilkan notifikasi terjadwal';

  @override
  String get notificationSent =>
      'Notifikasi terkirim! Periksa bilah notifikasi Anda';

  @override
  String get notificationScheduled => 'Notifikasi dijadwalkan selama 5 detik';

  @override
  String get notificationsRescheduled =>
      'Notifikasi berhasil dijadwalkan ulang';

  @override
  String get pendingNotifications => 'Notifikasi Tertunda';

  @override
  String get noPendingNotifications => 'Tidak ada notifikasi tertunda';

  @override
  String get close => 'Tutup';
}
