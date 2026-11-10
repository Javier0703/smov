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
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../../data/models/adventure_game_model.dart';
import '../viewmodels/adventures_viewmodel.dart';
import '../widgets/level_option_card.dart';

/// Pantalla `Elige tu nivel` (`/games/:gameId/levels`) y selector territorial de `España en tus manos`.
class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({
    super.key,
    required this.gameId,
    required this.viewModel,
    required this.onBack,
    required this.onOpenHowToPlay,
    required this.onStartLevel,
  });

  final String gameId;
  final AdventuresViewModel viewModel;
  final VoidCallback onBack;
  final void Function(AdventureGameModel game, int levelNumber) onOpenHowToPlay;
  final void Function(AdventureGameModel game, int levelNumber) onStartLevel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final game = viewModel.findGame(gameId);
        if (game == null) {
          return Scaffold(
            body: AppErrorView(
              message: 'No se encontró la aventura seleccionada ($gameId).',
              onRetry: onBack,
            ),
          );
        }

        final selectedNumber = viewModel.selectedLevelNumber;
        final selectedLevel =
            game.levels
                .where((l) => l.levelNumber == selectedNumber)
                .firstOrNull ??
            game.levels.first;
        final isSpainTerritoryGame = game.id == 'espana_en_tus_manos';

        return AdventureScaffold(
          backgroundColor: game.tintColor,
          topBar: AppTopBar(
            title: isSpainTerritoryGame
                ? 'España en tus manos'
                : 'Elige tu nivel — ${game.title}',
            subtitle:
                '${game.competencyTag} · Clase ${viewModel.currentUser.classId}',
            showBackButton: true,
            onBackPressed: onBack,
            coins: viewModel.currentUser.coins,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GameHeaderBanner(
                  game: game,
                  isSpainTerritoryGame: isSpainTerritoryGame,
                  selectedLevelNumber: selectedLevel.levelNumber,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final level in game.levels) ...[
                  LevelOptionCard(
                    level: level,
                    isSelected: level.levelNumber == selectedLevel.levelNumber,
                    onSelect: () => viewModel.selectLevel(level.levelNumber),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.sm),
                AppPrimaryButton(
                  label: selectedLevel.canPlay
                      ? 'Empezar Nivel ${selectedLevel.levelNumber}'
                      : 'Nivel bloqueado (${selectedLevel.statusLabel})',
                  icon: selectedLevel.canPlay
                      ? Icons.play_arrow_rounded
                      : Icons.lock_outline_rounded,
                  onPressed: selectedLevel.canPlay
                      ? () => onStartLevel(game, selectedLevel.levelNumber)
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppSecondaryButton(
                  label: 'Antes de jugar · Cómo se juega',
                  icon: Icons.help_outline_rounded,
                  onPressed: () =>
                      onOpenHowToPlay(game, selectedLevel.levelNumber),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GameHeaderBanner extends StatelessWidget {
  const _GameHeaderBanner({
    required this.game,
    required this.isSpainTerritoryGame,
    required this.selectedLevelNumber,
  });

  final AdventureGameModel game;
  final bool isSpainTerritoryGame;
  final int selectedLevelNumber;

  @override
  Widget build(BuildContext context) {
    final mapMode = switch (selectedLevelNumber) {
      2 => SpainMapMode.castillaYLeonProvinces,
      3 => SpainMapMode.spainProvinces,
      _ => SpainMapMode.autonomousCommunities,
    };

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.spaceBetween,
            children: [
              StatusBadge(
                label: isSpainTerritoryGame
                    ? 'RECORRIDO TERRITORIAL EN 3 NIVELES'
                    : 'PROGRESIÓN DE LA AVENTURA',
                variant: StatusBadgeVariant.brand,
                icon: game.icon,
              ),
              StatusBadge(
                label: 'Logro: ${game.achievementTitle}',
                variant: StatusBadgeVariant.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            game.shortDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          if (isSpainTerritoryGame) ...[
            const SizedBox(height: AppSpacing.sm),
            SpainVectorMapWidget(
              mode: mapMode,
              completedRegionIds: const <String>{
                'castilla_y_leon',
                'valladolid',
                'leon',
                'madrid',
              },
            ),
          ],
        ],
      ),
    );
  }
}
