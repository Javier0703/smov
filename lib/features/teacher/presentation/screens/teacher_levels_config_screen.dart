import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../data/models/teacher_models.dart';
import '../viewmodels/teacher_viewmodel.dart';
import '../widgets/teacher_nav_tabs_bar.dart';

/// Pantalla `Niveles para mi clase — Configura el recorrido de 4.º A` (`/levels`).
class TeacherLevelsConfigScreen extends StatelessWidget {
  const TeacherLevelsConfigScreen({
    super.key,
    required this.viewModel,
    required this.onNavigateRoute,
  });

  final TeacherViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final classId = viewModel.selectedClassId;
        final policies = viewModel.levelPolicies;

        return AdventureScaffold(
          maxContentWidth: 1080,
          topBar: AppTopBar(
            title: 'Niveles para mi clase — Configura el recorrido de $classId',
            subtitle: 'Activa o bloquea en vivo los niveles 1, 2 y 3 para tus alumnos',
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
                  activeTabIndex: 2,
                  onNavigateRoute: onNavigateRoute,
                ),
                const SizedBox(height: AppSpacing.md),
                _CourseGradeSelector(
                  grade: viewModel.selectedCourseGrade,
                  onChanged: viewModel.selectCourseGrade,
                ),
                const SizedBox(height: AppSpacing.md),
                _ClassPolicyHeaderBanner(classId: classId),
                const SizedBox(height: AppSpacing.md),
                for (final item in policies) ...[
                  _GameLevelPolicyCard(
                    item: item,
                    onToggleGame: (enabled) {
                      viewModel.toggleGame(
                        gameId: item.gameId,
                        enabled: enabled,
                      );
                    },
                    onToggleLevel: (levelNum, enabled) {
                      viewModel.toggleGameLevel(
                        gameId: item.gameId,
                        levelNumber: levelNum,
                        enabled: enabled,
                      );
                    },
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

class _CourseGradeSelector extends StatelessWidget {
  const _CourseGradeSelector({required this.grade, required this.onChanged});

  final int grade;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: AppColors.surfaceMuted,
      child: Row(
        children: [
          const Icon(Icons.school_rounded, color: AppColors.brandPrimary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curso escolar',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                Text(
                  'Los niveles avanzados se bloquean según el curso.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<int>(
            value: grade,
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
            items: List<DropdownMenuItem<int>>.generate(
              6,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}.º Primaria'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassPolicyHeaderBanner extends StatelessWidget {
  const _ClassPolicyHeaderBanner({required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: AppColors.surfaceMuted,
      child: Row(
        children: [
          const Icon(
            Icons.tune_rounded,
            color: AppColors.brandPrimary,
            size: 26,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Los cambios se aplican al instante en el catálogo de $classId. Por ejemplo, puedes habilitar el Nivel 3 ("Provincias de España") en "España en tus manos" cuando la clase haya consolidado "Castilla y León".',
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

class _GameLevelPolicyCard extends StatelessWidget {
  const _GameLevelPolicyCard({
    required this.item,
    required this.onToggleGame,
    required this.onToggleLevel,
  });

  final GameLevelPolicyItem item;
  final ValueChanged<bool> onToggleGame;
  final void Function(int levelNumber, bool enabled) onToggleLevel;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      label:
                          '${item.orderNumber.toString().padLeft(2, '0')} · ${item.competencyTag}',
                      variant: StatusBadgeVariant.brand,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.gameTitle,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Juego activo',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  Switch(
                    value: item.isGameEnabled,
                    activeTrackColor: AppColors.brandAccent,
                    activeThumbColor: AppColors.brandPrimary,
                    onChanged: onToggleGame,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          StatusBadge(
            label:
                '${item.enabledLevels.length}/3 niveles activos${item.isGameEnabled ? '' : ' · juego bloqueado'}',
            variant: item.isGameEnabled
                ? StatusBadgeVariant.success
                : StatusBadgeVariant.warning,
          ),
          const SizedBox(height: AppSpacing.xs),
          _LevelSwitchRow(
            label: item.level1Label,
            levelNumber: 1,
            enabled: item.enabledLevels.contains(1),
            isLocked: 1 > item.maximumAllowedLevel,
            gameEnabled: item.isGameEnabled,
            onChanged: (val) => onToggleLevel(1, val),
          ),
          _LevelSwitchRow(
            label: item.level2Label,
            levelNumber: 2,
            enabled: item.enabledLevels.contains(2),
            isLocked: 2 > item.maximumAllowedLevel,
            gameEnabled: item.isGameEnabled,
            onChanged: (val) => onToggleLevel(2, val),
          ),
          _LevelSwitchRow(
            label: item.level3Label,
            levelNumber: 3,
            enabled: item.enabledLevels.contains(3),
            isLocked: 3 > item.maximumAllowedLevel,
            gameEnabled: item.isGameEnabled,
            onChanged: (val) => onToggleLevel(3, val),
          ),
        ],
      ),
    );
  }
}

class _LevelSwitchRow extends StatelessWidget {
  const _LevelSwitchRow({
    required this.label,
    required this.levelNumber,
    required this.enabled,
    required this.isLocked,
    required this.gameEnabled,
    required this.onChanged,
  });

  final String label;
  final int levelNumber;
  final bool enabled;
  final bool isLocked;
  final bool gameEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final canChange = !isLocked && gameEnabled;
    final suffix = isLocked
        ? ' · Disponible desde $levelNumber.º Primaria'
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label$suffix',
              style: AppTypography.bodyMedium.copyWith(
                color: canChange ? AppColors.inkStrong : AppColors.textMuted,
              ),
            ),
          ),
          Switch(
            value: enabled,
            activeTrackColor: AppColors.brandAccent,
            activeThumbColor: AppColors.brandPrimary,
            onChanged: canChange ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
