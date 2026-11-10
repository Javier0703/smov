import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../../../../shared/widgets/cards/app_base_card.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/welcome_hero_card.dart';

/// Pantalla `Bienvenida — Aventura de exploradores` (`/welcome`).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.viewModel,
    required this.onEnterStudentHome,
    required this.onOpenAvatarEditor,
    required this.onEnterTeacherSpace,
  });

  final AuthViewModel viewModel;
  final VoidCallback onEnterStudentHome;
  final VoidCallback onOpenAvatarEditor;
  final VoidCallback onEnterTeacherSpace;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final avatarConfig =
            viewModel.currentUser?.avatarConfig ?? const AvatarConfig();

        return Scaffold(
          backgroundColor: AppColors.surfaceCanvas,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WelcomeHeroCard(
                        avatarConfig: avatarConfig,
                        selectedClassId: viewModel.selectedClassId,
                        availableClasses: viewModel.availableClasses,
                        onClassSelected: viewModel.selectClass,
                        onCustomizeAvatarTap: onOpenAvatarEditor,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _WelcomeExpeditionPreviewCard(),
                      const SizedBox(height: AppSpacing.lg),
                      AppPrimaryButton(
                        label: AppStrings.welcomeStartButton,
                        icon: Icons.rocket_launch_rounded,
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          final ok = await viewModel.enterAsStudent();
                          if (ok) {
                            onEnterStudentHome();
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppSecondaryButton(
                        label: AppStrings.welcomeCustomizeAvatarButton,
                        icon: Icons.face_retouching_natural_rounded,
                        onPressed: onOpenAvatarEditor,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _TeacherEntryCard(
                        selectedClassId: viewModel.selectedClassId,
                        onTap: () async {
                          final ok = await viewModel.enterAsTeacher();
                          if (ok) {
                            onEnterTeacherSpace();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeExpeditionPreviewCard extends StatelessWidget {
  const _WelcomeExpeditionPreviewCard();

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.map_rounded,
                color: AppColors.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Mapa interactivo de la expedición',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const SpainVectorMapWidget(
            completedRegionIds: <String>{
              'castilla_y_leon',
              'galicia',
              'asturias',
              'madrid',
              'andalucia',
            },
            routeRegionIds: <String>[
              'galicia',
              'castilla_y_leon',
              'madrid',
              'andalucia',
            ],
          ),
        ],
      ),
    );
  }
}

class _TeacherEntryCard extends StatelessWidget {
  const _TeacherEntryCard({required this.selectedClassId, required this.onTap});

  final String selectedClassId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      onTap: onTap,
      backgroundColor: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              Icons.co_present_rounded,
              color: AppColors.brandPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeTeacherAccessButton,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
                Text(
                  'Actividad de $selectedClassId, ficha de alumno, niveles y editor de preguntas',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}
