import '../../../../shared/models/role_enum.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Servicio de acceso e identificación de rol escolar.
class AuthService {
  AuthService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  List<String> getAvailableClasses() => const <String>[
    '4.º A',
    '4.º B',
    '5.º A',
  ];

  Future<UserModel> signInWithRole({
    required RoleEnum role,
    required String classId,
    String? customName,
  }) async {
    _store.setRole(role, classId: classId, displayName: customName);
    return _store.currentUser;
  }
}
