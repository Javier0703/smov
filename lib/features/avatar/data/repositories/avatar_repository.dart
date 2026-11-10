import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/avatar_editor_state_model.dart';
import '../services/avatar_service.dart';

/// Repositorio del editor de personaje explorador.
class AvatarRepository {
  AvatarRepository({required this._service});

  final AvatarService _service;

  Result<AvatarEditorStateModel> loadAvatarEditorState() {
    try {
      final user = _service.getCurrentUser();
      return Success<AvatarEditorStateModel>(
        AvatarEditorStateModel(
          savedConfig: user.avatarConfig,
          draftConfig: user.avatarConfig,
          explorerName: user.displayName,
        ),
      );
    } catch (e) {
      return Error<AvatarEditorStateModel>(
        ValidationFailure('No se pudo cargar tu personaje: $e'),
      );
    }
  }

  Future<Result<AvatarConfig>> saveAvatarConfig(AvatarConfig config) async {
    try {
      final saved = await _service.saveAvatarConfig(config);
      return Success<AvatarConfig>(saved);
    } catch (e) {
      return Error<AvatarConfig>(
        CacheFailure('No se pudo guardar el personaje: $e'),
      );
    }
  }
}
