import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/passport_entry_model.dart';
import '../services/passport_service.dart';

/// Repositorio de `Mi pasaporte` (`/passport`).
class PassportRepository {
  PassportRepository({required this._service});

  final PassportService _service;

  UserModel getCurrentUser() => _service.getCurrentUser();
  Set<String> getStampedCommunityIds() => _service.getStampedCommunityIds();

  Result<List<PassportEntryModel>> loadEntries() {
    try {
      return Success<List<PassportEntryModel>>(_service.fetchPassportEntries());
    } catch (e) {
      return Error<List<PassportEntryModel>>(
        CacheFailure('No se pudo cargar el pasaporte: $e'),
      );
    }
  }
}
