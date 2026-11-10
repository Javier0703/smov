import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/adventure_game_model.dart';
import '../../data/repositories/adventures_repository.dart';

/// ViewModel de `Elige tu aventura`, `Elige tu nivel` y `España en tus manos`.
class AdventuresViewModel extends ChangeNotifier {
  AdventuresViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(_onStoreChanged);
    loadCatalog();
  }

  final AdventuresRepository _repository;
  final Listenable? _externalStoreListenable;

  List<AdventureGameModel> _games = const <AdventureGameModel>[];
  String _searchQuery = '';
  int _selectedLevelByGame = 1;
  String? _errorMessage;

  List<AdventureGameModel> get games {
    if (_searchQuery.trim().isEmpty) return _games;
    final q = _searchQuery.trim().toLowerCase();
    return _games
        .where(
          (g) =>
              g.title.toLowerCase().contains(q) ||
              g.competencyTag.toLowerCase().contains(q) ||
              g.shortDescription.toLowerCase().contains(q),
        )
        .toList();
  }

  String get searchQuery => _searchQuery;
  int get selectedLevelNumber => _selectedLevelByGame;
  String? get errorMessage => _errorMessage;
  UserModel get currentUser => _repository.getCurrentUser();

  void _onStoreChanged() {
    loadCatalog();
  }

  void loadCatalog() {
    final result = _repository.loadAllAdventures();
    switch (result) {
      case Success<List<AdventureGameModel>>(:final data):
        _games = data;
        _errorMessage = null;
      case Error<List<AdventureGameModel>>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  AdventureGameModel? findGame(String gameId) {
    return _games.where((g) => g.id == gameId).firstOrNull;
  }

  void selectLevel(int levelNumber) {
    _selectedLevelByGame = levelNumber;
    notifyListeners();
  }

  /// Verifica si el nivel indicado está disponible para la clase y el alumno.
  bool canStartGameLevel(String gameId, int levelNumber) {
    final game = findGame(gameId);
    if (game == null) return false;
    final level = game.levels
        .where((l) => l.levelNumber == levelNumber)
        .firstOrNull;
    if (level == null) return false;
    return level.canPlay;
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(_onStoreChanged);
    super.dispose();
  }
}
