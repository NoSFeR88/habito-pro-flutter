import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/stats_overview.dart';
import '../models/habit.dart';
import '../core/theme.dart';
import '../services/notification_service.dart';
import '../generated/l10n/app_localizations.dart';
import 'add_habit_screen.dart';
import 'edit_habit_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HabitProvider>(context, listen: false);
      provider.initializeHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotificationTests(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loading,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (habitProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    habitProvider.errorMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      habitProvider.clearError();
                      habitProvider.initializeHabits();
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          final habits = habitProvider.habits;
          final habitsToday = habitProvider.habitsForToday;

          return Column(
            children: [
              // Resumen de estadísticas con navegación
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatsOverview(),
                ),
              ),

              // Título de hábitos de hoy
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.today,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hoy • ${_getCurrentDateString()}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de hábitos de hoy
              Expanded(
                child: habitsToday.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: habitsToday.length,
                        itemBuilder: (context, index) {
                          final habit = habitsToday[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: HabitCard(
                              habit: habit,
                              onTap: () => _toggleHabit(context, habit.id),
                              onLongPress: () => _showHabitOptions(context, habit),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_satisfied_alt,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '¡Todo listo por hoy!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No tienes hábitos programados para hoy o ya los completaste todos.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddHabitScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear mi primer hábito'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleHabit(BuildContext context, String habitId) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    provider.toggleHabitCompletion(habitId);
    
    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Hábito actualizado!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showHabitOptions(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(habit.icon, color: Color(habit.color)),
                title: Text(habit.name),
                subtitle: Text(habit.description),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditHabitScreen(habit: habit),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Ver estadísticas'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navegar a estadísticas del hábito
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Eliminar',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteHabit(context, habit);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteHabit(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar hábito'),
          content: Text('¿Estás seguro de que quieres eliminar "${habit.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final provider = Provider.of<HabitProvider>(context, listen: false);
                provider.deleteHabit(habit.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hábito "${habit.name}" eliminado')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  String _getCurrentDateString() {
    final now = DateTime.now();
    final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  void _showNotificationTests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.science_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pruebas de Notificaciones',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.notification_add, color: Colors.blue),
                title: const Text('Notificación Inmediata'),
                subtitle: const Text('Mostrar notificación ahora mismo'),
                onTap: () async {
                  Navigator.pop(context);
                  await NotificationService().testNotification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Notificación enviada! Revisa la barra de notificaciones'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.orange),
                title: const Text('Notificación Programada'),
                subtitle: const Text('Programar notificación en 5 segundos'),
                onTap: () async {
                  Navigator.pop(context);
                  await NotificationService().testScheduledNotification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notificación programada para 5 segundos'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.green),
                title: const Text('Reprogramar Todos los Hábitos'),
                subtitle: const Text('Actualizar todas las notificaciones'),
                onTap: () async {
                  Navigator.pop(context);
                  final habitProvider = Provider.of<HabitProvider>(context, listen: false);
                  await habitProvider.rescheduleAllNotifications();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notificaciones reprogramadas exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, color: Colors.purple),
                title: const Text('Ver Notificaciones Pendientes'),
                subtitle: const Text('Mostrar notificaciones programadas'),
                onTap: () async {
                  Navigator.pop(context);
                  final pending = await NotificationService().getPendingNotifications();
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Notificaciones Pendientes'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: pending.isEmpty
                                ? [const Text('No hay notificaciones pendientes')]
                                : pending.map((notification) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        'ID: ${notification.id}\n'
                                        'Título: ${notification.title ?? 'Sin título'}\n'
                                        'Cuerpo: ${notification.body ?? 'Sin descripción'}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}