import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../buttons/app_primary_button.dart';
import 'app_bottom_navigation_bar.dart';
import 'app_top_bar.dart';

/// Barra inferior de ayuda de partida ("Cómo jugar" + "Mochila") según los 10 frames de juego en Figma.
class AdventureHelpBottomRow extends StatelessWidget {
  final VoidCallback onHowToPlay;
  final VoidCallback onOpenBackpack;
  final String backpackLabel;

  const AdventureHelpBottomRow({
    super.key,
    required this.onHowToPlay,
    required this.onOpenBackpack,
    this.backpackLabel = 'Mochila',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children: <Widget>[
        Expanded(
          child: AppPrimaryButton(
            label: 'Cómo jugar',
            leadingIcon: Icons.menu_book_rounded,
            onPressed: onHowToPlay,
          ),
        ),
        Expanded(
          child: AppPrimaryButton(
            label: backpackLabel,
            leadingIcon: Icons.backpack_outlined,
            onPressed: onOpenBackpack,
          ),
        ),
      ],
    );
  }
}

/// Scaffold responsivo reutilizable para pantallas de Brújula Quest (Especificación 01 y 06).
class AdventureScaffold extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? trailingBadgeText;
  final Widget? trailingWidget;
  final Widget? topBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final double maxContentWidth;
  final Color backgroundColor;
  final Widget body;
  final int? bottomNavIndex;
  final ValueChanged<int>? onBottomNavSelected;

  const AdventureScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.onBack,
    this.trailingBadgeText,
    this.trailingWidget,
    this.topBar,
    this.drawer,
    this.bottomNavigationBar,
    this.maxContentWidth = AppSpacing.maxReadingWidth,
    this.backgroundColor = AppColors.background,
    required this.body,
    this.bottomNavIndex,
    this.onBottomNavSelected,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBottomNav =
        bottomNavigationBar ??
        (bottomNavIndex != null && onBottomNavSelected != null
            ? AppBottomNavigationBar(
                currentIndex: bottomNavIndex!,
                onDestinationSelected: onBottomNavSelected!,
              )
            : null);

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer,
      bottomNavigationBar: effectiveBottomNav,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (topBar != null)
                    topBar!
                  else if (title != null)
                    AppTopBar(
                      title: title!,
                      subtitle: subtitle,
                      onBack: onBack,
                      trailingBadgeText: trailingBadgeText,
                      trailingWidget: trailingWidget,
                    ),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
