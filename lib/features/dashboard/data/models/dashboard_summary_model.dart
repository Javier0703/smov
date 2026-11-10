import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user_model.dart';

/// Modelo de resumen del panel principal (`Inicio — Pasaporte y progreso`).
class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.user,
    required this.piecesCount,
    required this.medalsCount,
    required this.routeProgressPercent,
    required this.orientationStamps,
    required this.nextMissionGameId,
    required this.nextMissionTitle,
    required this.nextMissionSubtitle,
    required this.dailyRewardClaimed,
    required this.palette,
  });

  final UserModel user;
  final int piecesCount;
  final int medalsCount;
  final int routeProgressPercent;
  final Set<String> orientationStamps;
  final String nextMissionGameId;
  final String nextMissionTitle;
  final String nextMissionSubtitle;
  final bool dailyRewardClaimed;
  final AppPaletteType palette;
}
