import 'package:flutter/foundation.dart';

import '../../core/theme/app_colors.dart';
import '../models/ciclo_escolar.dart';
import '../models/role_enum.dart';
import '../models/user_model.dart';
import 'local_storage_service.dart';

/// Registro de una sesión de juego completada para estadísticas e idempotencia.
class SessionRecord {
  const SessionRecord({
    required this.sessionId,
    required this.studentId,
    required this.classId,
    required this.gameId,
    required this.gameTitle,
    required this.level,
    required this.correctAnswers,
    required this.totalAttempts,
    required this.durationSeconds,
    required this.coinsEarned,
    required this.completedAtIso,
  });

  final String sessionId;
  final String studentId;
  final String classId;
  final String gameId;
  final String gameTitle;
  final int level;
  final int correctAnswers;
  final int totalAttempts;
  final int durationSeconds;
  final int coinsEarned;
  final String completedAtIso;

  double get accuracy =>
      totalAttempts == 0 ? 0.0 : (correctAnswers / totalAttempts) * 100.0;
}

/// Pregunta editable por el docente (`Adapta una prueba a tu clase`).
class CustomQuestionData {
  const CustomQuestionData({
    required this.questionId,
    required this.classId,
    required this.gameId,
    required this.level,
    required this.prompt,
    required this.correctOption,
    required this.distractorA,
    required this.distractorB,
    required this.hint,
    required this.isPublished,
    required this.updatedAtIso,
  });

  final String questionId;
  final String classId;
  final String gameId;
  final int level;
  final String prompt;
  final String correctOption;
  final String distractorA;
  final String distractorB;
  final String hint;
  final bool isPublished;
  final String updatedAtIso;

  CustomQuestionData copyWith({
    String? classId,
    String? gameId,
    int? level,
    String? prompt,
    String? correctOption,
    String? distractorA,
    String? distractorB,
    String? hint,
    bool? isPublished,
    String? updatedAtIso,
  }) {
    return CustomQuestionData(
      questionId: questionId,
      classId: classId ?? this.classId,
      gameId: gameId ?? this.gameId,
      level: level ?? this.level,
      prompt: prompt ?? this.prompt,
      correctOption: correctOption ?? this.correctOption,
      distractorA: distractorA ?? this.distractorA,
      distractorB: distractorB ?? this.distractorB,
      hint: hint ?? this.hint,
      isPublished: isPublished ?? this.isPublished,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }
}

/// Almacén reactivo de estado local compartido entre los servicios de cada feature.
///
/// Actúa como capa de persistencia en memoria sincronizada con [LocalStorageService],
/// permitiendo que los cambios del docente (ej. bloquear Nivel 3 o publicar una pregunta)
/// o del alumno (canjear monedas, personalizar avatar, ganar sellos) se reflejen en toda la app.
class ExpeditionStateStore extends ChangeNotifier {
  ExpeditionStateStore({required this._localStorage}) {
    _initializeDefaultData();
  }

  final LocalStorageService _localStorage;

  UserModel _currentUser = const UserModel(
    id: 'student_alex',
    displayName: 'Alex',
    username: 'alex.4a',
    role: RoleEnum.estudiante,
    classId: '4.º A',
    cicloEscolar: CicloEscolar.segundoCiclo,
    coins: 240,
    streakDays: 5,
    avatarConfig: AvatarConfig(
      presentation: AvatarPresentation.boy,
      hair: AvatarHair.shortHair,
      skinTone: AvatarSkinTone.light,
      eyes: AvatarEyes.brown,
      glasses: AvatarGlasses.none,
      outfit: AvatarOutfit.tshirt,
    ),
  );

  AppPaletteType _palette = AppPaletteType.oceanAdventure;
  bool _dailyRewardClaimed = false;

  /// Inventario actual del alumno (`magnifying_glass`, `hourglass`, `special_compass`).
  final Map<String, int> _inventoryCounts = <String, int>{
    'magnifying_glass': 2,
    'hourglass': 1,
    'special_compass': 1,
  };

  /// Comunidades autónomas con sello y postal desbloqueados en `Mi pasaporte`.
  final Set<String> _stampedCommunities = <String>{
    'castilla_y_leon',
    'galicia',
    'asturias',
    'cantabria',
    'madrid',
    'andalucia',
    'aragon',
  };

  /// Sellos de orientación cardinal (N, E, S, O) en Inicio.
  final Set<String> _orientationStamps = <String>{'N', 'E', 'S', 'O'};

  /// Medallas desbloqueadas (1..8).
  final Set<int> _unlockedMedalNumbers = <int>{1, 2, 3, 5, 7};

  /// Niveles superados por el alumno en cada juego (`gameId` -> `Set<int>`).
  final Map<String, Set<int>> _completedLevelsByGame = <String, Set<int>>{
    'rumbo_desconocido': <int>{1, 2},
    'brujula_perdida': <int>{1, 2},
    'encuentra_lugar': <int>{1, 2},
    'llegar_a_tiempo': <int>{1},
    'tesoro_secreto': <int>{1, 2},
    'construye_mapa': <int>{1},
    'donde_estoy': <int>{1, 2},
    'espana_en_tus_manos': <int>{1},
    'viaje_por_espana': <int>{1},
    'gran_reto': <int>{},
  };

  /// Política docente de niveles habilitados por clase y juego (`classId` -> `gameId` -> `Set<int>`).
  final Map<String, Map<String, Set<int>>> _enabledLevelsByClass =
      <String, Map<String, Set<int>>>{};

  /// Sesiones históricas para cálculo ponderado de precisión y actividad.
  final List<SessionRecord> _sessions = <SessionRecord>[];

  /// Banco de preguntas adaptadas por el docente.
  final Map<String, CustomQuestionData> _customQuestions =
      <String, CustomQuestionData>{};

  void _initializeDefaultData() {
    const allGames = <String>[
      'rumbo_desconocido',
      'brujula_perdida',
      'encuentra_lugar',
      'llegar_a_tiempo',
      'tesoro_secreto',
      'construye_mapa',
      'donde_estoy',
      'espana_en_tus_manos',
      'viaje_por_espana',
      'gran_reto',
    ];

    for (final classId in const <String>['4.º A', '4.º B', '5.º A']) {
      _enabledLevelsByClass[classId] = <String, Set<int>>{};
      for (final gameId in allGames) {
        // Por defecto en 4.º A: niveles 1 y 2 activos; en España en tus manos 1 y 2 activos, 3 opcional
        if (classId == '4.º A' && gameId == 'espana_en_tus_manos') {
          _enabledLevelsByClass[classId]![gameId] = <int>{1, 2};
        } else {
          _enabledLevelsByClass[classId]![gameId] = <int>{1, 2, 3};
        }
      }
    }

    _sessions.addAll(const <SessionRecord>[
      SessionRecord(
        sessionId: 'seed_alex_1',
        studentId: 'student_alex',
        classId: '4.º A',
        gameId: 'rumbo_desconocido',
        gameTitle: '¡Rumbo desconocido!',
        level: 1,
        correctAnswers: 9,
        totalAttempts: 10,
        durationSeconds: 95,
        coinsEarned: 40,
        completedAtIso: 'Hoy · 10:15',
      ),
      SessionRecord(
        sessionId: 'seed_alex_2',
        studentId: 'student_alex',
        classId: '4.º A',
        gameId: 'brujula_perdida',
        gameTitle: 'La brújula perdida',
        level: 2,
        correctAnswers: 8,
        totalAttempts: 10,
        durationSeconds: 110,
        coinsEarned: 40,
        completedAtIso: 'Hoy · 09:40',
      ),
      SessionRecord(
        sessionId: 'seed_alex_3',
        studentId: 'student_alex',
        classId: '4.º A',
        gameId: 'espana_en_tus_manos',
        gameTitle: 'España en tus manos',
        level: 1,
        correctAnswers: 15,
        totalAttempts: 17,
        durationSeconds: 165,
        coinsEarned: 40,
        completedAtIso: 'Ayer · 17:20',
      ),
      SessionRecord(
        sessionId: 'seed_alex_4',
        studentId: 'student_alex',
        classId: '4.º A',
        gameId: 'tesoro_secreto',
        gameTitle: 'El tesoro secreto',
        level: 1,
        correctAnswers: 7,
        totalAttempts: 9,
        durationSeconds: 120,
        coinsEarned: 40,
        completedAtIso: 'Ayer · 16:05',
      ),
      // Otros alumnos de 4.º A para tabla ponderada del Espacio Docente
      SessionRecord(
        sessionId: 'seed_lucia_1',
        studentId: 'student_lucia',
        classId: '4.º A',
        gameId: 'rumbo_desconocido',
        gameTitle: '¡Rumbo desconocido!',
        level: 2,
        correctAnswers: 19,
        totalAttempts: 20,
        durationSeconds: 88,
        coinsEarned: 40,
        completedAtIso: 'Hoy · 10:22',
      ),
      SessionRecord(
        sessionId: 'seed_mateo_1',
        studentId: 'student_mateo',
        classId: '4.º A',
        gameId: 'brujula_perdida',
        gameTitle: 'La brújula perdida',
        level: 1,
        correctAnswers: 11,
        totalAttempts: 16,
        durationSeconds: 140,
        coinsEarned: 40,
        completedAtIso: 'Hoy · 10:05',
      ),
      SessionRecord(
        sessionId: 'seed_sofia_1',
        studentId: 'student_sofia',
        classId: '4.º A',
        gameId: 'espana_en_tus_manos',
        gameTitle: 'España en tus manos',
        level: 2,
        correctAnswers: 17,
        totalAttempts: 18,
        durationSeconds: 130,
        coinsEarned: 40,
        completedAtIso: 'Ayer · 18:10',
      ),
      SessionRecord(
        sessionId: 'seed_hugo_1',
        studentId: 'student_hugo',
        classId: '4.º A',
        gameId: 'donde_estoy',
        gameTitle: '¿Dónde estoy?',
        level: 1,
        correctAnswers: 9,
        totalAttempts: 15,
        durationSeconds: 155,
        coinsEarned: 40,
        completedAtIso: 'Hace 2 días',
      ),
    ]);

    _customQuestions['q_default'] = const CustomQuestionData(
      questionId: 'q_default',
      classId: '4.º A',
      gameId: 'rumbo_desconocido',
      level: 2,
      prompt: 'Si sales del campamento base y avanzas 3 casillas al Norte y 2 casillas al Este, ¿a qué refugio llegas?',
      correctOption: 'Refugio del Pico Azul (Noreste)',
      distractorA: 'Faro de la Costa Sur',
      distractorB: 'Bosque del Oeste',
      hint: 'Recuerda mirar la brújula: el Norte está arriba y el Este a la derecha.',
      isPublished: true,
      updatedAtIso: 'Publicado en 4.º A',
    );
  }

  UserModel get currentUser => _currentUser;
  AppPaletteType get palette => _palette;
  bool get dailyRewardClaimed => _dailyRewardClaimed;
  Map<String, int> get inventoryCounts =>
      Map<String, int>.unmodifiable(_inventoryCounts);
  Set<String> get stampedCommunities =>
      Set<String>.unmodifiable(_stampedCommunities);
  Set<String> get orientationStamps =>
      Set<String>.unmodifiable(_orientationStamps);
  Set<int> get unlockedMedalNumbers =>
      Set<int>.unmodifiable(_unlockedMedalNumbers);
  List<SessionRecord> get sessions =>
      List<SessionRecord>.unmodifiable(_sessions);
  Map<String, CustomQuestionData> get customQuestions =>
      Map<String, CustomQuestionData>.unmodifiable(_customQuestions);

  int get routeProgressPercent {
    var totalCompleted = 0;
    for (final levels in _completedLevelsByGame.values) {
      totalCompleted += levels.length;
    }
    // 10 juegos * 2 niveles base = 20 hitos principales
    final pct = ((totalCompleted / 20.0) * 100).round();
    return pct.clamp(12, 100);
  }

  void setRole(RoleEnum role, {String? classId, String? displayName}) {
    _currentUser = _currentUser.copyWith(
      role: role,
      classId: classId ?? _currentUser.classId,
      displayName:
          displayName ?? (role == RoleEnum.docente ? 'Prof. Marta' : 'Alex'),
    );
    notifyListeners();
  }

  void setPalette(AppPaletteType newPalette) {
    if (_palette == newPalette) return;
    _palette = newPalette;
    notifyListeners();
  }

  void updateAvatarConfig(AvatarConfig config) {
    _currentUser = _currentUser.copyWith(avatarConfig: config);
    notifyListeners();
  }

  bool claimDailyStreakReward() {
    if (_dailyRewardClaimed) return false;
    _dailyRewardClaimed = true;
    _currentUser = _currentUser.copyWith(
      coins: _currentUser.coins + 25,
      streakDays: _currentUser.streakDays + 1,
    );
    notifyListeners();
    return true;
  }

  Set<int> completedLevelsForGame(String gameId) {
    return Set<int>.unmodifiable(
      _completedLevelsByGame[gameId] ?? const <int>{},
    );
  }

  Set<int> enabledLevelsForClassGame(String classId, String gameId) {
    final classMap =
        _enabledLevelsByClass[classId] ?? _enabledLevelsByClass['4.º A']!;
    return Set<int>.unmodifiable(classMap[gameId] ?? const <int>{1, 2});
  }

  void toggleLevelPolicy({
    required String classId,
    required String gameId,
    required int level,
    required bool enabled,
  }) {
    final classMap = _enabledLevelsByClass.putIfAbsent(
      classId,
      () => <String, Set<int>>{},
    );
    final currentSet = Set<int>.from(classMap[gameId] ?? <int>{1, 2});
    if (enabled) {
      currentSet.add(level);
    } else {
      // El nivel 1 siempre permanece disponible como base pedagógica mínima
      if (level != 1 || currentSet.length > 1) {
        currentSet.remove(level);
      }
    }
    classMap[gameId] = currentSet;
    notifyListeners();
  }

  /// Registra el resultado de una partida de forma idempotente por `sessionId`.
  /// Devuelve las monedas otorgadas en esta llamada (`0` si ya fue procesada).
  Future<int> recordGameSession({
    required String sessionId,
    required String gameId,
    required String gameTitle,
    required int level,
    required int correctAnswers,
    required int totalAttempts,
    required int durationSeconds,
    required int rewardCoins,
    int? unlockedMedalNumber,
    List<String> newlyStampedCommunities = const <String>[],
  }) async {
    final idempotencyKey = 'session_reward_$sessionId';
    if (_localStorage.isKeyProcessed(idempotencyKey)) {
      return 0;
    }
    await _localStorage.markKeyProcessed(idempotencyKey);

    _currentUser = _currentUser.copyWith(
      coins: _currentUser.coins + rewardCoins,
    );
    final completed = _completedLevelsByGame.putIfAbsent(gameId, () => <int>{});
    completed.add(level);

    if (unlockedMedalNumber != null) {
      _unlockedMedalNumbers.add(unlockedMedalNumber);
    }
    for (final communityId in newlyStampedCommunities) {
      _stampedCommunities.add(communityId);
    }

    _sessions.insert(
      0,
      SessionRecord(
        sessionId: sessionId,
        studentId: _currentUser.id,
        classId: _currentUser.classId,
        gameId: gameId,
        gameTitle: gameTitle,
        level: level,
        correctAnswers: correctAnswers,
        totalAttempts: totalAttempts,
        durationSeconds: durationSeconds,
        coinsEarned: rewardCoins,
        completedAtIso: 'Ahora mismo',
      ),
    );

    notifyListeners();
    return rewardCoins;
  }

  void addStampedCommunity(String communityId) {
    if (_stampedCommunities.add(communityId)) {
      notifyListeners();
    }
  }

  /// Canjea un objeto de la tienda de forma idempotente por `transactionId`.
  Future<bool> redeemInventoryItem({
    required String transactionId,
    required String itemId,
    required int costCoins,
  }) async {
    final key = 'redeem_$transactionId';
    if (_localStorage.isKeyProcessed(key)) {
      return true;
    }
    if (_currentUser.coins < costCoins) {
      return false;
    }
    await _localStorage.markKeyProcessed(key);
    _currentUser = _currentUser.copyWith(coins: _currentUser.coins - costCoins);
    _inventoryCounts[itemId] = (_inventoryCounts[itemId] ?? 0) + 1;
    notifyListeners();
    return true;
  }

  /// Consume 1 unidad de una ayuda de la mochila durante una partida.
  bool consumeInventoryItem(String itemId) {
    final current = _inventoryCounts[itemId] ?? 0;
    if (current <= 0) return false;
    _inventoryCounts[itemId] = current - 1;
    notifyListeners();
    return true;
  }

  void saveCustomQuestion(CustomQuestionData question) {
    _customQuestions[question.questionId] = question;
    notifyListeners();
  }
}
