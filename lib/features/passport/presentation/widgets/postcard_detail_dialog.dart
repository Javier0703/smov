import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../data/models/passport_entry_model.dart';

/// Diálogo de lectura de postal cultural en `Mi pasaporte`.
class PostcardDetailDialog extends StatelessWidget {
  const PostcardDetailDialog({
    super.key,
    required this.entry,
    required this.onTravelNow,
  });

  final PassportEntryModel entry;
  final VoidCallback onTravelNow;

  @override
  Widget build(BuildContext context) {
    final region = entry.region;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  StatusBadge(
                    label: entry.isStamped
                        ? 'SELLO OFICIAL CONSEGUIDO'
                        : 'PENDIENTE DE VISITAR',
                    variant: entry.isStamped
                        ? StatusBadgeVariant.success
                        : StatusBadgeVariant.warning,
                    icon: entry.isStamped
                        ? Icons.verified_rounded
                        : Icons.lock_clock_rounded,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                region.name,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.brandPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Capital / sede: ${region.capital}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.markunread_mailbox_rounded,
                          color: AppColors.brandPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Postal de expedición (${region.shortLabel})',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.brandPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      region.curiosity.isNotEmpty
                          ? region.curiosity
                          : 'Territorio histórico de la geografía española.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.inkStrong,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!entry.isStamped)
                AppPrimaryButton(
                  label: 'Viajar ahora en El viaje por España',
                  icon: Icons.route_rounded,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onTravelNow();
                  },
                )
              else
                AppPrimaryButton(
                  label: 'Cerrar postal',
                  icon: Icons.check_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
