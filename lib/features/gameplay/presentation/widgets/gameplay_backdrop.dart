import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ilustración ambiental ligera que mantiene visible el fondo temático del juego.
class GameplayBackdrop extends StatelessWidget {
  const GameplayBackdrop({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    final illustrations = switch (gameId) {
      'rumbo_desconocido' => (
        Icons.school_rounded,
        Icons.forest_rounded,
        Icons.park_rounded,
      ),
      'brujula_perdida' => (
        Icons.explore_rounded,
        Icons.landscape_rounded,
        Icons.wb_sunny_rounded,
      ),
      'donde_estoy' => (
        Icons.map_rounded,
        Icons.my_location_rounded,
        Icons.terrain_rounded,
      ),
      _ => (Icons.explore_rounded, Icons.map_rounded, Icons.park_rounded),
    };

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 2,
            child: _BackdropIllustration(icon: illustrations.$1, size: 116),
          ),
          Positioned(
            bottom: 24,
            left: 4,
            child: _BackdropIllustration(icon: illustrations.$2, size: 98),
          ),
          Positioned(
            bottom: 112,
            right: 8,
            child: _BackdropIllustration(icon: illustrations.$3, size: 72),
          ),
        ],
      ),
    );
  }
}

class _BackdropIllustration extends StatelessWidget {
  const _BackdropIllustration({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: AppColors.brandPrimary.withValues(alpha: 0.075),
    );
  }
}
