import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/feedback/app_empty_state.dart';
import '../../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../data/models/adventure_game_model.dart';
import '../viewmodels/adventures_viewmodel.dart';
import '../widgets/adventure_catalog_card.dart';

/// Pantalla `Elige tu aventura` (`/adventures`).
class AdventuresCatalogScreen extends StatelessWidget {
  const AdventuresCatalogScreen({
    super.key,
    required this.viewModel,
    required this.onSelectGame,
    required this.onNavigateRoute,
  });

  final AdventuresViewModel viewModel;
  final ValueChanged<AdventureGameModel> onSelectGame;
  final ValueChanged<String> onNavigateRoute;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final user = viewModel.currentUser;
        final games = viewModel.games;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.adventuresScreenTitle,
            subtitle: AppStrings.adventuresScreenTag,
            coins: user.coins,
            onCoinsTap: () => onNavigateRoute('/inventory'),
          ),
          drawer: AppDrawer(
            user: user,
            currentRoute: '/adventures',
            onNavigate: onNavigateRoute,
            onSwitchRole: () => onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 1,
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const StatusBadge(
                          label: AppStrings.adventuresScreenTag,
                          variant: StatusBadgeVariant.brand,
                          icon: Icons.compass_calibration_rounded,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        StatusBadge(
                          label: 'Clase ${user.classId}',
                          variant: StatusBadgeVariant.neutral,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppStrings.adventuresScreenSubtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppSearchBar(
                      hintText: 'Buscar aventura por nombre o competencia...',
                      onChanged: viewModel.updateSearchQuery,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: games.isEmpty
                    ? const AppEmptyState(
                        title: 'Sin aventuras que coincidan',
                        subtitle: 'Prueba con otro término de búsqueda como "brújula" o "España".',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: games.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return AdventureCatalogCard(
                            game: game,
                            onTap: () => onSelectGame(game),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
