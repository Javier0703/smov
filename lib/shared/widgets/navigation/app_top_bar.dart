import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../buttons/app_icon_button.dart';
import '../cards/status_badge.dart';

/// Cabecera superior con botón circular de retroceso, título, subtítulo, monedas y acciones opcionales.
class AppTopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final int? coins;
  final VoidCallback? onCoinsTap;
  final List<Widget>? actions;
  final String? trailingBadgeText;
  final Widget? trailingWidget;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.onBackPressed,
    this.showBackButton = false,
    this.coins,
    this.onCoinsTap,
    this.actions,
    this.trailingBadgeText,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBack = onBackPressed ?? onBack;
    final hasBack = showBackButton || effectiveBack != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.sm,
        children: <Widget>[
          if (hasBack)
            AppIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Volver atrás',
              onPressed:
                  effectiveBack ??
                  () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (coins != null)
            _CoinsHeaderBadge(coins: coins!, onTap: onCoinsTap),
          if (trailingBadgeText != null)
            StatusBadge(
              text: trailingBadgeText!,
              backgroundColor: AppColors.surfaceVariant,
              textColor: AppColors.primary,
            ),
          ...?actions,
          ?trailingWidget,
        ],
      ),
    );
  }
}

class _CoinsHeaderBadge extends StatelessWidget {
  const _CoinsHeaderBadge({required this.coins, this.onTap});

  final int coins;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4D6),
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          border: Border.all(color: const Color(0xFFF59E0B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on_rounded,
              size: 16,
              color: Color(0xFFD97706),
            ),
            const SizedBox(width: 4),
            Text(
              '$coins',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
