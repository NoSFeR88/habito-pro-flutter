import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/gamification_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/stats_overview.dart';
import '../widgets/gamification_card.dart';
import '../widgets/dynamic_ritmo_logo.dart';
import '../models/habit.dart';
import '../core/theme.dart';
import '../generated/l10n/app_localizations.dart';
import '../utils/responsive_utils.dart';
import 'add_habit_screen.dart';
import 'edit_habit_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'all_habits_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cache responsive values to avoid recalculating on every build
  late bool _isLandscape;
  late bool _isTablet;
  late EdgeInsets _screenPadding;
  late double _fabSize;
  late String _currentDateString;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      final gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);

      // Conectar providers
      habitProvider.setGamificationProvider(gamificationProvider);

      habitProvider.initializeHabits();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache responsive values
    _isLandscape = ResponsiveUtils.isLandscape(context);
    _isTablet = ResponsiveUtils.isTablet(context);
    _screenPadding = ResponsiveUtils.getScreenPadding(context);
    _fabSize = ResponsiveUtils.getFabSize(context);
    _currentDateString = _getCurrentDateString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: DynamicRitmoLogo(
          fontSize: 28,
          animated: true,
          changeInterval: Duration(seconds: 8),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Gestionar hábitos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllHabitsScreen()),
              );
            },
          ),
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
            onPressed: () => _showNotificationSettings(context),
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

          final habitsToday = habitProvider.habitsForToday;

          return _isLandscape
            ? _buildLandscapeLayout(context, habitsToday, _screenPadding)
            : _buildPortraitLayout(context, habitsToday, _screenPadding);
        },
      ),
      floatingActionButton: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          // Solo mostrar el FAB si hay hábitos activos (no solo pausados)
          final hasActiveHabits = habitProvider.habits.any((h) => h.isActive);

          return hasActiveHabits
              ? SizedBox(
                  width: _fabSize,
                  height: _fabSize,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              : const SizedBox.shrink(); // Ocultar el FAB cuando no hay hábitos activos
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final hasAnyHabits = habitProvider.habits.isNotEmpty;
        final hasActiveHabits = habitProvider.habits.any((h) => h.isActive);

        return Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasActiveHabits ? Icons.sentiment_satisfied_alt : Icons.eco,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                hasActiveHabits ? '¡Todo listo por hoy!' : '¡Bienvenido a Ritmo!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasActiveHabits
                    ? 'No tienes hábitos programados para hoy o ya los completaste todos.'
                    : hasAnyHabits
                        ? 'Todos tus hábitos están pausados. Reactiva alguno o crea uno nuevo.'
                        : 'Comienza tu viaje hacia mejores hábitos creando tu primer hábito diario.',
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
                label: Text(hasActiveHabits ? 'Crear nuevo hábito' : 'Crear mi primer hábito'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleHabit(BuildContext context, String habitId) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);

    // Guardar logros actuales antes de la completación
    final previousAchievements = Set.from(gamificationProvider.unlockedAchievements.map((a) => a.id));

    habitProvider.toggleHabitCompletion(habitId);

    // Verificar si se desbloquearon nuevos logros después de la acción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentAchievements = Set.from(gamificationProvider.unlockedAchievements.map((a) => a.id));
      final newAchievementIds = currentAchievements.difference(previousAchievements);

      for (final achievementId in newAchievementIds) {
        final achievement = gamificationProvider.achievements.firstWhere((a) => a.id == achievementId);
        AchievementUnlockedDialog.show(context, achievement);
      }
    });

    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.habitUpdatedMessage),
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
                title: Text(AppLocalizations.of(context)!.edit),
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
                title: Text(AppLocalizations.of(context)!.viewStatistics),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navegar a estadísticas del hábito
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(
                  AppLocalizations.of(context)!.delete,
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
          title: Text(AppLocalizations.of(context)!.deleteHabit),
          content: Text(AppLocalizations.of(context)!.confirmDeleteHabitShort(habit.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final provider = Provider.of<HabitProvider>(context, listen: false);
                provider.deleteHabit(habit.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.habitDeletedMessage)),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context)!.delete),
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

  Widget _buildPortraitLayout(BuildContext context, List<Habit> habitsToday, EdgeInsets screenPadding) {
    return Column(
      children: [
        // StatsOverview FIJO arriba (Hoy/Semana/Mes + contenedor lila)
        SizedBox(
          height: 291,
          child: Padding(
            padding: EdgeInsets.fromLTRB(screenPadding.left, 12, screenPadding.right, 0),
            child: StatsOverview(),
          ),
        ),

        // GamificationCard + Hábitos con scroll CONJUNTO
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // GamificationCard (scrollea con los hábitos)
              const GamificationCard(),

              // Título "Hoy"
              Padding(
                padding: EdgeInsets.fromLTRB(screenPadding.left, 8, screenPadding.right, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.today,
                      color: AppColors.primary,
                      size: _isTablet ? 32 : 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hoy • $_currentDateString',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: _isTablet ? 24 : null,
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de hábitos
              if (habitsToday.isEmpty)
                SizedBox(
                  height: 300,
                  child: _buildEmptyState(),
                )
              else
                ...habitsToday.map((habit) => Padding(
                  padding: EdgeInsets.fromLTRB(screenPadding.left, 0, screenPadding.right, 12),
                  child: HabitCard(
                    habit: habit,
                    onTap: () => _toggleHabit(context, habit.id),
                    onLongPress: () => _showHabitOptions(context, habit),
                  ),
                )).toList(),

              // Espacio final para FAB
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, List<Habit> habitsToday, EdgeInsets screenPadding) {
    return Row(
      children: [
        // Panel izquierdo: Estadísticas
        Expanded(
          flex: ResponsiveUtils.isTablet(context) ? 1 : 2,
          child: Padding(
            padding: screenPadding.copyWith(right: screenPadding.right / 2),
            child: Column(
              children: [
                Expanded(child: StatsOverview()),
                // Título más compacto para landscape
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.today,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hoy • ${_getCurrentDateString()}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Panel derecho: Lista de hábitos
        Expanded(
          flex: ResponsiveUtils.isTablet(context) ? 1 : 3,
          child: Padding(
            padding: screenPadding.copyWith(left: screenPadding.left / 2),
            child: habitsToday.isEmpty
                ? _buildEmptyState()
                : ResponsiveUtils.isTablet(context)
                    ? GridView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 4.5,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: habitsToday.length,
                        itemBuilder: (context, index) {
                          final habit = habitsToday[index];
                          return HabitCard(
                            habit: habit,
                            onTap: () => _toggleHabit(context, habit.id),
                            onLongPress: () => _showHabitOptions(context, habit),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: habitsToday.length,
                        itemBuilder: (context, index) {
                          final habit = habitsToday[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: HabitCard(
                              habit: habit,
                              onTap: () => _toggleHabit(context, habit.id),
                              onLongPress: () => _showHabitOptions(context, habit),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
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
                    Icons.notifications_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.notificationSettings,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.notification_important, color: Theme.of(context).primaryColor),
                title: Text(AppLocalizations.of(context)!.activateNotifications),
                subtitle: Text(AppLocalizations.of(context)!.receiveRemindersForHabits),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.openSystemSettingsMessage),
                      backgroundColor: Theme.of(context).primaryColor,
                      action: SnackBarAction(
                        label: AppLocalizations.of(context)!.settings,
                        textColor: Colors.white,
                        onPressed: () {
                          // En una app real, esto abriría la configuración del sistema
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.green),
                title: Text(AppLocalizations.of(context)!.rescheduleAllHabits),
                subtitle: Text(AppLocalizations.of(context)!.updateAllNotificationsText),
                onTap: () async {
                  Navigator.pop(context);
                  final habitProvider = Provider.of<HabitProvider>(context, listen: false);
                  await habitProvider.rescheduleAllNotifications();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.notificationsRescheduledSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.orange),
                title: Text(AppLocalizations.of(context)!.notificationHelp),
                subtitle: Text(AppLocalizations.of(context)!.notReceivingReminders),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.notificationHelp),
                      content: const Text(
                        'Si no recibes notificaciones:\n\n'
                        '• Verifica que las notificaciones estén activadas en la configuración del sistema\n'
                        '• Asegúrate de que la app no esté en modo "No molestar"\n'
                        '• Comprueba que los hábitos tengan horarios de recordatorio configurados'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.understood),
                        ),
                      ],
                    ),
                  );
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


