import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../adventures/data/models/adventure_game_model.dart';

/// Pantalla `Rumbo a lo desconocido — Antes de jugar` (`/games/:gameId/how-to`).
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({
    super.key,
    required this.game,
    required this.levelNumber,
    required this.onStartOrResume,
    required this.onBack,
    this.isResumingGame = false,
  });

  final AdventureGameModel game;
  final int levelNumber;
  final VoidCallback onStartOrResume;
  final VoidCallback onBack;
  final bool isResumingGame;

  @override
  Widget build(BuildContext context) {
    final levelInfo =
        game.levels.where((l) => l.levelNumber == levelNumber).firstOrNull ??
        game.levels.first;

    return AdventureScaffold(
      backgroundColor: game.tintColor,
      topBar: AppTopBar(
        title: '${game.title} — ${AppStrings.howToPlayTitle}',
        subtitle: 'Nivel $levelNumber · ${levelInfo.title}',
        showBackButton: true,
        onBackPressed: onBack,
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
                  Row(
                    children: [
                      StatusBadge(
                        label: AppStrings.howToPlayTag,
                        variant: StatusBadgeVariant.brand,
                        icon: game.icon,
                      ),
                      const Spacer(),
                      StatusBadge(
                        label: '+${levelInfo.rewardCoins} monedas',
                        variant: StatusBadgeVariant.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Objetivo de la misión',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    game.howToPlayObjective,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.inkStrong,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Pasos para superar la prueba',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (var i = 0; i < game.howToPlaySteps.length; i++) ...[
                    _InstructionStepRow(
                      stepIndex: i + 1,
                      text: game.howToPlaySteps[i],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _BackpackTipCard(),
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: isResumingGame
                  ? 'Volver a la partida en curso'
                  : AppStrings.howToPlayStartButton,
              icon: Icons.play_arrow_rounded,
              onPressed: onStartOrResume,
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionStepRow extends StatelessWidget {
  const _InstructionStepRow({required this.stepIndex, required this.text});

  final int stepIndex;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.brandPrimary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$stepIndex',
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackpackTipCard extends StatelessWidget {
  const _BackpackTipCard();

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      backgroundColor: AppColors.surfaceMuted,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(
            Icons.backpack_rounded,
            color: AppColors.brandPrimary,
            size: 26,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Recuerda: durante la prueba puedes tocar "Mochila" para usar una lupa de pistas, el reloj de arena o la brújula especial.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
