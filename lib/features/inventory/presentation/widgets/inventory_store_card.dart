import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../data/models/inventory_item_model.dart';

/// Tarjeta de objeto en `Mi mochila`.
class InventoryStoreCard extends StatelessWidget {
  const InventoryStoreCard({
    super.key,
    required this.item,
    required this.userCoins,
    required this.onRedeemPressed,
  });

  final InventoryItemModel item;
  final int userCoins;
  final VoidCallback onRedeemPressed;

  @override
  Widget build(BuildContext context) {
    final canAfford = item.canAfford(userCoins);
    final missing = item.missingCoins(userCoins);

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brandAccent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(item.icon, color: AppColors.brandPrimary, size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.inkStrong,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Coste: ${item.costCoins} monedas',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: 'En mochila: ${item.ownedCount}',
                variant: item.ownedCount > 0
                    ? StatusBadgeVariant.success
                    : StatusBadgeVariant.neutral,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: canAfford
                ? 'Canjear por ${item.costCoins} monedas'
                : 'Te faltan $missing monedas',
            icon: canAfford
                ? Icons.shopping_bag_outlined
                : Icons.lock_clock_rounded,
            onPressed: canAfford ? onRedeemPressed : null,
          ),
        ],
      ),
    );
  }
}
