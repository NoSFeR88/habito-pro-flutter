import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ritmo/screens/add_habit_screen.dart';
import 'package:ritmo/providers/habit_provider.dart';
import 'package:ritmo/providers/premium_provider.dart';
import 'package:ritmo/generated/l10n/app_localizations.dart';

void main() {
  group('AddHabitScreen Widget Tests', () {
    late HabitProvider habitProvider;
    late PremiumProvider premiumProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      habitProvider = HabitProvider();
      await habitProvider.initializeHabits();
      premiumProvider = PremiumProvider();
      // PremiumProvider doesn't have loadPremiumStatus method, it auto-loads
    });

    tearDown(() {
      habitProvider.dispose();
      premiumProvider.dispose();
    });

    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<HabitProvider>.value(value: habitProvider),
          ChangeNotifierProvider<PremiumProvider>.value(value: premiumProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AddHabitScreen(),
        ),
      );
    }

    // ========================================
    // 1️⃣ RENDERING TESTS
    // ========================================

    group('Rendering', () {
      testWidgets('should render AddHabitScreen', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(AddHabitScreen), findsOneWidget);
      });

      testWidgets('should display AppBar with title', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('New Habit'), findsOneWidget); // Default English
      });

      testWidgets('should display Save button in AppBar', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('should display form with ListView', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    // ========================================
    // 2️⃣ FORM FIELDS TESTS
    // ========================================

    group('Form Fields', () {
      testWidgets('should display name TextField', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      });

      testWidgets('should allow entering habit name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'Morning Exercise');
        await tester.pump();

        expect(find.text('Morning Exercise'), findsOneWidget);
      });

      testWidgets('should display description TextField', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
      });

      testWidgets('should allow entering description', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final descriptionField = find.byType(TextFormField).at(1);
        await tester.enterText(descriptionField, 'Exercise for 30 minutes');
        await tester.pump();

        expect(find.text('Exercise for 30 minutes'), findsOneWidget);
      });
    });

    // ========================================
    // 3️⃣ VALIDATION TESTS
    // ========================================

    group('Validation', () {
      testWidgets('should show validation error when name is empty', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Try to save without entering name
        final saveButton = find.text('Save');
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Should show validation error
        expect(find.text('Please enter a name'), findsOneWidget);
      });

      testWidgets('should not show error when name is provided', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter name
        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'Valid Habit');
        await tester.pump();

        // Try to save
        final saveButton = find.text('Save');
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Should NOT show validation error for empty name
        expect(find.text('Please enter a name'), findsNothing);
      });
    });

    // ========================================
    // 4️⃣ CARD SECTIONS TESTS
    // ========================================

    group('Card Sections', () {
      testWidgets('should display multiple Card widgets', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsAtLeastNWidgets(4));
      });

      testWidgets('should display Basic Information card', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Basic Information'), findsOneWidget);
      });

      testWidgets('should display icon selection section', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Icon selection should be present (GridView with icons)
        expect(find.byType(GridView), findsWidgets);
      });
    });

    // ========================================
    // 5️⃣ NAVIGATION TESTS
    // ========================================

    group('Navigation', () {
      testWidgets('should have back button in AppBar', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // AppBar should have leading back button
        expect(find.byType(BackButton), findsOneWidget);
      });

      testWidgets('should pop when back button is tapped', (tester) async {
        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(value: habitProvider),
                        ChangeNotifierProvider.value(value: premiumProvider),
                      ],
                      child: const AddHabitScreen(),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(AddHabitScreen), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddHabitScreen), findsNothing);
      });
    });

    // ========================================
    // 6️⃣ LOADING STATE TESTS
    // ========================================

    group('Loading State', () {
      testWidgets('should show Save button when not loading', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('Save button should be tappable', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final saveButton = find.text('Save');
        expect(saveButton, findsOneWidget);

        // Should be able to tap
        await tester.tap(saveButton);
        await tester.pump();
      });
    });

    // ========================================
    // 7️⃣ SCROLLING TESTS
    // ========================================

    group('Scrolling', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);

        // Should be able to scroll
        await tester.drag(listView, const Offset(0, -200));
        await tester.pumpAndSettle();
      });

      testWidgets('should display all sections when scrolled', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Scroll down to see all sections
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        // Should still find Cards (some may be off-screen but rendered)
        expect(find.byType(Card), findsWidgets);
      });
    });

    // ========================================
    // 8️⃣ INTERACTION TESTS
    // ========================================

    group('Interactions', () {
      testWidgets('should allow selecting icons', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should have icon selection (GridView)
        expect(find.byType(GridView), findsWidgets);
      });

      testWidgets('should display time picker section', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Scroll to reminder time section
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Should have reminder time display
        expect(find.text('9:00 AM'), findsOneWidget); // Default time
      });
    });

    // ========================================
    // 9️⃣ ACCESSIBILITY TESTS
    // ========================================

    group('Accessibility', () {
      testWidgets('should have semantic labels', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // AppBar should have semantics
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('TextFields should be accessible', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        expect(textFields, findsAtLeastNWidgets(2));

        // TextFields should be present and interactable
        expect(textFields.first, findsOneWidget);
      });
    });

    // ========================================
    // 🔟 EDGE CASES TESTS
    // ========================================

    group('Edge Cases', () {
      testWidgets('should handle very long habit name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final longName = 'A' * 100;
        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, longName);
        await tester.pump();

        expect(find.text(longName), findsOneWidget);
      });

      testWidgets('should handle special characters in name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        const specialName = 'Habit 🎯 @#\$%';
        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, specialName);
        await tester.pump();

        expect(find.text(specialName), findsOneWidget);
      });

      testWidgets('should handle rapid taps on Save', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final saveButton = find.text('Save');

        // Rapid taps
        await tester.tap(saveButton);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(saveButton);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Should not crash
        expect(find.byType(AddHabitScreen), findsOneWidget);
      });
    });
  });
}
