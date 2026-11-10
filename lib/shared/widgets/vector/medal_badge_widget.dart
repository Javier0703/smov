import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Tipos de medallas del Medallero (`Mi medallero` · 8 insignias de Figma).
enum MedalType {
  buenRumbo(1, 'Buen rumbo', Icons.explore_rounded, Color(0xFF19D8BD)),
  rosaVientos(
    2,
    'Rosa de los vientos',
    Icons.compass_calibration_rounded,
    Color(0xFF29E1B4),
  ),
  lectorMapas(3, 'Lector de mapas', Icons.map_rounded, Color(0xFF3B82F6)),
  aTiempo(4, 'A tiempo', Icons.timer_rounded, Color(0xFFF59E0B)),
  buscatesoros(5, 'Buscatesoros', Icons.diamond_rounded, Color(0xFFEC4899)),
  cartografia(6, 'Cartografía', Icons.grid_on_rounded, Color(0xFF8B5CF6)),
  detectiveMapa(
    7,
    'Detective del mapa',
    Icons.travel_explore_rounded,
    Color(0xFF10B981),
  ),
  exploradorEspana(
    8,
    'Explorador de España',
    Icons.emoji_events_rounded,
    Color(0xFFD64045),
  );

  const MedalType(this.number, this.title, this.icon, this.accentColor);
  final int number;
  final String title;
  final IconData icon;
  final Color accentColor;
}

/// Insignia vectorial con cinta superior e icono central basada en `Medals_/1.svg`..`8.svg`.
class MedalBadgeWidget extends StatelessWidget {
  const MedalBadgeWidget({
    super.key,
    required this.type,
    required this.unlocked,
    this.size = 56,
  });

  final MedalType type;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Medalla ${type.title}: ${unlocked ? 'Conseguida' : 'En progreso'}',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size),
              painter: _MedalRibbonPainter(
                accentColor: unlocked
                    ? type.accentColor
                    : AppColors.borderDefault,
                unlocked: unlocked,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size * 0.14),
              child: Icon(
                type.icon,
                size: size * 0.42,
                color: unlocked ? AppColors.brandPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedalRibbonPainter extends CustomPainter {
  const _MedalRibbonPainter({
    required this.accentColor,
    required this.unlocked,
  });

  final Color accentColor;
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Cinta superior en V
    final ribbonLeft = Path()
      ..moveTo(w * 0.26, h * 0.04)
      ..lineTo(w * 0.44, h * 0.04)
      ..lineTo(w * 0.50, h * 0.34)
      ..lineTo(w * 0.34, h * 0.34)
      ..close();
    final ribbonRight = Path()
      ..moveTo(w * 0.74, h * 0.04)
      ..lineTo(w * 0.56, h * 0.04)
      ..lineTo(w * 0.50, h * 0.34)
      ..lineTo(w * 0.66, h * 0.34)
      ..close();

    canvas.drawPath(
      ribbonLeft,
      Paint()
        ..color = unlocked ? AppColors.brandPrimary : AppColors.borderDefault,
    );
    canvas.drawPath(
      ribbonRight,
      Paint()
        ..color = unlocked
            ? AppColors.brandPrimary.withValues(alpha: 0.8)
            : AppColors.borderDefault.withValues(alpha: 0.7),
    );

    // Disco exterior e interior de la medalla
    final center = Offset(w * 0.5, h * 0.57);
    final radius = w * 0.36;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = unlocked ? const Color(0xFFFFD166) : AppColors.surfaceMuted,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = unlocked ? AppColors.brandPrimary : AppColors.borderDefault
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()
        ..color = unlocked ? accentColor.withValues(alpha: 0.28) : Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _MedalRibbonPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor ||
        oldDelegate.unlocked != unlocked;
  }
}
