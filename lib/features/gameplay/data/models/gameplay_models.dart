import '../../../../shared/widgets/vector/compass_rose_widget.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';

/// Tipo de mecánica interactiva de una ronda de juego.
enum ChallengeMechanicType {
  gridNavigation,
  compassCalibration,
  gridCoordinateFind,
  gridTimedPath,
  gridTreasureClues,
  cartographyBuilder,
  whereAmIRiddle,
  spainTerritoryMap,
  spainNeighborRoute,
}

/// Posición entera `(row, col)` dentro de un tablero por casillas.
class GridCoord {
  const GridCoord(this.row, this.col);
  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridCoord && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}

/// Definición de un reto o etapa dentro de una sesión de juego.
class GameRoundChallenge {
  const GameRoundChallenge({
    required this.roundNumber,
    required this.mechanic,
    required this.title,
    required this.instruction,
    required this.hint,
    this.startCoord = const GridCoord(4, 1),
    this.targetCoord = const GridCoord(1, 4),
    this.obstacles = const <GridCoord>[],
    this.targetDirection = CardinalDirection.ne,
    this.targetRegionId = 'castilla_y_leon',
    this.originRegionId = 'galicia',
    this.mapMode = SpainMapMode.autonomousCommunities,
    this.options = const <String>[],
    this.correctOptionIndex = 0,
    this.clues = const <String>[],
    this.symbolLabel = 'Cumbre',
  });

  final int roundNumber;
  final ChallengeMechanicType mechanic;
  final String title;
  final String instruction;
  final String hint;
  final GridCoord startCoord;
  final GridCoord targetCoord;
  final List<GridCoord> obstacles;
  final CardinalDirection targetDirection;
  final String targetRegionId;
  final String originRegionId;
  final SpainMapMode mapMode;
  final List<String> options;
  final int correctOptionIndex;
  final List<String> clues;
  final String symbolLabel;
}

/// Resultado consolidado de una sesión de juego al completarse.
class GameSessionResultModel {
  const GameSessionResultModel({
    required this.sessionId,
    required this.gameId,
    required this.gameTitle,
    required this.achievementTitle,
    required this.medalNumber,
    required this.levelNumber,
    required this.correctAnswers,
    required this.totalAttempts,
    required this.durationSeconds,
    required this.coinsAwarded,
    required this.totalCoinsAfter,
    required this.isFinalExpedition,
    required this.stampedCommunitiesEarned,
  });

  final String sessionId;
  final String gameId;
  final String gameTitle;
  final String achievementTitle;
  final int medalNumber;
  final int levelNumber;
  final int correctAnswers;
  final int totalAttempts;
  final int durationSeconds;
  final int coinsAwarded;
  final int totalCoinsAfter;
  final bool isFinalExpedition;
  final List<String> stampedCommunitiesEarned;

  int get accuracyPercent => totalAttempts == 0
      ? 100
      : ((correctAnswers / totalAttempts) * 100).round();
}
