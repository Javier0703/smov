import 'package:flutter/material.dart';

/// Paletas de color personalizables por el usuario (Sesión de cocreación).
enum AppVisualPalette {
  exploradorClasico('Clásico Brújula'),
  pastelSuave('Tonos Pastel'),
  vibranteSolar('Llamativo Solar'),
  calmaGithub('Calma Pizarra');

  final String label;
  const AppVisualPalette(this.label);
}

/// Tipo de paleta cromática seleccionable por el alumno en Inicio.
enum AppPaletteType { oceanAdventure, warmMap, forestExpedition }

/// Definición cromática de una paleta de aventura.
class AppPaletteColors {
  const AppPaletteColors({
    required this.name,
    required this.primary,
    required this.accent,
    required this.canvas,
  });

  final String name;
  final Color primary;
  final Color accent;
  final Color canvas;
}

/// Paleta semántica y colores de marca extraídos exactamente del Figma de Brújula Quest.
class AppColors {
  const AppColors._();

  // Colores de Identidad (Tokens Figma: brand/*)
  static const Color primary = Color(0xFF17257C); // brand/primary
  static const Color brandPrimary = Color(0xFF17257C);
  static const Color primaryContainer = Color(0xFF101B54); // uniform/navy
  static const Color inkStrong = Color(0xFF101B54);
  static const Color secondary = Color(0xFF19D8BD); // brand/mint
  static const Color brandAccent = Color(0xFF19D8BD);
  static const Color secondaryContainer = Color(0xFF29E1B4); // brand/mintLight
  static const Color brandHighlight = Color(0xFFAFC6DD); // brand/sky
  static const Color brandSky = Color(0xFFAFC6DD);
  static const Color mintSoft = Color(0xFFE5FAF4);

  // Superficies y Fondos (Tokens Figma: surface/* & border/*)
  static const Color background = Color(0xFFF7F9FC); // surface/canvas
  static const Color surfaceCanvas = Color(0xFFF7F9FC);
  static const Color surface = Color(0xFFFFFFFF); // surface/white
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF1FA); // surface/soft
  static const Color surfaceMuted = Color(0xFFEEF1FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderDefault = Color(0xFFD9E3EE); // border/default

  // Textos e Iconos (Tokens Figma: text/*)
  static const Color textPrimary = Color(0xFF17257C);
  static const Color textSecondary = Color(0xFF536184); // text/secondary
  static const Color textMuted = Color(0xFF536184);
  static const Color textDisabled = Color(0xFF8A97B5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Estados Semánticos (Tokens Figma: brand/success, uniform/red, etc.)
  static const Color success = Color(0xFF23C450); // brand/success
  static const Color successSurface = Color(0xFFEAFBF0);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFD64045); // uniform/red
  static const Color danger = Color(0xFFD64045);
  static const Color errorSurface = Color(0xFFFDECEC);
  static const Color info = Color(0xFF19D8BD);

  // Tokens de Personaje / Avatar (Figma: character/* & uniform/*)
  static const Color characterSkinLight = Color(0xFFF3C9A8);
  static const Color characterSkinMedium = Color(0xFFD59B72);
  static const Color characterSkinDark = Color(0xFF8C583A);
  static const Color uniformRed = Color(0xFFD64045);
  static const Color uniformNavy = Color(0xFF101B54);
  static const Color hairDark = Color(0xFF17257C);
  static const Color hairHighlight = Color(0xFF5264A8);
  static const Color eyesBrown = Color(0xFF4E342E);
  static const Color eyesGreen = Color(0xFF1B8A5A);
  static const Color eyesBlue = Color(0xFF17257C);

  // Fondos temáticos por aventura (Especificación 07 · Tema, fondos y recursos)
  static const Color adventureWarmBg = Color(0xFFFCF6E6);
  static const Color adventureLavenderBg = Color(0xFFF2EEFC);
  static const Color adventureCoralBg = Color(0xFFFCEEE9);
  static const Color adventureRoseBg = Color(0xFFFBEEF3);

  static const Color adventureRumboTint = Color(0xFFFCF6E6);
  static const Color adventureBrujulaTint = Color(0xFFF2EEFC);
  static const Color adventureEncuentraTint = Color(0xFFFCEEE9);
  static const Color adventureTiempoTint = Color(0xFFFCF6E6);
  static const Color adventureTesoroTint = Color(0xFFFBEEF3);
  static const Color adventureConstruyeTint = Color(0xFFF2EEFC);
  static const Color adventureDondeTint = Color(0xFFFCEEE9);
  static const Color adventureEspanaTint = Color(0xFFFCF6E6);
  static const Color adventureViajeTint = Color(0xFFF2EEFC);
  static const Color adventureGranRetoTint = Color(0xFFFCEEE9);

  static AppPaletteColors paletteFor(AppPaletteType type) {
    switch (type) {
      case AppPaletteType.oceanAdventure:
        return const AppPaletteColors(
          name: 'Aventura Oceánica (Original)',
          primary: Color(0xFF17257C),
          accent: Color(0xFF19D8BD),
          canvas: Color(0xFFF7F9FC),
        );
      case AppPaletteType.warmMap:
        return const AppPaletteColors(
          name: 'Pergamino Cartográfico',
          primary: Color(0xFF1E295E),
          accent: Color(0xFF29E1B4),
          canvas: Color(0xFFFCF8F0),
        );
      case AppPaletteType.forestExpedition:
        return const AppPaletteColors(
          name: 'Bosque Ibérico',
          primary: Color(0xFF153B50),
          accent: Color(0xFF23C450),
          canvas: Color(0xFFF3F8F5),
        );
    }
  }

  /// Devuelve el fondo temático correspondiente al número de aventura (1..10).
  static Color backgroundForAdventure(int adventureNumber) {
    switch (adventureNumber) {
      case 1:
      case 4:
      case 8:
        return adventureWarmBg;
      case 2:
      case 6:
      case 9:
        return adventureLavenderBg;
      case 5:
        return adventureRoseBg;
      case 3:
      case 7:
      case 10:
      default:
        return adventureCoralBg;
    }
  }
}
