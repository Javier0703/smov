import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/role_enum.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/auth_session_model.dart';
import '../../data/repositories/auth_repository.dart';

/// ViewModel de la pantalla de Bienvenida (`Bienvenida — Aventura de exploradores`).
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this._repository}) {
    loadInitialSession();
  }

  final AuthRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  AuthSessionModel? _session;
  String _selectedClassId = '4.º A';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthSessionModel? get session => _session;
  String get selectedClassId => _selectedClassId;
  UserModel? get currentUser => _session?.user;
  List<String> get availableClasses =>
      _session?.availableClasses ?? const <String>['4.º A', '4.º B', '5.º A'];

  void loadInitialSession() {
    final result = _repository.loadSession();
    switch (result) {
      case Success<AuthSessionModel>(:final data):
        _session = data;
        _selectedClassId = data.selectedClassId;
        _errorMessage = null;
      case Error<AuthSessionModel>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  void selectClass(String classId) {
    if (_selectedClassId == classId) return;
    _selectedClassId = classId;
    notifyListeners();
  }

  Future<bool> enterAsStudent() async {
    return _signIn(role: RoleEnum.estudiante);
  }

  Future<bool> enterAsTeacher() async {
    return _signIn(role: RoleEnum.docente);
  }

  Future<bool> _signIn({required RoleEnum role}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.enterWithRole(
      role: role,
      classId: _selectedClassId,
    );

    _isLoading = false;
    switch (result) {
      case Success<AuthSessionModel>(:final data):
        _session = data;
        notifyListeners();
        return true;
      case Error<AuthSessionModel>(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }
}
