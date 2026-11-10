import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../viewmodels/achievements_viewmodel.dart';
import '../widgets/medal_showcase_card.dart';

/// Pantalla `Mi medallero` (`/medals`).
class MedalsScreen extends StatelessWidget {
  const MedalsScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
    required this.onOpenGame,
  });

  final AchievementsViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;
  final ValueChanged<String> onOpenGame;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final user = viewModel.currentUser;
        final medals = viewModel.medals;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.medalsScreenTitle,
            subtitle: AppStrings.medalsScreenSubtitle,
            coins: user.coins,
            onCoinsTap: () => onNavigateRoute('/inventory'),
          ),
          drawer: AppDrawer(
            user: user,
            currentRoute: '/medals',
            onNavigate: onNavigateRoute,
            onSwitchRole: () => onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 3,
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
                _MedalsProgressSummaryCard(
                  unlockedCount: viewModel.unlockedCount,
                  totalCount: medals.length,
                  coins: user.coins,
                  onRedeemCoinsTap: () => onNavigateRoute('/inventory'),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final medal in medals) ...[
                  MedalShowcaseCard(
                    medal: medal,
                    onTapPractice: () => onOpenGame(medal.relatedGameId),
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

class _MedalsProgressSummaryCard extends StatelessWidget {
  const _MedalsProgressSummaryCard({
    required this.unlockedCount,
    required this.totalCount,
    required this.coins,
    required this.onRedeemCoinsTap,
  });

  final int unlockedCount;
  final int totalCount;
  final int coins;
  final VoidCallback onRedeemCoinsTap;

  @override
  Widget build(BuildContext context) {
    final ratio = totalCount == 0 ? 0.0 : unlockedCount / totalCount;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(
                label: 'VITRINA DE LOGROS',
                variant: StatusBadgeVariant.brand,
                icon: Icons.emoji_events_rounded,
              ),
              const Spacer(),
              Text(
                '$unlockedCount de $totalCount conseguidas',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.brandAccent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: '${AppStrings.medalsRedeemButton} ($coins disponibles)',
            icon: Icons.storefront_rounded,
            onPressed: onRedeemCoinsTap,
          ),
        ],
      ),
    );
  }
}
