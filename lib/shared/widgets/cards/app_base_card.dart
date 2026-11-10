import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';

/// Contenedor de tarjeta base reutilizable basado en los tokens de Figma.
class AppBaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasShadow;

  const AppBaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.backgroundColor = AppColors.cardBackground,
    this.borderColor = AppColors.borderDefault,
    this.borderWidth = 1.2,
    this.borderRadius = AppRadius.radiusXl,
    this.onTap,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null
          ? Border.all(color: borderColor!, width: borderWidth)
          : null,
      boxShadow: hasShadow ? AppShadows.cardShadow : null,
    );

    if (onTap == null) {
      return Container(decoration: decoration, padding: padding, child: child);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(decoration: decoration, padding: padding, child: child),
      ),
    );
  }
}
