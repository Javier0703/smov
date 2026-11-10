import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../data/models/student_activity_model.dart';
import '../../data/repositories/statistics_repository.dart';

/// ViewModel de `Mi actividad` (`/activity`).
class StatisticsViewModel extends ChangeNotifier {
  StatisticsViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(refresh);
    refresh();
  }

  final StatisticsRepository _repository;
  final Listenable? _externalStoreListenable;

  StudentActivityModel? _activity;
  String? _errorMessage;

  StudentActivityModel? get activity => _activity;
  String? get errorMessage => _errorMessage;

  void refresh() {
    final result = _repository.loadStudentActivity();
    switch (result) {
      case Success<StudentActivityModel>(:final data):
        _activity = data;
        _errorMessage = null;
      case Error<StudentActivityModel>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(refresh);
    super.dispose();
  }
}
