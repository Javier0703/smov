import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Tonos de acción del botón principal según guía de componentes de Figma.
enum AppButtonTone { navy, successGreen, mint }

/// Botón de acción principal configurable con tono, etiqueta e icono (mínimo 48dp táctil).
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? icon;
  final AppButtonTone tone;
  final bool isLoading;
  final bool expand;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.icon,
    this.tone = AppButtonTone.navy,
    this.isLoading = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? leadingIcon;
    final Color bgColor;
    final Color fgColor;
    final BorderSide borderSide;

    switch (tone) {
      case AppButtonTone.successGreen:
        bgColor = AppColors.success;
        fgColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.4);
      case AppButtonTone.mint:
        bgColor = AppColors.secondary;
        fgColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.4);
      case AppButtonTone.navy:
        bgColor = AppColors.primary;
        fgColor = AppColors.textOnPrimary;
        borderSide = BorderSide.none;
    }

    final buttonChild = Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 54,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            disabledBackgroundColor: AppColors.borderDefault,
            disabledForegroundColor: AppColors.textSecondary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusLg),
              side: onPressed == null ? BorderSide.none : borderSide,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: fgColor,
                  ),
                )
              : _PrimaryButtonContent(
                  label: label,
                  leadingIcon: effectiveIcon,
                  foregroundColor: fgColor,
                ),
        ),
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: buttonChild);
    }
    return buttonChild;
  }
}

class _PrimaryButtonContent extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final Color foregroundColor;

  const _PrimaryButtonContent({
    required this.label,
    required this.leadingIcon,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (leadingIcon == null) {
      return Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: foregroundColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.sm,
      children: <Widget>[
        Icon(leadingIcon, size: 22, color: foregroundColor),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
