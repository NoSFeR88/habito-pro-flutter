import 'package:flutter/material.dart';
import 'design_constants.dart';

/// Touch target helpers for WCAG AA compliance (48x48dp minimum)
/// Material 3 Guidelines: https://m3.material.io/foundations/accessible-design/accessibility-basics
class TouchTargets {
  /// IconButton with guaranteed 48x48dp touch target
  static Widget iconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    double iconSize = DesignConstants.iconButtonSize,
    Color? color,
    String? tooltip,
    String? semanticLabel,
  }) {
    final button = SizedBox(
      width: DesignConstants.minTouchTarget,
      height: DesignConstants.minTouchTarget,
      child: IconButton(
        iconSize: iconSize,
        icon: Icon(icon),
        color: color,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );

    // Si hay semanticLabel, agregar Semantics
    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        button: true,
        enabled: onPressed != null,
        child: ExcludeSemantics(child: button),
      );
    }

    return button;
  }

  /// IconButton with explicit constraints (alternative approach)
  static Widget iconButtonConstrained({
    required IconData icon,
    required VoidCallback? onPressed,
    double iconSize = DesignConstants.iconButtonSize,
    Color? color,
    String? tooltip,
  }) {
    return IconButton(
      iconSize: iconSize,
      icon: Icon(icon),
      color: color,
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: DesignConstants.minTouchTarget,
        minHeight: DesignConstants.minTouchTarget,
      ),
      onPressed: onPressed,
    );
  }

  /// Custom button with guaranteed touch target
  static Widget customButton({
    required Widget child,
    required VoidCallback? onPressed,
    double minWidth = DesignConstants.minTouchTarget,
    double minHeight = DesignConstants.minTouchTarget,
  }) {
    return SizedBox(
      width: minWidth,
      height: minHeight,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusSmall),
        child: Center(child: child),
      ),
    );
  }

  /// Validates if a size meets minimum touch target
  static bool meetsMinimumSize(Size size) {
    return size.width >= DesignConstants.minTouchTarget &&
        size.height >= DesignConstants.minTouchTarget;
  }
}
