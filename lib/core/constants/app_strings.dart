/// Textos constantes y vocabulario pedagógico unificado (hablar de casillas, no de pasos).
class AppStrings {
  const AppStrings._();

  static const String appName = 'Brújula Quest · Sociales';
  static const String appBadge = 'Brújula Quest · Sociales';
  static const String appBrandTag = 'BRÚJULA QUEST · SOCIALES';

  // Bienvenida (/welcome)
  static const String welcomeTitle = '¡Tu aventura tiene un nombre!';
  static const String welcomeSubtitle =
      'Tu gran aventura por el mapa de España';
  static const String welcomeDescription =
      'Explora los puntos cardinales, lee planos por casillas y colecciona los sellos de las 17 comunidades autónomas.';
  static const String welcomeStartButton = 'Soy alumno · Empezar expedición';
  static const String welcomeCustomizeAvatarButton =
      'Personalizar mi personaje';
  static const String welcomeTeacherAccessButton =
      'Acceso docente · Ver espacio de clase';
  static const String createCharacterCta = 'Crear mi personaje';
  static const String roleSwitchFooter = 'Acceso alumnado · Acceso docente';

  // Avatar (/avatar)
  static const String avatarScreenTitle = 'Tu personaje, a tu manera';
  static const String avatarScreenSubtitle =
      'Elige el aspecto y uniforme de tu explorador';
  static const String avatarSaveButton = 'Guardar personaje';

  // Inicio (/home)
  static const String homeSubtitle = 'MI PASAPORTE DE EXPLORACIÓN';
  static const String homeOrientationStampsTitle = 'Sellos de orientación';
  static const String homeNextMissionBadge = 'SIGUIENTE MISIÓN';
  static const String homeContinueButton = 'Continuar expedición';
  static const String homeMyAvatarAction = 'Mi personaje';
  static const String homeMyActivityAction = 'Mi actividad';
  static const String homePiecesLabel = 'Piezas';
  static const String homeBadgesLabel = 'Insignias';
  static const String homeRouteLabel = 'Ruta';

  // Catálogo de aventuras (/adventures)
  static const String adventuresScreenTitle = 'Elige tu aventura';
  static const String adventuresScreenTag = '10 JUEGOS DE EXPLORACIÓN';
  static const String adventuresScreenSubtitle =
      'Supera cada reto para ganar monedas, sellos en tu pasaporte e insignias en tu medallero.';

  // Cómo jugar (/games/:gameId/how-to)
  static const String howToPlayTitle = 'Antes de jugar';
  static const String howToPlayTag = 'CÓMO SE JUEGA';
  static const String howToPlayStartButton = '¡Entendido, empezar a jugar!';

  // Mochila en partida y tienda (/inventory)
  static const String inGameBackpackTitle = 'Tu mochila en esta prueba';
  static const String inventoryScreenTitle = 'Mi mochila';
  static const String inventoryScreenSubtitle = 'Tus monedas y ayudas';
  static const String itemMagnifyingGlass = 'Lupa de pistas';
  static const int itemMagnifyingGlassCost = 120;
  static const String itemHourglass = 'Reloj de arena';
  static const int itemHourglassCost = 180;
  static const String itemSpecialCompass = 'Brújula especial';
  static const int itemSpecialCompassCost = 300;

  // Resultados (/results/:sessionId)
  static const String levelCompletedDefaultTitle = '¡Rumbo superado!';
  static const String grandExplorerTitle = '¡Gran explorador!';
  static const String grandExplorerSubtitle =
      'Has superado las 7 pruebas del Gran Reto y dominado la geografía de España.';

  // Medallero (/medals)
  static const String medalsScreenTitle = 'Mi medallero';
  static const String medalsScreenSubtitle = 'Tus insignias de exploración';
  static const String medalsRedeemButton = 'Canjear mis monedas';

  // Pasaporte (/passport)
  static const String passportScreenTitle = 'Mi pasaporte';
  static const String passportScreenSubtitle =
      '17 comunidades autónomas · Sellos y postales';

  // Actividad (/activity)
  static const String activityScreenTitle = 'Mi actividad';
  static const String activityScreenSubtitle = 'Estadísticas del explorador';

  // Docente (/questions/:questionId)
  static const String questionEditorTitle =
      'Editor de preguntas — Adapta una prueba a tu clase';
  static const String questionSaveDraftButton = 'Guardar borrador';

  // Navegación
  static const String navHome = 'Inicio';
  static const String navMissions = 'Misiones';
  static const String navMedals = 'Medallas';
  static const String navPassport = 'Pasaporte';

  static const String streakDefaultPhrase = 'Cada casilla cuenta. ¡A tu ritmo!';
  static const String safeLearningFooter =
      'Tu progreso es personal. No hay ranking entre compañeros.';
}
