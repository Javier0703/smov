import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../buttons/app_primary_button.dart';
import '../cards/app_base_card.dart';

/// Estado visual vacío estandarizado (ej. «Todavía no hay actividad» o «Tu mochila está vacía»).
class AppEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.explore_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppBaseCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: <Widget>[
              Icon(icon, size: 42, color: AppColors.secondary),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (actionLabel != null && onAction != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: AppPrimaryButton(
                    label: actionLabel!,
                    onPressed: onAction,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
