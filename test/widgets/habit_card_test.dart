import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/widgets/habit_card.dart';
import 'package:ritmo/models/habit.dart';
import 'package:ritmo/generated/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // Helper para crear un Habit de prueba
  Habit createTestHabit({
    String id = 'test-1',
    String name = 'Morning Workout',
    String description = 'Exercise for 30 minutes',
    IconData icon = Icons.fitness_center,
    int color = 0xFF2196F3,
    int streak = 5,
    TimeOfDay? reminderTime,
    Map<String, bool>? completions,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id,
      name: name,
      description: description,
      icon: icon,
      color: color,
      frequency: [1, 2, 3, 4, 5], // Mon-Fri
      streak: streak,
      reminderTime: reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
      completions: completions ?? {},
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  // Helper para crear widget con localización
  Widget createTestWidget({
    required Habit habit,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return MaterialApp(
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
      home: Scaffold(
        body: HabitCard(
          habit: habit,
          onTap: onTap ?? () {},
          onLongPress: onLongPress,
        ),
      ),
    );
  }

  group('HabitCard - Rendering', () {
    testWidgets('should display habit name', (tester) async {
      final habit = createTestHabit(name: 'Test Habit');

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('Test Habit'), findsOneWidget);
    });

    testWidgets('should display habit description when not empty', (tester) async {
      final habit = createTestHabit(
        name: 'Test Habit',
        description: 'Test Description',
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('Test Habit'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should not display description when empty', (tester) async {
      final habit = createTestHabit(
        name: 'Test Habit',
        description: '',
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('Test Habit'), findsOneWidget);
      // Solo debe haber el título, no un segundo Text widget para descripción
      expect(find.byType(Text).evaluate().length, lessThanOrEqualTo(3)); // Name + time + streak
    });

    testWidgets('should display habit icon', (tester) async {
      final habit = createTestHabit(icon: Icons.fitness_center);

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('should display reminder time', (tester) async {
      final habit = createTestHabit(
        reminderTime: const TimeOfDay(hour: 14, minute: 30),
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('14:30'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });
  });

  group('HabitCard - Completion State', () {
    testWidgets('should show check icon when habit is completed today', (tester) async {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final habit = createTestHabit(
        completions: {dateKey: true},
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should not show check icon when habit is not completed', (tester) async {
      final habit = createTestHabit(completions: {});

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('should apply line-through decoration when completed', (tester) async {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final habit = createTestHabit(
        name: 'Completed Habit',
        completions: {dateKey: true},
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      final textWidget = tester.widget<Text>(find.text('Completed Habit'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should not apply line-through when not completed', (tester) async {
      final habit = createTestHabit(
        name: 'Active Habit',
        completions: {},
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      final textWidget = tester.widget<Text>(find.text('Active Habit'));
      expect(textWidget.style?.decoration, isNot(TextDecoration.lineThrough));
    });
  });

  group('HabitCard - Streak Display', () {
    testWidgets('should display streak when greater than 0', (tester) async {
      final habit = createTestHabit(streak: 7);

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.text('7 days'), findsOneWidget);
    });

    testWidgets('should not display streak icon when streak is 0', (tester) async {
      final habit = createTestHabit(streak: 0);

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byIcon(Icons.local_fire_department), findsNothing);
    });

    testWidgets('should display correct streak in Spanish locale', (tester) async {
      final habit = createTestHabit(streak: 3);

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
          locale: const Locale('es'),
          home: Scaffold(
            body: HabitCard(
              habit: habit,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('3 días'), findsOneWidget);
    });
  });

  group('HabitCard - Interactions', () {
    testWidgets('should call onTap when card is tapped', (tester) async {
      bool tapped = false;
      final habit = createTestHabit();

      await tester.pumpWidget(
        createTestWidget(
          habit: habit,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(HabitCard));
      expect(tapped, isTrue);
    });

    testWidgets('should call onTap when completion button is tapped', (tester) async {
      bool tapped = false;
      final habit = createTestHabit();

      await tester.pumpWidget(
        createTestWidget(
          habit: habit,
          onTap: () => tapped = true,
        ),
      );

      // Buscar el GestureDetector del botón de completar (el último en el árbol)
      final completionButton = find.byType(GestureDetector).last;
      await tester.tap(completionButton);

      expect(tapped, isTrue);
    });

    testWidgets('should call onLongPress when card is long pressed', (tester) async {
      bool longPressed = false;
      final habit = createTestHabit();

      await tester.pumpWidget(
        createTestWidget(
          habit: habit,
          onLongPress: () => longPressed = true,
        ),
      );

      await tester.longPress(find.byType(HabitCard));
      expect(longPressed, isTrue);
    });

    testWidgets('should not crash when onLongPress is null', (tester) async {
      final habit = createTestHabit();

      await tester.pumpWidget(
        createTestWidget(
          habit: habit,
          onLongPress: null,
        ),
      );

      // Debe renderizar sin errores
      expect(find.byType(HabitCard), findsOneWidget);

      // Long press no debe causar error
      await tester.longPress(find.byType(HabitCard));
    });
  });

  group('HabitCard - Visual States', () {
    testWidgets('should have higher elevation when not completed', (tester) async {
      final habit = createTestHabit(completions: {});

      await tester.pumpWidget(createTestWidget(habit: habit));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 3);
    });

    testWidgets('should have lower elevation when completed', (tester) async {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final habit = createTestHabit(completions: {dateKey: true});

      await tester.pumpWidget(createTestWidget(habit: habit));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);
    });

    testWidgets('should display custom color from habit', (tester) async {
      final habit = createTestHabit(
        color: 0xFFFF5722, // Deep Orange
        icon: Icons.fitness_center,
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      final icon = tester.widget<Icon>(find.byIcon(Icons.fitness_center));
      expect(icon.color, const Color(0xFFFF5722));
    });
  });

  group('HabitCard - Edge Cases', () {
    testWidgets('should handle very long habit name', (tester) async {
      final habit = createTestHabit(
        name: 'This is a very long habit name that might cause layout issues if not handled properly',
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byType(HabitCard), findsOneWidget);
      // No debe haber overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle very long description', (tester) async {
      final habit = createTestHabit(
        description: 'This is a very long description that contains a lot of text and might cause layout issues if the widget is not properly configured with Expanded or Flexible widgets',
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.byType(HabitCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle midnight reminder time', (tester) async {
      final habit = createTestHabit(
        reminderTime: const TimeOfDay(hour: 0, minute: 0),
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('should handle 23:59 reminder time', (tester) async {
      final habit = createTestHabit(
        reminderTime: const TimeOfDay(hour: 23, minute: 59),
      );

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('23:59'), findsOneWidget);
    });

    testWidgets('should handle very high streak number', (tester) async {
      final habit = createTestHabit(streak: 365);

      await tester.pumpWidget(createTestWidget(habit: habit));

      expect(find.text('365 days'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });
  });

  group('HabitCard - Accessibility', () {
    testWidgets('should be tappable with sufficient tap area', (tester) async {
      final habit = createTestHabit();

      await tester.pumpWidget(createTestWidget(habit: habit));

      final card = tester.getSize(find.byType(Card));

      // Card debe tener altura suficiente para touch (mínimo 48dp)
      expect(card.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('should display all interactive elements', (tester) async {
      final habit = createTestHabit();

      await tester.pumpWidget(createTestWidget(habit: habit));

      // Debe tener GestureDetector para tap
      expect(find.byType(GestureDetector), findsWidgets);

      // Debe tener el botón de completar
      final completionButtons = find.byType(GestureDetector);
      expect(completionButtons, findsWidgets);
    });
  });
}
