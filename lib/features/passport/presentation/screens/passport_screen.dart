import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../../../../shared/widgets/vector/stamp_postal_card_widget.dart';
import '../../data/models/passport_entry_model.dart';
import '../viewmodels/passport_viewmodel.dart';
import '../widgets/postcard_detail_dialog.dart';

/// Pantalla `Mi pasaporte` (`/passport`) con mapa y 17 sellos/postales autonómicos.
class PassportScreen extends StatelessWidget {
  const PassportScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
    required this.onOpenTravelGame,
  });

  final PassportViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;
  final VoidCallback onOpenTravelGame;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final user = viewModel.currentUser;
        final entries = viewModel.entries;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.passportScreenTitle,
            subtitle: AppStrings.passportScreenSubtitle,
            coins: user.coins,
            onCoinsTap: () => onNavigateRoute('/inventory'),
          ),
          drawer: AppDrawer(
            user: user,
            currentRoute: '/passport',
            onNavigate: onNavigateRoute,
            onSwitchRole: () => onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 2,
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
                _PassportMapHeaderCard(
                  stampedCount: viewModel.stampedCount,
                  totalCount: entries.length,
                  stampedIds: viewModel.stampedIds,
                  selectedRegionId: viewModel.selectedRegionId,
                  onRegionTap: (region) {
                    viewModel.selectRegion(region.id);
                    final entry = entries
                        .where((e) => e.region.id == region.id)
                        .firstOrNull;
                    if (entry != null) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => PostcardDetailDialog(
                          entry: entry,
                          onTravelNow: onOpenTravelGame,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Sellos y postales por comunidad autónoma',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _PassportStampsGrid(
                  entries: entries,
                  onEntryTap: (entry) {
                    viewModel.selectRegion(entry.region.id);
                    showDialog<void>(
                      context: context,
                      builder: (_) => PostcardDetailDialog(
                        entry: entry,
                        onTravelNow: onOpenTravelGame,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PassportMapHeaderCard extends StatelessWidget {
  const _PassportMapHeaderCard({
    required this.stampedCount,
    required this.totalCount,
    required this.stampedIds,
    required this.selectedRegionId,
    required this.onRegionTap,
  });

  final int stampedCount;
  final int totalCount;
  final Set<String> stampedIds;
  final String? selectedRegionId;
  final ValueChanged<SpainMapRegion> onRegionTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(
                label: 'PASAPORTE AUTONÓMICO',
                variant: StatusBadgeVariant.brand,
                icon: Icons.verified_rounded,
              ),
              const Spacer(),
              Text(
                '$stampedCount / $totalCount sellos',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SpainVectorMapWidget(
            completedRegionIds: stampedIds,
            selectedRegionId: selectedRegionId,
            onRegionTap: onRegionTap,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Toca cualquier comunidad en el mapa o en las tarjetas para leer su postal cultural.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _PassportStampsGrid extends StatelessWidget {
  const _PassportStampsGrid({required this.entries, required this.onEntryTap});

  final List<PassportEntryModel> entries;
  final ValueChanged<PassportEntryModel> onEntryTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 680 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return StampPostalCardWidget(
              communityName: entry.region.name,
              capital: entry.region.capital,
              shortCode: entry.region.shortLabel,
              stamped: entry.isStamped,
              onTap: () => onEntryTap(entry),
            );
          },
        );
      },
    );
  }
}
