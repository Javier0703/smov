import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../data/models/inventory_item_model.dart';
import '../viewmodels/inventory_viewmodel.dart';
import '../widgets/inventory_store_card.dart';

/// Pantalla `Mi mochila` (`/inventory`).
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
    required this.onSelectRedeemItem,
  });

  final InventoryViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;
  final ValueChanged<InventoryItemModel> onSelectRedeemItem;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final user = viewModel.currentUser;
        final items = viewModel.items;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.inventoryScreenTitle,
            subtitle: AppStrings.inventoryScreenSubtitle,
            coins: user.coins,
          ),
          drawer: AppDrawer(
            user: user,
            currentRoute: '/inventory',
            onNavigate: onNavigateRoute,
            onSwitchRole: () => onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 4,
            onTap: (index) {
              switch (index) {
                case 0:
                  onNavigateRoute('/home');
                case 1:
                  onNavigateRoute('/adventures');
                case 2:
                  onNavigateRoute('/passport');
                case 3:
                  onNavigateRoute('/medals');
                case 4:
                  onNavigateRoute('/inventory');
              }
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CoinsBalanceHeaderCard(coins: user.coins),
                const SizedBox(height: AppSpacing.md),
                for (final item in items) ...[
                  InventoryStoreCard(
                    item: item,
                    userCoins: user.coins,
                    onRedeemPressed: () => onSelectRedeemItem(item),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CoinsBalanceHeaderCard extends StatelessWidget {
  const _CoinsBalanceHeaderCard({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D6),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: Color(0xFFD97706),
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'ECONOMÍA DE EXPEDICIÓN',
                  variant: StatusBadgeVariant.brand,
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.coinsWithLabel(coins),
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                Text(
                  'Gana +40 monedas por nivel superado y +300 en El gran reto.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
