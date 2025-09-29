// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'RITMO';

  @override
  String get homeAppBarTitle => 'RITMO';

  @override
  String get loading => 'Cargando...';

  @override
  String get retry => 'Reintentar';

  @override
  String get today => 'Hoy';

  @override
  String todayWithDate(String date) {
    return 'Hoy • $date';
  }

  @override
  String get allDoneToday => '¡Todo listo por hoy!';

  @override
  String get noProgrammedHabits =>
      'No tienes ritmos programados para hoy o ya los completaste todos.';

  @override
  String get createFirstHabit => 'Crear mi primer ritmo';

  @override
  String get rhythmUpdated => 'Habit updated!';

  @override
  String get edit => 'Editar';

  @override
  String get viewStatistics => 'Ver estadísticas';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteHabit => 'Eliminar ritmo';

  @override
  String confirmDeleteHabit(String rhythmName, Object habitName) {
    return '¿Estás seguro de que quieres eliminar \"$rhythmName\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String rhythmDeleted(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Mié';

  @override
  String get thursdayShort => 'Jue';

  @override
  String get fridayShort => 'Vie';

  @override
  String get saturdayShort => 'Sáb';

  @override
  String get sundayShort => 'Dom';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a Ritmo!';

  @override
  String get onboardingWelcomeSubtitle =>
      'La única app de hábitos que se adapta a TU vida real';

  @override
  String get onboardingFeatureFlexible => 'Hábitos flexibles adaptados a ti';

  @override
  String get onboardingFeatureMotivating => 'Diseño motivador que inspira';

  @override
  String get onboardingFeature26Languages => '26 idiomas - Líder del mercado';

  @override
  String get onboardingDiscoverDifference => 'Descubre la diferencia';

  @override
  String get onboardingProblemTitle => '¿Cansado de apps demasiado rígidas?';

  @override
  String get onboardingOtherApps => 'Otras apps';

  @override
  String get onboardingProblemExample => 'Gym TODOS los días ❌';

  @override
  String get onboardingSolutionExample => 'Gym Lun-Mié-Vie ✅ (TU ritmo)';

  @override
  String get onboardingFlexibilityMessage =>
      'Tu vida es única. Tus hábitos también deberían serlo.';

  @override
  String get onboardingThisSounds => 'Esto me suena familiar';

  @override
  String get onboardingSetupTitle => 'Crea tu primer hábito flexible';

  @override
  String get onboardingFlexibilityTip =>
      '💡 Consejo: Elige días realistas para tu estilo de vida';

  @override
  String get onboardingCreateFirstHabit => 'Crear mi primer hábito';

  @override
  String get onboardingCelebrationTitle => '¡Perfecto! Ya tienes tu ritmo';

  @override
  String get onboardingCelebrationSubtitle =>
      'Tu primer hábito flexible está listo para comenzar';

  @override
  String get onboardingDefaultHabitName => 'Mi primer hábito';

  @override
  String get onboardingNoDaysSelected => 'Sin días seleccionados';

  @override
  String get onboardingBenefitFlexibility => 'Flexibilidad total';

  @override
  String get onboardingBenefitMotivation => 'Motivación constante';

  @override
  String get onboardingBenefit26Languages => '26 idiomas disponibles';

  @override
  String get onboardingStartMyRhythm => 'Comenzar mi ritmo';

  @override
  String get rhythmName => 'Habit name';

  @override
  String get rhythmNameHint => 'E.g: Exercise, Read, Meditate...';

  @override
  String get selectDays => 'Selecciona días';

  @override
  String get januaryShort => 'Ene';

  @override
  String get februaryShort => 'Feb';

  @override
  String get marchShort => 'Mar';

  @override
  String get aprilShort => 'Abr';

  @override
  String get mayShort => 'May';

  @override
  String get juneShort => 'Jun';

  @override
  String get julyShort => 'Jul';

  @override
  String get augustShort => 'Ago';

  @override
  String get septemberShort => 'Sep';

  @override
  String get octoberShort => 'Oct';

  @override
  String get novemberShort => 'Nov';

  @override
  String get decemberShort => 'Dec';

  @override
  String get newHabit => 'Nuevo Ritmo';

  @override
  String get save => 'Guardar';

  @override
  String get statsToday => 'Hoy';

  @override
  String get statsWeek => 'Semana';

  @override
  String get statsMonth => 'Mes';

  @override
  String get notificationTests => 'Pruebas de Notificaciones';

  @override
  String get immediateNotification => 'Notificación Inmediata';

  @override
  String get showNotificationNow => 'Mostrar notificación ahora mismo';

  @override
  String get scheduledNotification => 'Notificación Programada';

  @override
  String get scheduleIn5Seconds => 'Programar notificación en 5 segundos';

  @override
  String get rescheduleAllHabits => 'Reprogramar Todos los Hábitos';

  @override
  String get updateAllNotifications => 'Actualizar todas las notificaciones';

  @override
  String get viewPendingNotifications => 'Ver Notificaciones Pendientes';

  @override
  String get showScheduledNotifications => 'Mostrar notificaciones programadas';

  @override
  String get notificationSent =>
      '¡Notificación enviada! Revisa la barra de notificaciones';

  @override
  String notificationScheduled(String rhythmName, String dateTime) {
    return 'Notificación programada para 5 segundos';
  }

  @override
  String get notificationsRescheduled =>
      'Notificaciones reprogramadas exitosamente';

  @override
  String get pendingNotifications => 'Notificaciones Pendientes';

  @override
  String get noPendingNotifications => 'No hay notificaciones pendientes';

  @override
  String get close => 'Cerrar';

  @override
  String get monthlyProgress => 'Progreso Mensual';

  @override
  String get rhythmStreaks => 'Habit Streaks';

  @override
  String get monthlyCalendar => 'Calendario del Mes';

  @override
  String get monthlyStats => 'Estadísticas del Mes';

  @override
  String get activeDays => 'Días Activos';

  @override
  String get bestStreak => 'Mejor Racha';

  @override
  String get averageCompletion => 'Promedio';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get themes => 'Temas';

  @override
  String get themeBasicBlue => 'Azul Básico';

  @override
  String get themeBasicGreen => 'Verde Básico';

  @override
  String get themeBasicPurple => 'Púrpura Básico';

  @override
  String get themeCyberNeon => 'Neón Cibernético';

  @override
  String get themeAuroraInspiration => 'Inspiración Aurora';

  @override
  String get themeZenGarden => 'Jardín Zen';

  @override
  String get premiumThemes => 'Temas Premium';

  @override
  String get activatePremium => 'Activar Premium';

  @override
  String get premiumPrice => 'Precio Premium';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get manageHabits => 'Gestionar Ritmos';

  @override
  String get noActiveHabits => 'No hay ritmos activos';

  @override
  String get createFirstHabitToStart => 'Crea tu primer ritmo para comenzar';

  @override
  String get noPausedHabits => 'No hay ritmos pausados';

  @override
  String get pausedHabitsWillAppearHere =>
      'Los ritmos pausados aparecerán aquí';

  @override
  String get noHabits => 'No hay hábitos';

  @override
  String get startJourneyCreatingFirstHabit =>
      'Comienza tu viaje creando tu primer hábito';

  @override
  String get deleteHabitConfirm => 'Confirmar eliminación de hábito';

  @override
  String get editHabit => 'Editar Hábito';

  @override
  String get basicInformation => 'Información Básica';

  @override
  String get rhythmNameLabel => 'Habit name';

  @override
  String get descriptionOptional => 'Descripción (Opcional)';

  @override
  String get descriptionHint =>
      'Ej: Ejercicio matutino, Leer antes de dormir...';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get allDays => 'Todos los días';

  @override
  String get weekdays => 'Días laborables';

  @override
  String get deleteHabitButton => 'Eliminar Hábito';

  @override
  String get deleteWarning => 'Advertencia de Eliminación';

  @override
  String get selectAtLeastOneDay => 'Selecciona al menos un día de la semana';

  @override
  String rhythmUpdatedSuccess(String rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String errorUpdatingHabit(String error) {
    return 'Error actualizando hábito';
  }

  @override
  String get deleteHabitTitle => 'Eliminar Hábito';

  @override
  String deleteHabitConfirmation(String rhythmName) {
    return 'Confirmación de eliminación de hábito';
  }

  @override
  String rhythmDeletedSuccess(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String errorDeletingHabit(String error) {
    return 'Error eliminando hábito';
  }

  @override
  String limitReached(int maxHabits) {
    return 'Límite alcanzado';
  }

  @override
  String get premiumThemesOnly => 'Solo en Temas Premium';

  @override
  String get advancedStatsOnly => 'Solo en Estadísticas Avanzadas';

  @override
  String get exportDataOnly => 'Solo en Exportar Datos';

  @override
  String get aiInsightsOnly => 'Solo en Insights de IA';

  @override
  String get featureOnlyInPro => 'Función solo en PRO';

  @override
  String get loadingYourHabits => 'Cargando tus hábitos...';

  @override
  String get guestMode => 'Modo invitado';

  @override
  String get createAccountToSave => 'Crear cuenta para guardar';

  @override
  String get later => 'Más tarde';

  @override
  String loginError(String error) {
    return 'Error de inicio de sesión';
  }

  @override
  String logoutError(String error) {
    return 'Error al cerrar sesión';
  }

  @override
  String get wrongPassword => 'Contraseña incorrecta';

  @override
  String get passwordTooShort => 'Contraseña muy corta';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get tooManyAttempts => 'Demasiados intentos';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String authError(String message) {
    return 'Error de autenticación';
  }

  @override
  String get champion => 'Campeón';

  @override
  String get hero => 'Héroe';

  @override
  String get mythic => 'Mítico';

  @override
  String get maximum => 'Máximo';

  @override
  String get completeFirstHabit3Days =>
      'Completa tu primer hábito 3 días seguidos';

  @override
  String get maintain7DayStreak => 'Mantén una racha de 7 días';

  @override
  String get maintain30DayStreak => 'Mantén una racha de 30 días';

  @override
  String get completeFirstHabit => 'Completa tu primer hábito';

  @override
  String get complete100Habits => 'Completa 100 hábitos en total';

  @override
  String get complete500Habits => 'Completa 500 hábitos en total';

  @override
  String get completeAllHabitsWeek =>
      'Completa todos tus hábitos durante una semana';

  @override
  String get create5DifferentHabits => 'Crea 5 hábitos diferentes';

  @override
  String get reachLevel5 => 'Alcanza el nivel 5';

  @override
  String get noHabitsToday => 'No tienes hábitos para hoy';

  @override
  String get allHabitsPaused => 'Todos los hábitos están pausados';

  @override
  String get startJourneyBetterHabits =>
      'Comienza tu viaje hacia mejores hábitos';

  @override
  String get createNewHabit => 'Crear Nuevo Hábito';

  @override
  String get createMyFirstHabit => 'Crear Mi Primer Hábito';

  @override
  String get notificationSettings => 'Configuración de Notificaciones';

  @override
  String get receiveRemindersForHabits =>
      'Recibe recordatorios para tus hábitos';

  @override
  String get openSystemSettings => 'Abrir configuración del sistema';

  @override
  String get settingsLabel => 'Configuración';

  @override
  String get rhythmReminders => 'Habit Reminders';

  @override
  String get notificationsToRemind => 'Notificaciones para recordar';

  @override
  String get reminderTicker => 'Ticker de recordatorio';

  @override
  String get timeToWorkOnHabit => '¡Es hora de trabajar en tu hábito!';

  @override
  String notificationsCancelled(String rhythmId) {
    return 'Notificaciones canceladas';
  }

  @override
  String errorCancellingNotifications(String rhythmId, String error) {
    return 'Error cancelando notificaciones';
  }

  @override
  String instantNotificationSent(String title) {
    return 'Notificación instantánea enviada';
  }

  @override
  String errorSendingNotification(String error) {
    return 'Error enviando notificación';
  }

  @override
  String get testNotificationTitle => '🧪 Prueba de Notificación';

  @override
  String get scheduledNotificationTitle => '⏰ Notificación Programada';

  @override
  String get scheduledNotificationBody =>
      'Esta notificación se programó hace 5 segundos';

  @override
  String get testNotificationScheduled => 'Notificación de prueba programada';

  @override
  String errorSchedulingTestNotification(String error) {
    return 'Error programando notificación de prueba';
  }

  @override
  String localizationInitialized(String languageCode) {
    return 'Localización inicializada';
  }

  @override
  String notificationReceivediOS(String title) {
    return 'Notificación recibida en iOS';
  }

  @override
  String userTappedNotification(String payload) {
    return 'Usuario tocó notificación';
  }

  @override
  String rhythmUpdatedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" updated successfully';
  }

  @override
  String confirmDeleteHabitMessage(String rhythmName) {
    return 'Confirmar mensaje de eliminación de hábito';
  }

  @override
  String rhythmDeletedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" deleted';
  }

  @override
  String rhythmCreatedSuccessfully(String rhythmName) {
    return 'Habit \"$rhythmName\" created successfully';
  }

  @override
  String confirmDeleteHabitShort(String rhythmName) {
    return 'Confirmar eliminación de hábito (corto)';
  }

  @override
  String get ensureAppNotInDoNotDisturb =>
      'Asegúrate de que la app no esté en No Molestar';

  @override
  String get firstStreak => 'Primera Racha';

  @override
  String get firstStreakDescription =>
      'Completa tu primer hábito 3 días seguidos';

  @override
  String get weekWarrior => 'Guerrero Semanal';

  @override
  String get weekWarriorDescription => 'Mantén una racha de 7 días';

  @override
  String get monthMaster => 'Maestro del Mes';

  @override
  String get monthMasterDescription => 'Mantén una racha de 30 días';

  @override
  String get firstStep => 'Primer Paso';

  @override
  String get firstStepDescription => 'Descripción del primer paso';

  @override
  String get centuryClub => 'Club del Centenar';

  @override
  String get centuryClubDescription => 'Descripción del club del centenar';

  @override
  String get marathonRunner => 'Corredor de Maratón';

  @override
  String get marathonRunnerDescription => 'Descripción del corredor de maratón';

  @override
  String get perfectWeek => 'Semana Perfecta';

  @override
  String get perfectWeekDescription => 'Descripción de semana perfecta';

  @override
  String get rhythmCreator => 'Habit Creator';

  @override
  String get rhythmCreatorDescription => 'Create 5 different rhythms';

  @override
  String get achievements => 'Logros';

  @override
  String get yourProgress => 'Tu Progreso';

  @override
  String get level => 'Nivel';

  @override
  String get points => 'Puntos';

  @override
  String get totalAccumulated => 'Total Acumulado';

  @override
  String get achievementsLabel => 'Etiqueta de Logros';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get streak => 'Racha';

  @override
  String get maxDays => 'Días Máximos';

  @override
  String get currentLevel => 'Nivel Actual';

  @override
  String get nextLevel => 'Siguiente Nivel';

  @override
  String get pointsToNext => 'Puntos para Siguiente';

  @override
  String get allAchievements => 'Todos los Logros';

  @override
  String get progressToNextLevel => 'Progreso al Siguiente Nivel';

  @override
  String pointsToLevel(int points, int level) {
    return 'Puntos para Nivel';
  }

  @override
  String unlockedCount(int count) {
    return 'Conteo Desbloqueado';
  }

  @override
  String lockedCount(int count) {
    return 'Conteo Bloqueado';
  }

  @override
  String get active => 'Activo';

  @override
  String get paused => 'Pausado';

  @override
  String get all => 'Todos';

  @override
  String get premiumTestingActivated => 'Testing Premium Activado';

  @override
  String get removeAds => 'Remover Anuncios';

  @override
  String get removePermanentAds => 'Remover Anuncios Permanentes';

  @override
  String get noAdvertising => 'Sin Publicidad';

  @override
  String get premiumThemesFeature => 'Función de Temas Premium';

  @override
  String get startPro => 'Iniciar PRO';

  @override
  String get drinkWater => 'Beber Agua';

  @override
  String get exercise => 'Ejercicio';

  @override
  String get read => 'Leer';

  @override
  String get completed => 'Completado';

  @override
  String get currentStreak => 'Racha Actual';

  @override
  String get scheduled => 'Programado';

  @override
  String get goodAfternoon => 'Buenas Tardes';

  @override
  String get goodEvening => 'Buenas Noches';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String get mondayFull => 'Lunes';

  @override
  String get tuesdayFull => 'Martes';

  @override
  String get wednesdayFull => 'Miércoles';

  @override
  String get thursdayFull => 'Jueves';

  @override
  String get fridayFull => 'Viernes';

  @override
  String get saturdayFull => 'Sábado';

  @override
  String get sundayFull => 'Domingo';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get pro => 'PRO';

  @override
  String get appInformation => 'Información de la App';

  @override
  String get appName => 'Nombre de la App';

  @override
  String get version => 'Versión';

  @override
  String get currentLanguage => 'Idioma Actual';

  @override
  String get supportedLanguages => 'Idiomas Soportados';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reanudar';

  @override
  String get pending => 'Pendiente';

  @override
  String get monthly => 'Mensual';

  @override
  String get annual => 'Anual';

  @override
  String get lifetime => 'De por Vida';

  @override
  String get limitedOffer => 'Oferta Limitada';

  @override
  String get unlockFullPotential => 'Desbloquea el Potencial Completo';

  @override
  String get startWithRitmoPro => 'Comenzar con Ritmo PRO';

  @override
  String get noAdvertisingFeature => 'Sin Publicidad';

  @override
  String get completelyCleanExperience => 'Experiencia Completamente Limpia';

  @override
  String get cloudBackup => 'Respaldo en la Nube';

  @override
  String get yourDataSafeInCloud => 'Tus Datos Seguros en la Nube';

  @override
  String get aiInsights => 'Insights de IA';

  @override
  String get intelligentRecommendations => 'Recomendaciones Inteligentes';

  @override
  String get chooseYourPlan => 'Elige tu Plan';

  @override
  String get beginnerlevel => 'Principiante';

  @override
  String get apprenticeLevel => 'Aprendiz';

  @override
  String get dedicatedLevel => 'Dedicado';

  @override
  String get consistentLevel => 'Constante';

  @override
  String get expertLevel => 'Experto';

  @override
  String get masterLevel => 'Maestro';

  @override
  String get legendLevel => 'Leyenda';

  @override
  String get championLevel => 'Campeón';

  @override
  String get heroLevel => 'Héroe';

  @override
  String get mythicLevel => 'Mítico';

  @override
  String get maximumLevel => 'Máximo';

  @override
  String get defaultUser => 'Usuario';

  @override
  String get activateNotifications => 'Activar Notificaciones';

  @override
  String get updateAllNotificationsText =>
      'Actualizar todas las notificaciones';

  @override
  String get notificationsRescheduledSuccessfully =>
      'Notificaciones reprogramadas exitosamente';

  @override
  String get notificationHelp => 'Ayuda con Notificaciones';

  @override
  String get helpWithNotifications => 'Ayuda con Notificaciones';

  @override
  String get understood => 'Entendido';

  @override
  String languagesCount(int count) {
    return '$count idiomas';
  }

  @override
  String get icon => 'Icono';

  @override
  String get color => 'Color';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get reminderTime => 'Hora de Recordatorio';

  @override
  String get pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get nameMinTwoCharacters =>
      'El nombre debe tener al menos 2 caracteres';

  @override
  String get totalPoints => 'puntos totales';

  @override
  String progressToLevel(int level) {
    return 'Progreso al nivel $level';
  }

  @override
  String get maxLevelReached => '¡Nivel máximo alcanzado!';

  @override
  String get maxStreak => 'Racha Máxima';

  @override
  String get tapToViewMore => 'Toca para ver más';

  @override
  String get achievementUnlocked => '¡Logro Desbloqueado!';

  @override
  String get excellent => '¡Genial!';

  @override
  String pointsWithCount(int count) {
    return '$count puntos';
  }

  @override
  String get unlockedLabel => 'Desbloqueado';

  @override
  String percentCompleted(int percent) {
    return '$percent% Completado';
  }

  @override
  String get totalHabits => 'Total Ritmos';

  @override
  String percentThisWeek(int percent) {
    return '$percent% Esta semana';
  }

  @override
  String percentThisMonth(int percent) {
    return '$percent% Este mes';
  }

  @override
  String get days => 'días';

  @override
  String get twoWeeks => '2 sem.';

  @override
  String get oneMonth => '1 mes';

  @override
  String weekNumber(int number, int year) {
    return 'Semana $number del $year';
  }

  @override
  String dayOfMonth(int day, int total) {
    return 'Día $day de $total';
  }

  @override
  String dateFormat(int day, String month) {
    return '$day de $month';
  }

  @override
  String dateRangeFormat(
      int startDay, String startMonth, int endDay, String endMonth) {
    return '$startDay $startMonth - $endDay $endMonth';
  }

  @override
  String monthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get motivationPerfectDay =>
      '¡PERFECTO! 🎆\\nHas completado TODO hoy.\\n¡Eres imparable!';

  @override
  String get motivationAlmostPerfect =>
      '¡Casi perfecto! 🌟\\nSolo te falta un poquito.\\n¡Tú puedes!';

  @override
  String get motivationExcellentDay =>
      '¡Excelente día! 💪\\nVas súper bien.\\n¡Sigue así!';

  @override
  String get motivationGoodProgress =>
      '¡Buen progreso! 🚀\\nVas por buen camino.\\n¡No pares!';

  @override
  String get motivationStarted =>
      '¡Ya empezaste! 🌱\\nCada paso cuenta.\\n¡Continúa!';

  @override
  String get motivationFirstStep =>
      '¡Primer paso! ⭐\\nLo más difícil ya pasó.\\n¡Sigue!';

  @override
  String get motivationYourMoment =>
      '¡Tu momento! 🌅\\nComienza ahora.\\n¡Hazlo realidad!';

  @override
  String get motivationPerfectWeek =>
      '¡SEMANA PERFECTA! 🏆\\nDominaste todos tus hábitos.\\n¡Eres increíble!';

  @override
  String get motivationBrutalWeek =>
      '¡Semana brutal! 🔥\\nCasi perfecto.\\n¡Eres un crack!';

  @override
  String get motivationGreatWeek =>
      '¡Gran semana! 💪\\nTu disciplina paga.\\n¡Bien ahí!';

  @override
  String get motivationGoodRhythm =>
      '¡Buen ritmo! 📈\\nVas construyendo.\\n¡Sigue así!';

  @override
  String get motivationProgressing =>
      '¡Progresando! 🌱\\nCada semana cuenta.\\n¡No pares!';

  @override
  String get motivationStartedWeek =>
      '¡Empezaste! ✨\\nYa diste el primer paso.\\n¡Mejoremos!';

  @override
  String get motivationNewWeek =>
      '¡Nueva semana! 🌟\\nFresh start.\\n¡Hazla épica!';

  @override
  String get motivationLegendaryMonth =>
      '¡MES LEGENDARIO! 👑\\nPerfección total.\\n¡Eres inspiración!';

  @override
  String get motivationEpicMonth =>
      '¡Mes épico! 🎆\\nResultados increíbles.\\n¡Imparable!';

  @override
  String get motivationSolidMonth =>
      '¡Sólido mes! 💪\\nTu constancia paga.\\n¡Genial trabajo!';

  @override
  String get motivationGoodMonth =>
      '¡Buen mes! 📊\\nVas progresando.\\n¡Sigue mejorando!';

  @override
  String get motivationBuilding =>
      '¡Construyendo! 🏗️\\nCada mes cuenta.\\n¡Pa\'lante!';

  @override
  String get motivationSeedsPlanted =>
      '¡Semillas plantadas! 🌱\\nYa comenzaste.\\n¡Crecerás!';

  @override
  String get motivationNewMonth =>
      '¡Nuevo mes! 🚀\\nInfinitas posibilidades.\\n¡Hazlo tuyo!';

  @override
  String get motivationPerfectShort => '¡PERFECTO! Completaste todo hoy';

  @override
  String get motivationAlmostPerfectShort =>
      '¡Casi perfecto! Solo te falta un poquito';

  @override
  String get motivationExcellentShort => '¡Excelente día! Vas súper bien';

  @override
  String get motivationGoodProgressShort =>
      '¡Buen progreso! Vas por buen camino';

  @override
  String get motivationStartedShort => '¡Ya empezaste! Cada paso cuenta';

  @override
  String get motivationFirstStepShort => '¡Primer paso! Lo más difícil ya pasó';

  @override
  String get motivationYourMomentShort => '¡Tu momento! Comienza ahora';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get week => 'Semana';

  @override
  String get trends => 'Tendencias';

  @override
  String get completedHabits => 'Completados';

  @override
  String get percentage => 'Porcentaje';

  @override
  String get progressToday => 'Progreso de Hoy';

  @override
  String get completedCount => 'Completados';

  @override
  String get pendingCount => 'Pendientes';

  @override
  String get noHabitsToShow => 'No hay hábitos para mostrar';

  @override
  String get todaysHabits => 'Ritmos de Hoy';

  @override
  String get noHabitsScheduledToday => 'No hay ritmos programados para hoy';

  @override
  String get weeklyProgress => 'Progreso Semanal';

  @override
  String get dayShortMon => 'L';

  @override
  String get dayShortTue => 'M';

  @override
  String get dayShortWed => 'X';

  @override
  String get dayShortThu => 'J';

  @override
  String get dayShortFri => 'V';

  @override
  String get dayShortSat => 'S';

  @override
  String get dayShortSun => 'D';

  @override
  String get weeklyHeatMap => 'Mapa de Calor Semanal';

  @override
  String get legend => 'Leyenda';

  @override
  String get notScheduled => 'No programado';

  @override
  String get week1 => 'S1';

  @override
  String get week2 => 'S2';

  @override
  String get week3 => 'S3';

  @override
  String get week4 => 'S4';

  @override
  String get loadingHabits => 'Cargando tus ritmos...';

  @override
  String get guestModeWarning => 'Modo invitado - Tus datos no se guardarán';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get saveYourProgressTitle => 'Guardar tu progreso';

  @override
  String get createAccountDescription =>
      'Crea una cuenta para guardar tus hábitos y sincronizarlos entre dispositivos.';

  @override
  String get accountCreatedSuccess => '¡Cuenta creada exitosamente!';

  @override
  String get rhythmoPro => 'HábitoPro';

  @override
  String get productivityCoach => 'Tu coach de productividad';

  @override
  String get enjoyRitmoInterruptions =>
      'Disfruta de Ritmo sin interrupciones con Ritmo PRO:';

  @override
  String get unlimitedHabits => 'Ritmos ilimitados';

  @override
  String get advancedStats => 'Estadísticas avanzadas';

  @override
  String get pricingText => 'Solo \$3.99/mes - 20% menos que la competencia';

  @override
  String get paywallComingSoon => 'Paywall próximamente disponible';

  @override
  String get firstStreakAchievement => 'Primera Racha';

  @override
  String get weekWarriorAchievement => 'Guerrero Semanal';

  @override
  String get monthMasterAchievement => 'Maestro del Mes';

  @override
  String get firstStepAchievement => 'Primer Paso';

  @override
  String get centuryClubAchievement => 'Club del Centenar';

  @override
  String get marathonRunnerAchievement => 'Maratonista';

  @override
  String get perfectWeekAchievement => 'Semana Perfecta';

  @override
  String get rhythmCollectorAchievement => 'Collector';

  @override
  String get rhythmMasterAchievement => 'Maestro del Ritmo';

  @override
  String streakFormat(int streak) {
    return '$streak días';
  }

  @override
  String get notificationsToRemindHabits =>
      'Notificaciones para recordar completar tus hábitos diarios';

  @override
  String get rhythmReminderTicker => 'Habit reminder';

  @override
  String get defaultHabitReminder => '¡Es hora de trabajar en tu hábito!';

  @override
  String get testNotificationBody =>
      '¡Sistema de notificaciones funcionando correctamente!';

  @override
  String get rhythmUpdatedMessage => 'Habit updated!';

  @override
  String get openSystemSettingsMessage =>
      'Abre la configuración del sistema para gestionar las notificaciones';

  @override
  String get notReceivingReminders => '¿No recibes recordatorios?';

  @override
  String get rhythmDeletedMessage => 'Habit deleted';

  @override
  String get updateError => 'Error al actualizar el hábito';

  @override
  String get deleteError => 'Error al eliminar el hábito';

  @override
  String get habitUpdatedMessage => '¡Ritmo actualizado!';

  @override
  String get habitDeletedMessage => 'Ritmo eliminado';

  @override
  String get habitNameLabel => 'Nombre del Ritmo';

  @override
  String get habitReminders => 'Recordatorios de Ritmos';

  @override
  String get habitReminderTicker => 'Recordatorio de ritmo';

  @override
  String get habitStreaks => 'Rachas por Ritmo';

  @override
  String get habitCollectorAchievement => 'Coleccionista de Ritmos';

  @override
  String get habitCreatedSuccessfully => 'Ritmo creado exitosamente';

  @override
  String get habitNameHint => 'Ej: Ejercicio, Leer, Meditar...';

  @override
  String get welcomeToRitmoPro => '¡Bienvenido a Ritmo PRO! 🎉';

  @override
  String get purchaseError => 'Error en la compra';

  @override
  String get googleLogin => 'Google';

  @override
  String get send => 'Enviar';

  @override
  String get passwordResetMessage =>
      'Ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.';
}
