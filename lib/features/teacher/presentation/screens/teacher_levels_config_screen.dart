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
                _ClassPolicyHeaderBanner(classId: classId),
                const SizedBox(height: AppSpacing.md),
                for (final item in policies) ...[
                  _GameLevelPolicyCard(
                    item: item,
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
  const _GameLevelPolicyCard({required this.item, required this.onToggleLevel});

  final GameLevelPolicyItem item;
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
              StatusBadge(
                label:
                    '${item.orderNumber.toString().padLeft(2, '0')} · ${item.competencyTag}',
                variant: StatusBadgeVariant.brand,
              ),
              const Spacer(),
              StatusBadge(
                label: '${item.enabledLevels.length}/3 niveles activos',
                variant: StatusBadgeVariant.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.gameTitle,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _LevelSwitchRow(
            label: item.level1Label,
            enabled: item.enabledLevels.contains(1),
            onChanged: (val) => onToggleLevel(1, val),
          ),
          _LevelSwitchRow(
            label: item.level2Label,
            enabled: item.enabledLevels.contains(2),
            onChanged: (val) => onToggleLevel(2, val),
          ),
          _LevelSwitchRow(
            label: item.level3Label,
            enabled: item.enabledLevels.contains(3),
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
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: enabled ? AppColors.inkStrong : AppColors.textMuted,
              ),
            ),
          ),
          Switch(
            value: enabled,
            activeTrackColor: AppColors.brandAccent,
            activeThumbColor: AppColors.brandPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
