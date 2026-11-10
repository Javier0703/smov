import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/adventure_game_model.dart';
import '../services/adventures_service.dart';

/// Repositorio del catálogo de las 10 aventuras y sus niveles.
class AdventuresRepository {
  AdventuresRepository({required this._service});

  final AdventuresService _service;

  UserModel getCurrentUser() => _service.getCurrentUser();

  Result<List<AdventureGameModel>> loadAllAdventures() {
    try {
      final games = _service.fetchGamesForCurrentClass();
      return Success<List<AdventureGameModel>>(games);
    } catch (e) {
      return Error<List<AdventureGameModel>>(
        CacheFailure('No se pudo cargar el catálogo de aventuras: $e'),
      );
    }
  }

  Result<AdventureGameModel> loadAdventureById(String gameId) {
    try {
      final games = _service.fetchGamesForCurrentClass();
      final match = games.where((g) => g.id == gameId).firstOrNull;
      if (match == null) {
        return Error<AdventureGameModel>(
          ValidationFailure('No existe la aventura con identificador $gameId'),
        );
      }
      return Success<AdventureGameModel>(match);
    } catch (e) {
      return Error<AdventureGameModel>(
        CacheFailure('Error al cargar los niveles de la aventura: $e'),
      );
    }
  }
}
