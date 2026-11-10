import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/info_tile.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../viewmodels/statistics_viewmodel.dart';
import '../widgets/competency_progress_card.dart';

/// Pantalla `Mi actividad` (`/activity`).
class StudentActivityScreen extends StatelessWidget {
  const StudentActivityScreen({
    super.key,
    required this.viewModel,
    required this.onBack,
  });

  final StatisticsViewModel viewModel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final activity = viewModel.activity;
        if (activity == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.activityScreenTitle,
            subtitle: AppStrings.activityScreenSubtitle,
            showBackButton: true,
            onBackPressed: onBack,
            coins: activity.user.coins,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfoTile(
                        value: Formatters.percentage(
                          activity.weightedAccuracyPercent,
                        ),
                        label: 'Precisión ponderada',
                        icon: Icons.track_changes_rounded,
                        accentColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: InfoTile(
                        value: '${activity.totalSessionsCount}',
                        label: 'Misiones jugadas',
                        icon: Icons.flag_rounded,
                        accentColor: AppColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: InfoTile(
                        value:
                            '${activity.totalCorrectAnswers}/${activity.totalAttempts}',
                        label: 'Aciertos totales',
                        icon: Icons.check_circle_outline_rounded,
                        accentColor: AppColors.brandAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                CompetencyProgressCard(competencies: activity.competencies),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Últimas partidas completadas',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final session in activity.recentSessions) ...[
                  _SessionHistoryTile(session: session),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SessionHistoryTile extends StatelessWidget {
  const _SessionHistoryTile({required this.session});

  final SessionRecord session;

  @override
  Widget build(BuildContext context) {
    final pct = session.accuracy.round();
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Text(
              Formatters.percentage(pct),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${session.gameTitle} · Nivel ${session.level}',
                  style: AppTypography.titleSmall,
                ),
                Text(
                  '${session.completedAtIso} · ${session.correctAnswers}/${session.totalAttempts} aciertos · ${Formatters.durationSeconds(session.durationSeconds)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: '+${session.coinsEarned}',
            variant: StatusBadgeVariant.success,
          ),
        ],
      ),
    );
  }
}
