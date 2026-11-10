import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/medal_item_model.dart';
import '../../data/repositories/achievements_repository.dart';

/// ViewModel de `Mi medallero` (`/medals`).
class AchievementsViewModel extends ChangeNotifier {
  AchievementsViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(refresh);
    refresh();
  }

  final AchievementsRepository _repository;
  final Listenable? _externalStoreListenable;

  List<MedalItemModel> _medals = const <MedalItemModel>[];
  String? _errorMessage;

  List<MedalItemModel> get medals => _medals;
  String? get errorMessage => _errorMessage;
  UserModel get currentUser => _repository.getCurrentUser();
  int get unlockedCount => _medals.where((m) => m.isUnlocked).length;

  void refresh() {
    final result = _repository.loadMedals();
    switch (result) {
      case Success<List<MedalItemModel>>(:final data):
        _medals = data;
        _errorMessage = null;
      case Error<List<MedalItemModel>>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(refresh);
    super.dispose();
  }
}
