import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicRitmoLogo extends StatefulWidget {
  final double fontSize;
  final Color? color;
  final bool animated;
  final Duration changeInterval;

  const DynamicRitmoLogo({
    super.key,
    this.fontSize = 32,
    this.color,
    this.animated = true,
    this.changeInterval = const Duration(seconds: 5),
  });

  @override
  State<DynamicRitmoLogo> createState() => _DynamicRitmoLogoState();
}

class _DynamicRitmoLogoState extends State<DynamicRitmoLogo>
    with TickerProviderStateMixin {
  int _currentStyleIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final Random _random = Random();

  // 🎨 LOGO DINÁMICO "RITMO VIVO" - 5 variaciones únicas
  final List<LogoStyle> _logoStyles = [
    LogoStyle(
      text: 'RITMO',
      googleFont: GoogleFonts.righteous,
      description: 'Bold Minimalista',
      weight: FontWeight.w700,
      letterSpacing: 3.0,
    ),
    LogoStyle(
      text: 'ℝ𝕀𝕋𝕄𝒪',
      googleFont: GoogleFonts.playfairDisplay,
      description: 'Serif Dramático',
      weight: FontWeight.w800,
      letterSpacing: 2.0,
    ),
    LogoStyle(
      text: 'RITMO',
      googleFont: GoogleFonts.orbitron,
      description: 'Futurista Tech',
      weight: FontWeight.w600,
      letterSpacing: 4.0,
    ),
    LogoStyle(
      text: 'ℛ𝒾𝓉𝓂𝑜',
      googleFont: GoogleFonts.dancingScript,
      description: 'Script Elegante',
      weight: FontWeight.w600,
      letterSpacing: 1.0,
    ),
    LogoStyle(
      text: 'RITMO',
      googleFont: GoogleFonts.russoOne,
      description: 'Impact Bold',
      weight: FontWeight.w900,
      letterSpacing: 2.5,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    if (widget.animated) {
      _startLogoRotation();
    }
  }

  void _startLogoRotation() {
    Future.delayed(widget.changeInterval, () {
      if (mounted) {
        _changeLogoStyle();
      }
    });
  }

  void _changeLogoStyle() {
    if (!mounted) return;

    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentStyleIndex = _random.nextInt(_logoStyles.length);
        });
        _fadeController.forward().then((_) {
          if (mounted && widget.animated) {
            _startLogoRotation();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoStyle = _logoStyles[_currentStyleIndex];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: 0.8 + (_fadeAnimation.value * 0.2),
            child: Text(
              logoStyle.text,
              style: logoStyle.googleFont(
                fontSize: widget.fontSize,
                fontWeight: logoStyle.weight,
                letterSpacing: logoStyle.letterSpacing,
                color: widget.color ?? theme.colorScheme.primary,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: (widget.color ?? theme.colorScheme.primary)
                        .withValues(alpha:0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔄 Método para cambio manual del logo
  void changeStyle() {
    _changeLogoStyle();
  }

  // 📊 Obtener estilo actual
  LogoStyle get currentStyle => _logoStyles[_currentStyleIndex];
}

class LogoStyle {
  final String text;
  final TextStyle Function({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    List<Shadow>? shadows,
  }) googleFont;
  final String description;
  final FontWeight weight;
  final double letterSpacing;

  const LogoStyle({
    required this.text,
    required this.googleFont,
    required this.description,
    required this.weight,
    required this.letterSpacing,
  });
}

// 🎯 Widget complementario para mostrar info del logo actual (debug)
class LogoStyleIndicator extends StatelessWidget {
  final LogoStyle logoStyle;
  final bool showDescription;

  const LogoStyleIndicator({
    super.key,
    required this.logoStyle,
    this.showDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showDescription) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: Text(
        logoStyle.description,
        style: GoogleFonts.roboto(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}