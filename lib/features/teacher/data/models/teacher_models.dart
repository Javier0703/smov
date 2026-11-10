import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';

/// Resumen individual de un alumno en la tabla del aula (`Actividad de 4.º A`).
class StudentRosterSummary {
  const StudentRosterSummary({
    required this.studentId,
    required this.displayName,
    required this.classId,
    required this.avatarConfig,
    required this.weightedAccuracyPercent,
    required this.totalCorrect,
    required this.totalAttempts,
    required this.completedMissions,
    required this.medalsCount,
    required this.stampedCommunitiesCount,
    required this.strengthTopic,
    required this.reinforcementTopic,
    required this.sessions,
  });

  final String studentId;
  final String displayName;
  final String classId;
  final AvatarConfig avatarConfig;
  final int weightedAccuracyPercent;
  final int totalCorrect;
  final int totalAttempts;
  final int completedMissions;
  final int medalsCount;
  final int stampedCommunitiesCount;
  final String strengthTopic;
  final String reinforcementTopic;
  final List<SessionRecord> sessions;
}

/// Métricas globales ponderadas de una clase (`Actividad de 4.º A`).
class ClassActivityDashboardModel {
  const ClassActivityDashboardModel({
    required this.classId,
    required this.weightedClassAccuracyPercent,
    required this.totalClassCorrect,
    required this.totalClassAttempts,
    required this.activeStudentsCount,
    required this.averageRouteProgressPercent,
    required this.students,
  });

  final String classId;
  final int weightedClassAccuracyPercent;
  final int totalClassCorrect;
  final int totalClassAttempts;
  final int activeStudentsCount;
  final int averageRouteProgressPercent;
  final List<StudentRosterSummary> students;
}

/// Configuración docente de niveles para una aventura concreta.
class GameLevelPolicyItem {
  const GameLevelPolicyItem({
    required this.gameId,
    required this.orderNumber,
    required this.gameTitle,
    required this.competencyTag,
    required this.level1Label,
    required this.level2Label,
    required this.level3Label,
    required this.enabledLevels,
  });

  final String gameId;
  final int orderNumber;
  final String gameTitle;
  final String competencyTag;
  final String level1Label;
  final String level2Label;
  final String level3Label;
  final Set<int> enabledLevels;
}
