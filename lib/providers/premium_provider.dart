import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  bool _isLoading = false;
  String _premiumType = ''; // 'monthly', 'annual', 'lifetime'
  DateTime? _subscriptionEndDate;

  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  String get premiumType => _premiumType;
  DateTime? get subscriptionEndDate => _subscriptionEndDate;

  static const String _premiumKey = 'is_premium';
  static const String _premiumTypeKey = 'premium_type';
  static const String _subscriptionEndKey = 'subscription_end_date';

  // Límites del plan gratuito
  static const int maxFreeHabits = 5;
  static const int maxFreeThemes = 2;
  static const int maxFreeStatsHistory = 7; // días

  Future<void> initializePremiumStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool(_premiumKey) ?? false;
      _premiumType = prefs.getString(_premiumTypeKey) ?? '';

      final endDateString = prefs.getString(_subscriptionEndKey);
      if (endDateString != null) {
        _subscriptionEndDate = DateTime.parse(endDateString);

        // Verificar si la suscripción ha expirado
        if (_subscriptionEndDate!.isBefore(DateTime.now())) {
          await _revokePremium();
        }
      }

      debugPrint('✅ Premium status initialized: $_isPremium ($_premiumType)');
    } catch (e) {
      debugPrint('❌ Error initializing premium status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> grantPremium(String type, {DateTime? endDate}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isPremium = true;
      _premiumType = type;
      _subscriptionEndDate = endDate;

      await prefs.setBool(_premiumKey, true);
      await prefs.setString(_premiumTypeKey, type);

      if (endDate != null) {
        await prefs.setString(_subscriptionEndKey, endDate.toIso8601String());
      }

      debugPrint('✅ Premium granted: $type');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error granting premium: $e');
    }
  }

  Future<void> _revokePremium() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isPremium = false;
      _premiumType = '';
      _subscriptionEndDate = null;

      await prefs.setBool(_premiumKey, false);
      await prefs.remove(_premiumTypeKey);
      await prefs.remove(_subscriptionEndKey);

      debugPrint('✅ Premium revoked');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error revoking premium: $e');
    }
  }

  // Verificadores de límites para features
  bool canAddMoreHabits(int currentCount) {
    if (_isPremium) return true;
    return currentCount < maxFreeHabits;
  }

  bool canAccessAdvancedStats() {
    return _isPremium;
  }

  bool canAccessPremiumThemes() {
    return _isPremium;
  }

  bool canRemoveAds() {
    return _isPremium;
  }

  bool canExportData() {
    return _isPremium;
  }

  bool canAccessAIInsights() {
    return _isPremium;
  }

  // Obtener mensaje de límite alcanzado
  String getLimitMessage(String feature) {
    switch (feature) {
      case 'habits':
        return 'Límite alcanzado: máximo $maxFreeHabits hábitos en el plan gratuito.';
      case 'themes':
        return 'Los temas premium están disponibles solo en Ritmo PRO.';
      case 'stats':
        return 'Estadísticas avanzadas disponibles en Ritmo PRO.';
      case 'export':
        return 'Exportar datos está disponible en Ritmo PRO.';
      case 'ai':
        return 'AI Insights están disponibles en Ritmo PRO.';
      default:
        return 'Esta función está disponible en Ritmo PRO.';
    }
  }

  // Simular trial premium (para testing)
  Future<void> startFreeTrial(int durationHours) async {
    final endDate = DateTime.now().add(Duration(hours: durationHours));
    await grantPremium('trial', endDate: endDate);
    debugPrint('🎁 Free trial started for $durationHours hours');
  }

  // Método para desarrollo/testing
  Future<void> togglePremiumForTesting() async {
    if (_isPremium) {
      await _revokePremium();
    } else {
      await grantPremium('testing');
    }
  }
}