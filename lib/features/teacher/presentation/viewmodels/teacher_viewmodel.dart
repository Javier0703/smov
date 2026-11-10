import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../data/models/teacher_models.dart';
import '../../data/repositories/teacher_repository.dart';

/// ViewModel del Espacio Docente (Actividad de aula, Ficha de alumno, Niveles y Editor).
class TeacherViewModel extends ChangeNotifier {
  TeacherViewModel({required this._repository, this._externalStoreListenable}) {
    _externalStoreListenable?.addListener(refreshAll);
    refreshAll();
  }

  final TeacherRepository _repository;
  final Listenable? _externalStoreListenable;

  String _selectedClassId = '4.º A';
  ClassActivityDashboardModel? _classDashboard;
  StudentRosterSummary? _selectedStudent;
  List<GameLevelPolicyItem> _levelPolicies = const <GameLevelPolicyItem>[];
  late CustomQuestionData _questionDraft;

  String? _promptError;
  String? _correctOptionError;
  String? _distractorAError;
  String? _distractorBError;
  String? _statusFeedbackMessage;

  String get selectedClassId => _selectedClassId;
  ClassActivityDashboardModel? get classDashboard => _classDashboard;
  StudentRosterSummary? get selectedStudent => _selectedStudent;
  List<GameLevelPolicyItem> get levelPolicies => _levelPolicies;
  CustomQuestionData get questionDraft => _questionDraft;

  String? get promptError => _promptError;
  String? get correctOptionError => _correctOptionError;
  String? get distractorAError => _distractorAError;
  String? get distractorBError => _distractorBError;
  String? get statusFeedbackMessage => _statusFeedbackMessage;

  void refreshAll() {
    final activityRes = _repository.loadClassActivity(_selectedClassId);
    if (activityRes case Success<ClassActivityDashboardModel>(:final data)) {
      _classDashboard = data;
    }

    final studentRes = _repository.loadStudentDetail(
      _selectedStudent?.studentId ?? 'student_alex',
      classId: _selectedClassId,
    );
    if (studentRes case Success<StudentRosterSummary>(:final data)) {
      _selectedStudent = data;
    }

    final levelsRes = _repository.loadLevelPoliciesForClass(_selectedClassId);
    if (levelsRes case Success<List<GameLevelPolicyItem>>(:final data)) {
      _levelPolicies = data;
    }

    _questionDraft = _repository.loadQuestionDraft('q_default');
    notifyListeners();
  }

  void selectClass(String classId) {
    _selectedClassId = classId == '4A' ? '4.º A' : classId;
    refreshAll();
  }

  void selectStudent(String studentId) {
    final res = _repository.loadStudentDetail(
      studentId,
      classId: _selectedClassId,
    );
    if (res case Success<StudentRosterSummary>(:final data)) {
      _selectedStudent = data;
      notifyListeners();
    }
  }

  void toggleGameLevel({
    required String gameId,
    required int levelNumber,
    required bool enabled,
  }) {
    _repository.setLevelEnabled(
      classId: _selectedClassId,
      gameId: gameId,
      level: levelNumber,
      enabled: enabled,
    );
    final levelsRes = _repository.loadLevelPoliciesForClass(_selectedClassId);
    if (levelsRes case Success<List<GameLevelPolicyItem>>(:final data)) {
      _levelPolicies = data;
    }
    _statusFeedbackMessage =
        'Recorrido de $_selectedClassId actualizado en tiempo real.';
    notifyListeners();
  }

  void updateDraftGame(String gameId) {
    _questionDraft = _questionDraft.copyWith(gameId: gameId);
    notifyListeners();
  }

  void updateDraftLevel(int level) {
    _questionDraft = _questionDraft.copyWith(level: level);
    notifyListeners();
  }

  void updateDraftPrompt(String value) {
    _questionDraft = _questionDraft.copyWith(prompt: value);
    _promptError = Validators.questionStatement(value);
    notifyListeners();
  }

  void updateDraftCorrectOption(String value) {
    _questionDraft = _questionDraft.copyWith(correctOption: value);
    _correctOptionError = Validators.answerOption(value);
    notifyListeners();
  }

  void updateDraftDistractorA(String value) {
    _questionDraft = _questionDraft.copyWith(distractorA: value);
    _distractorAError = Validators.answerOption(value);
    notifyListeners();
  }

  void updateDraftDistractorB(String value) {
    _questionDraft = _questionDraft.copyWith(distractorB: value);
    _distractorBError = Validators.answerOption(value);
    notifyListeners();
  }

  void updateDraftHint(String value) {
    _questionDraft = _questionDraft.copyWith(hint: value);
    notifyListeners();
  }

  bool _validateQuestionFields() {
    _promptError = Validators.questionStatement(_questionDraft.prompt);
    _correctOptionError = Validators.answerOption(_questionDraft.correctOption);
    _distractorAError = Validators.answerOption(_questionDraft.distractorA);
    _distractorBError = Validators.answerOption(_questionDraft.distractorB);
    notifyListeners();
    return _promptError == null &&
        _correctOptionError == null &&
        _distractorAError == null &&
        _distractorBError == null;
  }

  bool saveDraftOnly() {
    if (!_validateQuestionFields()) return false;
    final updated = _questionDraft.copyWith(
      classId: _selectedClassId,
      isPublished: false,
      updatedAtIso: 'Borrador guardado',
    );
    _repository.saveQuestionDraft(updated);
    _questionDraft = updated;
    _statusFeedbackMessage = 'Borrador guardado correctamente.';
    notifyListeners();
    return true;
  }

  bool publishQuestionToClass() {
    if (!_validateQuestionFields()) return false;
    final updated = _questionDraft.copyWith(
      classId: _selectedClassId,
      isPublished: true,
      updatedAtIso: 'Publicado en $_selectedClassId',
    );
    _repository.saveQuestionDraft(updated);
    _questionDraft = updated;
    _statusFeedbackMessage =
        '¡Pregunta publicada en $_selectedClassId! Ya está activa para los alumnos.';
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(refreshAll);
    super.dispose();
  }
}
