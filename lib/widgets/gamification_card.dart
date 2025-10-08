import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../models/achievement.dart';
import '../screens/achievements_screen.dart';
import '../generated/l10n/app_localizations.dart';
import '../core/design_constants.dart';

class GamificationCard extends StatelessWidget {
  const GamificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gamificationProvider, child) {
        final stats = gamificationProvider.gameStats;
        final progress = gamificationProvider.getLevelProgress();
        final l10n = AppLocalizations.of(context)!;

        // Semantic label para screen readers
        final semanticLabel =
            _buildSemanticLabel(context, l10n, stats, progress);

        return Semantics(
          label: semanticLabel,
          button: true,
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AchievementsScreen()),
            );
          },
          child: ExcludeSemantics(
            child: Card(
              margin: EdgeInsets.symmetric(
                horizontal: DesignConstants.paddingScreen,
                vertical: DesignConstants.spacingBetweenCards / 2,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AchievementsScreen()),
                  );
                },
                borderRadius:
                    BorderRadius.circular(DesignConstants.cardBorderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(
                      12.0), // Reduced from 16 to fix overflow
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.7),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${stats.level}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8), // Reduced from 12
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getLevelTitle(context, stats.level),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${stats.totalPoints} ${AppLocalizations.of(context)!.totalPoints}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: DesignConstants.statLabelFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Reduced from 12
                      if (stats.level < 10) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .progressToLevel(stats.level + 1),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${stats.pointsToNextLevel}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.maxLevelReached,
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8), // Reduced from 12
                      Row(
                        children: [
                          _buildQuickStat(
                            Icons.emoji_events,
                            '${stats.unlockedAchievements.length}',
                            AppLocalizations.of(context)!.achievements,
                            Colors.purple,
                          ),
                          const SizedBox(width: 16),
                          _buildQuickStat(
                            Icons.local_fire_department,
                            '${stats.longestStreak}',
                            AppLocalizations.of(context)!.maxStreak,
                            Colors.orange,
                          ),
                          const Spacer(),
                          Text(
                            AppLocalizations.of(context)!.tapToViewMore,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construir label semántico para screen readers
  String _buildSemanticLabel(BuildContext context, AppLocalizations l10n,
      dynamic stats, double progress) {
    final levelTitle = _getLevelTitle(context, stats.level);
    final progressPercent = (progress * 100).toInt();

    return '$levelTitle, ${stats.totalPoints} ${l10n.totalPoints}, $progressPercent% progress, ${stats.unlockedAchievements.length} ${l10n.achievements}, ${stats.longestStreak} ${l10n.maxStreak}';
  }

  Widget _buildQuickStat(
      IconData icon, String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getLevelTitle(BuildContext context, int level) {
    switch (level) {
      case 1:
        return AppLocalizations.of(context)!.beginnerlevel;
      case 2:
        return AppLocalizations.of(context)!.apprenticeLevel;
      case 3:
        return AppLocalizations.of(context)!.dedicatedLevel;
      case 4:
        return AppLocalizations.of(context)!.consistentLevel;
      case 5:
        return AppLocalizations.of(context)!.expertLevel;
      case 6:
        return AppLocalizations.of(context)!.masterLevel;
      case 7:
        return AppLocalizations.of(context)!.championLevel;
      case 8:
        return AppLocalizations.of(context)!.legendLevel;
      case 9:
        return AppLocalizations.of(context)!.heroLevel;
      case 10:
        return AppLocalizations.of(context)!.mythicLevel;
      default:
        return AppLocalizations.of(context)!.maximumLevel;
    }
  }
}

class AchievementUnlockedDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockedDialog({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    achievement.color,
                    achievement.color.withValues(alpha: 0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.achievementUnlocked,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: achievement.color,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${achievement.points} ${AppLocalizations.of(context)!.points.toLowerCase()}',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: achievement.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.excellent,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, Achievement achievement) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AchievementUnlockedDialog(achievement: achievement),
    );
  }
}
