import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 RITMO Typography System - Tipografía característica de marca
///
/// Sistema de tipografía que define la personalidad visual única de RITMO
/// Utiliza Google Fonts para crear una experiencia tipográfica distintiva
class RitmoTypography {

  /// 🎯 FUENTE PRINCIPAL DE MARCA - "Righteous"
  /// Fuente audaz, característica que representa la personalidad de RITMO
  /// Uso: Títulos principales, logo, elementos destacados
  static TextStyle get brandFont => GoogleFonts.righteous();

  /// 📝 FUENTE SECUNDARIA - "Inter"
  /// Fuente moderna y legible para texto general
  /// Uso: Texto corrido, descripciones, labels
  static TextStyle get bodyFont => GoogleFonts.inter();

  /// 🔢 FUENTE NUMÉRICA - "JetBrains Mono"
  /// Fuente monoespaciada para números y estadísticas
  /// Uso: Contadores, estadísticas, datos numéricos
  static TextStyle get numericFont => GoogleFonts.jetBrainsMono();

  // 🎨 ESTILOS DE MARCA PREDEFINIDOS

  /// 🏆 Título principal de marca (Logo grande)
  static TextStyle get heroTitle => brandFont.copyWith(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: 3.0,
    height: 1.1,
  );

  /// 📱 Título de pantalla
  static TextStyle get screenTitle => brandFont.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.2,
  );

  /// 🎯 Título de sección
  static TextStyle get sectionTitle => brandFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.3,
  );

  /// 🔤 Subtítulo
  static TextStyle get subtitle => brandFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// 📄 Cuerpo de texto
  static TextStyle get bodyText => bodyFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.5,
  );

  /// 🔽 Texto secundario
  static TextStyle get bodySecondary => bodyFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// 🏷️ Label/etiqueta
  static TextStyle get label => bodyFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    height: 1.3,
  );

  /// 🎮 Estadísticas y números
  static TextStyle get statistics => numericFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// 🎯 Número destacado
  static TextStyle get featuredNumber => numericFont.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.1,
  );

  // 🔧 MÉTODOS HELPER PARA APLICAR COLORES Y TEMA

  /// Aplicar color primario al estilo
  static TextStyle withPrimary(TextStyle style, BuildContext context) {
    return style.copyWith(color: Theme.of(context).colorScheme.primary);
  }

  /// Aplicar color secundario al estilo
  static TextStyle withSecondary(TextStyle style, BuildContext context) {
    return style.copyWith(color: Theme.of(context).colorScheme.secondary);
  }

  /// Aplicar color de superficie al estilo
  static TextStyle withOnSurface(TextStyle style, BuildContext context) {
    return style.copyWith(color: Theme.of(context).colorScheme.onSurface);
  }

  /// Aplicar color de error al estilo
  static TextStyle withError(TextStyle style, BuildContext context) {
    return style.copyWith(color: Theme.of(context).colorScheme.error);
  }

  /// Aplicar sombra al texto para efectos especiales
  static TextStyle withShadow(TextStyle style, {
    Color shadowColor = Colors.black26,
    double blurRadius = 4.0,
    Offset offset = const Offset(0, 2),
  }) {
    return style.copyWith(
      shadows: [
        Shadow(
          color: shadowColor,
          blurRadius: blurRadius,
          offset: offset,
        ),
      ],
    );
  }

  /// Aplicar degradado al texto (usando painting)
  static TextStyle withGradient(TextStyle style, Gradient gradient) {
    // Para gradientes, se recomienda usar ShaderMask o TextPainter
    return style;
  }

  // 🎯 CONFIGURACIONES ESPECÍFICAS DE RITMO

  /// Estilo para elementos de hábito/ritmo
  static TextStyle get ritmoCardTitle => brandFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
  );

  /// Estilo para rachas y contadores
  static TextStyle get streakCounter => numericFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.1,
  );

  /// Estilo para logros y achievements
  static TextStyle get achievementTitle => brandFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    height: 1.3,
  );

  /// Estilo para botones principales
  static TextStyle get primaryButton => brandFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );

  /// Estilo para navegación y tabs
  static TextStyle get navigation => bodyFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.2,
  );
}

/// 🎨 Extension para aplicar estilos de RITMO fácilmente en widgets Text
extension RitmoTextExtensions on Text {

  /// Aplicar estilo de marca principal
  Text get asBrandTitle => Text(
    data!,
    key: key,
    style: RitmoTypography.screenTitle.merge(style),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler ?? TextScaler.noScaling,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );

  /// Aplicar estilo de estadística
  Text get asStatistic => Text(
    data!,
    key: key,
    style: RitmoTypography.statistics.merge(style),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler ?? TextScaler.noScaling,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );

  /// Aplicar estilo de racha
  Text get asStreak => Text(
    data!,
    key: key,
    style: RitmoTypography.streakCounter.merge(style),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler ?? TextScaler.noScaling,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
}