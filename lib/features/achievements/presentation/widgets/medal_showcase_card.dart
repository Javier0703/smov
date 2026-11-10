import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/vector/medal_badge_widget.dart';
import '../../data/models/medal_item_model.dart';

/// Tarjeta de insignia en `Mi medallero`.
class MedalShowcaseCard extends StatelessWidget {
  const MedalShowcaseCard({
    super.key,
    required this.medal,
    required this.onTapPractice,
  });

  final MedalItemModel medal;
  final VoidCallback onTapPractice;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      onTap: onTapPractice,
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: medal.isUnlocked ? Colors.white : AppColors.surfaceMuted,
      child: Row(
        children: [
          MedalBadgeWidget(
            type: medal.type,
            unlocked: medal.isUnlocked,
            size: 64,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        medal.type.title,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.inkStrong,
                        ),
                      ),
                    ),
                    StatusBadge(
                      label: medal.isUnlocked ? 'Conseguida' : 'Pendiente',
                      variant: medal.isUnlocked
                          ? StatusBadgeVariant.success
                          : StatusBadgeVariant.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  medal.subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}
