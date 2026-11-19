import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/vector/compass_rose_widget.dart';
import '../../../../shared/widgets/vector/explorer_avatar_widget.dart';
import '../../data/models/gameplay_models.dart';

/// Tablero cuadriculado interactivo 5x5 (`Tablero.svg`) para juegos por casillas.
class GridExpeditionBoard extends StatelessWidget {
  const GridExpeditionBoard({
    super.key,
    required this.round,
    required this.explorerCoord,
    required this.visitedCoords,
    required this.avatarConfig,
    required this.showHintTarget,
    required this.showCompassBoost,
    this.allowTargetReveal = true,
    this.allowCellTap = true,
    this.showExplorer = true,
    required this.onCellTap,
    required this.onDirectionMove,
    this.placedSymbols = const <GridCoord, String>{},
    this.onSymbolPlaced,
  });

  final GameRoundChallenge round;
  final GridCoord explorerCoord;
  final List<GridCoord> visitedCoords;
  final AvatarConfig avatarConfig;
  final bool showHintTarget;
  final bool showCompassBoost;
  final bool allowTargetReveal;
  final bool allowCellTap;
  final bool showExplorer;
  final ValueChanged<GridCoord> onCellTap;
  final ValueChanged<CardinalDirection> onDirectionMove;
  final Map<GridCoord, String> placedSymbols;
  final void Function(String symbol, GridCoord coord)? onSymbolPlaced;

  static const int _gridSize = 5;

  @override
  Widget build(BuildContext context) {
    final showTargetDirectly =
        allowTargetReveal &&
        (round.mechanic == ChallengeMechanicType.gridNavigation ||
            round.mechanic == ChallengeMechanicType.gridTimedPath ||
            (showHintTarget &&
                round.mechanic != ChallengeMechanicType.cartographyBuilder));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Encabezado de columnas 1..5 + Rosa de orientación rápida
        Row(
          children: [
            Container(
              width: 32,
              height: 28,
              alignment: Alignment.center,
              child: const Icon(
                Icons.explore_rounded,
                size: 18,
                color: AppColors.brandPrimary,
              ),
            ),
            for (var col = 0; col < _gridSize; col++)
              Expanded(
                child: Center(
                  child: Text(
                    '${col + 1}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.brandPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        // Cuadrícula 5x5 con filas A..E
        for (var row = 0; row < _gridSize; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + row),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                for (var col = 0; col < _gridSize; col++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _GridCellItem(
                        coord: GridCoord(row, col),
                        isExplorerHere:
                            showExplorer &&
                            explorerCoord.row == row &&
                            explorerCoord.col == col,
                        showExplorer: showExplorer,
                        isTargetHere:
                            round.targetCoord.row == row &&
                            round.targetCoord.col == col,
                        showTargetFlag: showTargetDirectly,
                        isObstacle: round.obstacles.contains(
                          GridCoord(row, col),
                        ),
                        obstacleType: round.obstacleType,
                        isVisited:
                            showExplorer &&
                            visitedCoords.contains(GridCoord(row, col)),
                        isHintHighlighted:
                            allowTargetReveal &&
                            showHintTarget &&
                            (round.mechanic ==
                                    ChallengeMechanicType.cartographyBuilder
                                ? round.requiredMapSymbols.any(
                                    (placement) =>
                                        placement.coord.row == row &&
                                        placement.coord.col == col &&
                                        placedSymbols[placement.coord] !=
                                            placement.symbol,
                                  )
                                : round.targetCoord.row == row &&
                                      round.targetCoord.col == col),
                        landmark: round.landmarkAt(GridCoord(row, col)),
                        avatarConfig: avatarConfig,
                        mechanic: round.mechanic,
                        onTap: allowCellTap
                            ? () => onCellTap(GridCoord(row, col))
                            : null,
                        placedSymbol: placedSymbols[GridCoord(row, col)],
                        onSymbolPlaced: onSymbolPlaced,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (round.mechanic == ChallengeMechanicType.gridCoordinateFind &&
            round.landmarks.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          _LandmarkLegend(
            landmarks: round.landmarks
                .map((placement) => placement.landmark)
                .toSet()
                .toList(),
          ),
        ],
        if (round.mechanic == ChallengeMechanicType.gridNavigation ||
            round.mechanic == ChallengeMechanicType.gridTimedPath ||
            showCompassBoost) ...[
          const SizedBox(height: AppSpacing.xs),
          _DirectionalPadBar(
            onDirectionMove: onDirectionMove,
            directions: round.allowedDirections,
          ),
        ],
      ],
    );
  }
}

class _GridCellItem extends StatelessWidget {
  const _GridCellItem({
    required this.coord,
    required this.isExplorerHere,
    required this.showExplorer,
    required this.isTargetHere,
    required this.showTargetFlag,
    required this.isObstacle,
    required this.obstacleType,
    required this.isVisited,
    required this.isHintHighlighted,
    required this.landmark,
    required this.avatarConfig,
    required this.mechanic,
    required this.onTap,
    this.placedSymbol,
    this.onSymbolPlaced,
  });

  final GridCoord coord;
  final bool isExplorerHere;
  final bool showExplorer;
  final bool isTargetHere;
  final bool showTargetFlag;
  final bool isObstacle;
  final GridObstacleType obstacleType;
  final bool isVisited;
  final bool isHintHighlighted;
  final GridLandmark? landmark;
  final AvatarConfig avatarConfig;
  final ChallengeMechanicType mechanic;
  final VoidCallback? onTap;
  final String? placedSymbol;
  final void Function(String symbol, GridCoord coord)? onSymbolPlaced;

  @override
  Widget build(BuildContext context) {
    final rowLetter = String.fromCharCode(65 + coord.row);
    final coordLabel = '$rowLetter${coord.col + 1}';

    Color bgColor = AppColors.cardBackground;
    Color borderColor = AppColors.borderDefault;
    if (isObstacle) {
      bgColor = const Color(0xFFD9E3EE);
    } else if (isHintHighlighted) {
      bgColor = const Color(0xFFFFE08A);
      borderColor = const Color(0xFFD97706);
    } else if (isExplorerHere) {
      bgColor = AppColors.brandAccent.withValues(alpha: 0.28);
      borderColor = AppColors.brandPrimary;
    } else if (isTargetHere && showTargetFlag) {
      bgColor = AppColors.success.withValues(alpha: 0.16);
      borderColor = AppColors.success;
    } else if (isVisited) {
      bgColor = AppColors.surfaceMuted;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Semantics(
        button: true,
        label: 'Casilla $coordLabel',
        child: DragTarget<String>(
          onAcceptWithDetails: (details) {
            onSymbolPlaced?.call(details.data, coord);
          },
          builder: (context, candidateData, rejectedData) => InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: (isExplorerHere || isHintHighlighted) ? 2.2 : 1.3,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 3,
                    left: 5,
                    child: Text(
                      coordLabel,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 9.5,
                        color: AppColors.textMuted.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isObstacle)
                    Icon(
                      switch (obstacleType) {
                        GridObstacleType.rock => Icons.landscape_rounded,
                        GridObstacleType.river => Icons.water_rounded,
                        GridObstacleType.park => Icons.park_rounded,
                      },
                      color: obstacleType == GridObstacleType.river
                          ? AppColors.brandSky
                          : AppColors.textMuted,
                      size: 24,
                    )
                  else if (landmark != null)
                    _GridLandmarkIcon(landmark: landmark!)
                  else if (showExplorer && isExplorerHere)
                    ExplorerAvatarWidget(
                      config: avatarConfig,
                      size: 38,
                      showBackgroundCircle: false,
                    )
                  else if (isTargetHere && showTargetFlag)
                    Icon(
                      mechanic == ChallengeMechanicType.gridTreasureClues
                          ? Icons.diamond_rounded
                          : Icons.flag_rounded,
                      color: AppColors.success,
                      size: 26,
                    )
                  else if (placedSymbol != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          color: AppColors.brandPrimary,
                          size: 22,
                        ),
                        Text(
                          placedSymbol!,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 8,
                            color: AppColors.brandPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridLandmarkIcon extends StatelessWidget {
  const _GridLandmarkIcon({required this.landmark});

  final GridLandmark landmark;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (landmark) {
      GridLandmark.river => (Icons.water_rounded, AppColors.brandSky),
      GridLandmark.bridge => (Icons.alt_route_rounded, AppColors.warning),
      GridLandmark.park => (Icons.park_rounded, AppColors.success),
      GridLandmark.forest => (Icons.forest_rounded, AppColors.success),
      GridLandmark.school => (Icons.school_rounded, AppColors.brandPrimary),
      GridLandmark.hospital => (Icons.local_hospital_rounded, AppColors.danger),
      GridLandmark.shelter => (Icons.cabin_rounded, AppColors.brandPrimary),
    };
    return Icon(icon, size: 22, color: color);
  }
}

class _LandmarkLegend extends StatelessWidget {
  const _LandmarkLegend({required this.landmarks});

  final List<GridLandmark> landmarks;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: [
        for (final landmark in landmarks)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GridLandmarkIcon(landmark: landmark),
              const SizedBox(width: 4),
              Text(
                landmark.label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _DirectionalPadBar extends StatelessWidget {
  const _DirectionalPadBar({
    required this.onDirectionMove,
    required this.directions,
  });

  final ValueChanged<CardinalDirection> onDirectionMove;
  final List<CardinalDirection> directions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        for (final dir in directions)
          _DirectionButton(direction: dir, onTap: () => onDirectionMove(dir)),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({required this.direction, required this.onTap});

  final CardinalDirection direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 42),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDefault),
          ),
          alignment: Alignment.center,
          child: Text(
            '1 casilla ${direction.code}',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.brandPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
