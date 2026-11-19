import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/student_activity_model.dart';
import '../services/statistics_service.dart';

/// Repositorio de `Mi actividad` con cálculo ponderado de aciertos.
class StatisticsRepository {
  StatisticsRepository({required this._service});

  final StatisticsService _service;

  Result<StudentActivityModel> loadStudentActivity() {
    try {
      final user = _service.getCurrentUser();
      final sessions = _service.fetchStudentSessions('student_alex');

      var sumCorrect = 0;
      var sumAttempts = 0;
      var totalCoinsEarned = 0;
      for (final s in sessions) {
        sumCorrect += s.correctAnswers;
        sumAttempts += s.totalAttempts;
        totalCoinsEarned += s.coinsEarned;
      }
      final weightedPct = sumAttempts == 0
          ? 0
          : ((sumCorrect / sumAttempts) * 100).round();

      const competencies = <CompetencyStatBar>[
        CompetencyStatBar(
          title: 'Orientación y puntos cardinales',
          subtitle: '¡Rumbo desconocido! y La brújula perdida',
          percentage: 86,
        ),
        CompetencyStatBar(
          title: 'Lectura de mapas, leyendas y recorridos',
          subtitle: '¡Encuentra el lugar!, Llegar a tiempo y Tesoro secreto',
          percentage: 82,
        ),
        CompetencyStatBar(
          title: 'Territorio: Comunidades y Castilla y León',
          subtitle: 'España en tus manos y El viaje por España',
          percentage: 90,
        ),
      ];

      return Success<StudentActivityModel>(
        StudentActivityModel(
          user: user,
          weightedAccuracyPercent: weightedPct,
          totalSessionsCount: sessions.length,
          totalCorrectAnswers: sumCorrect,
          totalAttempts: sumAttempts,
          totalCoinsEarned: totalCoinsEarned,
          mostDifficultGameTitle: _mostDifficultGame(sessions),
          competencies: competencies,
          recentSessions: sessions,
        ),
      );
    } catch (e) {
      return Error<StudentActivityModel>(
        CacheFailure('No se pudo cargar tu actividad: $e'),
      );
    }
  }

  String _mostDifficultGame(List<SessionRecord> sessions) {
    final grouped = <String, List<SessionRecord>>{};
    for (final session in sessions) {
      grouped.putIfAbsent(session.gameId, () => <SessionRecord>[]).add(session);
    }
    if (grouped.isEmpty) return 'Sin datos suficientes';

    int accuracy(List<SessionRecord> gameSessions) {
      final attempts = gameSessions.fold<int>(
        0,
        (sum, session) => sum + session.totalAttempts,
      );
      if (attempts == 0) return 100;
      final correct = gameSessions.fold<int>(
        0,
        (sum, session) => sum + session.correctAnswers,
      );
      return (correct * 100 / attempts).round();
    }

    final hardest = grouped.entries.reduce(
      (current, next) =>
          accuracy(next.value) < accuracy(current.value) ? next : current,
    );
    return hardest.value.first.gameTitle;
  }
}
