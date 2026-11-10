import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../data/models/adventure_game_model.dart';

/// Tarjeta de un juego dentro del catálogo `Elige tu aventura`.
class AdventureCatalogCard extends StatelessWidget {
  const AdventureCatalogCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  final AdventureGameModel game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = game.completedLevelsCount;
    final enabled = game.enabledLevelsCount;

    return AppBaseCard(
      onTap: onTap,
      backgroundColor: AppColors.surfaceElevated,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: game.tintColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: AppColors.brandPrimary.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  game.orderNumber.toString().padLeft(2, '0'),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Icon(game.icon, size: 22, color: AppColors.brandPrimary),
              ],
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
                  children: [
                    StatusBadge(
                      label: game.competencyTag,
                      variant: StatusBadgeVariant.brand,
                    ),
                    StatusBadge(
                      label: '$completed/$enabled niveles',
                      variant: completed > 0
                          ? StatusBadgeVariant.success
                          : StatusBadgeVariant.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  game.title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.inkStrong,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  game.shortDescription,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 15,
                      color: AppColors.brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Logro: ${game.achievementTitle}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Elegir nivel',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.brandPrimary,
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
