import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/vector/compass_rose_widget.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../../../adventures/data/models/adventure_game_model.dart';
import '../../data/models/gameplay_models.dart';
import '../../data/repositories/gameplay_repository.dart';

/// ViewModel de ejecución de los 10 juegos interactivos, ayudas de mochila y resultados.
class GameplayViewModel extends ChangeNotifier {
  GameplayViewModel({required this._repository});

  final GameplayRepository _repository;

  AdventureGameModel? _activeGame;
  int _activeLevelNumber = 1;
  String _activeSessionId = 'session_default';
  List<GameRoundChallenge> _rounds = const <GameRoundChallenge>[];
  int _currentRoundIndex = 0;

  // Estado del tablero por casillas
  GridCoord _explorerCoord = const GridCoord(4, 1);
  final List<GridCoord> _visitedCoords = <GridCoord>[];
  String _selectedCartographySymbol = 'Cordillera';

  // Estado de la brújula
  CardinalDirection _compassDirection = CardinalDirection.n;
  bool _useMagneticNeedle = true;

  // Estado del mapa de España
  String? _selectedRegionId;
  final Set<String> _completedRegionIds = <String>{};
  final List<String> _routeRegionIds = <String>[];
  final List<String> _newlyStampedCommunities = <String>[];

  // Estado de ayudas de la mochila en partida
  bool _isHintRevealed = false;
  bool _isCompassBoostActive = false;
  int _bonusSeconds = 0;

  // Métricas de la sesión
  int _correctAnswers = 0;
  int _totalAttempts = 0;
  String? _feedbackMessage;
  bool _isFeedbackPositive = true;
  GameSessionResultModel? _lastResult;

  AdventureGameModel? get activeGame => _activeGame;
  int get activeLevelNumber => _activeLevelNumber;
  String get activeSessionId => _activeSessionId;
  List<GameRoundChallenge> get rounds => _rounds;
  int get currentRoundIndex => _currentRoundIndex;
  GameRoundChallenge? get currentRound =>
      _rounds.isEmpty ? null : _rounds[_currentRoundIndex];

  GridCoord get explorerCoord => _explorerCoord;
  List<GridCoord> get visitedCoords =>
      List<GridCoord>.unmodifiable(_visitedCoords);
  String get selectedCartographySymbol => _selectedCartographySymbol;

  CardinalDirection get compassDirection => _compassDirection;
  bool get useMagneticNeedle => _useMagneticNeedle;

  String? get selectedRegionId => _selectedRegionId;
  Set<String> get completedRegionIds =>
      Set<String>.unmodifiable(_completedRegionIds);
  List<String> get routeRegionIds => List<String>.unmodifiable(_routeRegionIds);

  bool get isHintRevealed => _isHintRevealed;
  bool get isCompassBoostActive => _isCompassBoostActive;
  int get bonusSeconds => _bonusSeconds;

  int get correctAnswers => _correctAnswers;
  int get totalAttempts => _totalAttempts;
  String? get feedbackMessage => _feedbackMessage;
  bool get isFeedbackPositive => _isFeedbackPositive;
  GameSessionResultModel? get lastResult => _lastResult;

  UserModel get currentUser => _repository.getCurrentUser();
  Map<String, int> get inventoryCounts => _repository.getInventoryCounts();

  void startNewSession({
    required AdventureGameModel game,
    required int levelNumber,
    String? customSessionId,
  }) {
    _activeGame = game;
    _activeLevelNumber = levelNumber;
    _activeSessionId =
        customSessionId ??
        '${game.id}_lvl${levelNumber}_${DateTime.now().millisecondsSinceEpoch}';

    final result = _repository.loadGameRounds(
      gameId: game.id,
      levelNumber: levelNumber,
    );
    switch (result) {
      case Success<List<GameRoundChallenge>>(:final data):
        _rounds = data;
      case Error<List<GameRoundChallenge>>():
        _rounds = const <GameRoundChallenge>[];
    }

    _currentRoundIndex = 0;
    _correctAnswers = 0;
    _totalAttempts = 0;
    _bonusSeconds = 0;
    _completedRegionIds.clear();
    _newlyStampedCommunities.clear();
    _setupCurrentRoundState();
    notifyListeners();
  }

  void _setupCurrentRoundState() {
    final round = currentRound;
    if (round == null) return;

    _explorerCoord = round.startCoord;
    _visitedCoords
      ..clear()
      ..add(round.startCoord);
    _selectedCartographySymbol = round.symbolLabel;
    _compassDirection = CardinalDirection.n;
    _selectedRegionId = null;
    _routeRegionIds.clear();
    if (round.mechanic == ChallengeMechanicType.spainNeighborRoute) {
      _routeRegionIds.add(round.originRegionId);
    }
    _isHintRevealed = false;
    _feedbackMessage = null;
  }

  void toggleNeedleStyle() {
    _useMagneticNeedle = !_useMagneticNeedle;
    notifyListeners();
  }

  void selectCartographySymbol(String symbol) {
    _selectedCartographySymbol = symbol;
    notifyListeners();
  }

  void setCompassDirection(CardinalDirection direction) {
    _compassDirection = direction;
    _feedbackMessage =
        'Aguja orientada hacia ${direction.label} (${direction.code}). Pulsa Comprobar rumbo.';
    _isFeedbackPositive = true;
    notifyListeners();
  }

  /// Movimiento por dirección cardinal sobre el tablero de casillas.
  Future<bool> moveByDirection(CardinalDirection direction) async {
    final (dRow, dCol) = switch (direction) {
      CardinalDirection.n => (-1, 0),
      CardinalDirection.ne => (-1, 1),
      CardinalDirection.e => (0, 1),
      CardinalDirection.se => (1, 1),
      CardinalDirection.s => (1, 0),
      CardinalDirection.so => (1, -1),
      CardinalDirection.o => (0, -1),
      CardinalDirection.no => (-1, -1),
    };
    final nextCoord = GridCoord(
      (_explorerCoord.row + dRow).clamp(0, 4),
      (_explorerCoord.col + dCol).clamp(0, 4),
    );
    return handleGridCellTap(nextCoord);
  }

  /// Interacción al tocar una casilla `(row, col)` del tablero.
  Future<bool> handleGridCellTap(GridCoord coord) async {
    final round = currentRound;
    if (round == null) return false;

    if (round.obstacles.contains(coord)) {
      _totalAttempts++;
      _feedbackMessage = '¡Cuidado! Esa casilla tiene un obstáculo natural. Bordéala por otra casilla.';
      _isFeedbackPositive = false;
      notifyListeners();
      return false;
    }

    if (round.mechanic == ChallengeMechanicType.gridNavigation ||
        round.mechanic == ChallengeMechanicType.gridTimedPath) {
      _explorerCoord = coord;
      if (!_visitedCoords.contains(coord)) {
        _visitedCoords.add(coord);
      }
      if (coord == round.targetCoord) {
        _totalAttempts++;
        _correctAnswers++;
        _feedbackMessage = '¡Destino alcanzado con precisión por casillas!';
        _isFeedbackPositive = true;
        return _advanceOrFinish();
      } else {
        final rowLetter = String.fromCharCode(65 + coord.row);
        _feedbackMessage =
            'Has avanzado a la casilla $rowLetter${coord.col + 1}. Sigue hacia la meta.';
        _isFeedbackPositive = true;
        notifyListeners();
        return false;
      }
    }

    // Para Encuentra el lugar, El tesoro secreto y Construye el mapa: validación directa de objetivo
    _totalAttempts++;
    _explorerCoord = coord;
    if (coord == round.targetCoord) {
      _correctAnswers++;
      _feedbackMessage = '¡Excelente lectura cartográfica! Casilla correcta.';
      _isFeedbackPositive = true;
      return _advanceOrFinish();
    } else {
      final rowLetter = String.fromCharCode(65 + coord.row);
      _feedbackMessage =
          'La casilla $rowLetter${coord.col + 1} no es el objetivo. Revisa la pista o usa una lupa.';
      _isFeedbackPositive = false;
      notifyListeners();
      return false;
    }
  }

  /// Comprueba el rumbo actual en `La brújula perdida`.
  Future<bool> submitCompassDirection() async {
    final round = currentRound;
    if (round == null) return false;

    _totalAttempts++;
    if (_compassDirection == round.targetDirection) {
      _correctAnswers++;
      _feedbackMessage =
          '¡Rumbo exacto hacia ${round.targetDirection.label} (${round.targetDirection.code})!';
      _isFeedbackPositive = true;
      return _advanceOrFinish();
    } else {
      _feedbackMessage =
          'La aguja apunta al ${_compassDirection.code}, pero necesitas orientarte al ${round.targetDirection.code}.';
      _isFeedbackPositive = false;
      notifyListeners();
      return false;
    }
  }

  /// Selecciona una opción en `¿Dónde estoy?`.
  Future<bool> submitRiddleOption(int optionIndex) async {
    final round = currentRound;
    if (round == null) return false;

    _totalAttempts++;
    if (optionIndex == round.correctOptionIndex) {
      _correctAnswers++;
      _completedRegionIds.add(round.targetRegionId);
      _feedbackMessage = '¡Deducción geográfica correcta!';
      _isFeedbackPositive = true;
      return _advanceOrFinish();
    } else {
      _feedbackMessage = 'Ese territorio no coincide con todos los límites. Vuelve a leer las pistas.';
      _isFeedbackPositive = false;
      notifyListeners();
      return false;
    }
  }

  /// Interacción al tocar un polígono en `SpainVectorMapWidget`.
  Future<bool> handleSpainRegionTap(SpainMapRegion region) async {
    final round = currentRound;
    if (round == null) return false;

    _selectedRegionId = region.id;

    if (round.mechanic == ChallengeMechanicType.whereAmIRiddle ||
        round.mechanic == ChallengeMechanicType.spainTerritoryMap) {
      _totalAttempts++;
      if (region.id == round.targetRegionId) {
        _correctAnswers++;
        _completedRegionIds.add(region.id);
        if (round.mapMode == SpainMapMode.autonomousCommunities) {
          _newlyStampedCommunities.add(region.id);
          _repository.registerCommunityStamp(region.id);
        }
        _feedbackMessage = '¡Muy bien! Has localizado ${region.name}.';
        _isFeedbackPositive = true;
        return _advanceOrFinish();
      } else {
        _feedbackMessage =
            'Has tocado ${region.name}. Busca el territorio indicado en la misión.';
        _isFeedbackPositive = false;
        notifyListeners();
        return false;
      }
    }

    if (round.mechanic == ChallengeMechanicType.spainNeighborRoute) {
      final currentLastId = _routeRegionIds.isEmpty
          ? round.originRegionId
          : _routeRegionIds.last;
      if (region.id == currentLastId) {
        notifyListeners();
        return false;
      }
      final currentLastRegion = SpainMapCatalog.findById(currentLastId);
      final isNeighbor =
          currentLastRegion?.neighbors.contains(region.id) ?? true;

      if (!isNeighbor) {
        _totalAttempts++;
        _feedbackMessage =
            '${region.name} no limita directamente con ${currentLastRegion?.name ?? 'tu posición'}. Elige una comunidad vecina.';
        _isFeedbackPositive = false;
        notifyListeners();
        return false;
      }

      _routeRegionIds.add(region.id);
      _completedRegionIds.add(region.id);
      _newlyStampedCommunities.add(region.id);
      _repository.registerCommunityStamp(region.id);

      if (region.id == round.targetRegionId) {
        _totalAttempts++;
        _correctAnswers++;
        _feedbackMessage =
            '¡Itinerario completado hasta ${region.name}! Nuevo sello en tu pasaporte.';
        _isFeedbackPositive = true;
        return _advanceOrFinish();
      } else {
        _feedbackMessage =
            'Tramo añadido por ${region.name} (sello conseguido). Sigue hacia tu destino.';
        _isFeedbackPositive = true;
        notifyListeners();
        return false;
      }
    }

    notifyListeners();
    return false;
  }

  /// Consume una ayuda de la mochila durante la partida (`Tu mochila en esta prueba`).
  bool useBackpackHelper(String itemId) {
    final result = _repository.useBackpackItem(itemId);
    switch (result) {
      case Success<bool>():
        if (itemId == 'magnifying_glass') {
          _isHintRevealed = true;
          _feedbackMessage = 'Lupa de pistas activada: se ha resaltado la solución y la pista detallada.';
        } else if (itemId == 'hourglass') {
          _bonusSeconds += 20;
          _feedbackMessage = 'Reloj de arena activado: +20 segundos extra de margen en esta misión.';
        } else if (itemId == 'special_compass') {
          _isCompassBoostActive = true;
          final round = currentRound;
          if (round != null &&
              round.mechanic == ChallengeMechanicType.compassCalibration) {
            _compassDirection = round.targetDirection;
          }
          _feedbackMessage = 'Brújula especial activada: rumbos cardinales calibrados en el tablero.';
        }
        _isFeedbackPositive = true;
        notifyListeners();
        return true;
      case Error<bool>(:final failure):
        _feedbackMessage = failure.message;
        _isFeedbackPositive = false;
        notifyListeners();
        return false;
    }
  }

  Future<bool> _advanceOrFinish() async {
    if (_currentRoundIndex + 1 < _rounds.length) {
      _currentRoundIndex++;
      _setupCurrentRoundState();
      _feedbackMessage =
          '¡Ronda superada! Pasamos a la ronda ${_currentRoundIndex + 1} de ${_rounds.length}.';
      _isFeedbackPositive = true;
      notifyListeners();
      return false;
    }

    await finishCurrentSession();
    return true;
  }

  Future<GameSessionResultModel?> finishCurrentSession() async {
    final game = _activeGame;
    if (game == null) return null;

    final levelInfo = game.levels
        .where((l) => l.levelNumber == _activeLevelNumber)
        .firstOrNull;
    final rewardCoins =
        levelInfo?.rewardCoins ?? (game.id == 'gran_reto' ? 300 : 40);

    final result = await _repository.finishSession(
      sessionId: _activeSessionId,
      gameId: game.id,
      gameTitle: game.title,
      achievementTitle: game.achievementTitle,
      medalNumber: game.medalNumber,
      levelNumber: _activeLevelNumber,
      correctAnswers: _correctAnswers == 0 ? _rounds.length : _correctAnswers,
      totalAttempts: _totalAttempts == 0 ? _rounds.length : _totalAttempts,
      durationSeconds: (85 - _bonusSeconds).clamp(35, 300),
      baseRewardCoins: rewardCoins,
      stampedCommunitiesEarned: _newlyStampedCommunities,
    );

    if (result case Success<GameSessionResultModel>(:final data)) {
      _lastResult = data;
      notifyListeners();
      return data;
    }
    return null;
  }
}
