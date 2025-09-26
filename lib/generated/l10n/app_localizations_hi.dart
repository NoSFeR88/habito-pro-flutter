// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आदत प्रो';

  @override
  String get homeAppBarTitle => 'आदत प्रो';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get today => 'आज';

  @override
  String todayWithDate(String date) {
    return 'आज • $date';
  }

  @override
  String get allDoneToday => 'आज का सब काम हो गया!';

  @override
  String get noProgrammedHabits =>
      'आपकी आज के लिए कोई आदतें निर्धारित नहीं हैं या आपने सभी पूरी कर ली हैं।';

  @override
  String get createFirstHabit => 'मेरी पहली आदत बनाएं';

  @override
  String get habitUpdated => 'आदत अपडेट हो गई!';

  @override
  String get edit => 'संपादित करें';

  @override
  String get viewStatistics => 'आंकड़े देखें';

  @override
  String get delete => 'हटाएं';

  @override
  String get deleteHabit => 'आदत हटाएं';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'क्या आप वाकई \"$habitName\" को हटाना चाहते हैं?';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String habitDeleted(String habitName) {
    return 'आदत \"$habitName\" हटा दी गई';
  }

  @override
  String get mondayShort => 'सोम';

  @override
  String get tuesdayShort => 'मंगल';

  @override
  String get wednesdayShort => 'बुध';

  @override
  String get thursdayShort => 'गुरु';

  @override
  String get fridayShort => 'शुक्र';

  @override
  String get saturdayShort => 'शनि';

  @override
  String get sundayShort => 'रवि';

  @override
  String get januaryShort => 'जन';

  @override
  String get februaryShort => 'फ़र';

  @override
  String get marchShort => 'मार्च';

  @override
  String get aprilShort => 'अप्रै';

  @override
  String get mayShort => 'मई';

  @override
  String get juneShort => 'जून';

  @override
  String get julyShort => 'जुल';

  @override
  String get augustShort => 'अग';

  @override
  String get septemberShort => 'सित';

  @override
  String get octoberShort => 'अक्टू';

  @override
  String get novemberShort => 'नव';

  @override
  String get decemberShort => 'दिस';

  @override
  String get newHabit => 'नई आदत';

  @override
  String get save => 'सहेजें';

  @override
  String get statsToday => 'आज';

  @override
  String get statsWeek => 'सप्ताह';

  @override
  String get statsMonth => 'महीना';

  @override
  String get notificationTests => 'सूचना परीक्षण';

  @override
  String get immediateNotification => 'तत्काल सूचना';

  @override
  String get showNotificationNow => 'अभी सूचना दिखाएं';

  @override
  String get scheduledNotification => 'निर्धारित सूचना';

  @override
  String get scheduleIn5Seconds => '5 सेकंड में सूचना निर्धारित करें';

  @override
  String get rescheduleAllHabits => 'सभी आदतों को फिर से निर्धारित करें';

  @override
  String get updateAllNotifications => 'सभी सूचनाएं अपडेट करें';

  @override
  String get viewPendingNotifications => 'लंबित सूचनाएं देखें';

  @override
  String get showScheduledNotifications => 'निर्धारित सूचनाएं दिखाएं';

  @override
  String get notificationSent => 'सूचना भेजी गई! अपनी सूचना पट्टी जांचें';

  @override
  String get notificationScheduled => '5 सेकंड के लिए सूचना निर्धारित की गई';

  @override
  String get notificationsRescheduled =>
      'सूचनाएं सफलतापूर्वक फिर से निर्धारित की गईं';

  @override
  String get pendingNotifications => 'लंबित सूचनाएं';

  @override
  String get noPendingNotifications => 'कोई लंबित सूचनाएं नहीं';

  @override
  String get close => 'बंद करें';
}
