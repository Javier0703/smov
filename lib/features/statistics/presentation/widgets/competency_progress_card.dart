import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../data/models/student_activity_model.dart';

/// Tarjeta de progreso por bloques competenciales en `Mi actividad`.
class CompetencyProgressCard extends StatelessWidget {
  const CompetencyProgressCard({super.key, required this.competencies});

  final List<CompetencyStatBar> competencies;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dominio por bloque geográfico',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final comp in competencies) ...[
            _CompetencyBarRow(item: comp),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _CompetencyBarRow extends StatelessWidget {
  const _CompetencyBarRow({required this.item});

  final CompetencyStatBar item;

  @override
  Widget build(BuildContext context) {
    final ratio = (item.percentage / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.inkStrong,
                ),
              ),
            ),
            Text(
              Formatters.percentage(item.percentage),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          item.subtitle,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.brandAccent,
            ),
          ),
        ),
      ],
    );
  }
}
