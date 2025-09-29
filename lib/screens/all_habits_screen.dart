import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../models/habit.dart';
import '../core/theme.dart';
import '../generated/l10n/app_localizations.dart';
import '../utils/responsive_utils.dart';
import 'add_habit_screen.dart';
import 'edit_habit_screen.dart';

class AllHabitsScreen extends StatefulWidget {
  const AllHabitsScreen({Key? key}) : super(key: key);

  @override
  State<AllHabitsScreen> createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends State<AllHabitsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appBarHeight = ResponsiveUtils.getAppBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight + kToolbarHeight),
        child: AppBar(
          title: Text(l10n.manageHabits),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textDark,
            unselectedLabelColor: AppColors.textSecondaryDark,
            tabs: [
              Tab(text: l10n.active),
              Tab(text: l10n.paused),
              Tab(text: l10n.all),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildActiveHabitsTab(habitProvider, l10n),
              _buildCompletedHabitsTab(habitProvider, l10n),
              _buildAllHabitsTab(habitProvider, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveHabitsTab(HabitProvider habitProvider, AppLocalizations l10n) {
    final activeHabits = habitProvider.habits.where((habit) => habit.isActive).toList();
    final screenPadding = ResponsiveUtils.getScreenPadding(context);
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (activeHabits.isEmpty) {
      return _buildEmptyState(
        Icons.fitness_center,
        l10n.noActiveHabits,
        l10n.createFirstHabitToStart,
      );
    }

    if (isLandscape && ResponsiveUtils.isTablet(context)) {
      return GridView.builder(
        padding: screenPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 3.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: activeHabits.length,
        itemBuilder: (context, index) {
          final habit = activeHabits[index];
          return _buildHabitTile(habit, habitProvider, l10n);
        },
      );
    }

    return ListView.builder(
      padding: screenPadding,
      itemCount: activeHabits.length,
      itemBuilder: (context, index) {
        final habit = activeHabits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildHabitTile(habit, habitProvider, l10n),
        );
      },
    );
  }

  Widget _buildCompletedHabitsTab(HabitProvider habitProvider, AppLocalizations l10n) {
    final completedHabits = habitProvider.habits.where((habit) => !habit.isActive).toList();
    final screenPadding = ResponsiveUtils.getScreenPadding(context);
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (completedHabits.isEmpty) {
      return _buildEmptyState(
        Icons.emoji_events,
        l10n.noPausedHabits,
        l10n.pausedHabitsWillAppearHere,
      );
    }

    if (isLandscape && ResponsiveUtils.isTablet(context)) {
      return GridView.builder(
        padding: screenPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 3.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: completedHabits.length,
        itemBuilder: (context, index) {
          final habit = completedHabits[index];
          return _buildHabitTile(habit, habitProvider, l10n);
        },
      );
    }

    return ListView.builder(
      padding: screenPadding,
      itemCount: completedHabits.length,
      itemBuilder: (context, index) {
        final habit = completedHabits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildHabitTile(habit, habitProvider, l10n),
        );
      },
    );
  }

  Widget _buildAllHabitsTab(HabitProvider habitProvider, AppLocalizations l10n) {
    final allHabits = habitProvider.habits;
    final screenPadding = ResponsiveUtils.getScreenPadding(context);
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (allHabits.isEmpty) {
      return _buildEmptyState(
        Icons.eco,
        l10n.noHabits,
        l10n.startJourneyCreatingFirstHabit,
      );
    }

    if (isLandscape && ResponsiveUtils.isTablet(context)) {
      return GridView.builder(
        padding: screenPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 3.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: allHabits.length,
        itemBuilder: (context, index) {
          final habit = allHabits[index];
          return _buildHabitTile(habit, habitProvider, l10n);
        },
      );
    }

    return ListView.builder(
      padding: screenPadding,
      itemCount: allHabits.length,
      itemBuilder: (context, index) {
        final habit = allHabits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildHabitTile(habit, habitProvider, l10n),
        );
      },
    );
  }

  Widget _buildHabitTile(Habit habit, HabitProvider habitProvider, AppLocalizations l10n) {
    final completionCount = habitProvider.getHabitCompletionCount(habit.id);
    final streak = habitProvider.getHabitStreak(habit.id);
    final isCompletedToday = habitProvider.isHabitCompletedToday(habit.id);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: habit.isActive
              ? (isCompletedToday ? AppColors.success : AppColors.primary.withOpacity(0.3))
              : AppColors.textSecondaryDark.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(habit.color).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            habit.icon,
            color: Color(habit.color),
            size: 24,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: habit.isActive ? AppColors.textDark : AppColors.textSecondaryDark,
            decoration: habit.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (habit.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                habit.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatChip(Icons.check_circle, '$completionCount', AppColors.success),
                const SizedBox(width: 8),
                _buildStatChip(Icons.local_fire_department, '$streak', AppColors.warning),
                const SizedBox(width: 8),
                _buildStatusChip(habit, isCompletedToday, l10n),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: AppColors.textSecondaryDark),
          onSelected: (value) => _handleMenuAction(value, habit, habitProvider, l10n),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: AppColors.textDark, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_status',
              child: Row(
                children: [
                  Icon(
                    habit.isActive ? Icons.pause : Icons.play_arrow,
                    color: AppColors.textDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(habit.isActive ? l10n.pause : l10n.resume),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: habit.isActive ? () => _toggleHabitCompletion(habit, habitProvider) : null,
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(Habit habit, bool isCompletedToday, AppLocalizations l10n) {
    if (!habit.isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.textSecondaryDark.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          l10n.paused,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondaryDark,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompletedToday
            ? AppColors.success.withOpacity(0.1)
            : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isCompletedToday ? l10n.completed : l10n.pending,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isCompletedToday ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Habit habit, HabitProvider habitProvider, AppLocalizations l10n) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditHabitScreen(habit: habit),
          ),
        );
        break;
      case 'toggle_status':
        habitProvider.toggleHabitStatus(habit.id);
        break;
      case 'delete':
        _confirmDeleteHabit(habit, habitProvider, l10n);
        break;
    }
  }

  void _toggleHabitCompletion(Habit habit, HabitProvider habitProvider) {
    habitProvider.toggleHabitCompletion(habit.id);
  }

  void _confirmDeleteHabit(Habit habit, HabitProvider habitProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteHabit),
          content: Text(l10n.deleteHabitConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                habitProvider.deleteHabit(habit.id);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}