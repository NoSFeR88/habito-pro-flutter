import 'package:flutter/material.dart';

// Paleta principal basada en tendencias 2024-2025
class AppColors {
  // Primarios - Coincide con imagen de referencia
  static const Color primary = Color(0xFF8B5CF6); // Púrpura (Total en la imagen)
  static const Color primaryLight = Color(0xFFA78BFA); // Púrpura claro
  static const Color primaryDark = Color(0xFF7C3AED); // Púrpura profundo

  // Secundarios - Sistema complementario moderno
  static const Color secondary = Color(0xFF06B6D4); // Cyan moderno
  static const Color accent = Color(0xFFEC4899); // Rosa vibrante

  // Funcionales - Colores exactos de la imagen
  static const Color success = Color(0xFF10B981); // Verde esmeralda (Completados)
  static const Color warning = Color(0xFFF59E0B); // Ámbar (Racha)
  static const Color error = Color(0xFFEF4444); // Rojo coral

  // Neutros - Base sofisticada 2024 (coincide con imagen de referencia)
  static const Color background = Color(0xFFFAFAFA); // Gris cálido
  static const Color backgroundDark = Color(0xFF2D2B42); // Azul oscuro de la imagen
  static const Color surface = Color(0xFFFFFFFF); // Blanco puro
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Gris muy claro
  static const Color surfaceDark = Color(0xFF3A3A5C); // Gris azulado de los contenedores de la imagen
  static const Color text = Color(0xFF111827); // Casi negro
  static const Color textSecondary = Color(0xFF6B7280); // Gris medio
  static const Color textDark = Color(0xFFF8FAFC); // Blanco cálido
  static const Color textSecondaryDark = Color(0xFFCBD5E1); // Gris claro
}

// TODO: Implementar múltiples themes para selección de usuario
// Themes futuros planeados:
// - Ocean Theme (azules y verdes oceánicos)
// - Sunset Theme (naranjas y rosas cálidos)
// - Forest Theme (verdes naturales)
// - Monochrome Theme (escala de grises premium)
// - Gaming Theme (neones vibrantes estilo Habitica)

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      surfaceContainerHigh: Color(0xFFF5F5F5), // Nivel intermedio alto
      surfaceContainer: Color(0xFFEFEFEF), // Nivel intermedio
      surfaceContainerLow: Color(0xFFE8E8E8), // Nivel bajo
      surfaceContainerLowest: Color(0xFFE0E0E0), // Nivel más bajo
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.text,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 4,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surfaceDark,
      surfaceContainerHighest: Color(0xFF4A4A6C), // Nivel más alto (más claro)
      surfaceContainerHigh: Color(0xFF444465), // Nivel intermedio alto
      surfaceContainer: Color(0xFF3E3E5E), // Nivel intermedio
      surfaceContainerLow: Color(0xFF383857), // Nivel bajo
      surfaceContainerLowest: Color(0xFF323250), // Nivel más bajo (más oscuro)
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: AppColors.primary.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}