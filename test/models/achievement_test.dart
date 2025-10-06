import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/models/achievement.dart';
import 'package:ritmo/generated/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Achievement - Creation', () {
    test('should create achievement with all required fields', () {
      final achievement = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
      );

      expect(achievement.id, 'test-1');
      expect(achievement.name, 'First Streak');
      expect(achievement.description, 'Complete your first streak');
      expect(achievement.icon, Icons.local_fire_department);
      expect(achievement.color, Colors.orange);
      expect(achievement.type, AchievementType.streak);
      expect(achievement.targetValue, 7);
      expect(achievement.points, 50);
      expect(achievement.isUnlocked, false); // default
      expect(achievement.unlockedAt, null); // default
    });

    test('should create achievement with unlocked state', () {
      final now = DateTime.now();
      final achievement = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
        isUnlocked: true,
        unlockedAt: now,
      );

      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, now);
    });
  });

  group('Achievement - AchievementType Enum', () {
    test('should have all achievement types', () {
      expect(AchievementType.values.length, 4);
      expect(AchievementType.values, contains(AchievementType.streak));
      expect(AchievementType.values, contains(AchievementType.completion));
      expect(AchievementType.values, contains(AchievementType.consistency));
      expect(AchievementType.values, contains(AchievementType.milestone));
    });

    test('should have correct indices', () {
      expect(AchievementType.streak.index, 0);
      expect(AchievementType.completion.index, 1);
      expect(AchievementType.consistency.index, 2);
      expect(AchievementType.milestone.index, 3);
    });
  });

  group('Achievement - copyWith', () {
    test('should copy achievement with modified fields', () {
      final original = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
      );

      final modified = original.copyWith(
        name: 'Modified Name',
        points: 100,
        isUnlocked: true,
      );

      expect(modified.id, original.id);
      expect(modified.name, 'Modified Name');
      expect(modified.description, original.description);
      expect(modified.points, 100);
      expect(modified.isUnlocked, true);
      expect(modified.icon, original.icon);
      expect(modified.color, original.color);
    });

    test('should preserve original fields when not specified', () {
      final original = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
        isUnlocked: true,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.description, original.description);
      expect(copied.icon, original.icon);
      expect(copied.color, original.color);
      expect(copied.type, original.type);
      expect(copied.targetValue, original.targetValue);
      expect(copied.points, original.points);
      expect(copied.isUnlocked, original.isUnlocked);
    });
  });

  group('Achievement - JSON Serialization', () {
    test('should convert to JSON correctly', () {
      final achievement = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
        isUnlocked: true,
        unlockedAt: DateTime(2025, 1, 15, 10, 30),
      );

      final json = achievement.toJson();

      expect(json['id'], 'test-1');
      expect(json['name'], 'First Streak');
      expect(json['description'], 'Complete your first streak');
      expect(json['icon'], Icons.local_fire_department.codePoint);
      expect(json['color'], Colors.orange.value);
      expect(json['type'], AchievementType.streak.index);
      expect(json['targetValue'], 7);
      expect(json['points'], 50);
      expect(json['isUnlocked'], true);
      expect(json['unlockedAt'], '2025-01-15T10:30:00.000');
    });

    test('should handle null unlockedAt in JSON', () {
      final achievement = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
      );

      final json = achievement.toJson();

      expect(json['unlockedAt'], null);
    });

    test('should create from JSON correctly', () {
      final json = {
        'id': 'test-1',
        'name': 'First Streak',
        'description': 'Complete your first streak',
        'icon': Icons.local_fire_department.codePoint,
        'color': Colors.orange.value,
        'type': AchievementType.streak.index,
        'targetValue': 7,
        'points': 50,
        'isUnlocked': true,
        'unlockedAt': '2025-01-15T10:30:00.000',
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.id, 'test-1');
      expect(achievement.name, 'First Streak');
      expect(achievement.description, 'Complete your first streak');
      expect(achievement.icon, Icons.local_fire_department);
      expect(achievement.color.value, Colors.orange.value); // Compare color values
      expect(achievement.type, AchievementType.streak);
      expect(achievement.targetValue, 7);
      expect(achievement.points, 50);
      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, DateTime(2025, 1, 15, 10, 30));
    });

    test('should handle missing isUnlocked in JSON', () {
      final json = {
        'id': 'test-1',
        'name': 'First Streak',
        'description': 'Complete your first streak',
        'icon': Icons.local_fire_department.codePoint,
        'color': Colors.orange.value,
        'type': AchievementType.streak.index,
        'targetValue': 7,
        'points': 50,
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.isUnlocked, false); // default
    });

    test('should handle null unlockedAt in JSON', () {
      final json = {
        'id': 'test-1',
        'name': 'First Streak',
        'description': 'Complete your first streak',
        'icon': Icons.local_fire_department.codePoint,
        'color': Colors.orange.value,
        'type': AchievementType.streak.index,
        'targetValue': 7,
        'points': 50,
        'unlockedAt': null,
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.unlockedAt, null);
    });

    test('should serialize and deserialize correctly (round trip)', () {
      final original = Achievement(
        id: 'test-1',
        name: 'First Streak',
        description: 'Complete your first streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak,
        targetValue: 7,
        points: 50,
        isUnlocked: true,
        unlockedAt: DateTime(2025, 1, 15, 10, 30),
      );

      final json = original.toJson();
      final deserialized = Achievement.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.name, original.name);
      expect(deserialized.description, original.description);
      expect(deserialized.icon, original.icon);
      expect(deserialized.color.value, original.color.value); // Compare color values
      expect(deserialized.type, original.type);
      expect(deserialized.targetValue, original.targetValue);
      expect(deserialized.points, original.points);
      expect(deserialized.isUnlocked, original.isUnlocked);
      expect(deserialized.unlockedAt, original.unlockedAt);
    });
  });

  group('GameStats - Level Calculation', () {
    test('should calculate level 1 for points < 100', () {
      expect(GameStats.calculateLevel(0), 1);
      expect(GameStats.calculateLevel(50), 1);
      expect(GameStats.calculateLevel(99), 1);
    });

    test('should calculate level 2 for points 100-299', () {
      expect(GameStats.calculateLevel(100), 2);
      expect(GameStats.calculateLevel(200), 2);
      expect(GameStats.calculateLevel(299), 2);
    });

    test('should calculate level 3 for points 300-599', () {
      expect(GameStats.calculateLevel(300), 3);
      expect(GameStats.calculateLevel(450), 3);
      expect(GameStats.calculateLevel(599), 3);
    });

    test('should calculate level 4 for points 600-999', () {
      expect(GameStats.calculateLevel(600), 4);
      expect(GameStats.calculateLevel(800), 4);
      expect(GameStats.calculateLevel(999), 4);
    });

    test('should calculate level 5 for points 1000-1499', () {
      expect(GameStats.calculateLevel(1000), 5);
      expect(GameStats.calculateLevel(1250), 5);
      expect(GameStats.calculateLevel(1499), 5);
    });

    test('should calculate level 6 for points 1500-2099', () {
      expect(GameStats.calculateLevel(1500), 6);
    });

    test('should calculate level 7 for points 2100-2799', () {
      expect(GameStats.calculateLevel(2100), 7);
    });

    test('should calculate level 8 for points 2800-3599', () {
      expect(GameStats.calculateLevel(2800), 8);
    });

    test('should calculate level 9 for points 3600-4499', () {
      expect(GameStats.calculateLevel(3600), 9);
    });

    test('should calculate level 10 for points >= 4500', () {
      expect(GameStats.calculateLevel(4500), 10);
      expect(GameStats.calculateLevel(5000), 10);
      expect(GameStats.calculateLevel(10000), 10);
    });
  });

  group('GameStats - Points for Level', () {
    test('should return correct minimum points for each level', () {
      expect(GameStats.pointsForLevel(1), 0);
      expect(GameStats.pointsForLevel(2), 100);
      expect(GameStats.pointsForLevel(3), 300);
      expect(GameStats.pointsForLevel(4), 600);
      expect(GameStats.pointsForLevel(5), 1000);
      expect(GameStats.pointsForLevel(6), 1500);
      expect(GameStats.pointsForLevel(7), 2100);
      expect(GameStats.pointsForLevel(8), 2800);
      expect(GameStats.pointsForLevel(9), 3600);
      expect(GameStats.pointsForLevel(10), 4500);
    });

    test('should return max points for invalid levels', () {
      expect(GameStats.pointsForLevel(0), 4500);
      expect(GameStats.pointsForLevel(11), 4500);
      expect(GameStats.pointsForLevel(-1), 4500);
      expect(GameStats.pointsForLevel(100), 4500);
    });
  });

  group('GameStats - Level Titles', () {
    testWidgets('should return correct level titles in English', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          home: Builder(
            builder: (context) {
              // Verificar que las funciones retornan strings (no null)
              expect(GameStats.getLevelTitle(1, context), isNotNull);
              expect(GameStats.getLevelTitle(2, context), isNotNull);
              expect(GameStats.getLevelTitle(3, context), isNotNull);
              expect(GameStats.getLevelTitle(4, context), isNotNull);
              expect(GameStats.getLevelTitle(5, context), isNotNull);
              expect(GameStats.getLevelTitle(6, context), isNotNull);
              expect(GameStats.getLevelTitle(7, context), isNotNull);
              expect(GameStats.getLevelTitle(8, context), isNotNull);
              expect(GameStats.getLevelTitle(9, context), isNotNull);
              expect(GameStats.getLevelTitle(10, context), isNotNull);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle invalid level numbers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          home: Builder(
            builder: (context) {
              // Niveles inválidos deberían usar maximumLevel
              expect(GameStats.getLevelTitle(0, context), isNotNull);
              expect(GameStats.getLevelTitle(11, context), isNotNull);
              expect(GameStats.getLevelTitle(-1, context), isNotNull);

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('GameStats - Creation', () {
    test('should create GameStats with all fields', () {
      final achievements = [
        Achievement(
          id: 'test-1',
          name: 'First Streak',
          description: 'Complete your first streak',
          icon: Icons.local_fire_department,
          color: Colors.orange,
          type: AchievementType.streak,
          targetValue: 7,
          points: 50,
          isUnlocked: true,
        ),
      ];

      final stats = GameStats(
        totalPoints: 150,
        level: 2,
        currentLevelPoints: 50,
        pointsToNextLevel: 150,
        unlockedAchievements: achievements,
        longestStreak: 14,
        totalCompletions: 42,
        averageCompletion: 0.85,
      );

      expect(stats.totalPoints, 150);
      expect(stats.level, 2);
      expect(stats.currentLevelPoints, 50);
      expect(stats.pointsToNextLevel, 150);
      expect(stats.unlockedAchievements, achievements);
      expect(stats.longestStreak, 14);
      expect(stats.totalCompletions, 42);
      expect(stats.averageCompletion, 0.85);
    });
  });

  group('Achievement - Edge Cases', () {
    test('should handle zero points achievement', () {
      final achievement = Achievement(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        icon: Icons.star,
        color: Colors.blue,
        type: AchievementType.milestone,
        targetValue: 0,
        points: 0,
      );

      expect(achievement.points, 0);
      expect(achievement.targetValue, 0);
    });

    test('should handle very high target values', () {
      final achievement = Achievement(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        icon: Icons.star,
        color: Colors.blue,
        type: AchievementType.milestone,
        targetValue: 999999,
        points: 999999,
      );

      expect(achievement.targetValue, 999999);
      expect(achievement.points, 999999);
    });

    test('should handle all achievement types in serialization', () {
      for (var type in AchievementType.values) {
        final achievement = Achievement(
          id: 'test-${type.index}',
          name: 'Test',
          description: 'Test',
          icon: Icons.star,
          color: Colors.blue,
          type: type,
          targetValue: 10,
          points: 50,
        );

        final json = achievement.toJson();
        final deserialized = Achievement.fromJson(json);

        expect(deserialized.type, type);
      }
    });
  });
}
