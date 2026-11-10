/// Sistema de espaciado (escala de Figma: 4 · 8 · 12 · 16 · 20 · 24 · 32 · 48).
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double mdLg = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusPill = 999.0;

  static const double minTouchTarget = 48.0;
  static const double compactBreakpoint = 600.0;
  static const double wideBreakpoint = 1024.0;
  static const double maxReadingWidth = 1200.0;
}

/// Radios de curvatura según componentes de Figma.
class AppRadius {
  const AppRadius._();

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;
}
