import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/role_enum.dart';
import '../models/auth_session_model.dart';
import '../services/auth_service.dart';

/// Repositorio de autenticación escolar y selección de grupo/aula.
class AuthRepository {
  AuthRepository({required this._service});

  final AuthService _service;

  Result<AuthSessionModel> loadSession() {
    try {
      final user = _service.getCurrentUser();
      final classes = _service.getAvailableClasses();
      return Success<AuthSessionModel>(
        AuthSessionModel(
          user: user,
          availableClasses: classes,
          selectedClassId: user.classId,
        ),
      );
    } catch (e) {
      return Error<AuthSessionModel>(
        ValidationFailure('No se pudo cargar la sesión: $e'),
      );
    }
  }

  Future<Result<AuthSessionModel>> enterWithRole({
    required RoleEnum role,
    required String classId,
    String? customName,
  }) async {
    try {
      final user = await _service.signInWithRole(
        role: role,
        classId: classId,
        customName: customName,
      );
      return Success<AuthSessionModel>(
        AuthSessionModel(
          user: user,
          availableClasses: _service.getAvailableClasses(),
          selectedClassId: user.classId,
        ),
      );
    } catch (e) {
      return Error<AuthSessionModel>(
        AuthFailure('Error al iniciar sesión escolar: $e'),
      );
    }
  }
}
