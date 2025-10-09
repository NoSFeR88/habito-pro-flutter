import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/onboarding_provider.dart';

/// Onboarding moderno que destaca las virtudes clave de RITMO
/// - Gamificación (puntos, rachas, logros)
/// - Estadísticas visuales profesionales
/// - Temas premium únicos
/// - UX simple y efectiva
class OnboardingScreenNew extends StatefulWidget {
  const OnboardingScreenNew({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenNew> createState() => _OnboardingScreenNewState();
}

class _OnboardingScreenNewState extends State<OnboardingScreenNew>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final onboardingProvider =
        Provider.of<OnboardingProvider>(context, listen: false);
    await onboardingProvider.completeOnboarding();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header compacto
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo + Brand
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.waves,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'RITMO',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),

                    // Skip button
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        l10n.skip,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page indicator moderno
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == _currentPage ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              // Contenido principal
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    _animationController.reset();
                    _animationController.forward();
                  },
                  children: [
                    _buildGamificationPage(l10n, theme),
                    _buildVisualizationPage(l10n, theme),
                    _buildCustomizationPage(l10n, theme),
                  ],
                ),
              ),

              // Footer con CTA
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor:
                              theme.colorScheme.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == 2
                                  ? l10n.onboardingStartMyRhythm
                                  : l10n.next,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == 2
                                  ? Icons.check_circle
                                  : Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_currentPage < 2) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_open,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Gratis • Sin tarjeta',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Página 1: Gamificación (puntos, rachas, logros)
  Widget _buildGamificationPage(AppLocalizations l10n, ThemeData theme) {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.3),
                    theme.colorScheme.primary.withValues(alpha: 0.0),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Racha de fuego
                  Icon(
                    Icons.local_fire_department,
                    size: 100,
                    color: Colors.orange[600],
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+5',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              '¡Convierte hábitos en juego!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'Gana puntos, construye rachas épicas y desbloquea logros mientras mejoras tu vida.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Feature cards
            _buildFeatureCard(
              theme,
              Icons.emoji_events,
              '5 puntos',
              'Por cada hábito completado',
              Colors.amber,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.whatshot,
              'Rachas',
              'Días consecutivos con recompensa',
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.military_tech,
              'Logros',
              'Desbloquea insignias especiales',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  /// Página 2: Visualización (estadísticas profesionales)
  Widget _buildVisualizationPage(AppLocalizations l10n, ThemeData theme) {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero illustration - Gráfico mockup
            Container(
              width: 280,
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.show_chart,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Progreso Semanal',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mockup de gráfico de barras
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildMockBar(theme, 0.6),
                        _buildMockBar(theme, 0.9),
                        _buildMockBar(theme, 0.7),
                        _buildMockBar(theme, 1.0),
                        _buildMockBar(theme, 0.8),
                        _buildMockBar(theme, 0.5),
                        _buildMockBar(theme, 0.85),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('L', style: theme.textTheme.bodySmall),
                      Text('M', style: theme.textTheme.bodySmall),
                      Text('X', style: theme.textTheme.bodySmall),
                      Text('J', style: theme.textTheme.bodySmall),
                      Text('V', style: theme.textTheme.bodySmall),
                      Text('S', style: theme.textTheme.bodySmall),
                      Text('D', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Visualiza tu progreso',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'Gráficos profesionales, heatmaps semanales y estadísticas detalladas para entender tu evolución.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            _buildFeatureCard(
              theme,
              Icons.pie_chart,
              'Gráficos',
              'Líneas, barras y tortas con colores vibrantes',
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.calendar_month,
              'Heatmap',
              'Calendario visual de tus hábitos',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  /// Página 3: Personalización (temas premium)
  Widget _buildCustomizationPage(AppLocalizations l10n, ThemeData theme) {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero illustration - Theme showcase
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 30,
                    child: _buildThemePreview(theme, Colors.blue, 0.7),
                  ),
                  Positioned(
                    right: 60,
                    top: 10,
                    child: _buildThemePreview(theme, Colors.purple, 1.0),
                  ),
                  Positioned(
                    left: 80,
                    bottom: 20,
                    child: _buildThemePreview(theme, Colors.orange, 0.85),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 40,
                    child: _buildThemePreview(theme, Colors.teal, 0.9),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              '¡Haz tu app única!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              '6 temas premium dramáticos + modo oscuro/claro. Crea una experiencia visual que te motive.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            _buildFeatureCard(
              theme,
              Icons.palette,
              '9 Temas',
              '3 gratis + 6 premium únicos en el mercado',
              Colors.pink,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.dark_mode,
              'Modo Oscuro',
              'Todos los temas en versión clara y oscura',
              Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockBar(ThemeData theme, double heightFactor) {
    return Container(
      width: 24,
      height: 100 * heightFactor,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
    );
  }

  Widget _buildThemePreview(ThemeData theme, Color color, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(8),
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              height: 6,
              width: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
