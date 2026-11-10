import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// ThemeExtension para paletas de aventura y personalización cromática.
@immutable
class AdventureThemeExtension extends ThemeExtension<AdventureThemeExtension> {
  final Color warmCanvas;
  final Color lavenderCanvas;
  final Color coralCanvas;
  final Color roseCanvas;
  final Color accentMint;

  const AdventureThemeExtension({
    required this.warmCanvas,
    required this.lavenderCanvas,
    required this.coralCanvas,
    required this.roseCanvas,
    required this.accentMint,
  });

  static const AdventureThemeExtension standard = AdventureThemeExtension(
    warmCanvas: AppColors.adventureWarmBg,
    lavenderCanvas: AppColors.adventureLavenderBg,
    coralCanvas: AppColors.adventureCoralBg,
    roseCanvas: AppColors.adventureRoseBg,
    accentMint: AppColors.secondary,
  );

  @override
  AdventureThemeExtension copyWith({
    Color? warmCanvas,
    Color? lavenderCanvas,
    Color? coralCanvas,
    Color? roseCanvas,
    Color? accentMint,
  }) {
    return AdventureThemeExtension(
      warmCanvas: warmCanvas ?? this.warmCanvas,
      lavenderCanvas: lavenderCanvas ?? this.lavenderCanvas,
      coralCanvas: coralCanvas ?? this.coralCanvas,
      roseCanvas: roseCanvas ?? this.roseCanvas,
      accentMint: accentMint ?? this.accentMint,
    );
  }

  @override
  AdventureThemeExtension lerp(
    ThemeExtension<AdventureThemeExtension>? other,
    double t,
  ) {
    if (other is! AdventureThemeExtension) return this;
    return AdventureThemeExtension(
      warmCanvas: Color.lerp(warmCanvas, other.warmCanvas, t) ?? warmCanvas,
      lavenderCanvas:
          Color.lerp(lavenderCanvas, other.lavenderCanvas, t) ?? lavenderCanvas,
      coralCanvas: Color.lerp(coralCanvas, other.coralCanvas, t) ?? coralCanvas,
      roseCanvas: Color.lerp(roseCanvas, other.roseCanvas, t) ?? roseCanvas,
      accentMint: Color.lerp(accentMint, other.accentMint, t) ?? accentMint,
    );
  }
}

/// Constructor de ThemeData (Material 3) con soporte para las paletas cocreadas.
class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme({
    AppPaletteType palette = AppPaletteType.oceanAdventure,
  }) {
    final p = AppColors.paletteFor(palette);
    return _buildWithColors(
      primaryColor: p.primary,
      accentColor: p.accent,
      canvasColor: p.canvas,
    );
  }

  static ThemeData buildTheme([
    AppVisualPalette palette = AppVisualPalette.exploradorClasico,
  ]) {
    final Color primaryColor;
    final Color accentColor;
    final Color canvasColor;

    switch (palette) {
      case AppVisualPalette.pastelSuave:
        primaryColor = const Color(0xFF283A8C);
        accentColor = const Color(0xFF42E3C8);
        canvasColor = const Color(0xFFF6F9FF);
      case AppVisualPalette.vibranteSolar:
        primaryColor = const Color(0xFF142072);
        accentColor = const Color(0xFF00D4B2);
        canvasColor = const Color(0xFFFFFBF2);
      case AppVisualPalette.calmaGithub:
        primaryColor = const Color(0xFF1F2937);
        accentColor = const Color(0xFF10B981);
        canvasColor = const Color(0xFFF6F8FA);
      case AppVisualPalette.exploradorClasico:
        primaryColor = AppColors.primary;
        accentColor = AppColors.secondary;
        canvasColor = AppColors.background;
    }

    return _buildWithColors(
      primaryColor: primaryColor,
      accentColor: accentColor,
      canvasColor: canvasColor,
    );
  }

  static ThemeData _buildWithColors({
    required Color primaryColor,
    required Color accentColor,
    required Color canvasColor,
  }) {
    final textTheme = AppTypography.buildTextTheme(primaryColor: primaryColor);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: canvasColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: AppColors.textOnPrimary,
        secondary: accentColor,
        onSecondary: primaryColor,
        surface: AppColors.surface,
        onSurface: primaryColor,
        error: AppColors.error,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusXl),
          side: const BorderSide(color: AppColors.borderDefault),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AdventureThemeExtension(
          warmCanvas: AppColors.adventureWarmBg,
          lavenderCanvas: AppColors.adventureLavenderBg,
          coralCanvas: AppColors.adventureCoralBg,
          roseCanvas: AppColors.adventureRoseBg,
          accentMint: accentColor,
        ),
      ],
    );
  }
}
