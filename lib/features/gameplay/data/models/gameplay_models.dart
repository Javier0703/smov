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

/// Hito cartográfico que puede aparecer en una casilla del tablero.
enum GridLandmark {
  river('Río'),
  bridge('Puente'),
  park('Parque'),
  forest('Bosque'),
  school('Colegio'),
  hospital('Hospital'),
  shelter('Refugio de montaña');

  const GridLandmark(this.label);

  final String label;
}

enum GridObstacleType {
  rock,
  river,
  park,
}

/// Hito concreto y su posición dentro de una ronda.
class GridLandmarkPlacement {
  const GridLandmarkPlacement(this.coord, this.landmark);

  final GridCoord coord;
  final GridLandmark landmark;
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

/// Tramo de una ruta de casillas en una dirección cardinal.
class GridPathStep {
  const GridPathStep(this.direction, this.distance);

  final CardinalDirection direction;
  final int distance;
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
    GridCoord? targetCoord,
    this.pathSteps = const <GridPathStep>[],
    this.obstacles = const <GridCoord>[],
    this.startDirection = CardinalDirection.n,
    this.targetDirection = CardinalDirection.ne,
    this.targetRegionId = 'castilla_y_leon',
    this.originRegionId = 'galicia',
    this.mapMode = SpainMapMode.autonomousCommunities,
    this.options = const <String>[],
    this.correctOptionIndex = 0,
    this.clues = const <String>[],
    this.symbolLabel = 'Cumbre',
    this.landmarks = const <GridLandmarkPlacement>[],
    this.obstacleType = GridObstacleType.rock,
  }) : _targetCoord = targetCoord ?? const GridCoord(1, 4);

  final int roundNumber;
  final ChallengeMechanicType mechanic;
  final String title;
  final String instruction;
  final String hint;
  final GridCoord startCoord;
  final GridCoord _targetCoord;
  final List<GridPathStep> pathSteps;
  final List<GridCoord> obstacles;
  final CardinalDirection startDirection;
  final CardinalDirection targetDirection;
  final String targetRegionId;
  final String originRegionId;
  final SpainMapMode mapMode;
  final List<String> options;
  final int correctOptionIndex;
  final List<String> clues;
  final String symbolLabel;
  final List<GridLandmarkPlacement> landmarks;
  final GridObstacleType obstacleType;

  GridCoord get targetCoord {
    if (pathSteps.isEmpty) return _targetCoord;

    return pathSteps.fold(startCoord, (coord, step) {
      final (dRow, dCol) = switch (step.direction) {
        CardinalDirection.n => (-1, 0),
        CardinalDirection.ne => (-1, 1),
        CardinalDirection.e => (0, 1),
        CardinalDirection.se => (1, 1),
        CardinalDirection.s => (1, 0),
        CardinalDirection.so => (1, -1),
        CardinalDirection.o => (0, -1),
        CardinalDirection.no => (-1, -1),
      };
      return GridCoord(
        coord.row + dRow * step.distance,
        coord.col + dCol * step.distance,
      );
    });
  }

  GridLandmark? landmarkAt(GridCoord coord) {
    for (final placement in landmarks) {
      if (placement.coord == coord) return placement.landmark;
    }
    return null;
  }
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
