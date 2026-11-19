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
    required this.canRedeem,
    required this.hasRequiredMedal,
    required this.onRedeemPressed,
  });

  final InventoryItemModel item;
  final int userCoins;
  final bool canRedeem;
  final bool hasRequiredMedal;
  final VoidCallback onRedeemPressed;

  @override
  Widget build(BuildContext context) {
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
                      'Coste: ${item.costCoins} Brújulas',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: item.isOwned
                    ? 'Desbloqueado'
                    : item.category == InventoryItemCategory.aid
                    ? 'En mochila: ${item.ownedCount}'
                    : item.categoryLabel.toUpperCase(),
                variant: item.isOwned
                    ? StatusBadgeVariant.success
                    : StatusBadgeVariant.neutral,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (item.requiredMedalNumber != null) ...[
            StatusBadge(
              label: hasRequiredMedal
                  ? 'Medalla ${item.requiredMedalNumber} conseguida'
                  : 'Requiere medalla ${item.requiredMedalNumber}',
              variant: hasRequiredMedal
                  ? StatusBadgeVariant.success
                  : StatusBadgeVariant.warning,
              icon: Icons.emoji_events_rounded,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            item.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: item.isOwned
                ? 'Ya lo tienes'
                : !hasRequiredMedal
                ? 'Consigue la medalla ${item.requiredMedalNumber}'
                : item.canAfford(userCoins)
                ? 'Comprar por ${item.costCoins} Brújulas'
                : 'Te faltan $missing Brújulas',
            icon: item.isOwned
                ? Icons.check_circle_outline_rounded
                : canRedeem
                ? Icons.shopping_bag_outlined
                : Icons.lock_clock_rounded,
            onPressed: canRedeem ? onRedeemPressed : null,
          ),
        ],
      ),
    );
  }
}
