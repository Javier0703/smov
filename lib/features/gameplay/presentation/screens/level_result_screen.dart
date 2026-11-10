import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/info_tile.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../../../shared/widgets/vector/medal_badge_widget.dart';
import '../../data/models/gameplay_models.dart';

/// Pantalla de resultado `¡Rumbo superado!` y celebración final `¡Gran explorador!` (`/results/:sessionId`).
class LevelResultScreen extends StatelessWidget {
  const LevelResultScreen({
    super.key,
    required this.result,
    required this.avatarConfig,
    required this.onPlayNext,
    required this.onReplay,
    required this.onOpenMedals,
    required this.onBackHome,
  });

  final GameSessionResultModel result;
  final AvatarConfig avatarConfig;
  final VoidCallback onPlayNext;
  final VoidCallback onReplay;
  final VoidCallback onOpenMedals;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final isFinal = result.isFinalExpedition;
    final medalType =
        MedalType.values
            .where((m) => m.number == result.medalNumber)
            .firstOrNull ??
        MedalType.buenRumbo;

    return AdventureScaffold(
      topBar: AppTopBar(
        title: isFinal
            ? AppStrings.grandExplorerTitle
            : AppStrings.levelCompletedDefaultTitle,
        subtitle: '${result.gameTitle} · Nivel ${result.levelNumber}',
        coins: result.totalCoinsAfter,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CelebrationHeroCard(
              result: result,
              avatarConfig: avatarConfig,
              medalType: medalType,
              isFinal: isFinal,
            ),
            const SizedBox(height: AppSpacing.md),
            _ResultMetricsRow(result: result),
            if (result.stampedCommunitiesEarned.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _StampedPassportNoticeCard(
                count: result.stampedCommunitiesEarned.length,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: isFinal
                  ? 'Ver mi medallero completo'
                  : 'Continuar expedición',
              icon: isFinal
                  ? Icons.emoji_events_rounded
                  : Icons.arrow_forward_rounded,
              onPressed: isFinal ? onOpenMedals : onPlayNext,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppSecondaryButton(
              label: 'Repetir este nivel para practicar',
              icon: Icons.replay_rounded,
              onPressed: onReplay,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton.icon(
              onPressed: onBackHome,
              icon: const Icon(Icons.home_outlined),
              label: const Text('Volver a Inicio — Pasaporte y progreso'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationHeroCard extends StatelessWidget {
  const _CelebrationHeroCard({
    required this.result,
    required this.avatarConfig,
    required this.medalType,
    required this.isFinal,
  });

  final GameSessionResultModel result;
  final AvatarConfig avatarConfig;
  final MedalType medalType;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: AppColors.brandPrimary,
      child: Column(
        children: [
          StatusBadge(
            label: isFinal
                ? 'DIPLOMA DE LA EXPEDICIÓN FINAL'
                : 'PRUEBA SUPERADA CON ÉXITO',
            variant: StatusBadgeVariant.success,
            icon: Icons.verified_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExplorerAvatarWidget(
                config: avatarConfig,
                size: 88,
                backgroundColor: AppColors.surfaceMuted,
              ),
              const SizedBox(width: AppSpacing.md),
              MedalBadgeWidget(type: medalType, unlocked: true, size: 76),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isFinal
                ? AppStrings.grandExplorerTitle
                : '¡${result.gameTitle} superado!',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isFinal
                ? AppStrings.grandExplorerSubtitle
                : 'Has desbloqueado el logro "${result.achievementTitle}" y sumado monedas a tu mochila.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandAccent.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: AppColors.brandPrimary),
            ),
            child: Text(
              result.coinsAwarded > 0
                  ? '+${result.coinsAwarded} monedas ganadas · Saldo: ${result.totalCoinsAfter}'
                  : 'Recompensa de sesión ya acreditada · Saldo: ${result.totalCoinsAfter}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultMetricsRow extends StatelessWidget {
  const _ResultMetricsRow({required this.result});

  final GameSessionResultModel result;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoTile(
            value: Formatters.percentage(result.accuracyPercent),
            label: 'Precisión',
            icon: Icons.track_changes_rounded,
            accentColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: '${result.correctAnswers}/${result.totalAttempts}',
            label: 'Aciertos',
            icon: Icons.check_circle_outline_rounded,
            accentColor: AppColors.brandPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: Formatters.durationSeconds(result.durationSeconds),
            label: 'Tiempo',
            icon: Icons.timer_outlined,
            accentColor: AppColors.brandAccent,
          ),
        ),
      ],
    );
  }
}

class _StampedPassportNoticeCard extends StatelessWidget {
  const _StampedPassportNoticeCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      backgroundColor: AppColors.surfaceMuted,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.success,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '¡Has sellado $count comunidad(es) autónoma(s) nueva(s) en Mi pasaporte!',
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
