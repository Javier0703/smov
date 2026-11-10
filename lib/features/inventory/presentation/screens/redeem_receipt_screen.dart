import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../data/models/inventory_item_model.dart';

/// Pantalla de comprobante post-canje `¡Lupa en tu mochila!`.
class RedeemReceiptScreen extends StatelessWidget {
  const RedeemReceiptScreen({
    super.key,
    required this.receipt,
    required this.onGoToAdventures,
    required this.onBackToInventory,
  });

  final RedeemReceiptModel receipt;
  final VoidCallback onGoToAdventures;
  final VoidCallback onBackToInventory;

  @override
  Widget build(BuildContext context) {
    final item = receipt.item;

    return AdventureScaffold(
      topBar: AppTopBar(
        title: '¡${item.name} en tu mochila!',
        subtitle: 'Comprobante de canje completado',
        coins: receipt.remainingCoins,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBaseCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              borderColor: AppColors.success,
              child: Column(
                children: [
                  const StatusBadge(
                    label: 'CANJE COMPLETADO',
                    variant: StatusBadgeVariant.success,
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.brandPrimary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '¡${item.name} añadida a tu mochila!',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Ahora tienes ${receipt.newOwnedCount} unidad(es) de ${item.name} listas para usar durante cualquier prueba.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    child: Text(
                      'Saldo restante: ${receipt.remainingCoins} monedas',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: 'Ir a jugar para usar mi ayuda',
              icon: Icons.play_arrow_rounded,
              onPressed: onGoToAdventures,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppSecondaryButton(
              label: 'Volver a Mi mochila',
              icon: Icons.backpack_outlined,
              onPressed: onBackToInventory,
            ),
          ],
        ),
      ),
    );
  }
}
