import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/passport_entry_model.dart';
import '../../data/repositories/passport_repository.dart';

/// ViewModel de `Mi pasaporte` (`/passport`).
class PassportViewModel extends ChangeNotifier {
  PassportViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(refresh);
    refresh();
  }

  final PassportRepository _repository;
  final Listenable? _externalStoreListenable;

  List<PassportEntryModel> _entries = const <PassportEntryModel>[];
  String? _selectedRegionId;
  String? _errorMessage;

  List<PassportEntryModel> get entries => _entries;
  String? get selectedRegionId => _selectedRegionId;
  String? get errorMessage => _errorMessage;
  UserModel get currentUser => _repository.getCurrentUser();
  Set<String> get stampedIds => _repository.getStampedCommunityIds();
  int get stampedCount => _entries.where((e) => e.isStamped).length;

  void refresh() {
    final result = _repository.loadEntries();
    switch (result) {
      case Success<List<PassportEntryModel>>(:final data):
        _entries = data;
        _errorMessage = null;
      case Error<List<PassportEntryModel>>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  void selectRegion(String regionId) {
    _selectedRegionId = regionId;
    notifyListeners();
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(refresh);
    super.dispose();
  }
}
