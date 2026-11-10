import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';

/// Tarjeta de `Sellos de orientación` (`N`, `E`, `S`, `O`) en `Inicio — Pasaporte y progreso`.
class OrientationStampsCard extends StatelessWidget {
  const OrientationStampsCard({super.key, required this.unlockedStamps});

  final Set<String> unlockedStamps;

  static const List<String> _directions = <String>['N', 'E', 'S', 'O'];

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeOrientationStampsTitle,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.brandPrimary,
                ),
              ),
              Text(
                '${unlockedStamps.length} / 4 rumbos',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _directions
                .map(
                  (code) => _DirectionStampBadge(
                    code: code,
                    unlocked: unlockedStamps.contains(code),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DirectionStampBadge extends StatelessWidget {
  const _DirectionStampBadge({required this.code, required this.unlocked});

  final String code;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Sello punto cardinal $code ${unlocked ? 'conseguido' : 'pendiente'}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: unlocked
                  ? AppColors.brandAccent.withValues(alpha: 0.22)
                  : AppColors.surfaceMuted,
              shape: BoxShape.circle,
              border: Border.all(
                color: unlocked
                    ? AppColors.brandPrimary
                    : AppColors.borderDefault,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              code,
              style: AppTypography.titleMedium.copyWith(
                color: unlocked ? AppColors.brandPrimary : AppColors.textMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            unlocked
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            size: 16,
            color: unlocked ? AppColors.success : AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
