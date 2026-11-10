import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../data/models/adventure_game_model.dart';

/// Tarjeta seleccionable de nivel en `Elige tu nivel` y `España en tus manos`.
class LevelOptionCard extends StatelessWidget {
  const LevelOptionCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onSelect,
  });

  final AdventureLevelInfo level;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final canPlay = level.canPlay;

    return AppBaseCard(
      onTap: onSelect,
      backgroundColor: !canPlay
          ? AppColors.surfaceMuted.withValues(alpha: 0.7)
          : (isSelected ? AppColors.surfaceElevated : Colors.white),
      borderColor: isSelected
          ? AppColors.brandPrimary
          : AppColors.borderDefault,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: !canPlay
                  ? AppColors.borderDefault
                  : (isSelected
                        ? AppColors.brandPrimary
                        : AppColors.surfaceMuted),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: !canPlay
                ? const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                  )
                : Text(
                    level.codeLabel,
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.brandPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      level.categoryTag,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    StatusBadge(
                      label: level.statusLabel,
                      variant: !level.isEnabledByTeacher
                          ? StatusBadgeVariant.danger
                          : (level.isCompleted
                                ? StatusBadgeVariant.success
                                : (canPlay
                                      ? StatusBadgeVariant.brand
                                      : StatusBadgeVariant.neutral)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  level.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: canPlay ? AppColors.inkStrong : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  level.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_rounded,
                      size: 15,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${level.rewardCoins} monedas al superar',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
