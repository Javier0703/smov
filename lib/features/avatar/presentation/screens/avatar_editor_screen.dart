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
                if (!await viewModel.saveChanges()) return;
              } else {
                viewModel.discardChanges();
              }
              onBackOrSaved();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AvatarLivePreviewHeader(
                  config: draft,
                  explorerName: viewModel.explorerName,
                  hasUnsavedChanges: viewModel.hasUnsavedChanges,
                  onNameChanged: viewModel.setExplorerName,
                ),
                if (viewModel.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    viewModel.errorMessage!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                          options: <AvatarChoiceItem<AvatarOutfit>>[
                            AvatarChoiceItem(
                              value: AvatarOutfit.tshirt,
                              label: 'Camiseta de manga corta',
                              swatchColor: Color(0xFF29E1B4),
                            ),
                            AvatarChoiceItem(
                              value: AvatarOutfit.redHoodie,
                              label: 'Sudadera roja',
                              swatchColor: Color(0xFFD64045),
                            ),
                            AvatarChoiceItem(
                              value: AvatarOutfit.schoolTracksuit,
                              label: 'Chándal del colegio',
                              swatchColor: Color(0xFF17257C),
                            ),
                            if (viewModel.ownedCosmetics.contains(
                              'explorer_jacket',
                            ))
                              const AvatarChoiceItem(
                                value: AvatarOutfit.explorerJacket,
                                label: 'Chaqueta exploradora',
                                swatchColor: Color(0xFF19D88D),
                              ),
                          ],
                        ),
                        if (viewModel.ownedCosmetics.contains(
                          'compass_badge',
                        )) ...[
                          const SizedBox(height: AppSpacing.sm),
                          AvatarOptionSelectorCard<AvatarAccessory>(
                            title: 'Accesorios',
                            selectedValue: draft.accessory,
                            onSelected: viewModel.setAccessory,
                            options: const <AvatarChoiceItem<AvatarAccessory>>[
                              AvatarChoiceItem(
                                value: AvatarAccessory.none,
                                label: 'Sin accesorio',
                                icon: Icons.face_rounded,
                              ),
                              AvatarChoiceItem(
                                value: AvatarAccessory.compassBadge,
                                label: 'Insignia de brújula',
                                icon: Icons.explore_rounded,
                              ),
                            ],
                          ),
                        ],
                        if (viewModel.ownedCosmetics.contains(
                          'golden_avatar',
                        )) ...[
                          const SizedBox(height: AppSpacing.sm),
                          AvatarOptionSelectorCard<AvatarSpecialStyle>(
                            title: 'Avatar especial',
                            selectedValue: draft.specialStyle,
                            onSelected: viewModel.setSpecialStyle,
                            options:
                                const <AvatarChoiceItem<AvatarSpecialStyle>>[
                                  AvatarChoiceItem(
                                    value: AvatarSpecialStyle.classic,
                                    label: 'Explorador clásico',
                                    icon: Icons.person_rounded,
                                  ),
                                  AvatarChoiceItem(
                                    value: AvatarSpecialStyle.goldenExplorer,
                                    label: 'Explorador dorado',
                                    swatchColor: Color(0xFFF2B544),
                                  ),
                                ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        AppPrimaryButton(
                          label: AppStrings.avatarSaveButton,
                          icon: Icons.check_circle_rounded,
                          isLoading: viewModel.isSaving,
                          onPressed: viewModel.canSave
                              ? () async {
                                  final ok = await viewModel.saveChanges();
                                  if (ok) {
                                    onBackOrSaved();
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarLivePreviewHeader extends StatefulWidget {
  const _AvatarLivePreviewHeader({
    required this.config,
    required this.explorerName,
    required this.hasUnsavedChanges,
    required this.onNameChanged,
  });

  final AvatarConfig config;
  final String explorerName;
  final bool hasUnsavedChanges;
  final ValueChanged<String> onNameChanged;

  @override
  State<_AvatarLivePreviewHeader> createState() =>
      _AvatarLivePreviewHeaderState();
}

class _AvatarLivePreviewHeaderState extends State<_AvatarLivePreviewHeader> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.explorerName);
  }

  @override
  void didUpdateWidget(covariant _AvatarLivePreviewHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.explorerName != widget.explorerName &&
        _nameController.text != widget.explorerName) {
      _nameController.value = TextEditingValue(
        text: widget.explorerName,
        selection: TextSelection.collapsed(offset: widget.explorerName.length),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          ExplorerAvatarWidget(
            config: widget.config,
            size: 112,
            backgroundColor: AppColors.surfaceMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: widget.hasUnsavedChanges
                      ? 'Cambios en vista previa'
                      : 'Personaje guardado',
                  variant: widget.hasUnsavedChanges
                      ? StatusBadgeVariant.warning
                      : StatusBadgeVariant.success,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Nombre del explorador',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                TextFormField(
                  maxLength: 24,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un nombre',
                    counterText: '',
                    isDense: true,
                  ),
                  controller: _nameController,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                  onChanged: widget.onNameChanged,
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
