// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Hábito Pro';

  @override
  String get homeAppBarTitle => 'Hábito Pro';

  @override
  String get loading => 'Carregando...';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get today => 'Hoje';

  @override
  String todayWithDate(String date) {
    return 'Hoje • $date';
  }

  @override
  String get allDoneToday => 'Tudo pronto para hoje!';

  @override
  String get noProgrammedHabits =>
      'Não tens hábitos programados para hoje ou já completaste todos.';

  @override
  String get createFirstHabit => 'Criar o meu primeiro hábito';

  @override
  String get habitUpdated => 'Hábito atualizado!';

  @override
  String get edit => 'Editar';

  @override
  String get viewStatistics => 'Ver estatísticas';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteHabit => 'Eliminar hábito';

  @override
  String confirmDeleteHabit(String habitName) {
    return 'Tens a certeza de que queres eliminar \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String habitDeleted(String habitName) {
    return 'Hábito \"$habitName\" eliminado';
  }

  @override
  String get mondayShort => 'Seg';

  @override
  String get tuesdayShort => 'Ter';

  @override
  String get wednesdayShort => 'Qua';

  @override
  String get thursdayShort => 'Qui';

  @override
  String get fridayShort => 'Sex';

  @override
  String get saturdayShort => 'Sáb';

  @override
  String get sundayShort => 'Dom';

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
  String get februaryShort => 'Fev';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Abr';

  @override
  String get mayShort => 'Mai';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Ago';

  @override
  String get septemberShort => 'Set';

  @override
  String get octoberShort => 'Out';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dez';

  @override
  String get newHabit => 'Novo Hábito';

  @override
  String get save => 'Guardar';

  @override
  String get statsToday => 'Hoje';

  @override
  String get statsWeek => 'Semana';

  @override
  String get statsMonth => 'Mês';

  @override
  String get notificationTests => 'Testes de Notificações';

  @override
  String get immediateNotification => 'Notificação Imediata';

  @override
  String get showNotificationNow => 'Mostrar notificação agora';

  @override
  String get scheduledNotification => 'Notificação Programada';

  @override
  String get scheduleIn5Seconds => 'Programar notificação em 5 segundos';

  @override
  String get rescheduleAllHabits => 'Reprogramar Todos os Hábitos';

  @override
  String get updateAllNotifications => 'Atualizar todas as notificações';

  @override
  String get viewPendingNotifications => 'Ver Notificações Pendentes';

  @override
  String get showScheduledNotifications => 'Mostrar notificações programadas';

  @override
  String get notificationSent =>
      'Notificação enviada! Verifica a barra de notificações';

  @override
  String get notificationScheduled => 'Notificação programada para 5 segundos';

  @override
  String get notificationsRescheduled =>
      'Notificações reprogramadas com sucesso';

  @override
  String get pendingNotifications => 'Notificações Pendentes';

  @override
  String get noPendingNotifications => 'Sem notificações pendentes';

  @override
  String get close => 'Fechar';
}
