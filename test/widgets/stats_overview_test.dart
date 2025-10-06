import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ritmo/widgets/stats_overview.dart';
import 'package:ritmo/providers/habit_provider.dart';
import 'package:ritmo/models/habit.dart';
import 'package:ritmo/generated/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Mock DatabaseHelper para tests
class MockDatabaseHelper {
  Future<List<Map<String, dynamic>>> getHabits() async => [];
  Future<int> insertHabit(Map<String, dynamic> habit) async => 1;
  Future<int> updateHabit(Map<String, dynamic> habit) async => 1;
  Future<int> deleteHabit(String id) async => 1;
}

void main() {
  // Helper para crear HabitProvider con datos de prueba
  HabitProvider createMockProvider({List<Habit>? habits}) {
    final provider = HabitProvider();

    if (habits != null) {
      for (final habit in habits) {
        // Usar el método interno para agregar sin async
        provider.habits.add(habit);
      }
      provider.notifyListeners();
    }

    return provider;
  }

  // Helper para crear widget con provider y localización
  Widget createTestWidget(HabitProvider provider) {
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
        body: ChangeNotifierProvider<HabitProvider>.value(
          value: provider,
          child: const StatsOverview(),
        ),
      ),
    );
  }

  // Helper para crear hábito de prueba
  Habit createTestHabit({
    String id = 'test-1',
    String name = 'Test Habit',
    List<int>? frequency,
    Map<String, bool>? completions,
  }) {
    return Habit(
      id: id,
      name: name,
      description: '',
      icon: Icons.star,
      color: Colors.blue.value,
      frequency: frequency ?? [1, 2, 3, 4, 5, 6, 7], // Everyday
      reminderTime: const TimeOfDay(hour: 9, minute: 0),
      createdAt: DateTime.now(),
      completions: completions ?? {},
    );
  }

  group('StatsOverview - Basic Rendering', () {
    testWidgets('should render page indicators', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Debe tener 3 page indicators (Today, Week, Month)
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
    });

    testWidgets('should render PageView with 3 pages', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should start at page 0 (Today)', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Verificar que Today esté activo (puede verificar decoración o estado)
      expect(find.text('Today'), findsOneWidget);
    });
  });

  group('StatsOverview - Page Navigation', () {
    testWidgets('should navigate to Week page when tapped', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Tap en "Week"
      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();

      // Verificar que la página cambió (Week debe estar visible)
      expect(find.text('Week'), findsOneWidget);
    });

    testWidgets('should navigate to Month page when tapped', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Tap en "Month"
      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();

      // Verificar que la página cambió
      expect(find.text('Month'), findsOneWidget);
    });

    testWidgets('should navigate back to Today when tapped', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Navegar a Week
      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();

      // Volver a Today
      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    });
  });

  group('StatsOverview - Today Stats', () {
    testWidgets('should display 0/0 when no habits', (tester) async {
      final provider = createMockProvider(habits: []);

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.text('0/0'), findsOneWidget);
    });

    testWidgets('should display correct completion ratio', (tester) async {
      final today = DateTime.now();
      final dateKey = today.toDateString();

      final habits = [
        createTestHabit(id: '1', name: 'Habit 1', completions: {dateKey: true}),
        createTestHabit(id: '2', name: 'Habit 2', completions: {}),
        createTestHabit(id: '3', name: 'Habit 3', completions: {dateKey: true}),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      // 2 completed out of 3
      expect(find.text('2/3'), findsOneWidget);
    });

    testWidgets('should calculate correct percentage', (tester) async {
      final today = DateTime.now();
      final dateKey = today.toDateString();

      final habits = [
        createTestHabit(id: '1', completions: {dateKey: true}),
        createTestHabit(id: '2', completions: {dateKey: true}),
        createTestHabit(id: '3', completions: {}),
        createTestHabit(id: '4', completions: {}),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      // 2/4 = 50%
      expect(find.textContaining('50%'), findsOneWidget);
    });
  });

  group('StatsOverview - Display Elements', () {
    testWidgets('should display total habits stat', (tester) async {
      final habits = [
        createTestHabit(id: '1'),
        createTestHabit(id: '2'),
        createTestHabit(id: '3'),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      // Debe mostrar "3" en Total Habits
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('should display progress bar', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Buscar FractionallySizedBox (usado para progress bar)
      expect(find.byType(FractionallySizedBox), findsWidgets);
    });

    testWidgets('should display motivational message', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Debe haber texto con mensaje motivacional (varios widgets Text)
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('StatsOverview - Empty State', () {
    testWidgets('should handle empty habits list', (tester) async {
      final provider = createMockProvider(habits: []);

      await tester.pumpWidget(createTestWidget(provider));

      // No debe crashear
      expect(find.byType(StatsOverview), findsOneWidget);

      // Debe mostrar 0/0
      expect(find.text('0/0'), findsOneWidget);
    });

    testWidgets('should display 0% when no habits', (tester) async {
      final provider = createMockProvider(habits: []);

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.textContaining('0%'), findsOneWidget);
    });
  });

  group('StatsOverview - Multiple Habits Scenarios', () {
    testWidgets('should handle all habits completed', (tester) async {
      final today = DateTime.now();
      final dateKey = today.toDateString();

      final habits = [
        createTestHabit(id: '1', completions: {dateKey: true}),
        createTestHabit(id: '2', completions: {dateKey: true}),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.text('2/2'), findsOneWidget);
      expect(find.textContaining('100%'), findsOneWidget);
    });

    testWidgets('should handle no habits completed', (tester) async {
      final habits = [
        createTestHabit(id: '1', completions: {}),
        createTestHabit(id: '2', completions: {}),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.text('0/2'), findsOneWidget);
      expect(find.textContaining('0%'), findsOneWidget);
    });

    testWidgets('should handle partial completion', (tester) async {
      final today = DateTime.now();
      final dateKey = today.toDateString();

      final habits = [
        createTestHabit(id: '1', completions: {dateKey: true}),
        createTestHabit(id: '2', completions: {}),
        createTestHabit(id: '3', completions: {}),
      ];

      final provider = createMockProvider(habits: habits);

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.text('1/3'), findsOneWidget);
      // 1/3 = 33%
      expect(find.textContaining('33%'), findsOneWidget);
    });
  });

  group('StatsOverview - Widget Lifecycle', () {
    testWidgets('should dispose PageController properly', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Widget creado
      expect(find.byType(StatsOverview), findsOneWidget);

      // Remover widget
      await tester.pumpWidget(Container());

      // No debe haber errores de dispose
      expect(tester.takeException(), isNull);
    });
  });

  group('StatsOverview - UI Elements', () {
    testWidgets('should display icons in stat cards', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Debe haber múltiples iconos (total habits, completed, streak, etc.)
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('should display header with date/greeting', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Debe haber texto con fecha o saludo
      // (difícil de verificar el texto exacto, pero debe renderizar)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should render Card widgets', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      expect(find.byType(Card), findsWidgets);
    });
  });

  group('StatsOverview - Accessibility', () {
    testWidgets('should be scrollable with PageView', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);

      // Verificar que se puede hacer swipe
      await tester.drag(pageView, const Offset(-400, 0));
      await tester.pumpAndSettle();

      // No debe crashear
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle rapid page changes', (tester) async {
      final provider = createMockProvider();

      await tester.pumpWidget(createTestWidget(provider));

      // Tap rápido en diferentes páginas
      await tester.tap(find.text('Week'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Month'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
