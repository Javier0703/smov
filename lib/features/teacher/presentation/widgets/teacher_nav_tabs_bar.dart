import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Barra de pestañas de navegación del Espacio Docente.
class TeacherNavTabsBar extends StatelessWidget {
  const TeacherNavTabsBar({
    super.key,
    required this.activeTabIndex,
    required this.onNavigateRoute,
  });

  final int activeTabIndex;
  final ValueChanged<String> onNavigateRoute;

  @override
  Widget build(BuildContext context) {
    const items = <(int, String, IconData, String)>[
      (
        0,
        'Actividad de 4.º A',
        Icons.analytics_outlined,
        '/teacher/classes/4A/activity',
      ),
      (
        1,
        'Ficha de alumno',
        Icons.person_search_rounded,
        '/students/student_alex',
      ),
      (2, 'Niveles de clase', Icons.tune_rounded, '/levels'),
      (
        3,
        'Editor de preguntas',
        Icons.edit_note_rounded,
        '/questions/q_default',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in items) ...[
            _TeacherTabPill(
              label: item.$2,
              icon: item.$3,
              isSelected: activeTabIndex == item.$1,
              onTap: () => onNavigateRoute(item.$4),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          _TeacherTabPill(
            label: 'Vista alumno (Inicio)',
            icon: Icons.explore_outlined,
            isSelected: false,
            onTap: () => onNavigateRoute('/home'),
          ),
        ],
      ),
    );
  }
}

class _TeacherTabPill extends StatelessWidget {
  const _TeacherTabPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandPrimary
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(
              color: isSelected
                  ? AppColors.brandPrimary
                  : AppColors.borderDefault,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.brandPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.brandPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
