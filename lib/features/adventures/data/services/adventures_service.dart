import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/adventure_game_model.dart';

/// Servicio de catálogo de aventuras y estados de niveles según la clase.
class AdventuresService {
  AdventuresService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  List<AdventureGameModel> fetchGamesForCurrentClass() {
    final classId = _store.currentUser.classId;
    const gameIds = <String>[
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

    final completedMap = <String, Set<int>>{};
    final enabledMap = <String, Set<int>>{};

    for (final id in gameIds) {
      completedMap[id] = _store.completedLevelsForGame(id);
      enabledMap[id] = _store.enabledLevelsForClassGame(classId, id);
    }

    return AdventuresCatalogDefinitions.buildCatalog(
      completedByGame: completedMap,
      enabledByTeacher: enabledMap,
    );
  }
}
