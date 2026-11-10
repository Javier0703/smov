import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Puntos cardinales y colaterales de la rosa de los vientos.
enum CardinalDirection {
  n('N', 'Norte', 0),
  ne('NE', 'Noreste', 45),
  e('E', 'Este', 90),
  se('SE', 'Sureste', 135),
  s('S', 'Sur', 180),
  so('SO', 'Suroeste', 225),
  o('O', 'Oeste', 270),
  no('NO', 'Noroeste', 315);

  const CardinalDirection(this.code, this.label, this.degrees);
  final String code;
  final String label;
  final double degrees;
}

/// Rosa de los vientos interactiva basada en `Brújula.svg`.
///
/// Soporta aguja clásica verde (`Brújula.svg`) o aguja magnética roja/blanca
/// recomendada en `Cambios_a_realizar_09-11_mapas.pdf`.
class CompassRoseWidget extends StatelessWidget {
  const CompassRoseWidget({
    super.key,
    required this.selectedDirection,
    this.targetDirection,
    this.useMagneticRedWhiteNeedle = true,
    this.showCollateralLabels = true,
    this.size = 240,
    this.onDirectionSelected,
  });

  final CardinalDirection selectedDirection;
  final CardinalDirection? targetDirection;
  final bool useMagneticRedWhiteNeedle;
  final bool showCollateralLabels;
  final double size;
  final ValueChanged<CardinalDirection>? onDirectionSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Brújula interactiva apuntando al ${selectedDirection.label} (${selectedDirection.code})',
      child: GestureDetector(
        onTapUp: onDirectionSelected == null
            ? null
            : (details) => _handleOffset(details.localPosition),
        onPanUpdate: onDirectionSelected == null
            ? null
            : (details) => _handleOffset(details.localPosition),
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CompassRosePainter(
              selectedDirection: selectedDirection,
              targetDirection: targetDirection,
              useMagneticRedWhiteNeedle: useMagneticRedWhiteNeedle,
              showCollateralLabels: showCollateralLabels,
            ),
          ),
        ),
      ),
    );
  }

  void _handleOffset(Offset localPosition) {
    final center = Offset(size / 2, size / 2);
    final vector = localPosition - center;
    if (vector.distance < 14) return;
    // Ángulo con 0 grados en el Norte (arriba) y sentido horario
    var angleDeg = (math.atan2(vector.dx, -vector.dy) * 180 / math.pi) % 360;
    if (angleDeg < 0) angleDeg += 360;

    CardinalDirection closest = CardinalDirection.n;
    var minDiff = 360.0;
    for (final dir in CardinalDirection.values) {
      if (!showCollateralLabels && dir.degrees % 90 != 0) continue;
      var diff = (dir.degrees - angleDeg).abs();
      if (diff > 180) diff = 360 - diff;
      if (diff < minDiff) {
        minDiff = diff;
        closest = dir;
      }
    }
    onDirectionSelected?.call(closest);
  }
}

class _CompassRosePainter extends CustomPainter {
  _CompassRosePainter({
    required this.selectedDirection,
    required this.targetDirection,
    required this.useMagneticRedWhiteNeedle,
    required this.showCollateralLabels,
  });

  final CardinalDirection selectedDirection;
  final CardinalDirection? targetDirection;
  final bool useMagneticRedWhiteNeedle;
  final bool showCollateralLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Fondo exterior e interior de Brújula.svg
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.brandPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()
        ..color = AppColors.borderDefault
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Líneas guía de los 8 rumbos
    for (final dir in CardinalDirection.values) {
      if (!showCollateralLabels && dir.degrees % 90 != 0) continue;
      final rad = dir.degrees * math.pi / 180;
      final isMain = dir.degrees % 90 == 0;
      final innerR = radius * (isMain ? 0.20 : 0.35);
      final outerR = radius * 0.72;
      final p1 = Offset(
        center.dx + innerR * math.sin(rad),
        center.dy - innerR * math.cos(rad),
      );
      final p2 = Offset(
        center.dx + outerR * math.sin(rad),
        center.dy - outerR * math.cos(rad),
      );
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = isMain
              ? AppColors.brandPrimary.withValues(alpha: 0.35)
              : AppColors.borderDefault
          ..strokeWidth = isMain ? 2.0 : 1.2,
      );

      // Etiquetas N, NE, E, SE, S, SO, O, NO
      final labelRadius = radius * 0.87;
      final labelPos = Offset(
        center.dx + labelRadius * math.sin(rad),
        center.dy - labelRadius * math.cos(rad),
      );
      final isSelected = dir == selectedDirection;
      final isTarget = dir == targetDirection;

      if (isSelected || isTarget) {
        canvas.drawCircle(
          labelPos,
          isMain ? 14 : 12,
          Paint()
            ..color = isSelected
                ? AppColors.brandPrimary
                : AppColors.brandAccent.withValues(alpha: 0.35),
        );
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: dir.code,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: isMain ? 14 : 11,
            fontWeight: FontWeight.w800,
            color: isSelected
                ? Colors.white
                : (dir == CardinalDirection.n
                      ? AppColors.danger
                      : AppColors.brandPrimary),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          labelPos.dx - textPainter.width / 2,
          labelPos.dy - textPainter.height / 2,
        ),
      );
    }

    // Dibujar aguja rotada hacia selectedDirection
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(selectedDirection.degrees * math.pi / 180);

    final needleLength = radius * 0.62;
    final needleHalfWidth = radius * 0.12;

    if (useMagneticRedWhiteNeedle) {
      // Mitad norte/punta activa (roja)
      final northPath = Path()
        ..moveTo(0, -needleLength)
        ..lineTo(needleHalfWidth, 0)
        ..lineTo(-needleHalfWidth, 0)
        ..close();
      canvas.drawPath(
        northPath,
        Paint()
          ..color = AppColors.danger
          ..style = PaintingStyle.fill,
      );

      // Mitad sur/cola opuesta (blanca con borde azul marino)
      final southPath = Path()
        ..moveTo(0, needleLength * 0.82)
        ..lineTo(needleHalfWidth, 0)
        ..lineTo(-needleHalfWidth, 0)
        ..close();
      canvas.drawPath(
        southPath,
        Paint()
          ..color = AppColors.surfaceMuted
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        southPath,
        Paint()
          ..color = AppColors.brandPrimary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    } else {
      // Flecha verde clásica de Brújula.svg (#23C450)
      final arrowPath = Path()
        ..moveTo(0, -needleLength)
        ..lineTo(needleHalfWidth * 1.15, needleLength * 0.45)
        ..lineTo(0, needleLength * 0.22)
        ..lineTo(-needleHalfWidth * 1.15, needleLength * 0.45)
        ..close();
      canvas.drawPath(
        arrowPath,
        Paint()
          ..color = AppColors.success
          ..style = PaintingStyle.fill,
      );
    }

    // Eje central
    canvas.drawCircle(
      Offset.zero,
      radius * 0.09,
      Paint()..color = AppColors.brandPrimary,
    );
    canvas.drawCircle(
      Offset.zero,
      radius * 0.04,
      Paint()..color = Colors.white,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CompassRosePainter oldDelegate) {
    return oldDelegate.selectedDirection != selectedDirection ||
        oldDelegate.targetDirection != targetDirection ||
        oldDelegate.useMagneticRedWhiteNeedle != useMagneticRedWhiteNeedle ||
        oldDelegate.showCollateralLabels != showCollateralLabels;
  }
}
