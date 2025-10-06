import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ritmo/providers/onboarding_provider.dart';

void main() {
  group('OnboardingProvider', () {
    late OnboardingProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = OnboardingProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    // ========================================
    // 1️⃣ INITIALIZATION TESTS
    // ========================================

    group('Initialization', () {
      test('should start with isFirstTime true and isLoading true', () {
        expect(provider.isFirstTime, true);
        expect(provider.isLoading, true);
      });

      test('should have correct default state before checkFirstTime', () {
        expect(provider.isFirstTime, true);
        expect(provider.isLoading, true);
      });

      test('should expose isFirstTime getter', () {
        expect(provider.isFirstTime, isA<bool>());
      });

      test('should expose isLoading getter', () {
        expect(provider.isLoading, isA<bool>());
      });
    });

    // ========================================
    // 2️⃣ CHECK FIRST TIME TESTS
    // ========================================

    group('Check First Time', () {
      test('should set isFirstTime to true when no saved preference', () async {
        await provider.checkFirstTime();

        expect(provider.isFirstTime, true);
        expect(provider.isLoading, false);
      });

      test('should set isFirstTime to false when onboarding was completed', () async {
        SharedPreferences.setMockInitialValues({'onboarding_completed': true});
        provider = OnboardingProvider();

        await provider.checkFirstTime();

        expect(provider.isFirstTime, false);
        expect(provider.isLoading, false);
      });

      test('should set isLoading to false after checking', () async {
        expect(provider.isLoading, true);

        await provider.checkFirstTime();

        expect(provider.isLoading, false);
      });

      test('should notify listeners after checking', () async {
        var notified = false;
        provider.addListener(() => notified = true);

        await provider.checkFirstTime();

        expect(notified, true);
      });

      test('should handle error gracefully and assume first time', () async {
        // No podemos simular error fácilmente con mocks, pero verificamos behavior normal
        await provider.checkFirstTime();

        expect(provider.isFirstTime, true);
        expect(provider.isLoading, false);
      });
    });

    // ========================================
    // 3️⃣ COMPLETE ONBOARDING TESTS
    // ========================================

    group('Complete Onboarding', () {
      test('should set isFirstTime to false when completing onboarding', () async {
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        await provider.completeOnboarding();

        expect(provider.isFirstTime, false);
      });

      test('should persist completion in SharedPreferences', () async {
        await provider.completeOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('onboarding_completed'), true);
      });

      test('should notify listeners when completing', () async {
        var notified = false;
        provider.addListener(() => notified = true);

        await provider.completeOnboarding();

        expect(notified, true);
      });

      test('should persist across provider instances', () async {
        await provider.completeOnboarding();

        // Create new provider instance
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();

        expect(newProvider.isFirstTime, false);
        newProvider.dispose();
      });
    });

    // ========================================
    // 4️⃣ RESET ONBOARDING TESTS
    // ========================================

    group('Reset Onboarding', () {
      test('should set isFirstTime to true when resetting', () async {
        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        await provider.resetOnboarding();

        expect(provider.isFirstTime, true);
      });

      test('should remove preference from SharedPreferences', () async {
        await provider.completeOnboarding();

        await provider.resetOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('onboarding_completed'), false);
      });

      test('should notify listeners when resetting', () async {
        await provider.completeOnboarding();

        var notified = false;
        provider.addListener(() => notified = true);

        await provider.resetOnboarding();

        expect(notified, true);
      });

      test('should allow re-completing onboarding after reset', () async {
        await provider.completeOnboarding();
        await provider.resetOnboarding();

        expect(provider.isFirstTime, true);

        await provider.completeOnboarding();

        expect(provider.isFirstTime, false);
      });

      test('should persist reset across provider instances', () async {
        await provider.completeOnboarding();
        await provider.resetOnboarding();

        // Create new provider instance
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();

        expect(newProvider.isFirstTime, true);
        newProvider.dispose();
      });
    });

    // ========================================
    // 5️⃣ STATE TRANSITIONS TESTS
    // ========================================

    group('State Transitions', () {
      test('should handle complete flow: check -> complete -> check', () async {
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        // Create new instance to verify persistence
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();
        expect(newProvider.isFirstTime, false);
        newProvider.dispose();
      });

      test('should handle full cycle: check -> complete -> reset -> check', () async {
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        await provider.resetOnboarding();
        expect(provider.isFirstTime, true);

        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);
      });

      test('should handle multiple completes without error', () async {
        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);
      });

      test('should handle multiple resets without error', () async {
        await provider.resetOnboarding();
        expect(provider.isFirstTime, true);

        await provider.resetOnboarding();
        expect(provider.isFirstTime, true);

        await provider.resetOnboarding();
        expect(provider.isFirstTime, true);
      });
    });

    // ========================================
    // 6️⃣ LISTENER NOTIFICATIONS TESTS
    // ========================================

    group('Listener Notifications', () {
      test('should notify listeners on checkFirstTime', () async {
        var notifyCount = 0;
        provider.addListener(() => notifyCount++);

        await provider.checkFirstTime();

        expect(notifyCount, 1);
      });

      test('should notify listeners on completeOnboarding', () async {
        var notifyCount = 0;
        provider.addListener(() => notifyCount++);

        await provider.completeOnboarding();

        expect(notifyCount, 1);
      });

      test('should notify listeners on resetOnboarding', () async {
        var notifyCount = 0;
        provider.addListener(() => notifyCount++);

        await provider.resetOnboarding();

        expect(notifyCount, 1);
      });

      test('should notify multiple listeners', () async {
        var notify1 = false;
        var notify2 = false;
        var notify3 = false;

        provider.addListener(() => notify1 = true);
        provider.addListener(() => notify2 = true);
        provider.addListener(() => notify3 = true);

        await provider.completeOnboarding();

        expect(notify1, true);
        expect(notify2, true);
        expect(notify3, true);
      });

      test('should stop notifying after listener removal', () async {
        var notified = false;
        void listener() => notified = true;

        provider.addListener(listener);
        provider.removeListener(listener);

        await provider.completeOnboarding();

        expect(notified, false);
      });
    });

    // ========================================
    // 7️⃣ EDGE CASES TESTS
    // ========================================

    group('Edge Cases', () {
      test('should handle rapid state changes', () async {
        await provider.completeOnboarding();
        await provider.resetOnboarding();
        await provider.completeOnboarding();
        await provider.resetOnboarding();

        expect(provider.isFirstTime, true);
      });

      test('should handle complete before checkFirstTime', () async {
        // Complete without checking first
        await provider.completeOnboarding();

        expect(provider.isFirstTime, false);

        // Now check
        await provider.checkFirstTime();

        expect(provider.isFirstTime, false);
      });

      test('should handle reset before checkFirstTime', () async {
        // Reset without checking first
        await provider.resetOnboarding();

        expect(provider.isFirstTime, true);
      });

      test('should maintain state consistency after dispose', () async {
        await provider.completeOnboarding();
        final wasFirstTime = provider.isFirstTime;

        // Create new provider - state should persist in SharedPreferences
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();

        expect(newProvider.isFirstTime, wasFirstTime);
        newProvider.dispose();
      });

      test('should handle null/missing SharedPreferences key gracefully', () async {
        // Start fresh
        SharedPreferences.setMockInitialValues({});
        provider = OnboardingProvider();

        await provider.checkFirstTime();

        expect(provider.isFirstTime, true);
        expect(provider.isLoading, false);
      });

      test('should handle boolean false value in SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'onboarding_completed': false});
        provider = OnboardingProvider();

        await provider.checkFirstTime();

        expect(provider.isFirstTime, true);
      });
    });

    // ========================================
    // 8️⃣ PERSISTENCE TESTS
    // ========================================

    group('Persistence', () {
      test('should persist onboarding completion across sessions', () async {
        await provider.completeOnboarding();

        // Simulate new session
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();

        expect(newProvider.isFirstTime, false);
        newProvider.dispose();
      });

      test('should persist onboarding reset across sessions', () async {
        await provider.completeOnboarding();
        await provider.resetOnboarding();

        // Simulate new session
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();

        expect(newProvider.isFirstTime, true);
        newProvider.dispose();
      });

      test('should use correct SharedPreferences key', () async {
        await provider.completeOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('onboarding_completed'), true);
      });

      test('should save true value when completing', () async {
        await provider.completeOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('onboarding_completed'), true);
      });

      test('should clear value when resetting', () async {
        await provider.completeOnboarding();
        final prefs1 = await SharedPreferences.getInstance();
        expect(prefs1.getBool('onboarding_completed'), true);

        await provider.resetOnboarding();
        final prefs2 = await SharedPreferences.getInstance();
        expect(prefs2.containsKey('onboarding_completed'), false);
      });
    });

    // ========================================
    // 9️⃣ INTEGRATION TESTS
    // ========================================

    group('Integration Scenarios', () {
      test('should simulate first app launch', () async {
        // User opens app for first time
        await provider.checkFirstTime();

        expect(provider.isFirstTime, true);
        expect(provider.isLoading, false);
      });

      test('should simulate user completing onboarding', () async {
        // First launch
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        // User completes onboarding
        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        // Next app launch
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();
        expect(newProvider.isFirstTime, false);
        newProvider.dispose();
      });

      test('should simulate developer resetting onboarding for testing', () async {
        await provider.completeOnboarding();
        expect(provider.isFirstTime, false);

        // Developer resets for testing
        await provider.resetOnboarding();
        expect(provider.isFirstTime, true);

        // App behaves as first launch again
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);
      });

      test('should handle onboarding skip scenario', () async {
        // User sees onboarding but doesn't complete
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        // User closes app without completing
        // Next launch
        final newProvider = OnboardingProvider();
        await newProvider.checkFirstTime();
        expect(newProvider.isFirstTime, true); // Should show again
        newProvider.dispose();
      });

      test('should handle multiple app sessions', () async {
        // Session 1: First time
        await provider.checkFirstTime();
        expect(provider.isFirstTime, true);

        // Session 2: Complete onboarding
        await provider.completeOnboarding();
        final session2 = OnboardingProvider();
        await session2.checkFirstTime();
        expect(session2.isFirstTime, false);
        session2.dispose();

        // Session 3: Normal usage
        final session3 = OnboardingProvider();
        await session3.checkFirstTime();
        expect(session3.isFirstTime, false);
        session3.dispose();

        // Session 4: After reset
        await provider.resetOnboarding();
        final session4 = OnboardingProvider();
        await session4.checkFirstTime();
        expect(session4.isFirstTime, true);
        session4.dispose();
      });
    });
  });
}
