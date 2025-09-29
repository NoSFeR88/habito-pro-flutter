import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/premium_provider.dart';

class PaywallScreen extends StatefulWidget {
  final String? featureBlocked; // Para mostrar mensaje específico
  final Function()? onPurchaseSuccess;

  const PaywallScreen({
    Key? key,
    this.featureBlocked,
    this.onPurchaseSuccess,
  }) : super(key: key);

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedPlan = 1; // 0=Monthly, 1=Annual, 2=Lifetime
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'type': 'monthly',
      'title': 'Mensual',
      'price': '\$3.99',
      'period': '/mes',
      'savings': '',
      'color': AppColors.primary.withOpacity(0.1),
      'borderColor': AppColors.primary.withOpacity(0.3),
    },
    {
      'type': 'annual',
      'title': 'Anual',
      'price': '\$29.99',
      'period': '/año',
      'savings': '37% DESCUENTO',
      'color': AppColors.success.withOpacity(0.1),
      'borderColor': AppColors.success,
      'highlight': true,
    },
    {
      'type': 'lifetime',
      'title': 'De por vida',
      'price': '\$49.99',
      'period': 'pago único',
      'savings': 'OFERTA LIMITADA',
      'color': AppColors.warning.withOpacity(0.1),
      'borderColor': AppColors.warning,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
      final selectedPlan = _plans[_selectedPlan];

      // Simular proceso de compra
      await Future.delayed(const Duration(seconds: 2));

      // Para desarrollo - simular compra exitosa
      await premiumProvider.grantPremium(selectedPlan['type']);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.welcomeToRitmoPro),
              ],
            ),
            backgroundColor: AppColors.surfaceDark,
            duration: const Duration(seconds: 3),
          ),
        );

        // Callback de éxito
        widget.onPurchaseSuccess?.call();

        // Cerrar paywall
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.purchaseError}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: Column(
                  children: [
                    // Header con botón cerrar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                          Text(
                            'Ritmo PRO',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 48), // Balance
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Logo/Icon hero
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.star,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Título principal
                            Text(
                              'Desbloquea todo el potencial de Ritmo',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            // Mensaje específico si viene de feature bloqueada
                            if (widget.featureBlocked != null) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.warning.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      color: AppColors.warning,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.featureBlocked!,
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Features premium
                            ..._buildPremiumFeatures(),

                            const SizedBox(height: 32),

                            // Planes de precios
                            ..._buildPricingPlans(),

                            const SizedBox(height: 24),

                            // Botón de compra
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isProcessing ? null : _handlePurchase,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Comenzar con Ritmo PRO',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Términos y condiciones
                            Text(
                              'Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildPremiumFeatures() {
    final features = [
      {
        'icon': Icons.all_inclusive,
        'title': 'Hábitos ilimitados',
        'subtitle': 'Crea todos los hábitos que quieras',
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Estadísticas avanzadas',
        'subtitle': 'Análisis profundo y tendencias',
      },
      {
        'icon': Icons.palette,
        'title': '5 temas premium',
        'subtitle': 'Ocean, Sunset, Forest y más',
      },
      {
        'icon': Icons.ads_click_off,
        'title': 'Sin publicidad',
        'subtitle': 'Experiencia completamente limpia',
      },
      {
        'icon': Icons.cloud_upload,
        'title': 'Backup automático',
        'subtitle': 'Tus datos seguros en la nube',
      },
      {
        'icon': Icons.psychology,
        'title': 'AI Insights',
        'subtitle': 'Recomendaciones inteligentes',
      },
    ];

    return features.map((feature) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    feature['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 20,
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildPricingPlans() {
    return [
      Text(
        'Elige tu plan',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      ...List.generate(_plans.length, (index) {
        final plan = _plans[index];
        final isSelected = _selectedPlan == index;
        final isHighlighted = plan['highlight'] == true;

        return GestureDetector(
          onTap: () => setState(() => _selectedPlan = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? plan['color'] : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? plan['borderColor']
                    : AppColors.surfaceDark,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? plan['borderColor']
                          : AppColors.textSecondaryDark,
                      width: 2,
                    ),
                    color: isSelected ? plan['borderColor'] : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                // Plan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          if (isHighlighted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (plan['savings'].isNotEmpty)
                        Text(
                          plan['savings'],
                          style: TextStyle(
                            fontSize: 12,
                            color: plan['borderColor'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      plan['period'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ];
  }
}