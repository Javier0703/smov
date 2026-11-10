import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Botón secundario con borde o estilo píldora seleccionable (usado en opciones de juego y filtros).
class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? icon;
  final bool isSelected;
  final bool expand;

  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.icon,
    this.isSelected = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? leadingIcon;
    final bgColor = isSelected ? AppColors.secondary : AppColors.surface;
    final borderColor = isSelected
        ? AppColors.primary
        : AppColors.borderDefault;

    final button = Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.minTouchTarget,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: AppColors.primary,
            side: BorderSide(color: borderColor, width: isSelected ? 2.0 : 1.2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            ),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.xs,
            children: <Widget>[
              if (effectiveIcon != null)
                Icon(effectiveIcon, size: 18, color: AppColors.primary),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
