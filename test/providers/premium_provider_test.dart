import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ritmo/providers/premium_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PremiumProvider', () {
    late PremiumProvider provider;

    setUp(() {
      // Reset SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      provider = PremiumProvider();
    });

    group('Initialization', () {
      test('should start with isPremium false by default', () {
        expect(provider.isPremium, false);
        expect(provider.premiumType, '');
        expect(provider.subscriptionEndDate, null);
      });

      test('should load premium status from SharedPreferences', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'is_premium': true,
          'premium_type': 'monthly',
        });

        // Act
        await provider.initializePremiumStatus();

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'monthly');
      });

      test('should revoke expired premium subscription on init', () async {
        // Arrange
        final expiredDate = DateTime.now().subtract(const Duration(days: 1));
        SharedPreferences.setMockInitialValues({
          'is_premium': true,
          'premium_type': 'monthly',
          'subscription_end_date': expiredDate.toIso8601String(),
        });

        // Act
        await provider.initializePremiumStatus();

        // Assert
        expect(provider.isPremium, false);
        expect(provider.premiumType, '');
        expect(provider.subscriptionEndDate, null);
      });

      test('should keep valid premium subscription on init', () async {
        // Arrange
        final futureDate = DateTime.now().add(const Duration(days: 30));
        SharedPreferences.setMockInitialValues({
          'is_premium': true,
          'premium_type': 'monthly',
          'subscription_end_date': futureDate.toIso8601String(),
        });

        // Act
        await provider.initializePremiumStatus();

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'monthly');
        expect(provider.subscriptionEndDate, isNotNull);
      });

      test('should set isLoading correctly during initialization', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        bool loadingDuringInit = false;

        // Listen to changes
        provider.addListener(() {
          if (provider.isLoading) {
            loadingDuringInit = true;
          }
        });

        // Act
        await provider.initializePremiumStatus();

        // Assert
        expect(loadingDuringInit, true);
        expect(provider.isLoading, false);
      });
    });

    group('Grant Premium', () {
      test('should grant premium monthly subscription', () async {
        // Act
        await provider.grantPremium('monthly');

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'monthly');
      });

      test('should grant premium annual subscription', () async {
        // Act
        await provider.grantPremium('annual');

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'annual');
      });

      test('should grant premium lifetime subscription', () async {
        // Act
        await provider.grantPremium('lifetime');

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'lifetime');
      });

      test('should save premium status to SharedPreferences', () async {
        // Act
        await provider.grantPremium('monthly');

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('is_premium'), true);
        expect(prefs.getString('premium_type'), 'monthly');
      });

      test('should grant premium with end date', () async {
        // Arrange
        final endDate = DateTime.now().add(const Duration(days: 30));

        // Act
        await provider.grantPremium('monthly', endDate: endDate);

        // Assert
        expect(provider.isPremium, true);
        expect(provider.subscriptionEndDate, isNotNull);
      });

      test('should notify listeners when granting premium', () async {
        // Arrange
        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        // Act
        await provider.grantPremium('monthly');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('Feature Access Checks', () {
      test('canAddMoreHabits should return true for premium users', () async {
        // Arrange
        await provider.grantPremium('monthly');

        // Act & Assert
        expect(provider.canAddMoreHabits(100), true);
      });

      test('canAddMoreHabits should enforce limit for free users', () {
        // Act & Assert
        expect(provider.canAddMoreHabits(0), true);
        expect(provider.canAddMoreHabits(4), true);
        expect(provider.canAddMoreHabits(5), false); // At limit
        expect(provider.canAddMoreHabits(6), false); // Over limit
      });

      test('canAccessAdvancedStats should return true only for premium', () async {
        // Free user
        expect(provider.canAccessAdvancedStats(), false);

        // Premium user
        await provider.grantPremium('monthly');
        expect(provider.canAccessAdvancedStats(), true);
      });

      test('canAccessPremiumThemes should return true only for premium', () async {
        // Free user
        expect(provider.canAccessPremiumThemes(), false);

        // Premium user
        await provider.grantPremium('annual');
        expect(provider.canAccessPremiumThemes(), true);
      });

      test('canRemoveAds should return true only for premium', () async {
        // Free user
        expect(provider.canRemoveAds(), false);

        // Premium user
        await provider.grantPremium('lifetime');
        expect(provider.canRemoveAds(), true);
      });

      test('canExportData should return true only for premium', () async {
        // Free user
        expect(provider.canExportData(), false);

        // Premium user
        await provider.grantPremium('monthly');
        expect(provider.canExportData(), true);
      });

      test('canAccessAIInsights should return true only for premium', () async {
        // Free user
        expect(provider.canAccessAIInsights(), false);

        // Premium user
        await provider.grantPremium('monthly');
        expect(provider.canAccessAIInsights(), true);
      });
    });

    group('Limit Messages', () {
      test('should return correct message for habits limit', () {
        final message = provider.getLimitMessage('habits');
        expect(message, contains('5 hábitos'));
      });

      test('should return correct message for themes limit', () {
        final message = provider.getLimitMessage('themes');
        expect(message, contains('temas premium'));
      });

      test('should return correct message for stats limit', () {
        final message = provider.getLimitMessage('stats');
        expect(message, contains('Estadísticas avanzadas'));
      });

      test('should return correct message for export limit', () {
        final message = provider.getLimitMessage('export');
        expect(message, contains('Exportar datos'));
      });

      test('should return correct message for AI limit', () {
        final message = provider.getLimitMessage('ai');
        expect(message, contains('AI Insights'));
      });

      test('should return default message for unknown feature', () {
        final message = provider.getLimitMessage('unknown');
        expect(message, contains('Ritmo PRO'));
      });
    });

    group('Free Trial', () {
      test('should start free trial with correct duration', () async {
        // Act
        await provider.startFreeTrial(24);

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'trial');
        expect(provider.subscriptionEndDate, isNotNull);
      });

      test('should set correct end date for trial', () async {
        // Arrange
        final beforeTrial = DateTime.now();

        // Act
        await provider.startFreeTrial(48);

        // Assert
        final endDate = provider.subscriptionEndDate!;
        final difference = endDate.difference(beforeTrial);
        expect(difference.inHours, greaterThanOrEqualTo(47));
        expect(difference.inHours, lessThanOrEqualTo(49));
      });
    });

    group('Testing Utilities', () {
      test('togglePremiumForTesting should grant premium when free', () async {
        // Arrange
        expect(provider.isPremium, false);

        // Act
        await provider.togglePremiumForTesting();

        // Assert
        expect(provider.isPremium, true);
        expect(provider.premiumType, 'testing');
      });

      test('togglePremiumForTesting should revoke premium when premium', () async {
        // Arrange
        await provider.grantPremium('monthly');
        expect(provider.isPremium, true);

        // Act
        await provider.togglePremiumForTesting();

        // Assert
        expect(provider.isPremium, false);
        expect(provider.premiumType, '');
      });

      test('togglePremiumForTesting should toggle back and forth', () async {
        // First toggle: grant
        await provider.togglePremiumForTesting();
        expect(provider.isPremium, true);

        // Second toggle: revoke
        await provider.togglePremiumForTesting();
        expect(provider.isPremium, false);

        // Third toggle: grant again
        await provider.togglePremiumForTesting();
        expect(provider.isPremium, true);
      });
    });

    group('Constants', () {
      test('should have correct free tier limits', () {
        expect(PremiumProvider.maxFreeHabits, 5);
        expect(PremiumProvider.maxFreeThemes, 2);
        expect(PremiumProvider.maxFreeStatsHistory, 7);
      });
    });

    group('Edge Cases', () {
      test('should handle granting premium multiple times', () async {
        // Grant monthly
        await provider.grantPremium('monthly');
        expect(provider.premiumType, 'monthly');

        // Upgrade to annual
        await provider.grantPremium('annual');
        expect(provider.premiumType, 'annual');
        expect(provider.isPremium, true);
      });

      test('should handle initialization with corrupted data', () async {
        // Arrange - invalid date string
        SharedPreferences.setMockInitialValues({
          'is_premium': true,
          'premium_type': 'monthly',
          'subscription_end_date': 'invalid-date',
        });

        // Act - should not crash
        await provider.initializePremiumStatus();

        // Assert - should handle gracefully
        expect(provider.isPremium, true); // Still loads the boolean
      });

      test('should handle zero habits count correctly', () {
        expect(provider.canAddMoreHabits(0), true);
      });

      test('should handle negative habits count correctly', () {
        // Edge case - should still work logically
        expect(provider.canAddMoreHabits(-1), true);
      });
    });
  });
}
