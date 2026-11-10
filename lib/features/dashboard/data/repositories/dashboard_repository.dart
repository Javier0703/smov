import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/dashboard_summary_model.dart';
import '../services/dashboard_service.dart';

/// Repositorio del panel principal (`Inicio — Pasaporte y progreso`).
class DashboardRepository {
  DashboardRepository({required this._service});

  final DashboardService _service;

  Result<DashboardSummaryModel> loadDashboardSummary() {
    try {
      return Success<DashboardSummaryModel>(_service.fetchSummary());
    } catch (e) {
      return Error<DashboardSummaryModel>(
        CacheFailure('No se pudo cargar el pasaporte de exploración: $e'),
      );
    }
  }

  Result<DashboardSummaryModel> claimDailyStreakReward() {
    try {
      final claimed = _service.claimDailyReward();
      if (!claimed) {
        return const Error<DashboardSummaryModel>(
          ValidationFailure('La recompensa diaria de hoy ya fue reclamada.'),
        );
      }
      return Success<DashboardSummaryModel>(_service.fetchSummary());
    } catch (e) {
      return Error<DashboardSummaryModel>(
        CacheFailure('No se pudo reclamar la recompensa diaria: $e'),
      );
    }
  }

  Result<DashboardSummaryModel> changePalette(AppPaletteType palette) {
    try {
      _service.updatePalette(palette);
      return Success<DashboardSummaryModel>(_service.fetchSummary());
    } catch (e) {
      return Error<DashboardSummaryModel>(
        ValidationFailure('No se pudo cambiar la paleta: $e'),
      );
    }
  }
}
