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
