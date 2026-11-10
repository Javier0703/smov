import '../../../../shared/models/user_model.dart';

/// Modelo de estado del editor de personaje (`Tu personaje, a tu manera`).
class AvatarEditorStateModel {
  const AvatarEditorStateModel({
    required this.savedConfig,
    required this.draftConfig,
    required this.explorerName,
  });

  final AvatarConfig savedConfig;
  final AvatarConfig draftConfig;
  final String explorerName;

  bool get hasUnsavedChanges => savedConfig != draftConfig;
}
