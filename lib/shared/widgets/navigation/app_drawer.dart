import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../models/user_model.dart';

/// Menú lateral de navegación rápida escolar para cambiar de vista o paleta cromática.
class AppDrawer extends StatelessWidget {
  final UserModel? user;
  final String? currentRoute;
  final ValueChanged<String>? onNavigate;
  final VoidCallback? onSwitchRole;
  final String? explorerName;
  final String? className;
  final VoidCallback? onOpenHome;
  final VoidCallback? onOpenAdventures;
  final VoidCallback? onOpenMedals;
  final VoidCallback? onOpenPassport;
  final VoidCallback? onOpenInventory;
  final VoidCallback? onOpenActivity;
  final VoidCallback? onOpenAvatar;
  final VoidCallback? onOpenTeacherSpace;

  const AppDrawer({
    super.key,
    this.user,
    this.currentRoute,
    this.onNavigate,
    this.onSwitchRole,
    this.explorerName,
    this.className,
    this.onOpenHome,
    this.onOpenAdventures,
    this.onOpenMedals,
    this.onOpenPassport,
    this.onOpenInventory,
    this.onOpenActivity,
    this.onOpenAvatar,
    this.onOpenTeacherSpace,
  });

  @override
  Widget build(BuildContext context) {
    final display = user?.displayName ?? explorerName ?? 'Alex';
    final group = user?.classId ?? className ?? '4.º A';

    void go(String route, VoidCallback? callback) {
      Navigator.of(context).pop();
      if (callback != null) {
        callback();
      } else {
        onNavigate?.call(route);
      }
    }

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: <Widget>[
                  Text(
                    display,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    'Clase $group · Brújula Quest',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _DrawerTile(
              icon: Icons.home_rounded,
              label: 'Inicio',
              onTap: () => go('/home', onOpenHome),
            ),
            _DrawerTile(
              icon: Icons.map_rounded,
              label: 'Misiones (10 juegos)',
              onTap: () => go('/adventures', onOpenAdventures),
            ),
            _DrawerTile(
              icon: Icons.workspace_premium_rounded,
              label: 'Mi medallero',
              onTap: () => go('/medals', onOpenMedals),
            ),
            _DrawerTile(
              icon: Icons.menu_book_rounded,
              label: 'Mi pasaporte',
              onTap: () => go('/passport', onOpenPassport),
            ),
            _DrawerTile(
              icon: Icons.backpack_rounded,
              label: 'Mi mochila',
              onTap: () => go('/inventory', onOpenInventory),
            ),
            _DrawerTile(
              icon: Icons.insights_rounded,
              label: 'Mi actividad',
              onTap: () => go('/activity', onOpenActivity),
            ),
            _DrawerTile(
              icon: Icons.face_retouching_natural_rounded,
              label: 'Mi personaje',
              onTap: () => go('/avatar', onOpenAvatar),
            ),
            const Divider(height: AppSpacing.lg),
            _DrawerTile(
              icon: Icons.school_rounded,
              label: 'Espacio docente',
              onTap: () => go(
                '/teacher/classes/4A/activity',
                onSwitchRole ?? onOpenTeacherSpace,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      onTap: onTap,
    );
  }
}
