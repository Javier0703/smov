import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Variantes semánticas de etiqueta de estado.
enum StatusBadgeVariant { brand, success, warning, danger, neutral }

/// Etiqueta de estado tipo píldora (CONSEGUIDA, PENDIENTE, NIVEL 3, 1 / 4).
class StatusBadge extends StatelessWidget {
  final String? text;
  final String? label;
  final StatusBadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    this.text,
    this.label,
    this.variant = StatusBadgeVariant.brand,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final display = label ?? text ?? '';
    final (defaultBg, defaultFg) = switch (variant) {
      StatusBadgeVariant.brand => (
        AppColors.brandAccent.withValues(alpha: 0.20),
        AppColors.brandPrimary,
      ),
      StatusBadgeVariant.success => (
        AppColors.successSurface,
        const Color(0xFF157A34),
      ),
      StatusBadgeVariant.warning => (
        AppColors.warningSurface,
        const Color(0xFFB45309),
      ),
      StatusBadgeVariant.danger => (AppColors.errorSurface, AppColors.danger),
      StatusBadgeVariant.neutral => (
        AppColors.surfaceVariant,
        AppColors.textSecondary,
      ),
    };

    final bg = backgroundColor ?? defaultBg;
    final fg = textColor ?? defaultFg;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: <Widget>[
          if (icon != null) Icon(icon, size: 15, color: fg),
          Flexible(
            child: Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
