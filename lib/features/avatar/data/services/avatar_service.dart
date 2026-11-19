import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Servicio de persistencia de la configuración del avatar explorador.
class AvatarService {
  AvatarService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  Set<String> getOwnedCosmetics() {
    return _store.inventoryCounts.keys
        .where((itemId) => (_store.inventoryCounts[itemId] ?? 0) > 0)
        .toSet();
  }

  Future<UserModel> saveAvatarConfig({
    required AvatarConfig config,
    required String displayName,
  }) async {
    _store.updateAvatarConfig(config, displayName: displayName);
    return _store.currentUser;
  }
}
