import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/info_tile.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../data/models/teacher_models.dart';
import '../viewmodels/teacher_viewmodel.dart';
import '../widgets/teacher_nav_tabs_bar.dart';

/// Pantalla `Ficha de alumno — Así progresa Alex` (`/students/:studentId`).
class TeacherStudentDetailScreen extends StatelessWidget {
  const TeacherStudentDetailScreen({
    super.key,
    required this.studentId,
    required this.viewModel,
    required this.onNavigateRoute,
  });

  final String studentId;
  final TeacherViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final student = viewModel.selectedStudent;
        if (student == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AdventureScaffold(
          maxContentWidth: 1080,
          topBar: AppTopBar(
            title: 'Ficha de alumno — Así progresa ${student.displayName}',
            subtitle: 'Clase ${student.classId} · Evaluación de competencias',
            showBackButton: true,
            onBackPressed: () =>
                onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TeacherNavTabsBar(
                  activeTabIndex: 1,
                  onNavigateRoute: onNavigateRoute,
                ),
                const SizedBox(height: AppSpacing.md),
                _StudentProfileHeroCard(student: student),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: InfoTile(
                        value: Formatters.percentage(
                          student.weightedAccuracyPercent,
                        ),
                        label: 'Precisión ponderada',
                        icon: Icons.track_changes_rounded,
                        accentColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: InfoTile(
                        value: '${student.medalsCount}/8',
                        label: 'Medallas logradas',
                        icon: Icons.emoji_events_rounded,
                        accentColor: AppColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: InfoTile(
                        value: '${student.stampedCommunitiesCount}/17',
                        label: 'Sellos pasaporte',
                        icon: Icons.verified_rounded,
                        accentColor: AppColors.brandAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _PedagogicalDiagnosisCard(
                  student: student,
                  onAdaptQuestionTap: () =>
                      onNavigateRoute('/questions/q_default'),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Sesiones recientes de ${student.displayName}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final session in student.sessions) ...[
                  _StudentSessionLogCard(session: session),
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

class _StudentProfileHeroCard extends StatelessWidget {
  const _StudentProfileHeroCard({required this.student});

  final StudentRosterSummary student;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          ExplorerAvatarWidget(
            config: student.avatarConfig,
            size: 84,
            backgroundColor: AppColors.surfaceMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: 'FICHA INDIVIDUAL · ${student.classId}',
                  variant: StatusBadgeVariant.brand,
                ),
                const SizedBox(height: 6),
                Text(
                  'Explorador ${student.displayName}',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                Text(
                  '${student.completedMissions} misiones superadas · ${student.totalCorrect}/${student.totalAttempts} respuestas correctas en sesiones registradas.',
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

class _PedagogicalDiagnosisCard extends StatelessWidget {
  const _PedagogicalDiagnosisCard({
    required this.student,
    required this.onAdaptQuestionTap,
  });

  final StudentRosterSummary student;
  final VoidCallback onAdaptQuestionTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observaciones pedagógicas',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Punto fuerte: ${student.strengthTopic}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.inkStrong,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFFD97706),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Área recomendada de refuerzo: ${student.reinforcementTopic}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.inkStrong,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: 'Adaptar una pregunta de refuerzo para la clase',
            icon: Icons.edit_note_rounded,
            onPressed: onAdaptQuestionTap,
          ),
        ],
      ),
    );
  }
}

class _StudentSessionLogCard extends StatelessWidget {
  const _StudentSessionLogCard({required this.session});

  final SessionRecord session;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${session.gameTitle} · Nivel ${session.level}',
                  style: AppTypography.titleSmall,
                ),
                Text(
                  '${session.completedAtIso} · ${session.correctAnswers}/${session.totalAttempts} aciertos',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: Formatters.percentage(session.accuracy.round()),
            variant: session.accuracy >= 80
                ? StatusBadgeVariant.success
                : StatusBadgeVariant.warning,
          ),
        ],
      ),
    );
  }
}
