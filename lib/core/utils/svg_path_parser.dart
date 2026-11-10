import 'dart:ui';

/// Parser ligero de rutas SVG (M, L, H, V, C, Z) a objetos nativos [Path] de Flutter
/// para renderizado vectorial exacto y detección táctil de polígonos geográficos.
class SvgPathParser {
  const SvgPathParser._();

  static final RegExp _tokenRegex = RegExp(
    r'([MmLlHhVvCcZz])|(-?\d+(?:\.\d+)?)',
  );

  static Path parse(String svgPathData) {
    final path = Path();
    final matches = _tokenRegex.allMatches(svgPathData).toList();
    String currentCommand = '';
    double currentX = 0;
    double currentY = 0;
    double startX = 0;
    double startY = 0;

    int i = 0;
    while (i < matches.length) {
      final token = matches[i].group(0)!;
      if (_isCommand(token)) {
        currentCommand = token;
        i++;
        if (currentCommand == 'Z' || currentCommand == 'z') {
          path.close();
          currentX = startX;
          currentY = startY;
        }
        continue;
      }

      switch (currentCommand) {
        case 'M':
          if (i + 1 < matches.length) {
            currentX = double.parse(matches[i].group(0)!);
            currentY = double.parse(matches[i + 1].group(0)!);
            startX = currentX;
            startY = currentY;
            path.moveTo(currentX, currentY);
            currentCommand = 'L';
            i += 2;
          } else {
            i++;
          }
        case 'm':
          if (i + 1 < matches.length) {
            currentX += double.parse(matches[i].group(0)!);
            currentY += double.parse(matches[i + 1].group(0)!);
            startX = currentX;
            startY = currentY;
            path.moveTo(currentX, currentY);
            currentCommand = 'l';
            i += 2;
          } else {
            i++;
          }
        case 'L':
          if (i + 1 < matches.length) {
            currentX = double.parse(matches[i].group(0)!);
            currentY = double.parse(matches[i + 1].group(0)!);
            path.lineTo(currentX, currentY);
            i += 2;
          } else {
            i++;
          }
        case 'l':
          if (i + 1 < matches.length) {
            currentX += double.parse(matches[i].group(0)!);
            currentY += double.parse(matches[i + 1].group(0)!);
            path.lineTo(currentX, currentY);
            i += 2;
          } else {
            i++;
          }
        case 'H':
          currentX = double.parse(matches[i].group(0)!);
          path.lineTo(currentX, currentY);
          i++;
        case 'h':
          currentX += double.parse(matches[i].group(0)!);
          path.lineTo(currentX, currentY);
          i++;
        case 'V':
          currentY = double.parse(matches[i].group(0)!);
          path.lineTo(currentX, currentY);
          i++;
        case 'v':
          currentY += double.parse(matches[i].group(0)!);
          path.lineTo(currentX, currentY);
          i++;
        case 'C':
          if (i + 5 < matches.length) {
            final x1 = double.parse(matches[i].group(0)!);
            final y1 = double.parse(matches[i + 1].group(0)!);
            final x2 = double.parse(matches[i + 2].group(0)!);
            final y2 = double.parse(matches[i + 3].group(0)!);
            currentX = double.parse(matches[i + 4].group(0)!);
            currentY = double.parse(matches[i + 5].group(0)!);
            path.cubicTo(x1, y1, x2, y2, currentX, currentY);
            i += 6;
          } else {
            i++;
          }
        default:
          i++;
      }
    }
    return path;
  }

  static bool _isCommand(String token) {
    return token.length == 1 && 'MmLlHhVvCcZz'.contains(token);
  }
}
