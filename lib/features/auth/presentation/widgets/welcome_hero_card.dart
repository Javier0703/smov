import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';

/// Tarjeta heroica de bienvenida con vista previa del personaje explorador y selector de aula.
class WelcomeHeroCard extends StatelessWidget {
  const WelcomeHeroCard({
    super.key,
    required this.avatarConfig,
    required this.selectedClassId,
    required this.availableClasses,
    required this.onClassSelected,
    required this.onCustomizeAvatarTap,
  });

  final AvatarConfig avatarConfig;
  final String selectedClassId;
  final List<String> availableClasses;
  final ValueChanged<String> onClassSelected;
  final VoidCallback onCustomizeAvatarTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(
                label: AppStrings.appBrandTag,
                variant: StatusBadgeVariant.brand,
                icon: Icons.explore_rounded,
              ),
              const Spacer(),
              _ClassSelectorPill(
                selectedClassId: selectedClassId,
                availableClasses: availableClasses,
                onClassSelected: onClassSelected,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.welcomeSubtitle,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.welcomeDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              children: [
                ExplorerAvatarWidget(
                  config: avatarConfig,
                  size: 84,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explorador Alex · $selectedClassId',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.inkStrong,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Brújula lista · 10 misiones geográficas y pasaporte de comunidades autónomas.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: onCustomizeAvatarTap,
                          icon: const Icon(Icons.checkroom_rounded, size: 18),
                          label: const Text('Personalizar'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.brandPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xxs,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassSelectorPill extends StatelessWidget {
  const _ClassSelectorPill({
    required this.selectedClassId,
    required this.availableClasses,
    required this.onClassSelected,
  });

  final String selectedClassId;
  final List<String> availableClasses;
  final ValueChanged<String> onClassSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Seleccionar clase',
      onSelected: onClassSelected,
      itemBuilder: (context) => availableClasses
          .map((c) => PopupMenuItem<String>(value: c, child: Text('Clase $c')))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.school_rounded,
              size: 16,
              color: AppColors.brandPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              selectedClassId,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.brandPrimary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: AppColors.brandPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
