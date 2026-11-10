import '../../../../shared/models/role_enum.dart';
import '../../../../shared/models/user_model.dart';

/// Modelo de sesión de bienvenida e inicio de expedición.
class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.availableClasses,
    required this.selectedClassId,
  });

  final UserModel user;
  final List<String> availableClasses;
  final String selectedClassId;

  bool get isTeacher => user.role == RoleEnum.docente;
}
