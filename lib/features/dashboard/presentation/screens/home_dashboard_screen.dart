import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/info_tile.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../widgets/next_mission_card.dart';
import '../widgets/orientation_stamps_card.dart';

/// Pantalla `Inicio — Pasaporte y progreso` (`/home`).
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
    required this.onOpenNextMission,
  });

  final DashboardViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;
  final ValueChanged<String> onOpenNextMission;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final summary = viewModel.summary;
        if (summary == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AdventureScaffold(
          backgroundColor: AppColors.paletteFor(summary.palette).canvas,
          topBar: AppTopBar(
            title: '¡Hola, ${summary.user.displayName}!',
            subtitle: AppStrings.homeSubtitle,
            coins: summary.user.coins,
            onCoinsTap: () => onNavigateRoute('/inventory'),
            actions: [
              _PaletteMenuButton(
                currentPalette: summary.palette,
                onSelected: viewModel.selectPalette,
              ),
            ],
          ),
          drawer: AppDrawer(
            user: summary.user,
            currentRoute: '/home',
            onNavigate: onNavigateRoute,
            onSwitchRole: () => onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 0,
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
                _ExplorerPassportHeaderCard(
                  summary: summary,
                  onAvatarTap: () => onNavigateRoute('/avatar'),
                  onActivityTap: () => onNavigateRoute('/activity'),
                  onInventoryTap: () => onNavigateRoute('/inventory'),
                  onClaimDailyReward: () {
                    final claimed = viewModel.claimDailyReward();
                    if (claimed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '¡Racha diaria! Has ganado +25 monedas para tu mochila.',
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                OrientationStampsCard(
                  unlockedStamps: summary.orientationStamps,
                ),
                const SizedBox(height: AppSpacing.md),
                _KpiMetricsRow(summary: summary),
                const SizedBox(height: AppSpacing.md),
                NextMissionCard(
                  title: summary.nextMissionTitle,
                  subtitle: summary.nextMissionSubtitle,
                  onContinuePressed: () =>
                      onOpenNextMission(summary.nextMissionGameId),
                ),
                const SizedBox(height: AppSpacing.md),
                _QuickNavigationGrid(
                  coins: summary.user.coins,
                  onNavigateRoute: onNavigateRoute,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExplorerPassportHeaderCard extends StatelessWidget {
  const _ExplorerPassportHeaderCard({
    required this.summary,
    required this.onAvatarTap,
    required this.onActivityTap,
    required this.onInventoryTap,
    required this.onClaimDailyReward,
  });

  final DashboardSummaryModel summary;
  final VoidCallback onAvatarTap;
  final VoidCallback onActivityTap;
  final VoidCallback onInventoryTap;
  final VoidCallback onClaimDailyReward;

  @override
  Widget build(BuildContext context) {
    final UserModel user = summary.user;
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: ExplorerAvatarWidget(
                  config: user.avatarConfig,
                  size: 72,
                  backgroundColor: AppColors.surfaceMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusBadge(
                          label: 'Clase ${user.classId}',
                          variant: StatusBadgeVariant.brand,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        StatusBadge(
                          label: '${user.streakDays} días seguidos',
                          variant: StatusBadgeVariant.success,
                          icon: Icons.local_fire_department_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Explorador ${user.displayName}',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.inkStrong,
                      ),
                    ),
                    Text(
                      'Colegio · Segundo Ciclo de Primaria',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _ActionChipLink(
                icon: Icons.person_outline_rounded,
                label: AppStrings.homeMyAvatarAction,
                onTap: onAvatarTap,
              ),
              _ActionChipLink(
                icon: Icons.insights_rounded,
                label: AppStrings.homeMyActivityAction,
                onTap: onActivityTap,
              ),
              _ActionChipLink(
                icon: Icons.backpack_outlined,
                label: 'Mochila · ${Formatters.coinsWithLabel(user.coins)}',
                onTap: onInventoryTap,
              ),
              if (!summary.dailyRewardClaimed)
                _ActionChipLink(
                  icon: Icons.card_giftcard_rounded,
                  label: 'Recompensa diaria (+25)',
                  highlight: true,
                  onTap: onClaimDailyReward,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChipLink extends StatelessWidget {
  const _ActionChipLink({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.brandAccent.withValues(alpha: 0.25)
              : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: highlight ? AppColors.brandPrimary : AppColors.borderDefault,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.brandPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiMetricsRow extends StatelessWidget {
  const _KpiMetricsRow({required this.summary});

  final DashboardSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoTile(
            value: '${summary.piecesCount}',
            label: AppStrings.homePiecesLabel,
            icon: Icons.extension_rounded,
            accentColor: AppColors.brandPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: '${summary.medalsCount}',
            label: AppStrings.homeBadgesLabel,
            icon: Icons.emoji_events_rounded,
            accentColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: Formatters.percentage(summary.routeProgressPercent),
            label: AppStrings.homeRouteLabel,
            icon: Icons.route_rounded,
            accentColor: AppColors.brandAccent,
          ),
        ),
      ],
    );
  }
}

class _QuickNavigationGrid extends StatelessWidget {
  const _QuickNavigationGrid({
    required this.coins,
    required this.onNavigateRoute,
  });

  final int coins;
  final ValueChanged<String> onNavigateRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuaderno de expedición',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.brandPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _ShortcutTile(
                icon: Icons.explore_rounded,
                title: 'Elige tu aventura',
                subtitle: '10 retos geográficos',
                onTap: () => onNavigateRoute('/adventures'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _ShortcutTile(
                icon: Icons.menu_book_rounded,
                title: 'Mi pasaporte',
                subtitle: '17 sellos y postales',
                onTap: () => onNavigateRoute('/passport'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _ShortcutTile(
                icon: Icons.emoji_events_rounded,
                title: 'Mi medallero',
                subtitle: '8 insignias de logro',
                onTap: () => onNavigateRoute('/medals'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _ShortcutTile(
                icon: Icons.school_rounded,
                title: 'Espacio docente',
                subtitle: 'Aula 4.º A y preguntas',
                onTap: () => onNavigateRoute('/teacher/classes/4A/activity'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: AppColors.brandPrimary, size: 22),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteMenuButton extends StatelessWidget {
  const _PaletteMenuButton({
    required this.currentPalette,
    required this.onSelected,
  });

  final AppPaletteType currentPalette;
  final ValueChanged<AppPaletteType> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppPaletteType>(
      tooltip: 'Cambiar paleta visual',
      icon: const Icon(Icons.palette_outlined, color: AppColors.brandPrimary),
      onSelected: onSelected,
      itemBuilder: (context) => AppPaletteType.values
          .map(
            (p) => CheckedPopupMenuItem<AppPaletteType>(
              value: p,
              checked: p == currentPalette,
              child: Text(AppColors.paletteFor(p).name),
            ),
          )
          .toList(),
    );
  }
}
