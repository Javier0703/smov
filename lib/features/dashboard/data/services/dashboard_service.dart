import '../../../../core/theme/app_colors.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/dashboard_summary_model.dart';

/// Servicio de datos del panel principal de Inicio.
class DashboardService {
  DashboardService({required this._store});

  final ExpeditionStateStore _store;

  DashboardSummaryModel fetchSummary() {
    return DashboardSummaryModel(
      user: _store.currentUser,
      piecesCount: _store.stampedCommunities.length,
      medalsCount: _store.unlockedMedalNumbers.length,
      routeProgressPercent: _store.routeProgressPercent,
      orientationStamps: _store.orientationStamps,
      nextMissionGameId: 'rumbo_desconocido',
      nextMissionTitle: '¡Rumbo desconocido! · Nivel 2',
      nextMissionSubtitle: 'Oriéntate con la brújula y guía al explorador por casillas hasta el refugio.',
      dailyRewardClaimed: _store.dailyRewardClaimed,
      palette: _store.palette,
    );
  }

  bool claimDailyReward() => _store.claimDailyStreakReward();

  void updatePalette(AppPaletteType palette) => _store.setPalette(palette);
}
