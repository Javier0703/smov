import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/teacher_models.dart';
import '../services/teacher_service.dart';

/// Repositorio del Espacio Docente con agregación ponderada de métricas del aula.
class TeacherRepository {
  TeacherRepository({required this._service});

  final TeacherService _service;

  Result<ClassActivityDashboardModel> loadClassActivity(String classId) {
    try {
      final normalizedClass = classId == '4A' ? '4.º A' : classId;
      final students = _service.buildRosterForClass(normalizedClass);

      var sumCorrect = 0;
      var sumAttempts = 0;
      for (final student in students) {
        sumCorrect += student.totalCorrect;
        sumAttempts += student.totalAttempts;
      }
      final weightedClassPct = sumAttempts == 0
          ? 0
          : ((sumCorrect / sumAttempts) * 100).round();

      return Success<ClassActivityDashboardModel>(
        ClassActivityDashboardModel(
          classId: normalizedClass,
          weightedClassAccuracyPercent: weightedClassPct,
          totalClassCorrect: sumCorrect,
          totalClassAttempts: sumAttempts,
          activeStudentsCount: students.length,
          averageRouteProgressPercent: 72,
          students: students,
        ),
      );
    } catch (e) {
      return Error<ClassActivityDashboardModel>(
        CacheFailure('No se pudo cargar la actividad de la clase: $e'),
      );
    }
  }

  Result<StudentRosterSummary> loadStudentDetail(
    String studentId, {
    String classId = '4.º A',
  }) {
    try {
      final students = _service.buildRosterForClass(classId);
      final student =
          students.where((s) => s.studentId == studentId).firstOrNull ??
          students.first;
      return Success<StudentRosterSummary>(student);
    } catch (e) {
      return Error<StudentRosterSummary>(
        CacheFailure('No se pudo cargar la ficha del alumno: $e'),
      );
    }
  }

  Result<List<GameLevelPolicyItem>> loadLevelPoliciesForClass(String classId) {
    try {
      final normalizedClass = classId == '4A' ? '4.º A' : classId;
      final specs = <(String, int, String, String, String, String, String)>[
        (
          'espana_en_tus_manos',
          8,
          'España en tus manos',
          'Territorio',
          '01 · Comunidades autónomas',
          '02 · Castilla y León (9 provincias)',
          '03 · Provincias de España',
        ),
        (
          'rumbo_desconocido',
          1,
          '¡Rumbo desconocido!',
          'Puntos cardinales',
          '01 · Cuatro rumbos (N, S, E, O)',
          '02 · Ocho rumbos y obstáculos',
          '03 · Secuencia encadenada',
        ),
        (
          'brujula_perdida',
          2,
          'La brújula perdida',
          'Orientación',
          '01 · Norte, Sur, Este y Oeste',
          '02 · Rosa completa de 8 puntas',
          '03 · Giros relativos',
        ),
        (
          'encuentra_lugar',
          3,
          '¡Encuentra el lugar!',
          'Lectura de mapas',
          '01 · Coordenadas directas',
          '02 · Posición relativa',
          '03 · Altitud y leyenda',
        ),
        (
          'viaje_por_espana',
          9,
          'El viaje por España',
          'Itinerario autonómico',
          '01 · Ruta Norte-Centro',
          '02 · De costa a costa',
          '03 · Gran vuelta ibérica',
        ),
        (
          'gran_reto',
          10,
          'El gran reto del explorador',
          'Expedición final',
          '01 · Las 7 pruebas oficiales',
          '02 · Expedición experta',
          '03 · Expedición maestra',
        ),
      ];

      final items = specs
          .map(
            (spec) => GameLevelPolicyItem(
              gameId: spec.$1,
              orderNumber: spec.$2,
              gameTitle: spec.$3,
              competencyTag: spec.$4,
              level1Label: spec.$5,
              level2Label: spec.$6,
              level3Label: spec.$7,
              enabledLevels: _service.getEnabledLevels(
                normalizedClass,
                spec.$1,
              ),
            ),
          )
          .toList();

      return Success<List<GameLevelPolicyItem>>(items);
    } catch (e) {
      return Error<List<GameLevelPolicyItem>>(
        CacheFailure('No se pudo cargar la configuración de niveles: $e'),
      );
    }
  }

  void setLevelEnabled({
    required String classId,
    required String gameId,
    required int level,
    required bool enabled,
  }) {
    final normalizedClass = classId == '4A' ? '4.º A' : classId;
    _service.updateLevelPolicy(
      classId: normalizedClass,
      gameId: gameId,
      level: level,
      enabled: enabled,
    );
  }

  CustomQuestionData loadQuestionDraft(String questionId) =>
      _service.fetchQuestion(questionId);

  Result<CustomQuestionData> saveQuestionDraft(CustomQuestionData draft) {
    try {
      _service.saveQuestion(draft);
      return Success<CustomQuestionData>(draft);
    } catch (e) {
      return Error<CustomQuestionData>(
        CacheFailure('No se pudo guardar la pregunta: $e'),
      );
    }
  }
}
