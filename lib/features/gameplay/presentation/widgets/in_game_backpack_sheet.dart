import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';

/// Hoja modal / pantalla `Tu mochila en esta prueba` para activar ayudas durante una partida.
class InGameBackpackSheet extends StatelessWidget {
  const InGameBackpackSheet({
    super.key,
    required this.inventoryCounts,
    required this.onUseItem,
    required this.onOpenStore,
  });

  final Map<String, int> inventoryCounts;
  final ValueChanged<String> onUseItem;
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    final lupas = inventoryCounts['magnifying_glass'] ?? 0;
    final relojes = inventoryCounts['hourglass'] ?? 0;
    final brujulas = inventoryCounts['special_compass'] ?? 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const StatusBadge(
                    label: 'AYUDAS EN PARTIDA',
                    variant: StatusBadgeVariant.brand,
                    icon: Icons.backpack_rounded,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.inGameBackpackTitle,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.brandPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Elige una ayuda de tu mochila para aplicarla inmediatamente en esta misión.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _BackpackHelperActionTile(
                icon: Icons.search_rounded,
                title: AppStrings.itemMagnifyingGlass,
                description: 'Resalta la casilla o región correcta y muestra la pista detallada.',
                availableCount: lupas,
                buttonLabel: 'Usar 1 lupa',
                onUse: () {
                  Navigator.of(context).pop();
                  onUseItem('magnifying_glass');
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _BackpackHelperActionTile(
                icon: Icons.hourglass_bottom_rounded,
                title: AppStrings.itemHourglass,
                description: 'Añade +20 segundos extra de margen al temporizador de la ruta.',
                availableCount: relojes,
                buttonLabel: 'Usar reloj de arena',
                onUse: () {
                  Navigator.of(context).pop();
                  onUseItem('hourglass');
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _BackpackHelperActionTile(
                icon: Icons.explore_rounded,
                title: AppStrings.itemSpecialCompass,
                description: 'Calibra automáticamente los puntos cardinales y rumbos en pantalla.',
                availableCount: brujulas,
                buttonLabel: 'Usar brújula especial',
                onUse: () {
                  Navigator.of(context).pop();
                  onUseItem('special_compass');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppSecondaryButton(
                label: 'Ir a Mi mochila para canjear más ayudas',
                icon: Icons.storefront_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  onOpenStore();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackpackHelperActionTile extends StatelessWidget {
  const _BackpackHelperActionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.availableCount,
    required this.buttonLabel,
    required this.onUse,
  });

  final IconData icon;
  final String title;
  final String description;
  final int availableCount;
  final String buttonLabel;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    final hasStock = availableCount > 0;
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: hasStock ? Colors.white : AppColors.surfaceMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandAccent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: AppColors.brandPrimary, size: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.inkStrong,
                      ),
                    ),
                    Text(
                      'Disponibles en mochila: $availableCount',
                      style: AppTypography.labelSmall.copyWith(
                        color: hasStock
                            ? AppColors.brandPrimary
                            : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            label: hasStock ? buttonLabel : 'Sin unidades disponibles',
            onPressed: hasStock ? onUse : null,
          ),
        ],
      ),
    );
  }
}
