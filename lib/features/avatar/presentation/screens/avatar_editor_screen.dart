import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../viewmodels/avatar_viewmodel.dart';
import '../widgets/avatar_option_selector_card.dart';

/// Pantalla `Tu personaje, a tu manera` (`/avatar`).
class AvatarEditorScreen extends StatelessWidget {
  const AvatarEditorScreen({
    super.key,
    required this.viewModel,
    required this.onBackOrSaved,
  });

  final AvatarViewModel viewModel;
  final VoidCallback onBackOrSaved;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final draft = viewModel.draftConfig;

        return AdventureScaffold(
          topBar: AppTopBar(
            title: AppStrings.avatarScreenTitle,
            subtitle: AppStrings.avatarScreenSubtitle,
            showBackButton: true,
            onBackPressed: () async {
              if (!viewModel.hasUnsavedChanges) {
                onBackOrSaved();
                return;
              }
              final shouldSave = await showDialog<bool>(
                context: context,
                builder: (ctx) => const _UnsavedAvatarDialog(),
              );
              if (shouldSave == null) return;
              if (shouldSave) {
                await viewModel.saveChanges();
              } else {
                viewModel.discardChanges();
              }
              onBackOrSaved();
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AvatarLivePreviewHeader(
                  config: draft,
                  explorerName: viewModel.explorerName,
                  hasUnsavedChanges: viewModel.hasUnsavedChanges,
                ),
                const SizedBox(height: AppSpacing.md),
                AvatarOptionSelectorCard<AvatarPresentation>(
                  title: 'Presentación',
                  selectedValue: draft.presentation,
                  onSelected: viewModel.setPresentation,
                  options: const <AvatarChoiceItem<AvatarPresentation>>[
                    AvatarChoiceItem(
                      value: AvatarPresentation.boy,
                      label: 'Niño',
                      icon: Icons.boy_rounded,
                    ),
                    AvatarChoiceItem(
                      value: AvatarPresentation.girl,
                      label: 'Niña',
                      icon: Icons.girl_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AvatarOptionSelectorCard<AvatarHair>(
                  title: 'Peinado',
                  selectedValue: draft.hair,
                  onSelected: viewModel.setHair,
                  options: const <AvatarChoiceItem<AvatarHair>>[
                    AvatarChoiceItem(
                      value: AvatarHair.shortHair,
                      label: 'Corto',
                      swatchColor: Color(0xFF6B3E26),
                    ),
                    AvatarChoiceItem(
                      value: AvatarHair.longHair,
                      label: 'Largo',
                      swatchColor: Color(0xFF4A2816),
                    ),
                    AvatarChoiceItem(
                      value: AvatarHair.curlyHair,
                      label: 'Rizado',
                      swatchColor: Color(0xFF2D1B12),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AvatarOptionSelectorCard<AvatarSkinTone>(
                  title: 'Tono de piel',
                  selectedValue: draft.skinTone,
                  onSelected: viewModel.setSkinTone,
                  options: const <AvatarChoiceItem<AvatarSkinTone>>[
                    AvatarChoiceItem(
                      value: AvatarSkinTone.light,
                      label: 'Claro',
                      swatchColor: Color(0xFFF3C9A8),
                    ),
                    AvatarChoiceItem(
                      value: AvatarSkinTone.medium,
                      label: 'Medio',
                      swatchColor: Color(0xFFE0A97E),
                    ),
                    AvatarChoiceItem(
                      value: AvatarSkinTone.dark,
                      label: 'Moreno',
                      swatchColor: Color(0xFF9C6644),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AvatarOptionSelectorCard<AvatarEyes>(
                  title: 'Color de ojos',
                  selectedValue: draft.eyes,
                  onSelected: viewModel.setEyes,
                  options: const <AvatarChoiceItem<AvatarEyes>>[
                    AvatarChoiceItem(
                      value: AvatarEyes.brown,
                      label: 'Marrón',
                      swatchColor: Color(0xFF101B54),
                    ),
                    AvatarChoiceItem(
                      value: AvatarEyes.green,
                      label: 'Verde',
                      swatchColor: Color(0xFF1E7E48),
                    ),
                    AvatarChoiceItem(
                      value: AvatarEyes.blue,
                      label: 'Azul',
                      swatchColor: Color(0xFF1D63B8),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AvatarOptionSelectorCard<AvatarGlasses>(
                  title: 'Gafas',
                  selectedValue: draft.glasses,
                  onSelected: viewModel.setGlasses,
                  options: const <AvatarChoiceItem<AvatarGlasses>>[
                    AvatarChoiceItem(
                      value: AvatarGlasses.none,
                      label: 'Sin gafas',
                      icon: Icons.visibility_outlined,
                    ),
                    AvatarChoiceItem(
                      value: AvatarGlasses.round,
                      label: 'Gafas redondas',
                      icon: Icons.remove_red_eye_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AvatarOptionSelectorCard<AvatarOutfit>(
                  title: 'Ropa de expedición',
                  selectedValue: draft.outfit,
                  onSelected: viewModel.setOutfit,
                  options: const <AvatarChoiceItem<AvatarOutfit>>[
                    AvatarChoiceItem(
                      value: AvatarOutfit.tshirt,
                      label: 'Camiseta',
                      swatchColor: Color(0xFF29E1B4),
                    ),
                    AvatarChoiceItem(
                      value: AvatarOutfit.redHoodie,
                      label: 'Sudadera roja',
                      swatchColor: Color(0xFFD64045),
                    ),
                    AvatarChoiceItem(
                      value: AvatarOutfit.navyPolo,
                      label: 'Polo azul',
                      swatchColor: Color(0xFF17257C),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: AppStrings.avatarSaveButton,
                  icon: Icons.check_circle_rounded,
                  isLoading: viewModel.isSaving,
                  onPressed: () async {
                    final ok = await viewModel.saveChanges();
                    if (ok) {
                      onBackOrSaved();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarLivePreviewHeader extends StatelessWidget {
  const _AvatarLivePreviewHeader({
    required this.config,
    required this.explorerName,
    required this.hasUnsavedChanges,
  });

  final AvatarConfig config;
  final String explorerName;
  final bool hasUnsavedChanges;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          ExplorerAvatarWidget(
            config: config,
            size: 112,
            backgroundColor: AppColors.surfaceMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: hasUnsavedChanges
                      ? 'Cambios en vista previa'
                      : 'Personaje guardado',
                  variant: hasUnsavedChanges
                      ? StatusBadgeVariant.warning
                      : StatusBadgeVariant.success,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Explorador $explorerName',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tu avatar aparecerá en el pasaporte, el tablero y la ficha de la clase.',
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

class _UnsavedAvatarDialog extends StatelessWidget {
  const _UnsavedAvatarDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Guardar cambios del personaje?'),
      content: const Text(
        'Has modificado el aspecto de tu explorador. ¿Quieres guardar los cambios antes de salir?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Descartar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Guardar y salir'),
        ),
      ],
    );
  }
}
