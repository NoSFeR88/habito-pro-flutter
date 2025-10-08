import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/ads_service.dart';
import '../providers/premium_provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../core/theme.dart';

class AdBannerWidget extends StatefulWidget {
  final bool showOnlyIfFree;
  final EdgeInsets margin;

  const AdBannerWidget({
    Key? key,
    this.showOnlyIfFree = true,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final AdsService _adsService = AdsService();
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeAd();
  }

  void _initializeAd() {
    // Verificar si el servicio está inicializado
    if (_adsService.isInitialized && _adsService.bannerAd != null) {
      setState(() => _isAdLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumProvider>(
      builder: (context, premiumProvider, child) {
        // No mostrar ads si es premium (y se especifica showOnlyIfFree)
        if (widget.showOnlyIfFree && premiumProvider.isPremium) {
          return const SizedBox.shrink();
        }

        // No mostrar si el ad no está cargado
        if (!_isAdLoaded || _adsService.bannerAd == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.textSecondaryDark.withValues(alpha:0.1),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Banner Ad
                SizedBox(
                  width: _adsService.bannerAd!.size.width.toDouble(),
                  height: _adsService.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _adsService.bannerAd!),
                ),

                // Overlay con botón "Quitar ads" si no es premium
                if (!premiumProvider.isPremium)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _showRemoveAdsDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha:0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.removeAds,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRemoveAdsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.block, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.removePermanentAds,
                style: TextStyle(color: AppColors.textDark),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.enjoyRitmoInterruptions,
                style: TextStyle(color: AppColors.textSecondaryDark),
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.block, AppLocalizations.of(context)!.noAdvertising),
              _buildFeatureRow(Icons.all_inclusive, AppLocalizations.of(context)!.unlimitedHabits),
              _buildFeatureRow(Icons.palette, AppLocalizations.of(context)!.premiumThemesFeature),
              _buildFeatureRow(Icons.bar_chart, AppLocalizations.of(context)!.advancedStats),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha:0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.pricingText,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.later,
                style: TextStyle(color: AppColors.textSecondaryDark),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToPaywall(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.startPro),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPaywall(BuildContext context) {
    // Importar PaywallScreen cuando esté disponible
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => PaywallScreen(
    //       featureBlocked: 'Accede a Ritmo sin publicidad con PRO',
    //     ),
    //   ),
    // );

    // Por ahora, solo mostrar snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.paywallComingSoon),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    // No disposear el ad aquí, ya que es manejado por AdsService
    super.dispose();
  }
}