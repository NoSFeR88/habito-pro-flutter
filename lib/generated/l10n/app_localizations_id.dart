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
