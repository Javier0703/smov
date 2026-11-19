import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/feedback/app_error_view.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/compass_rose_widget.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../../data/models/gameplay_models.dart';
import '../viewmodels/gameplay_viewmodel.dart';
import '../widgets/gameplay_backdrop.dart';
import '../widgets/grid_expedition_board.dart';
import '../widgets/in_game_backpack_sheet.dart';

/// Pantalla activa de juego (`/play/:sessionId`) adaptable a móvil y tablet.
class GameplayScreen extends StatelessWidget {
  const GameplayScreen({
    super.key,
    required this.viewModel,
    required this.onBack,
    required this.onOpenHowToPlayModal,
    required this.onOpenStore,
    required this.onSessionCompleted,
  });

  final GameplayViewModel viewModel;
  final VoidCallback onBack;
  final VoidCallback onOpenHowToPlayModal;
  final VoidCallback onOpenStore;
  final ValueChanged<GameSessionResultModel> onSessionCompleted;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final game = viewModel.activeGame;
        final round = viewModel.currentRound;

        if (game == null || round == null) {
          return Scaffold(
            body: AppErrorView(
              message: 'No hay una sesión de juego activa.',
              onRetry: onBack,
            ),
          );
        }

        return AdventureScaffold(
          backgroundColor: game.tintColor,
          maxContentWidth: 1120,
          topBar: AppTopBar(
            title: game.title,
            subtitle:
                'Nivel ${viewModel.activeLevelNumber} · Ronda ${viewModel.currentRoundIndex + 1} de ${viewModel.rounds.length}',
            showBackButton: true,
            onBackPressed: onBack,
            coins: viewModel.currentUser.coins,
            actions: [
              AppIconButton(
                icon: Icons.help_outline_rounded,
                tooltip: 'Cómo jugar',
                onPressed: onOpenHowToPlayModal,
              ),
              const SizedBox(width: 4),
              AppIconButton(
                icon: Icons.backpack_outlined,
                tooltip: 'Tu mochila en esta prueba',
                backgroundColor: AppColors.brandAccent.withValues(alpha: 0.25),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppColors.cardBackground,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.radiusLg),
                      ),
                    ),
                    builder: (_) => InGameBackpackSheet(
                      inventoryCounts: viewModel.inventoryCounts,
                      onUseItem: viewModel.useBackpackHelper,
                      onOpenStore: onOpenStore,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(child: GameplayBackdrop(gameId: game.id)),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTabletOrWide =
                      constraints.maxWidth >= AppSpacing.compactBreakpoint;

                  final boardSection = _InteractiveBoardSection(
                    viewModel: viewModel,
                    round: round,
                    onFinishedCheck: (completed) {
                      if (completed && viewModel.lastResult != null) {
                        onSessionCompleted(viewModel.lastResult!);
                      }
                    },
                  );

                  final missionPanelSection = _MissionControlSidePanel(
                    viewModel: viewModel,
                    round: round,
                    onOpenBackpack: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.cardBackground,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.radiusLg),
                          ),
                        ),
                        builder: (_) => InGameBackpackSheet(
                          inventoryCounts: viewModel.inventoryCounts,
                          onUseItem: viewModel.useBackpackHelper,
                          onOpenStore: onOpenStore,
                        ),
                      );
                    },
                    onFinishedCheck: (completed) {
                      if (completed && viewModel.lastResult != null) {
                        onSessionCompleted(viewModel.lastResult!);
                      }
                    },
                  );

                  if (isTabletOrWide) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: boardSection),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(flex: 5, child: missionPanelSection),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        missionPanelSection,
                        const SizedBox(height: AppSpacing.md),
                        boardSection,
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InteractiveBoardSection extends StatelessWidget {
  const _InteractiveBoardSection({
    required this.viewModel,
    required this.round,
    required this.onFinishedCheck,
  });

  final GameplayViewModel viewModel;
  final GameRoundChallenge round;
  final ValueChanged<bool> onFinishedCheck;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      backgroundColor: AppColors.cardBackground,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: switch (round.mechanic) {
        ChallengeMechanicType.compassCalibration => _CompassChallengeBoard(
          viewModel: viewModel,
          round: round,
          onFinishedCheck: onFinishedCheck,
        ),
        ChallengeMechanicType.whereAmIRiddle ||
        ChallengeMechanicType.spainTerritoryMap ||
        ChallengeMechanicType.spainNeighborRoute => _SpainMapChallengeBoard(
          viewModel: viewModel,
          round: round,
          onFinishedCheck: onFinishedCheck,
        ),
        _ => _GridChallengeWrapperBoard(
          viewModel: viewModel,
          round: round,
          onFinishedCheck: onFinishedCheck,
        ),
      },
    );
  }
}

class _GridChallengeWrapperBoard extends StatelessWidget {
  const _GridChallengeWrapperBoard({
    required this.viewModel,
    required this.round,
    required this.onFinishedCheck,
  });

  final GameplayViewModel viewModel;
  final GameRoundChallenge round;
  final ValueChanged<bool> onFinishedCheck;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (round.mechanic == ChallengeMechanicType.gridCoordinateFind &&
            (viewModel.activeLevelNumber == 3 ||
                viewModel.activeGame?.id == 'gran_reto')) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.center,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.park_rounded, color: AppColors.success),
                    SizedBox(width: 6),
                    Text('Leyenda: parque'),
                  ],
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.commit_rounded, color: Color(0xFFD97706)),
                    SizedBox(width: 6),
                    Text('Puente'),
                  ],
                ),
                Text(
                  viewModel.activeLevelNumber == 3
                      ? 'Escala: 1 tramo = 1 casilla'
                      : 'Escala: usa filas y columnas',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (round.mechanic == ChallengeMechanicType.cartographyBuilder) ...[
          _CartographySymbolBar(
            selectedSymbol: viewModel.selectedCartographySymbol,
            onSelectSymbol: viewModel.selectCartographySymbol,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        GridExpeditionBoard(
          round: round,
          explorerCoord: viewModel.explorerCoord,
          visitedCoords: viewModel.visitedCoords,
          avatarConfig: viewModel.currentUser.avatarConfig,
          showHintTarget: viewModel.isHintRevealed,
          showCompassBoost: viewModel.isCompassBoostActive,
          onCellTap: (coord) async {
            final finished = await viewModel.handleGridCellTap(coord);
            onFinishedCheck(finished);
          },
          onDirectionMove: (dir) async {
            final finished = await viewModel.moveByDirection(dir);
            onFinishedCheck(finished);
          },
          placedSymbols: viewModel.placedCartographySymbols,
          onSymbolPlaced: (symbol, coord) async {
            final finished = await viewModel.placeCartographySymbol(
              symbol,
              coord,
            );
            onFinishedCheck(finished);
          },
        ),
        if (viewModel.activeGame?.id == 'rumbo_desconocido') ...[
          const SizedBox(height: AppSpacing.sm),
          AppSecondaryButton(
            label: 'Comprobar el destino',
            icon: Icons.check_circle_outline_rounded,
            onPressed: () async {
              final finished = await viewModel.confirmRumboDestination();
              onFinishedCheck(finished);
            },
          ),
        ],
      ],
    );
  }
}

class _CartographySymbolBar extends StatelessWidget {
  const _CartographySymbolBar({
    required this.selectedSymbol,
    required this.onSelectSymbol,
  });

  final String selectedSymbol;
  final ValueChanged<String> onSelectSymbol;

  static const List<(String, IconData)> _symbols = <(String, IconData)>[
    ('Colegio', Icons.school_rounded),
    ('Árbol', Icons.park_rounded),
    ('Parque', Icons.park_rounded),
    ('Hospital', Icons.local_hospital_rounded),
    ('Casa', Icons.home_rounded),
    ('Cordillera', Icons.terrain_rounded),
    ('Puerto', Icons.directions_boat_rounded),
    ('Bosque', Icons.park_rounded),
    ('Refugio', Icons.cabin_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final item in _symbols)
          Draggable<String>(
            data: item.$1,
            feedback: Material(
              color: Colors.transparent,
              child: Chip(
                avatar: Icon(item.$2, size: 16),
                label: Text(item.$1),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.35,
              child: ChoiceChip(
                label: Text(item.$1),
                avatar: Icon(item.$2, size: 16),
                selected: false,
                onSelected: null,
              ),
            ),
            child: ChoiceChip(
              label: Text(item.$1),
              avatar: Icon(item.$2, size: 16),
              selected: selectedSymbol == item.$1,
              onSelected: (_) => onSelectSymbol(item.$1),
            ),
          ),
      ],
    );
  }
}

class _CompassChallengeBoard extends StatelessWidget {
  const _CompassChallengeBoard({
    required this.viewModel,
    required this.round,
    required this.onFinishedCheck,
  });

  final GameplayViewModel viewModel;
  final GameRoundChallenge round;
  final ValueChanged<bool> onFinishedCheck;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.activeLevelNumber == 3
                  ? 'Gira la brújula para fijar el rumbo'
                  : 'Brújula de aguja roja (Norte) y blanca (Sur)',
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.brandPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: CompassRoseWidget(
            selectedDirection: viewModel.compassDirection,
            targetDirection: viewModel.isHintRevealed
                ? round.targetDirection
                : null,
            useMagneticRedWhiteNeedle: true,
            showCollateralLabels: viewModel.activeLevelNumber > 1,
            size: 248,
            onDirectionSelected: viewModel.setCompassDirection,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            for (final dir in CardinalDirection.values.where(
              (direction) =>
                  viewModel.activeLevelNumber > 1 ||
                  direction.degrees % 90 == 0,
            ))
              ChoiceChip(
                label: Text('${dir.code} (${dir.label})'),
                selected: viewModel.compassDirection == dir,
                onSelected: (_) => viewModel.setCompassDirection(dir),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppPrimaryButton(
          label: 'Comprobar rumbo (${viewModel.compassDirection.code})',
          icon: Icons.check_circle_rounded,
          onPressed: () async {
            final finished = await viewModel.submitCompassDirection();
            onFinishedCheck(finished);
          },
        ),
      ],
    );
  }
}

class _SpainMapChallengeBoard extends StatelessWidget {
  const _SpainMapChallengeBoard({
    required this.viewModel,
    required this.round,
    required this.onFinishedCheck,
  });

  final GameplayViewModel viewModel;
  final GameRoundChallenge round;
  final ValueChanged<bool> onFinishedCheck;

  @override
  Widget build(BuildContext context) {
    final regions = SpainMapCatalog.regionsForMode(round.mapMode);
    final isTerritoryPuzzle = viewModel.activeGame?.id == 'espana_en_tus_manos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (round.mechanic == ChallengeMechanicType.whereAmIRiddle) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    color: AppColors.brandPrimary,
                    size: 34,
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Encuentra la posición que cumple las 3 pistas',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        SpainVectorMapWidget(
          mode: round.mapMode,
          completedRegionIds: viewModel.completedRegionIds,
          selectedRegionId: viewModel.selectedRegionId,
          hintRegionIds: viewModel.isHintRevealed
              ? <String>{round.targetRegionId}
              : const <String>{},
          routeRegionIds: viewModel.routeRegionIds,
          onRegionTap: (region) async {
            final finished = await viewModel.handleSpainRegionTap(region);
            onFinishedCheck(finished);
          },
          onRegionDrop: isTerritoryPuzzle
              ? (dragged, target) async {
                  final finished = await viewModel.handleSpainRegionDrop(
                    dragged,
                    target,
                  );
                  onFinishedCheck(finished);
                }
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          isTerritoryPuzzle
              ? 'Arrastra cada nombre hasta su zona del mapa:'
              : 'También puedes tocar el territorio directamente en la lista:',
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final region in regions)
              if (isTerritoryPuzzle)
                Draggable<SpainMapRegion>(
                  data: region,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Chip(
                      label: Text(region.name),
                      backgroundColor: AppColors.brandAccent,
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.35,
                    child: Chip(label: Text(region.name)),
                  ),
                  child: ActionChip(
                    label: Text(region.name),
                    backgroundColor:
                        viewModel.completedRegionIds.contains(region.id)
                        ? AppColors.success.withValues(alpha: 0.22)
                        : AppColors.surfaceMuted,
                    onPressed: () async {
                      final finished = await viewModel.handleSpainRegionTap(
                        region,
                      );
                      onFinishedCheck(finished);
                    },
                  ),
                )
              else
                ActionChip(
                  label: Text(region.name),
                  backgroundColor:
                      viewModel.completedRegionIds.contains(region.id)
                      ? AppColors.success.withValues(alpha: 0.22)
                      : AppColors.surfaceMuted,
                  onPressed: () async {
                    final finished = await viewModel.handleSpainRegionTap(
                      region,
                    );
                    onFinishedCheck(finished);
                  },
                ),
          ],
        ),
      ],
    );
  }
}

class _MissionControlSidePanel extends StatelessWidget {
  const _MissionControlSidePanel({
    required this.viewModel,
    required this.round,
    required this.onOpenBackpack,
    required this.onFinishedCheck,
  });

  final GameplayViewModel viewModel;
  final GameRoundChallenge round;
  final VoidCallback onOpenBackpack;
  final ValueChanged<bool> onFinishedCheck;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      backgroundColor: AppColors.cardBackground,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusBadge(
                label:
                    'MISIÓN ${viewModel.currentRoundIndex + 1}/${viewModel.rounds.length}',
                variant: StatusBadgeVariant.brand,
                icon: Icons.flag_rounded,
              ),
              const Spacer(),
              if (viewModel.activeGame?.id == 'llegar_a_tiempo')
                StatusBadge(
                  label: AppFormatters.formatCountdown(
                    viewModel.remainingSeconds,
                  ),
                  variant: viewModel.remainingSeconds <= 30
                      ? StatusBadgeVariant.danger
                      : StatusBadgeVariant.warning,
                  icon: Icons.timer_rounded,
                ),
              if (viewModel.activeGame?.id == 'llegar_a_tiempo')
                const SizedBox(width: AppSpacing.xs),
              if (viewModel.bonusSeconds > 0)
                StatusBadge(
                  label: '+${viewModel.bonusSeconds} s extra',
                  variant: StatusBadgeVariant.success,
                  icon: Icons.hourglass_bottom_rounded,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            round.title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            round.instruction,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.inkStrong,
            ),
          ),
          if (viewModel.isFunnyDetourActive &&
              viewModel.funnyDetourMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _FunnyDetourCard(
              message: viewModel.funnyDetourMessage!,
              avatarConfig: viewModel.currentUser.avatarConfig,
            ),
          ],
          if (round.clues.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _CluesScrollBox(clues: round.clues),
          ],
          if (round.options.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < round.options.length; i++) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: AppSecondaryButton(
                  label: round.options[i],
                  icon: Icons.place_outlined,
                  onPressed: () async {
                    final finished = await viewModel.submitRiddleOption(i);
                    onFinishedCheck(finished);
                  },
                ),
              ),
            ],
          ],
          if (viewModel.isHintRevealed) ...[
            const SizedBox(height: AppSpacing.sm),
            _ActiveHintBox(hintText: round.hint),
          ],
          if (viewModel.feedbackMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _FeedbackBanner(
              message: viewModel.feedbackMessage!,
              isPositive: viewModel.isFeedbackPositive,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label:
                      'Mochila (${viewModel.inventoryCounts['magnifying_glass'] ?? 0} lupas)',
                  icon: Icons.backpack_outlined,
                  onPressed: onOpenBackpack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CluesScrollBox extends StatelessWidget {
  const _CluesScrollBox({required this.clues});

  final List<String> clues;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9E7),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: const Color(0xFFF5CBA7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final clue in clues)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                clue,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.inkStrong,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FunnyDetourCard extends StatelessWidget {
  const _FunnyDetourCard({required this.message, required this.avatarConfig});

  final String message;
  final AvatarConfig avatarConfig;

  @override
  Widget build(BuildContext context) {
    final isPuddleLanding = message.contains('charca');
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: -28, end: 0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.bounceOut,
            builder: (context, offset, child) =>
                Transform.translate(offset: Offset(0, offset), child: child),
            child: ExplorerAvatarWidget(
              config: avatarConfig,
              size: 38,
              backgroundColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            isPuddleLanding ? Icons.pool_rounded : Icons.roofing_rounded,
            color: AppColors.brandPrimary,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkStrong,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveHintBox extends StatelessWidget {
  const _ActiveHintBox({required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.brandAccent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.brandPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.brandPrimary,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Pista de la lupa: $hintText',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message, required this.isPositive});

  final String message;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          Icon(
            isPositive
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 18,
            color: isPositive ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkStrong,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
