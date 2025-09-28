import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  // Variables de estado
  bool _isInitialized = false;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Configuración de testing - IDs de AdMob de prueba
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  // TODO: Reemplazar con IDs reales de AdMob cuando tengas cuenta
  static const String _prodBannerId = _testBannerId; // 'ca-app-pub-XXXXXXXX/XXXXXXXX'
  static const String _prodInterstitialId = _testInterstitialId; // 'ca-app-pub-XXXXXXXX/XXXXXXXX'
  static const String _prodRewardedId = _testRewardedId; // 'ca-app-pub-XXXXXXXX/XXXXXXXX'

  // Getters para IDs dependiendo del entorno
  String get _bannerId => kDebugMode ? _testBannerId : _prodBannerId;
  String get _interstitialId => kDebugMode ? _testInterstitialId : _prodInterstitialId;
  String get _rewardedId => kDebugMode ? _testRewardedId : _prodRewardedId;

  // Control de frecuencia de ads
  DateTime? _lastInterstitialShown;
  static const Duration _interstitialCooldown = Duration(minutes: 5);

  bool get isInitialized => _isInitialized;
  BannerAd? get bannerAd => _bannerAd;

  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('✅ AdMob initialized successfully');

      // Pre-cargar ads
      await _loadBannerAd();
      await _loadInterstitialAd();
      await _loadRewardedAd();
    } catch (e) {
      debugPrint('❌ Error initializing AdMob: $e');
    }
  }

  // ==================== BANNER ADS ====================
  Future<void> _loadBannerAd() async {
    if (!_isInitialized) return;

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
        onAdClicked: (ad) {
          debugPrint('📊 Banner ad clicked');
        },
      ),
    );

    await _bannerAd!.load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // ==================== INTERSTITIAL ADS ====================
  Future<void> _loadInterstitialAd() async {
    if (!_isInitialized) return;

    await InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('✅ Interstitial ad loaded');

          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('📊 Interstitial ad showed');
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('📊 Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              // Pre-cargar el siguiente
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
            },
            onAdClicked: (ad) {
              debugPrint('📊 Interstitial ad clicked');
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<bool> showInterstitialAd() async {
    if (_interstitialAd == null) {
      debugPrint('⚠️ Interstitial ad not ready');
      return false;
    }

    // Control de frecuencia
    if (_lastInterstitialShown != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastInterstitialShown!);
      if (timeSinceLastAd < _interstitialCooldown) {
        debugPrint('⚠️ Interstitial ad cooldown active');
        return false;
      }
    }

    try {
      await _interstitialAd!.show();
      _lastInterstitialShown = DateTime.now();
      return true;
    } catch (e) {
      debugPrint('❌ Error showing interstitial ad: $e');
      return false;
    }
  }

  // ==================== REWARDED ADS ====================
  Future<void> _loadRewardedAd() async {
    if (!_isInitialized) return;

    await RewardedAd.load(
      adUnitId: _rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          debugPrint('✅ Rewarded ad loaded');

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('📊 Rewarded ad showed');
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('📊 Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              // Pre-cargar el siguiente
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
            },
            onAdClicked: (ad) {
              debugPrint('📊 Rewarded ad clicked');
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewardedAd({required Function(RewardItem) onRewardEarned}) async {
    if (_rewardedAd == null) {
      debugPrint('⚠️ Rewarded ad not ready');
      return false;
    }

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
          onRewardEarned(reward);
        },
      );
      return true;
    } catch (e) {
      debugPrint('❌ Error showing rewarded ad: $e');
      return false;
    }
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  // ==================== CLEANUP ====================
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
    debugPrint('🧹 AdsService disposed');
  }

  // ==================== UTILITY METHODS ====================

  // Método para obtener configuración de ConsentForm (GDPR)
  Future<void> requestConsent() async {
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          if (await ConsentInformation.instance.isConsentFormAvailable()) {
            _loadConsentForm();
          }
        },
        (error) {
          debugPrint('❌ Consent info error: $error');
        },
      );
    } catch (e) {
      debugPrint('❌ Error requesting consent: $e');
    }
  }

  void _loadConsentForm() {
    ConsentForm.loadConsentForm(
      (consentForm) async {
        if (await ConsentInformation.instance.getConsentStatus() ==
            ConsentStatus.required) {
          consentForm.show((formError) {
            debugPrint('Consent form error: $formError');
            _loadConsentForm();
          });
        }
      },
      (formError) {
        debugPrint('❌ Consent form load error: $formError');
      },
    );
  }

  // Estadísticas simples de ads
  Map<String, dynamic> getAdStats() {
    return {
      'banner_loaded': _bannerAd != null,
      'interstitial_loaded': _interstitialAd != null,
      'rewarded_loaded': _rewardedAd != null,
      'last_interstitial': _lastInterstitialShown?.toIso8601String(),
      'initialized': _isInitialized,
    };
  }
}