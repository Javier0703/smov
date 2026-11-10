import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/medal_item_model.dart';
import '../services/achievements_service.dart';

/// Repositorio del Medallero (`Mi medallero`).
class AchievementsRepository {
  AchievementsRepository({required this._service});

  final AchievementsService _service;

  UserModel getCurrentUser() => _service.getCurrentUser();

  Result<List<MedalItemModel>> loadMedals() {
    try {
      return Success<List<MedalItemModel>>(_service.fetchMedals());
    } catch (e) {
      return Error<List<MedalItemModel>>(
        CacheFailure('No se pudo cargar el medallero: $e'),
      );
    }
  }
}
