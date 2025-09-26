// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hábito Pro';

  @override
  String get homeAppBarTitle => 'Hábito Pro';

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
      'No tienes hábitos programados para hoy o ya los completaste todos.';

  @override
  String get createFirstHabit => 'Crear mi primer hábito';

  @override
  String get habitUpdated => '¡Hábito actualizado!';

  @override
  String get edit => 'Editar';

  @override
  String get viewStatistics => 'Ver estadísticas';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteHabit => 'Eliminar hábito';

  @override
  String confirmDeleteHabit(String habitName) {
    return '¿Estás seguro de que quieres eliminar \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String habitDeleted(String habitName) {
    return 'Hábito \"$habitName\" eliminado';
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
  String get decemberShort => 'Dic';

  @override
  String get newHabit => 'Nuevo Hábito';

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
  String get notificationScheduled => 'Notificación programada para 5 segundos';

  @override
  String get notificationsRescheduled =>
      'Notificaciones reprogramadas exitosamente';

  @override
  String get pendingNotifications => 'Notificaciones Pendientes';

  @override
  String get noPendingNotifications => 'No hay notificaciones pendientes';

  @override
  String get close => 'Cerrar';
}
