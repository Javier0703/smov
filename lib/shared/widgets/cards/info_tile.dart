import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'app_base_card.dart';

/// Tarjeta compacta de métrica o dato informativo (ej. "7 Piezas de mapa", "5 Insignias").
class InfoTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? accentColor;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = accentColor ?? AppColors.primary;

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      borderRadius: AppRadius.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xxs,
        children: <Widget>[
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: effectiveColor),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
