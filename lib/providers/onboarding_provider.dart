import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  bool _isFirstTime = true;
  bool _isLoading = true;

  bool get isFirstTime => _isFirstTime;
  bool get isLoading => _isLoading;

  static const String _onboardingCompletedKey = 'onboarding_completed';

  Future<void> checkFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool(_onboardingCompletedKey) ?? false;
      _isFirstTime = !completed;

      debugPrint('🔍 Checking first time: $_isFirstTime');
    } catch (e) {
      debugPrint('❌ Error checking first time: $e');
      // En caso de error, asumir que es primera vez para mostrar onboarding
      _isFirstTime = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      _isFirstTime = false;

      debugPrint('✅ Onboarding marked as completed');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error completing onboarding: $e');
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      _isFirstTime = true;

      debugPrint('🔄 Onboarding reset');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error resetting onboarding: $e');
    }
  }
}