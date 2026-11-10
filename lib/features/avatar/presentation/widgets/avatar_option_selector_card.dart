import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';

/// Opción seleccionable dentro de una categoría del editor de avatar.
class AvatarChoiceItem<T> {
  const AvatarChoiceItem({
    required this.value,
    required this.label,
    this.swatchColor,
    this.icon,
  });

  final T value;
  final String label;
  final Color? swatchColor;
  final IconData? icon;
}

/// Tarjeta reutilizable de selección de rasgo o prenda para `Tu personaje, a tu manera`.
class AvatarOptionSelectorCard<T> extends StatelessWidget {
  const AvatarOptionSelectorCard({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final List<AvatarChoiceItem<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: options
                .map(
                  (option) => _AvatarChoiceChipButton<T>(
                    option: option,
                    isSelected: option.value == selectedValue,
                    onTap: () => onSelected(option.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AvatarChoiceChipButton<T> extends StatelessWidget {
  const _AvatarChoiceChipButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final AvatarChoiceItem<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: option.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.brandPrimary
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: isSelected
                    ? AppColors.brandPrimary
                    : AppColors.borderDefault,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.swatchColor != null) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: option.swatchColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ] else if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.brandPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  option.label,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.inkStrong,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
