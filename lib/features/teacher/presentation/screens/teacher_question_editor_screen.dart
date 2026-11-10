import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/cards/status_badge.dart';
import '../../../../shared/widgets/inputs/app_dropdown_field.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/navigation/adventure_scaffold.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../viewmodels/teacher_viewmodel.dart';
import '../widgets/teacher_nav_tabs_bar.dart';

/// Pantalla `Editor de preguntas — Adapta una prueba a tu clase` (`/questions/:questionId`).
class TeacherQuestionEditorScreen extends StatefulWidget {
  const TeacherQuestionEditorScreen({
    super.key,
    required this.questionId,
    required this.viewModel,
    required this.onNavigateRoute,
  });

  final String questionId;
  final TeacherViewModel viewModel;
  final ValueChanged<String> onNavigateRoute;

  @override
  State<TeacherQuestionEditorScreen> createState() =>
      _TeacherQuestionEditorScreenState();
}

class _TeacherQuestionEditorScreenState
    extends State<TeacherQuestionEditorScreen> {
  late final TextEditingController _promptController;
  late final TextEditingController _correctController;
  late final TextEditingController _distractorAController;
  late final TextEditingController _distractorBController;
  late final TextEditingController _hintController;

  @override
  void initState() {
    super.initState();
    final draft = widget.viewModel.questionDraft;
    _promptController = TextEditingController(text: draft.prompt);
    _correctController = TextEditingController(text: draft.correctOption);
    _distractorAController = TextEditingController(text: draft.distractorA);
    _distractorBController = TextEditingController(text: draft.distractorB);
    _hintController = TextEditingController(text: draft.hint);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _correctController.dispose();
    _distractorAController.dispose();
    _distractorBController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final draft = vm.questionDraft;

        return AdventureScaffold(
          maxContentWidth: 1080,
          topBar: AppTopBar(
            title: AppStrings.questionEditorTitle,
            subtitle: 'Clase ${vm.selectedClassId} · ${draft.updatedAtIso}',
            showBackButton: true,
            onBackPressed: () =>
                widget.onNavigateRoute('/teacher/classes/4A/activity'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TeacherNavTabsBar(
                  activeTabIndex: 3,
                  onNavigateRoute: widget.onNavigateRoute,
                ),
                const SizedBox(height: AppSpacing.md),
                _QuestionFormCard(
                  viewModel: vm,
                  promptController: _promptController,
                  correctController: _correctController,
                  distractorAController: _distractorAController,
                  distractorBController: _distractorBController,
                  hintController: _hintController,
                ),
                const SizedBox(height: AppSpacing.md),
                _QuestionLivePreviewCard(draft: draft),
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: 'Publicar en ${vm.selectedClassId}',
                  icon: Icons.publish_rounded,
                  onPressed: () {
                    final ok = vm.publishQuestionToClass();
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            vm.statusFeedbackMessage ??
                                'Pregunta publicada en la clase.',
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                AppSecondaryButton(
                  label: AppStrings.questionSaveDraftButton,
                  icon: Icons.save_outlined,
                  onPressed: () {
                    final ok = vm.saveDraftOnly();
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Borrador guardado correctamente.'),
                        ),
                      );
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

class _QuestionFormCard extends StatelessWidget {
  const _QuestionFormCard({
    required this.viewModel,
    required this.promptController,
    required this.correctController,
    required this.distractorAController,
    required this.distractorBController,
    required this.hintController,
  });

  final TeacherViewModel viewModel;
  final TextEditingController promptController;
  final TextEditingController correctController;
  final TextEditingController distractorAController;
  final TextEditingController distractorBController;
  final TextEditingController hintController;

  @override
  Widget build(BuildContext context) {
    final draft = viewModel.questionDraft;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(
                label: 'CONFIGURACIÓN DE LA PRUEBA',
                variant: StatusBadgeVariant.brand,
                icon: Icons.edit_note_rounded,
              ),
              const Spacer(),
              StatusBadge(
                label: draft.isPublished ? 'Publicada' : 'En borrador',
                variant: draft.isPublished
                    ? StatusBadgeVariant.success
                    : StatusBadgeVariant.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppDropdownField<String>(
                  label: 'Aventura destino',
                  value: draft.gameId,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'rumbo_desconocido',
                      child: Text('¡Rumbo desconocido!'),
                    ),
                    DropdownMenuItem(
                      value: 'donde_estoy',
                      child: Text('¿Dónde estoy?'),
                    ),
                    DropdownMenuItem(
                      value: 'espana_en_tus_manos',
                      child: Text('España en tus manos'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) viewModel.updateDraftGame(v);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppDropdownField<int>(
                  label: 'Nivel',
                  value: draft.level,
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem(value: 1, child: Text('Nivel 1')),
                    DropdownMenuItem(value: 2, child: Text('Nivel 2')),
                    DropdownMenuItem(value: 3, child: Text('Nivel 3')),
                  ],
                  onChanged: (v) {
                    if (v != null) viewModel.updateDraftLevel(v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label:
                'Enunciado de la pregunta (usa "casillas" en lugar de "pasos")',
            controller: promptController,
            maxLines: 3,
            errorText: viewModel.promptError,
            onChanged: viewModel.updateDraftPrompt,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Respuesta correcta',
            controller: correctController,
            errorText: viewModel.correctOptionError,
            onChanged: viewModel.updateDraftCorrectOption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Opción incorrecta A',
                  controller: distractorAController,
                  errorText: viewModel.distractorAError,
                  onChanged: viewModel.updateDraftDistractorA,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: 'Opción incorrecta B',
                  controller: distractorBController,
                  errorText: viewModel.distractorBError,
                  onChanged: viewModel.updateDraftDistractorB,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Pista pedagógica (visible al usar una Lupa de pistas)',
            controller: hintController,
            onChanged: viewModel.updateDraftHint,
          ),
        ],
      ),
    );
  }
}

class _QuestionLivePreviewCard extends StatelessWidget {
  const _QuestionLivePreviewCard({required this.draft});

  final CustomQuestionData draft;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceElevated,
      borderColor: AppColors.brandPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(
                label: 'VISTA PREVIA EN VIVO PARA EL ALUMNO',
                variant: StatusBadgeVariant.brand,
                icon: Icons.visibility_rounded,
              ),
              const Spacer(),
              Text(
                'Nivel ${draft.level}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            draft.prompt.isEmpty
                ? 'Escribe el enunciado de la pregunta arriba...'
                : draft.prompt,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.inkStrong,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PreviewOptionTile(label: draft.correctOption, isCorrect: true),
          const SizedBox(height: 6),
          _PreviewOptionTile(label: draft.distractorA, isCorrect: false),
          const SizedBox(height: 6),
          _PreviewOptionTile(label: draft.distractorB, isCorrect: false),
          if (draft.hint.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Lupa de pistas: "${draft.hint}"',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.brandPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PreviewOptionTile extends StatelessWidget {
  const _PreviewOptionTile({required this.label, required this.isCorrect});

  final String label;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.borderDefault,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: isCorrect ? AppColors.success : AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label.isEmpty ? 'Opción vacía' : label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkStrong,
                fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
