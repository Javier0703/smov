import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/feedback/app_error_view.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../data/models/inventory_item_model.dart';
import '../viewmodels/inventory_viewmodel.dart';

/// Pantalla `¿Canjear una lupa?` (`/inventory/redeem/:itemId`).
class RedeemConfirmScreen extends StatelessWidget {
  const RedeemConfirmScreen({
    super.key,
    required this.itemId,
    required this.viewModel,
    required this.onCancel,
    required this.onRedeemSuccess,
  });

  final String itemId;
  final InventoryViewModel viewModel;
  final VoidCallback onCancel;
  final ValueChanged<RedeemReceiptModel> onRedeemSuccess;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final item = viewModel.findItem(itemId);
        if (item == null) {
          return Scaffold(
            body: AppErrorView(
              message: 'No se encontró la ayuda seleccionada ($itemId).',
              onRetry: onCancel,
            ),
          );
        }

        final currentCoins = viewModel.coinsBalance;
        final canAfford = item.canAfford(currentCoins);
        final projectedCoins = currentCoins - item.costCoins;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: '¿Canjear una ${item.shortName}?',
            subtitle: 'Confirmación de canje en tu mochila',
            showBackButton: true,
            onBackPressed: onCancel,
            coins: currentCoins,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBaseCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusBadge(
                        label: 'RESUMEN DEL CANJE',
                        variant: StatusBadgeVariant.brand,
                        icon: Icons.receipt_long_rounded,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.brandAccent.withValues(
                                alpha: 0.22,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                            ),
                            child: Icon(
                              item.icon,
                              color: AppColors.brandPrimary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: AppTypography.headlineSmall.copyWith(
                                    color: AppColors.brandPrimary,
                                  ),
                                ),
                                Text(
                                  'Actualmente tienes ${item.ownedCount} en tu mochila.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        item.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.inkStrong,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _AccountingRow(
                        label: 'Saldo actual en mochila',
                        value: '$currentCoins monedas',
                      ),
                      const Divider(height: AppSpacing.md),
                      _AccountingRow(
                        label: 'Coste de ${item.name}',
                        value: '-${item.costCoins} monedas',
                        isNegative: true,
                      ),
                      const Divider(height: AppSpacing.md),
                      _AccountingRow(
                        label: 'Saldo restante tras el canje',
                        value: '$projectedCoins monedas',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: canAfford
                      ? 'Confirmar canje (-${item.costCoins} monedas)'
                      : 'Saldo insuficiente',
                  icon: Icons.check_circle_rounded,
                  isLoading: viewModel.isRedeeming,
                  onPressed: canAfford
                      ? () async {
                          final receipt = await viewModel.confirmRedeem(
                            item.id,
                          );
                          if (receipt != null) {
                            onRedeemSuccess(receipt);
                          }
                        }
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppSecondaryButton(
                  label: 'Cancelar y volver a Mi mochila',
                  icon: Icons.arrow_back_rounded,
                  onPressed: onCancel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountingRow extends StatelessWidget {
  const _AccountingRow({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isNegative;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.titleSmall.copyWith(color: AppColors.inkStrong)
              : AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: isNegative ? AppColors.danger : AppColors.brandPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
