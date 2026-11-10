import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
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
      for (final s in sessions) {
        sumCorrect += s.correctAnswers;
        sumAttempts += s.totalAttempts;
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
}
