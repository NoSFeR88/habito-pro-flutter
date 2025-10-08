import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/utils/responsive_utils.dart';

void main() {
  group('ResponsiveUtils - getResponsivePadding', () {
    testWidgets('should return 2x base padding on desktop', (tester) async {
      // Simular desktop width (> 1200) ANTES de pumpWidget
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Desktop: base × 2.0 = 32.0
      expect(padding, equals(32.0));
    });

    testWidgets('should return 1.5x base padding on tablet', (tester) async {
      // Simular tablet width (600-1200) ANTES de pumpWidget
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Tablet: base × 1.5 = 24.0
      expect(padding, equals(24.0));
    });

    testWidgets('should return base padding on mobile', (tester) async {
      // Simular mobile width (<= 600) ANTES de pumpWidget
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Mobile: base × 1.0 = 16.0
      expect(padding, equals(16.0));
    });

    testWidgets('should handle different base values correctly', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding8, padding24;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Test con base = 8.0
              padding8 = ResponsiveUtils.getResponsivePadding(context, base: 8.0);
              // Test con base = 24.0
              padding24 = ResponsiveUtils.getResponsivePadding(context, base: 24.0);
              return const Scaffold();
            },
          ),
        ),
      );

      expect(padding8, equals(16.0)); // 8.0 × 2.0
      expect(padding24, equals(48.0)); // 24.0 × 2.0
    });
  });

  group('ResponsiveUtils - getResponsiveSpacing', () {
    testWidgets('should return 1.5x base spacing on desktop', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double spacing;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Desktop: base × 1.5 = 18.0
      expect(spacing, equals(18.0));
    });

    testWidgets('should return 1.25x base spacing on tablet', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double spacing;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Tablet: base × 1.25 = 15.0
      expect(spacing, equals(15.0));
    });

    testWidgets('should return base spacing on mobile', (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double spacing;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 12.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Mobile: base × 1.0 = 12.0
      expect(spacing, equals(12.0));
    });
  });

  group('ResponsiveUtils - getResponsiveFontSize', () {
    testWidgets('should return +12.5% font size on desktop', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Desktop: base × 1.125 = 18.0
      expect(fontSize, equals(18.0));
    });

    testWidgets('should return +6.25% font size on tablet', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Tablet: base × 1.0625 = 17.0
      expect(fontSize, equals(17.0));
    });

    testWidgets('should return base font size on mobile', (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // Mobile: base × 1.0 = 16.0
      expect(fontSize, equals(16.0));
    });

    testWidgets('should handle typical font sizes correctly', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double titleSize, bodySize, captionSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Título (20.0) → 22.5
              titleSize = ResponsiveUtils.getResponsiveFontSize(context, base: 20.0);
              // Body (14.0) → 15.75
              bodySize = ResponsiveUtils.getResponsiveFontSize(context, base: 14.0);
              // Caption (12.0) → 13.5
              captionSize = ResponsiveUtils.getResponsiveFontSize(context, base: 12.0);
              return const Scaffold();
            },
          ),
        ),
      );

      expect(titleSize, equals(22.5));
      expect(bodySize, equals(15.75));
      expect(captionSize, equals(13.5));
    });
  });

  group('ResponsiveUtils - Edge Cases', () {
    testWidgets('should handle zero base values', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding, spacing, fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 0.0);
              spacing = ResponsiveUtils.getResponsiveSpacing(context, base: 0.0);
              fontSize = ResponsiveUtils.getResponsiveFontSize(context, base: 0.0);
              return const Scaffold();
            },
          ),
        ),
      );

      expect(padding, equals(0.0));
      expect(spacing, equals(0.0));
      expect(fontSize, equals(0.0));
    });

    testWidgets('should handle negative base values', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Aunque no es caso de uso real, debe manejar correctamente
              padding = ResponsiveUtils.getResponsivePadding(context, base: -10.0);
              return const Scaffold();
            },
          ),
        ),
      );

      expect(padding, equals(-20.0));
    });

    testWidgets('should handle very large base values', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double largePadding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              largePadding = ResponsiveUtils.getResponsivePadding(context, base: 1000.0);
              return const Scaffold();
            },
          ),
        ),
      );

      expect(largePadding, equals(2000.0));
    });

    testWidgets('should handle tablet breakpoint boundary correctly (601px)', (tester) async {
      // Test just above 600px (tablet lower boundary)
      tester.view.physicalSize = const Size(601, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // 601px es tablet (> 600), debería ser 1.5x = 24.0
      expect(padding, equals(24.0));
    });

    testWidgets('should handle desktop breakpoint boundary correctly (1201px)', (tester) async {
      // Test just above 1200px (desktop lower boundary)
      tester.view.physicalSize = const Size(1201, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      late double padding;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              padding = ResponsiveUtils.getResponsivePadding(context, base: 16.0);
              return const Scaffold();
            },
          ),
        ),
      );

      // 1201px es desktop (> 1200), debería ser 2.0x = 32.0
      expect(padding, equals(32.0));
    });
  });
}
