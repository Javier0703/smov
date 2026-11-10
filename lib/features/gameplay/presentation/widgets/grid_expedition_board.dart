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
    required this.onCellTap,
    required this.onDirectionMove,
  });

  final GameRoundChallenge round;
  final GridCoord explorerCoord;
  final List<GridCoord> visitedCoords;
  final AvatarConfig avatarConfig;
  final bool showHintTarget;
  final bool showCompassBoost;
  final ValueChanged<GridCoord> onCellTap;
  final ValueChanged<CardinalDirection> onDirectionMove;

  static const int _gridSize = 5;

  @override
  Widget build(BuildContext context) {
    final showTargetDirectly =
        round.mechanic == ChallengeMechanicType.gridNavigation ||
        round.mechanic == ChallengeMechanicType.gridTimedPath ||
        showHintTarget;

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
                            explorerCoord.row == row &&
                            explorerCoord.col == col,
                        isTargetHere:
                            round.targetCoord.row == row &&
                            round.targetCoord.col == col,
                        showTargetFlag: showTargetDirectly,
                        isObstacle: round.obstacles.contains(
                          GridCoord(row, col),
                        ),
                        isVisited: visitedCoords.contains(GridCoord(row, col)),
                        isHintHighlighted:
                            showHintTarget &&
                            round.targetCoord.row == row &&
                            round.targetCoord.col == col,
                        avatarConfig: avatarConfig,
                        mechanic: round.mechanic,
                        onTap: () => onCellTap(GridCoord(row, col)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (round.mechanic == ChallengeMechanicType.gridNavigation ||
            round.mechanic == ChallengeMechanicType.gridTimedPath ||
            showCompassBoost) ...[
          const SizedBox(height: AppSpacing.xs),
          _DirectionalPadBar(onDirectionMove: onDirectionMove),
        ],
      ],
    );
  }
}

class _GridCellItem extends StatelessWidget {
  const _GridCellItem({
    required this.coord,
    required this.isExplorerHere,
    required this.isTargetHere,
    required this.showTargetFlag,
    required this.isObstacle,
    required this.isVisited,
    required this.isHintHighlighted,
    required this.avatarConfig,
    required this.mechanic,
    required this.onTap,
  });

  final GridCoord coord;
  final bool isExplorerHere;
  final bool isTargetHere;
  final bool showTargetFlag;
  final bool isObstacle;
  final bool isVisited;
  final bool isHintHighlighted;
  final AvatarConfig avatarConfig;
  final ChallengeMechanicType mechanic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rowLetter = String.fromCharCode(65 + coord.row);
    final coordLabel = '$rowLetter${coord.col + 1}';

    Color bgColor = Colors.white;
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
        child: InkWell(
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
                  const Icon(
                    Icons.landscape_rounded,
                    color: AppColors.textMuted,
                    size: 24,
                  )
                else if (isExplorerHere)
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
                else if (mechanic == ChallengeMechanicType.gridCoordinateFind)
                  _LandmarkSeedIcon(coord: coord),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandmarkSeedIcon extends StatelessWidget {
  const _LandmarkSeedIcon({required this.coord});

  final GridCoord coord;

  @override
  Widget build(BuildContext context) {
    if (coord.row == 0 && coord.col == 0) {
      return const Icon(
        Icons.terrain_rounded,
        size: 22,
        color: AppColors.brandPrimary,
      );
    }
    if (coord.row == 1 && coord.col == 3) {
      return const Icon(
        Icons.commit_rounded,
        size: 22,
        color: Color(0xFFD97706),
      );
    }
    if (coord.row == 3 && coord.col == 3) {
      return const Icon(Icons.park_rounded, size: 22, color: AppColors.success);
    }
    return const SizedBox.shrink();
  }
}

class _DirectionalPadBar extends StatelessWidget {
  const _DirectionalPadBar({required this.onDirectionMove});

  final ValueChanged<CardinalDirection> onDirectionMove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        for (final dir in const <CardinalDirection>[
          CardinalDirection.no,
          CardinalDirection.n,
          CardinalDirection.ne,
          CardinalDirection.o,
          CardinalDirection.e,
          CardinalDirection.so,
          CardinalDirection.s,
          CardinalDirection.se,
        ])
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
