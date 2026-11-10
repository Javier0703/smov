import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/repositories/dashboard_repository.dart';

/// ViewModel de `Inicio — Pasaporte y progreso` (`/home`).
class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(_onExternalChange);
    refresh();
  }

  final DashboardRepository _repository;
  final Listenable? _externalStoreListenable;

  DashboardSummaryModel? _summary;
  String? _errorMessage;

  DashboardSummaryModel? get summary => _summary;
  String? get errorMessage => _errorMessage;

  void _onExternalChange() {
    refresh();
  }

  void refresh() {
    final result = _repository.loadDashboardSummary();
    switch (result) {
      case Success<DashboardSummaryModel>(:final data):
        _summary = data;
        _errorMessage = null;
      case Error<DashboardSummaryModel>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  bool claimDailyReward() {
    final result = _repository.claimDailyStreakReward();
    switch (result) {
      case Success<DashboardSummaryModel>(:final data):
        _summary = data;
        _errorMessage = null;
        notifyListeners();
        return true;
      case Error<DashboardSummaryModel>(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }

  void selectPalette(AppPaletteType palette) {
    final result = _repository.changePalette(palette);
    if (result case Success<DashboardSummaryModel>(:final data)) {
      _summary = data;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(_onExternalChange);
    super.dispose();
  }
}
