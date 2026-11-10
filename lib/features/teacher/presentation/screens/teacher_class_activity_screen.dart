import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/info_tile.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../data/models/teacher_models.dart';
import '../viewmodels/teacher_viewmodel.dart';
import '../widgets/teacher_nav_tabs_bar.dart';

/// Pantalla `Espacio docente — Actividad de 4.º A` (`/teacher/classes/:classId/activity`).
class TeacherClassActivityScreen extends StatelessWidget {
  const TeacherClassActivityScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
    required this.onOpenStudentDetail,
  });

  final TeacherViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;
  final ValueChanged<String> onOpenStudentDetail;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final dashboard = viewModel.classDashboard;
        if (dashboard == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AdventureScaffold(
          maxContentWidth: 1080,
          topBar: AppTopBar(
            title: 'Espacio docente — Actividad de ${dashboard.classId}',
            subtitle: 'Seguimiento pedagógico ponderado del grupo',
            showBackButton: true,
            onBackPressed: () => onNavigateRoute('/home'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TeacherNavTabsBar(
                  activeTabIndex: 0,
                  onNavigateRoute: onNavigateRoute,
                ),
                const SizedBox(height: AppSpacing.md),
                _ClassKpiSummaryRow(dashboard: dashboard),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alumnado de ${dashboard.classId}',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    const StatusBadge(
                      label: 'Toca un alumno para ver su ficha',
                      variant: StatusBadgeVariant.brand,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final student in dashboard.students) ...[
                  _StudentRosterRowCard(
                    student: student,
                    onTap: () {
                      viewModel.selectStudent(student.studentId);
                      onOpenStudentDetail(student.studentId);
                    },
                  ),
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

class _ClassKpiSummaryRow extends StatelessWidget {
  const _ClassKpiSummaryRow({required this.dashboard});

  final ClassActivityDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoTile(
            value: Formatters.percentage(
              dashboard.weightedClassAccuracyPercent,
            ),
            label: 'Precisión ponderada',
            icon: Icons.analytics_rounded,
            accentColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: '${dashboard.activeStudentsCount}',
            label: 'Alumnos activos',
            icon: Icons.groups_rounded,
            accentColor: AppColors.brandPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: InfoTile(
            value: Formatters.percentage(dashboard.averageRouteProgressPercent),
            label: 'Avance de ruta',
            icon: Icons.route_rounded,
            accentColor: AppColors.brandAccent,
          ),
        ),
      ],
    );
  }
}

class _StudentRosterRowCard extends StatelessWidget {
  const _StudentRosterRowCard({required this.student, required this.onTap});

  final StudentRosterSummary student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          ExplorerAvatarWidget(
            config: student.avatarConfig,
            size: 52,
            backgroundColor: AppColors.surfaceMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student.displayName,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.inkStrong,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    StatusBadge(
                      label: '${student.completedMissions} misiones',
                      variant: StatusBadgeVariant.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Fortaleza: ${student.strengthTopic}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(
                label:
                    '${Formatters.percentage(student.weightedAccuracyPercent)} acierto',
                variant: student.weightedAccuracyPercent >= 80
                    ? StatusBadgeVariant.success
                    : StatusBadgeVariant.warning,
              ),
              const SizedBox(height: 4),
              Text(
                '${student.medalsCount}/8 medallas · ${student.stampedCommunitiesCount} sellos',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}
