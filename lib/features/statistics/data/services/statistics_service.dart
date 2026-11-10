import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Servicio de sesiones del alumno para el cálculo ponderado de actividad.
class StatisticsService {
  StatisticsService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  List<SessionRecord> fetchStudentSessions(String studentId) {
    return _store.sessions.where((s) => s.studentId == studentId).toList();
  }
}
