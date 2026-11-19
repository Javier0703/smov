import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Barra de navegación inferior de destinos principales con píldora turquesa activa.
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;
  final ValueChanged<int>? onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onDestinationSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    void handleSelect(int index) {
      onTap?.call(index);
      onDestinationSelected?.call(index);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderDefault, width: 1.2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (var index = 0; index < 5; index++)
                Expanded(
                  child: _NavDestinationItem(
                    label: switch (index) {
                      0 => AppStrings.navHome,
                      1 => AppStrings.navMissions,
                      2 => AppStrings.navPassport,
                      3 => AppStrings.navMedals,
                      _ => 'Mochila',
                    },
                    icon: switch (index) {
                      0 => Icons.home_outlined,
                      1 => Icons.map_outlined,
                      2 => Icons.menu_book_outlined,
                      3 => Icons.workspace_premium_outlined,
                      _ => Icons.backpack_outlined,
                    },
                    selectedIcon: switch (index) {
                      0 => Icons.home_rounded,
                      1 => Icons.map_rounded,
                      2 => Icons.menu_book_rounded,
                      3 => Icons.workspace_premium_rounded,
                      _ => Icons.backpack_rounded,
                    },
                    isSelected: currentIndex == index,
                    onTap: () => handleSelect(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDestinationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavDestinationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 60,
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                ),
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
