import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Dominio por bloque competencial en `Mi actividad`.
class CompetencyStatBar {
  const CompetencyStatBar({
    required this.title,
    required this.subtitle,
    required this.percentage,
  });

  final String title;
  final String subtitle;
  final int percentage;
}

/// Modelo consolidado de `Mi actividad` (`/activity`).
class StudentActivityModel {
  const StudentActivityModel({
    required this.user,
    required this.weightedAccuracyPercent,
    required this.totalSessionsCount,
    required this.totalCorrectAnswers,
    required this.totalAttempts,
    required this.competencies,
    required this.recentSessions,
  });

  final UserModel user;
  final int weightedAccuracyPercent;
  final int totalSessionsCount;
  final int totalCorrectAnswers;
  final int totalAttempts;
  final List<CompetencyStatBar> competencies;
  final List<SessionRecord> recentSessions;
}
