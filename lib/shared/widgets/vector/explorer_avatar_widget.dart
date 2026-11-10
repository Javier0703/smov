import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/svg_path_parser.dart';
import '../../models/user_model.dart';

/// Renderizador vectorial por capas del avatar explorador de Figma (`Explorer.svg`).
///
/// Soporta personalización en tiempo real según [AvatarConfig]:
/// - Presentación (`boy` / `girl`)
/// - Peinado (`short` / `long` / `curly`)
/// - Tono de piel (`light` / `medium` / `dark`)
/// - Color de ojos (`brown` / `green` / `blue`)
/// - Gafas (`none` / `round`)
/// - Ropa (`tshirt` / `redHoodie` / `navyPolo`)
class ExplorerAvatarWidget extends StatelessWidget {
  const ExplorerAvatarWidget({
    super.key,
    required this.config,
    this.size = 96,
    this.showBackgroundCircle = true,
    this.backgroundColor,
  });

  final AvatarConfig config;
  final double size;
  final bool showBackgroundCircle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Avatar explorador personalizado',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ExplorerAvatarPainter(
            config: config,
            showBackgroundCircle: showBackgroundCircle,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }
}

class _ExplorerAvatarPainter extends CustomPainter {
  _ExplorerAvatarPainter({
    required this.config,
    required this.showBackgroundCircle,
    this.backgroundColor,
  });

  final AvatarConfig config;
  final bool showBackgroundCircle;
  final Color? backgroundColor;

  // Trazados exactos extraídos de INFO/img/Flutter_/Assets_/Explorer.svg (viewBox 0 0 98 111)
  static final Path _hatCrownPath = SvgPathParser.parse(
    'M49 12C33 12 23 21 21 34H77C75 21 65 12 49 12Z',
  );
  static final Path _hatBandPath = SvgPathParser.parse(
    'M20.5 31H77.5V35.5H20.5V31Z',
  );
  static final Path _hatBrimPath = SvgPathParser.parse(
    'M10 35C10 32.7909 11.7909 31 14 31H84C86.2091 31 88 32.7909 88 35C88 37.2091 86.2091 39 84 39H14C11.7909 39 10 37.2091 10 35Z',
  );
  static final Path _facePath = SvgPathParser.parse(
    'M24 39H74V60C74 73.8071 62.8071 85 49 85C35.1929 85 24 73.8071 24 60V39Z',
  );
  static final Path _shortHairPath = SvgPathParser.parse(
    'M23 38C23 38 27 46 37 44C44 42.5 52 42.5 60 44C70 46 75 38 75 38V44C75 44 68 41 61 41C51 41 47 41 37 41C30 41 23 44 23 44V38Z',
  );
  static final Path _smilePath = SvgPathParser.parse(
    'M42 68C44 71.5 54 71.5 56 68',
  );
  static final Path _torsoPath = SvgPathParser.parse(
    'M22 110C23.5 92 34 84 49 84C64 84 74.5 92 76 110H22Z',
  );
  static final Path _scarfPath = SvgPathParser.parse(
    'M35 83H63L60 95L49 99L38 95L35 83Z',
  );
  static final Path _strapLeftPath = SvgPathParser.parse(
    'M29 88L35 86L38 110H31L29 88Z',
  );
  static final Path _strapRightPath = SvgPathParser.parse(
    'M69 88L63 86L60 110H67L69 88Z',
  );

  Color get _skinColor {
    switch (config.skinTone) {
      case AvatarSkinTone.light:
        return const Color(0xFFF3C9A8);
      case AvatarSkinTone.medium:
        return const Color(0xFFE0A97E);
      case AvatarSkinTone.dark:
        return const Color(0xFF9C6644);
    }
  }

  Color get _hairColor {
    switch (config.hair) {
      case AvatarHair.shortHair:
        return const Color(0xFF6B3E26);
      case AvatarHair.longHair:
        return const Color(0xFF4A2816);
      case AvatarHair.curlyHair:
        return const Color(0xFF2D1B12);
    }
  }

  Color get _eyeColor {
    switch (config.eyes) {
      case AvatarEyes.brown:
        return const Color(0xFF101B54);
      case AvatarEyes.green:
        return const Color(0xFF1E7E48);
      case AvatarEyes.blue:
        return const Color(0xFF1D63B8);
    }
  }

  Color get _outfitColor {
    switch (config.outfit) {
      case AvatarOutfit.tshirt:
        return const Color(0xFF29E1B4);
      case AvatarOutfit.redHoodie:
        return const Color(0xFFD64045);
      case AvatarOutfit.navyPolo:
        return const Color(0xFF17257C);
    }
  }

  Color get _scarfColor {
    switch (config.outfit) {
      case AvatarOutfit.tshirt:
        return const Color(0xFFD64045);
      case AvatarOutfit.redHoodie:
        return const Color(0xFFF39C12);
      case AvatarOutfit.navyPolo:
        return const Color(0xFF19D8BD);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (showBackgroundCircle) {
      final bgPaint = Paint()
        ..color = backgroundColor ?? AppColors.surfaceElevated
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        bgPaint,
      );
      final borderPaint = Paint()
        ..color = AppColors.borderDefault
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 - 0.75,
        borderPaint,
      );
    }

    canvas.save();
    if (showBackgroundCircle) {
      final clipPath = Path()
        ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.clipPath(clipPath);
    }

    // Escalar de viewBox (98 x 111) al tamaño del widget
    final scaleX = size.width / 98.0;
    final scaleY = size.height / 111.0;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    final dx = (size.width - 98.0 * scale) / 2.0;
    final dy = (size.height - 111.0 * scale) / 2.0 + (4.0 * scale);
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    final hairPaint = Paint()
      ..color = _hairColor
      ..style = PaintingStyle.fill;

    // 1. Cabello trasero (para pelo largo o rizado, o presentación niña)
    if (config.hair == AvatarHair.longHair ||
        config.presentation == AvatarPresentation.girl) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(18, 36, 12, 46),
          const Radius.circular(6),
        ),
        hairPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(68, 36, 12, 46),
          const Radius.circular(6),
        ),
        hairPaint,
      );
    } else if (config.hair == AvatarHair.curlyHair) {
      for (final offset in const <Offset>[
        Offset(22, 44),
        Offset(21, 55),
        Offset(23, 66),
        Offset(76, 44),
        Offset(77, 55),
        Offset(75, 66),
      ]) {
        canvas.drawCircle(offset, 7.5, hairPaint);
      }
    }

    // 2. Sombrero de explorador (corona)
    canvas.drawPath(
      _hatCrownPath,
      Paint()
        ..color = const Color(0xFFD69E5C)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      _hatBandPath,
      Paint()
        ..color = AppColors.brandPrimary
        ..style = PaintingStyle.fill,
    );

    // 3. Orejas y rostro
    final skinPaint = Paint()
      ..color = _skinColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(23, 56), 6.5, skinPaint);
    canvas.drawCircle(const Offset(75, 56), 6.5, skinPaint);
    canvas.drawPath(_facePath, skinPaint);

    // Mejillas sonrojadas suaves
    final cheekPaint = Paint()
      ..color = const Color(0xFFE77E6B).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    canvas.drawOval(const Rect.fromLTWH(28.5, 59, 9, 5.5), cheekPaint);
    canvas.drawOval(const Rect.fromLTWH(60.5, 59, 9, 5.5), cheekPaint);

    // 4. Flequillo / cabello frontal + ala del sombrero
    canvas.drawPath(_shortHairPath, hairPaint);
    if (config.hair == AvatarHair.curlyHair) {
      for (final cx in const <double>[30, 40, 49, 58, 68]) {
        canvas.drawCircle(Offset(cx, 41.5), 4.8, hairPaint);
      }
    }
    canvas.drawPath(
      _hatBrimPath,
      Paint()
        ..color = const Color(0xFFC48B48)
        ..style = PaintingStyle.fill,
    );

    // 5. Ojos y cejas
    final eyePaint = Paint()
      ..color = _eyeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(39, 55), 3.8, eyePaint);
    canvas.drawCircle(const Offset(59, 55), 3.8, eyePaint);

    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(37.8, 53.8), 1.3, shinePaint);
    canvas.drawCircle(const Offset(57.8, 53.8), 1.3, shinePaint);

    // Pestañas sutiles si presentación es girl
    if (config.presentation == AvatarPresentation.girl) {
      final lashPaint = Paint()
        ..color = AppColors.inkStrong
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        const Offset(35, 52.5),
        const Offset(33, 50.5),
        lashPaint,
      );
      canvas.drawLine(
        const Offset(63, 52.5),
        const Offset(65, 50.5),
        lashPaint,
      );
    }

    // 6. Gafas redondas opcionales
    if (config.glasses == AvatarGlasses.round) {
      final glassesStroke = Paint()
        ..color = AppColors.inkStrong
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4;
      final lensFill = Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(39, 55), 8.2, lensFill);
      canvas.drawCircle(const Offset(59, 55), 8.2, lensFill);
      canvas.drawCircle(const Offset(39, 55), 8.2, glassesStroke);
      canvas.drawCircle(const Offset(59, 55), 8.2, glassesStroke);
      canvas.drawLine(
        const Offset(47.2, 55),
        const Offset(50.8, 55),
        glassesStroke,
      );
    }

    // 7. Sonrisa
    canvas.drawPath(
      _smilePath,
      Paint()
        ..color = AppColors.inkStrong
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );

    // 8. Torso / Ropa + Pañuelo + Tirantes de mochila
    canvas.drawPath(
      _torsoPath,
      Paint()
        ..color = _outfitColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      _scarfPath,
      Paint()
        ..color = _scarfColor
        ..style = PaintingStyle.fill,
    );

    // Detalle de cuello polo o capucha según prenda
    if (config.outfit == AvatarOutfit.navyPolo) {
      final buttonPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(49, 102), 1.6, buttonPaint);
      canvas.drawCircle(const Offset(49, 106.5), 1.6, buttonPaint);
    }

    final strapPaint = Paint()
      ..color = AppColors.brandPrimary
      ..style = PaintingStyle.fill;
    canvas.drawPath(_strapLeftPath, strapPaint);
    canvas.drawPath(_strapRightPath, strapPaint);

    // Estrella dorada en la cinta del sombrero
    final badgePaint = Paint()
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(49, 33.2), 3.2, badgePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExplorerAvatarPainter oldDelegate) {
    return oldDelegate.config != config ||
        oldDelegate.showBackgroundCircle != showBackgroundCircle ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
