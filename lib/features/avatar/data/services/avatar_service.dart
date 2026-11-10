import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Servicio de persistencia de la configuración del avatar explorador.
class AvatarService {
  AvatarService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  Future<AvatarConfig> saveAvatarConfig(AvatarConfig config) async {
    _store.updateAvatarConfig(config);
    return _store.currentUser.avatarConfig;
  }
}
