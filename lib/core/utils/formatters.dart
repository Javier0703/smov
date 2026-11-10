/// Formateadores de duración, porcentaje y saldo para Brújula Quest.
class AppFormatters {
  const AppFormatters._();

  /// Formatea segundos en formato MM:SS (ej. 120 -> "02:00").
  static String formatCountdown(int totalSeconds) {
    final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
    final minutes = (safeSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (safeSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Formatea porcentaje redondeado (ej. 0.68 -> "68%").
  static String formatPercentage(double ratio) {
    final clamped = ratio.clamp(0.0, 1.0);
    return '${(clamped * 100).round()}%';
  }

  /// Formatea minutos de práctica escolar.
  static String formatMinutes(int minutes) => '$minutes min';
}

/// Utilidades de formato para vistas y tarjetas de indicadores.
class Formatters {
  const Formatters._();

  static String coinsWithLabel(int coins) => '$coins monedas';

  static String percentage(int pct) => '$pct%';

  static String durationSeconds(int totalSeconds) {
    final safe = totalSeconds < 0 ? 0 : totalSeconds;
    final mins = safe ~/ 60;
    final secs = safe % 60;
    if (mins == 0) return '${secs}s';
    return '${mins}m ${secs.toString().padLeft(2, '0')}s';
  }
}
