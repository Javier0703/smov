import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/teacher_models.dart';

/// Servicio del Espacio Docente (actividad del aula, fichas de alumno, niveles y preguntas).
class TeacherService {
  TeacherService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  List<SessionRecord> fetchAllSessions() => _store.sessions;

  Set<int> getEnabledLevels(String classId, String gameId) =>
      _store.enabledLevelsForClassGame(classId, gameId);

  void updateLevelPolicy({
    required String classId,
    required String gameId,
    required int level,
    required bool enabled,
  }) {
    _store.toggleLevelPolicy(
      classId: classId,
      gameId: gameId,
      level: level,
      enabled: enabled,
    );
  }

  CustomQuestionData fetchQuestion(String questionId) {
    return _store.customQuestions[questionId] ??
        _store.customQuestions['q_default']!;
  }

  void saveQuestion(CustomQuestionData question) {
    _store.saveCustomQuestion(question);
  }

  List<StudentRosterSummary> buildRosterForClass(String classId) {
    final sessions = _store.sessions;

    StudentRosterSummary buildStudent({
      required String id,
      required String name,
      required AvatarConfig avatar,
      required int completedMissions,
      required int medals,
      required int stamps,
      required String strength,
      required String reinforcement,
    }) {
      final studentSessions = sessions.where((s) => s.studentId == id).toList();
      var sumCorrect = 0;
      var sumAttempts = 0;
      for (final s in studentSessions) {
        sumCorrect += s.correctAnswers;
        sumAttempts += s.totalAttempts;
      }
      final weightedPct = sumAttempts == 0
          ? 80
          : ((sumCorrect / sumAttempts) * 100).round();

      return StudentRosterSummary(
        studentId: id,
        displayName: name,
        classId: classId,
        avatarConfig: avatar,
        weightedAccuracyPercent: weightedPct,
        totalCorrect: sumCorrect,
        totalAttempts: sumAttempts,
        completedMissions: completedMissions,
        medalsCount: medals,
        stampedCommunitiesCount: stamps,
        strengthTopic: strength,
        reinforcementTopic: reinforcement,
        sessions: studentSessions,
      );
    }

    return <StudentRosterSummary>[
      buildStudent(
        id: 'student_alex',
        name: 'Alex',
        avatar: _store.currentUser.avatarConfig,
        completedMissions: 14,
        medals: _store.unlockedMedalNumbers.length,
        stamps: _store.stampedCommunities.length,
        strength: 'Castilla y León y Puntos cardinales',
        reinforcement: 'Provincias costeras y rumbos colaterales (SO/NO)',
      ),
      buildStudent(
        id: 'student_lucia',
        name: 'Lucía',
        avatar: const AvatarConfig(
          presentation: AvatarPresentation.girl,
          hair: AvatarHair.longHair,
          skinTone: AvatarSkinTone.light,
          eyes: AvatarEyes.green,
          glasses: AvatarGlasses.round,
          outfit: AvatarOutfit.redHoodie,
        ),
        completedMissions: 17,
        medals: 7,
        stamps: 12,
        strength: 'Comunidades autónomas e itinerarios',
        reinforcement: 'Rutas contrarreloj por casillas',
      ),
      buildStudent(
        id: 'student_mateo',
        name: 'Mateo',
        avatar: const AvatarConfig(
          presentation: AvatarPresentation.boy,
          hair: AvatarHair.curlyHair,
          skinTone: AvatarSkinTone.medium,
          eyes: AvatarEyes.brown,
          glasses: AvatarGlasses.none,
          outfit: AvatarOutfit.navyPolo,
        ),
        completedMissions: 10,
        medals: 4,
        stamps: 6,
        strength: 'Lectura de símbolos cartográficos',
        reinforcement: 'Orientación con aguja magnética de 8 puntas',
      ),
      buildStudent(
        id: 'student_sofia',
        name: 'Sofía',
        avatar: const AvatarConfig(
          presentation: AvatarPresentation.girl,
          hair: AvatarHair.shortHair,
          skinTone: AvatarSkinTone.dark,
          eyes: AvatarEyes.brown,
          glasses: AvatarGlasses.none,
          outfit: AvatarOutfit.tshirt,
        ),
        completedMissions: 16,
        medals: 6,
        stamps: 11,
        strength: 'Las 9 provincias de Castilla y León',
        reinforcement: 'Coordenadas cruzadas en el plano',
      ),
      buildStudent(
        id: 'student_hugo',
        name: 'Hugo',
        avatar: const AvatarConfig(
          presentation: AvatarPresentation.boy,
          hair: AvatarHair.shortHair,
          skinTone: AvatarSkinTone.light,
          eyes: AvatarEyes.blue,
          glasses: AvatarGlasses.round,
          outfit: AvatarOutfit.redHoodie,
        ),
        completedMissions: 9,
        medals: 3,
        stamps: 5,
        strength: 'Norte, Sur, Este y Oeste',
        reinforcement: 'Límites entre comunidades del interior',
      ),
    ];
  }
}
