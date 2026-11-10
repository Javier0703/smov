import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';

/// Tarjeta `SIGUIENTE MISIÓN` en `Inicio — Pasaporte y progreso`.
class NextMissionCard extends StatelessWidget {
  const NextMissionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onContinuePressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceElevated,
      borderColor: AppColors.brandPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusBadge(
            label: AppStrings.homeNextMissionBadge,
            variant: StatusBadgeVariant.brand,
            icon: Icons.flag_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: AppStrings.homeContinueButton,
            icon: Icons.play_arrow_rounded,
            onPressed: onContinuePressed,
          ),
        ],
      ),
    );
  }
}
