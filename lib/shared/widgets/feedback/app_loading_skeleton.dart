import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Estado visual de carga coherente con el diseño de Brújula Quest (Especificación 05).
class AppLoadingSkeleton extends StatelessWidget {
  final String message;

  const AppLoadingSkeleton({
    super.key,
    this.message = 'Preparando tu mapa de exploración...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: <Widget>[
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: AppColors.secondary,
                strokeWidth: 3.5,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
