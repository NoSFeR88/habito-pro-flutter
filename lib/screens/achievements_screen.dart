import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../models/achievement.dart';
import '../generated/l10n/app_localizations.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.achievements),
        elevation: 0,
      ),
      body: Consumer<GamificationProvider>(
        builder: (context, gamificationProvider, child) {
          final stats = gamificationProvider.gameStats;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlayerStats(context, stats, l10n),
                const SizedBox(height: 24),
                _buildLevelProgress(context, gamificationProvider, l10n),
                const SizedBox(height: 24),
                _buildAchievementsSection(context, gamificationProvider.achievements, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerStats(BuildContext context, GameStats stats, AppLocalizations l10n) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.yourProgress,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    l10n.level,
                    '${stats.level}',
                    _getLevelTitle(context, stats.level),
                    Icons.military_tech,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    l10n.points,
                    '${stats.totalPoints}',
                    l10n.totalAccumulated,
                    Icons.star,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    l10n.achievementsLabel,
                    '${stats.unlockedAchievements.length}',
                    l10n.unlocked,
                    Icons.emoji_events,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    l10n.streak,
                    '${stats.longestStreak}',
                    l10n.maxDays,
                    Icons.local_fire_department,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress(BuildContext context, GamificationProvider provider, AppLocalizations l10n) {
    final progress = provider.getLevelProgress();
    final stats = provider.gameStats;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.progressToNextLevel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${stats.level}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.pointsToLevel(stats.pointsToNextLevel, stats.level + 1),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${stats.level + 1}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, List<Achievement> achievements, AppLocalizations l10n) {
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();
    final lockedAchievements = achievements.where((a) => !a.isUnlocked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.achievements,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        if (unlockedAchievements.isNotEmpty) ...[
          Text(
            l10n.unlockedCount(unlockedAchievements.length),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          ...unlockedAchievements.map((achievement) =>
            _buildAchievementCard(context, achievement, true)),
          const SizedBox(height: 16),
        ],

        if (lockedAchievements.isNotEmpty) ...[
          Text(
            l10n.lockedCount(lockedAchievements.length),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ...lockedAchievements.map((achievement) =>
            _buildAchievementCard(context, achievement, false)),
        ],
      ],
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement, bool isUnlocked) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withValues(alpha: 0.2)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                color: isUnlocked ? achievement.color : Colors.grey[500],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isUnlocked ? null : Colors.grey[600],
                          ),
                        ),
                      ),
                      if (isUnlocked)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.grey[700] : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.pointsWithCount(achievement.points),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[700],
                        ),
                      ),
                      if (isUnlocked && achievement.unlockedAt != null) ...[
                        const Spacer(),
                        Text(
                          AppLocalizations.of(context)!.unlockedLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelTitle(BuildContext context, int level) {
    switch (level) {
      case 1: return AppLocalizations.of(context)!.beginnerlevel;
      case 2: return AppLocalizations.of(context)!.apprenticeLevel;
      case 3: return AppLocalizations.of(context)!.dedicatedLevel;
      case 4: return AppLocalizations.of(context)!.consistentLevel;
      case 5: return AppLocalizations.of(context)!.expertLevel;
      case 6: return AppLocalizations.of(context)!.masterLevel;
      case 7: return AppLocalizations.of(context)!.championLevel;
      case 8: return AppLocalizations.of(context)!.legendLevel;
      case 9: return AppLocalizations.of(context)!.heroLevel;
      case 10: return AppLocalizations.of(context)!.mythicLevel;
      default: return AppLocalizations.of(context)!.maximumLevel;
    }
  }
}