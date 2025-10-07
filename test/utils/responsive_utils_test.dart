import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/utils/responsive_utils.dart';

void main() {
  group('ResponsiveUtils - getResponsivePadding', () {
    testWidgets('should return 2x base padding on desktop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Simular desktop width (>= 1024)
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);

              // Desktop: base × 2.0 = 32.0
              expect(padding, equals(32.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return 1.5x base padding on tablet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Simular tablet width (768-1023)
              tester.binding.window.physicalSizeTestValue = const Size(800, 600);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);

              // Tablet: base × 1.5 = 24.0
              expect(padding, equals(24.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return base padding on mobile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Simular mobile width (<768)
              tester.binding.window.physicalSizeTestValue = const Size(375, 667);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);

              // Mobile: base × 1.0 = 16.0
              expect(padding, equals(16.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should handle different base values correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              // Test con base = 8.0
              final padding8 = ResponsiveUtils.getResponsivePadding(context, base: 8.0);
              expect(padding8, equals(16.0)); // 8.0 × 2.0

              // Test con base = 24.0
              final padding24 = ResponsiveUtils.getResponsivePadding(context, base: 24.0);
              expect(padding24, equals(48.0)); // 24.0 × 2.0

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('ResponsiveUtils - getResponsiveSpacing', () {
    testWidgets('should return 1.5x base spacing on desktop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);

              // Desktop: base × 1.5 = 18.0
              expect(spacing, equals(18.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return 1.25x base spacing on tablet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(800, 600);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);

              // Tablet: base × 1.25 = 15.0
              expect(spacing, equals(15.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return base spacing on mobile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(375, 667);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);

              // Mobile: base × 1.0 = 12.0
              expect(spacing, equals(12.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('ResponsiveUtils - getResponsiveFontSize', () {
    testWidgets('should return +12.5% font size on desktop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);

              // Desktop: base × 1.125 = 18.0
              expect(fontSize, equals(18.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return +6.25% font size on tablet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(800, 600);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);

              // Tablet: base × 1.0625 = 17.0
              expect(fontSize, equals(17.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return base font size on mobile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(375, 667);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);

              // Mobile: base × 1.0 = 16.0
              expect(fontSize, equals(16.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should handle typical font sizes correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              // Título (20.0) → 22.5
              final titleSize = ResponsiveUtils.getResponsiveFontSize(context, base: 20.0);
              expect(titleSize, equals(22.5));

              // Body (14.0) → 15.75
              final bodySize = ResponsiveUtils.getResponsiveFontSize(context, base: 14.0);
              expect(bodySize, equals(15.75));

              // Caption (12.0) → 13.5
              final captionSize = ResponsiveUtils.getResponsiveFontSize(context, base: 12.0);
              expect(captionSize, equals(13.5));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('ResponsiveUtils - Edge Cases', () {
    testWidgets('should handle zero base values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              expect(ResponsiveUtils.getResponsivePadding(context, base: 0.0), equals(0.0));
              expect(ResponsiveUtils.getResponsiveSpacing(context, base: 0.0), equals(0.0));
              expect(ResponsiveUtils.getResponsiveFontSize(context, base: 0.0), equals(0.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should handle negative base values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              // Aunque no es caso de uso real, debe manejar correctamente
              expect(ResponsiveUtils.getResponsivePadding(context, base: -10.0), equals(-20.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should handle very large base values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final largePadding = ResponsiveUtils.getResponsivePadding(context, base: 1000.0);
              expect(largePadding, equals(2000.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should handle breakpoint boundaries correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Exactly at mobile/tablet boundary (768)
              tester.binding.window.physicalSizeTestValue = const Size(768, 600);
              tester.binding.window.devicePixelRatioTestValue = 1.0;

              final padding768 = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              // 768 es tablet, debería ser 1.5x = 24.0
              expect(padding768, equals(24.0));

              // Exactly at tablet/desktop boundary (1024)
              tester.binding.window.physicalSizeTestValue = const Size(1024, 768);
              final padding1024 = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              // 1024 es desktop, debería ser 2.0x = 32.0
              expect(padding1024, equals(32.0));

              return const Scaffold();
            },
          ),
        ),
      );

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
