/// Configuración global de la aplicación Brújula Quest (GeoExplorer).
class AppConfig {
  const AppConfig._();

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Brújula Quest',
  );

  static const String appArea = String.fromEnvironment(
    'APP_AREA',
    defaultValue: 'Sociales',
  );

  static const String defaultClassId = '4A';
  static const String defaultClassLabel = '4.º A';
  static const String defaultGradeLabel = '4.º de Primaria';

  static const int totalAdventures = 10;
  static const int totalAutonomousCommunities = 17;
  static const int totalAutonomousEntities = 19; // 17 CCAA + Ceuta y Melilla
  static const int levelCompletionRewardCoins = 40;
  static const int finalChallengeBonusCoins = 300;
  static const int dailyRewardCoins = 20;
}
