import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/vector/medal_badge_widget.dart';
import '../models/medal_item_model.dart';

/// Servicio de consulta de medallas desbloqueadas.
class AchievementsService {
  AchievementsService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;

  List<MedalItemModel> fetchMedals() {
    final unlocked = _store.unlockedMedalNumbers;
    return <MedalItemModel>[
      MedalItemModel(
        type: MedalType.buenRumbo,
        subtitle: 'Domina los puntos cardinales en ¡Rumbo desconocido!',
        relatedGameId: 'rumbo_desconocido',
        isUnlocked: unlocked.contains(1),
      ),
      MedalItemModel(
        type: MedalType.rosaVientos,
        subtitle: 'Calibra la aguja magnética en La brújula perdida',
        relatedGameId: 'brujula_perdida',
        isUnlocked: unlocked.contains(2),
      ),
      MedalItemModel(
        type: MedalType.lectorMapas,
        subtitle: 'Localiza elementos por coordenadas en ¡Encuentra el lugar!',
        relatedGameId: 'encuentra_lugar',
        isUnlocked: unlocked.contains(3),
      ),
      MedalItemModel(
        type: MedalType.aTiempo,
        subtitle: 'Traza el sendero más rápido en Misión: llegar a tiempo',
        relatedGameId: 'llegar_a_tiempo',
        isUnlocked: unlocked.contains(4),
      ),
      MedalItemModel(
        type: MedalType.buscatesoros,
        subtitle: 'Descifra las pistas del pergamino en El tesoro secreto',
        relatedGameId: 'tesoro_secreto',
        isUnlocked: unlocked.contains(5),
      ),
      MedalItemModel(
        type: MedalType.cartografia,
        subtitle: 'Sitúa los símbolos en el plano en Construye el mapa',
        relatedGameId: 'construye_mapa',
        isUnlocked: unlocked.contains(6),
      ),
      MedalItemModel(
        type: MedalType.detectiveMapa,
        subtitle: 'Adivina tu posición por fronteras en ¿Dónde estoy?',
        relatedGameId: 'donde_estoy',
        isUnlocked: unlocked.contains(7),
      ),
      MedalItemModel(
        type: MedalType.exploradorEspana,
        subtitle: 'Completa España en tus manos y El gran reto del explorador',
        relatedGameId: 'espana_en_tus_manos',
        isUnlocked: unlocked.contains(8),
      ),
    ];
  }
}
