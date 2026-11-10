import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../models/passport_entry_model.dart';

/// Servicio de sellos y postales del Pasaporte de España.
class PassportService {
  PassportService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;
  Set<String> getStampedCommunityIds() => _store.stampedCommunities;

  List<PassportEntryModel> fetchPassportEntries() {
    final stamped = _store.stampedCommunities;
    // Las 17 comunidades autónomas principales
    return SpainMapCatalog.autonomousCommunities
        .where((r) => r.id != 'ceuta' && r.id != 'melilla')
        .map(
          (region) => PassportEntryModel(
            region: region,
            isStamped: stamped.contains(region.id),
          ),
        )
        .toList();
  }
}
