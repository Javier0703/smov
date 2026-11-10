import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Definición de un nivel dentro de una aventura geográfica.
class AdventureLevelInfo {
  const AdventureLevelInfo({
    required this.levelNumber,
    required this.codeLabel,
    required this.categoryTag,
    required this.title,
    required this.description,
    required this.rewardCoins,
    required this.isCompleted,
    required this.isEnabledByTeacher,
    required this.isUnlockedByProgression,
  });

  final int levelNumber;
  final String codeLabel;
  final String categoryTag;
  final String title;
  final String description;
  final int rewardCoins;
  final bool isCompleted;
  final bool isEnabledByTeacher;
  final bool isUnlockedByProgression;

  bool get canPlay => isEnabledByTeacher && isUnlockedByProgression;

  String get statusLabel {
    if (!isEnabledByTeacher) return 'No disponible para tu clase';
    if (isCompleted) return 'Superado · Repetir práctica';
    if (isUnlockedByProgression) return 'Disponible';
    return 'Supera el nivel anterior';
  }
}

/// Modelo completo de uno de los 10 juegos de exploración de `Brújula Quest`.
class AdventureGameModel {
  const AdventureGameModel({
    required this.id,
    required this.orderNumber,
    required this.title,
    required this.competencyTag,
    required this.shortDescription,
    required this.howToPlayObjective,
    required this.howToPlaySteps,
    required this.achievementTitle,
    required this.medalNumber,
    required this.tintColor,
    required this.icon,
    required this.levels,
  });

  final String id;
  final int orderNumber;
  final String title;
  final String competencyTag;
  final String shortDescription;
  final String howToPlayObjective;
  final List<String> howToPlaySteps;
  final String achievementTitle;
  final int medalNumber;
  final Color tintColor;
  final IconData icon;
  final List<AdventureLevelInfo> levels;

  int get completedLevelsCount => levels.where((l) => l.isCompleted).length;

  int get enabledLevelsCount =>
      levels.where((l) => l.isEnabledByTeacher).length;
}

/// Catálogo base de las 10 aventuras oficiales de Figma.
abstract final class AdventuresCatalogDefinitions {
  static List<AdventureGameModel> buildCatalog({
    required Map<String, Set<int>> completedByGame,
    required Map<String, Set<int>> enabledByTeacher,
  }) {
    List<AdventureLevelInfo> buildLevels(
      String gameId,
      List<(String tag, String title, String desc, int coins)> specs,
    ) {
      final completed = completedByGame[gameId] ?? const <int>{};
      final enabled = enabledByTeacher[gameId] ?? const <int>{1, 2, 3};
      final list = <AdventureLevelInfo>[];

      for (var i = 0; i < specs.length; i++) {
        final levelNum = i + 1;
        final spec = specs[i];
        final prevCompleted = levelNum == 1 || completed.contains(levelNum - 1);
        list.add(
          AdventureLevelInfo(
            levelNumber: levelNum,
            codeLabel: '0$levelNum',
            categoryTag: spec.$1,
            title: spec.$2,
            description: spec.$3,
            rewardCoins: spec.$4,
            isCompleted: completed.contains(levelNum),
            isEnabledByTeacher: enabled.contains(levelNum),
            isUnlockedByProgression: prevCompleted || levelNum <= 2,
          ),
        );
      }
      return list;
    }

    return <AdventureGameModel>[
      AdventureGameModel(
        id: 'rumbo_desconocido',
        orderNumber: 1,
        title: '¡Rumbo desconocido!',
        competencyTag: 'Puntos cardinales',
        shortDescription: 'Sigue las indicaciones de la brújula y avanza por casillas hasta el refugio.',
        howToPlayObjective: 'Lee la misión de orientación y desplaza a tu explorador el número exacto de casillas en la dirección cardinal indicada.',
        howToPlaySteps: const <String>[
          'Observa la rosa de los vientos en la esquina del tablero: el Norte (N) está arriba.',
          'Cuenta las casillas que te pide la pista antes de moverte (evita rocas y ríos).',
          'Si necesitas ayuda, abre Tu mochila en esta prueba para usar una lupa de pistas.',
        ],
        achievementTitle: 'Buen rumbo',
        medalNumber: 1,
        tintColor: AppColors.adventureRumboTint,
        icon: Icons.explore_rounded,
        levels: buildLevels('rumbo_desconocido', const [
          (
            'NIVEL 1 · INICIAL',
            'Cuatro rumbos principales (N, S, E, O)',
            'Desplázate por la cuadrícula siguiendo direcciones cardinales básicas por casillas.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Ocho direcciones y obstáculos naturales',
            'Combina rumbos como Noreste (NE) o Suroeste (SO) bordeando montañas y lagos.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Secuencia de exploración encadenada',
            'Completa un itinerario de varios tramos consecutivos por casillas sin flechas guía.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'brujula_perdida',
        orderNumber: 2,
        title: 'La brújula perdida',
        competencyTag: 'Orientación',
        shortDescription: 'Gira la aguja magnética roja y blanca hacia el punto cardinal o colateral correcto.',
        howToPlayObjective: 'Apunta la aguja de la brújula hacia el rumbo solicitado tomando como referencia el Sol, la Estrella Polar o los hitos del paisaje.',
        howToPlaySteps: const <String>[
          'Recuerda que la punta roja imantada señala la dirección activa de tu rumbo.',
          'Toca o arrastra sobre las letras N, NE, E, SE, S, SO, O, NO de la esfera.',
          'Pulsa Comprobar rumbo cuando la aguja apunte al destino de la misión.',
        ],
        achievementTitle: 'Rosa de los vientos',
        medalNumber: 2,
        tintColor: AppColors.adventureBrujulaTint,
        icon: Icons.compass_calibration_rounded,
        levels: buildLevels('brujula_perdida', const [
          (
            'NIVEL 1 · INICIAL',
            'Norte, Sur, Este y Oeste con pistas del Sol',
            'Orienta la aguja usando el amanecer por el Este y el atardecer por el Oeste.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Rosa completa de 8 puntas (NE, SE, SO, NO)',
            'Calibra la brújula hacia los rumbos intermedios entre montañas y costas.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Giros relativos y cambio de viento',
            'Calcula a qué dirección miras tras girar 90° o 135° desde tu rumbo inicial.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'encuentra_lugar',
        orderNumber: 3,
        title: '¡Encuentra el lugar!',
        competencyTag: 'Lectura de mapas',
        shortDescription: 'Localiza refugios, puentes, bosques y cumbres usando coordenadas de cuadrícula.',
        howToPlayObjective: 'Cruza la letra de la columna y el número de la fila en el plano topográfico para tocar la casilla exacta del elemento buscado.',
        howToPlaySteps: const <String>[
          'Lee el elemento que busca la expedición y su pista geográfica o coordenada.',
          'Toca la casilla correspondiente dentro del plano cuadriculado.',
          'Observa la leyenda del mapa para distinguir cumbres, ríos, puentes y refugios.',
        ],
        achievementTitle: 'Lector de mapas',
        medalNumber: 3,
        tintColor: AppColors.adventureEncuentraTint,
        icon: Icons.pin_drop_rounded,
        levels: buildLevels('encuentra_lugar', const [
          (
            'NIVEL 1 · INICIAL',
            'Símbolos básicos y coordenadas directas',
            'Localiza el campamento, el puente y el bosque en la cuadrícula del valle.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Posición relativa entre elementos del plano',
            'Encuentra el lugar situado al Norte del río y al Este del mirador.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Lectura combinada de altitud y leyenda',
            'Identifica el paso de montaña correcto interpretando todos los símbolos.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'llegar_a_tiempo',
        orderNumber: 4,
        title: 'Misión: llegar a tiempo',
        competencyTag: 'Recorridos',
        shortDescription: 'Elige el camino más eficiente por casillas antes de que anochezca en la montaña.',
        howToPlayObjective: 'Planifica y recorre casilla a casilla la ruta más rápida hacia la meta teniendo en cuenta el coste de paso de cada terreno.',
        howToPlaySteps: const <String>[
          'Los senderos despejados consumen menos tiempo que cruzar zonas rocosas.',
          'Toca las casillas contiguas para trazar tu recorrido hasta la bandera.',
          'Si usas el Reloj de arena de tu mochila, sumarás +20 segundos extra.',
        ],
        achievementTitle: 'A tiempo',
        medalNumber: 4,
        tintColor: AppColors.adventureTiempoTint,
        icon: Icons.timer_rounded,
        levels: buildLevels('llegar_a_tiempo', const [
          (
            'NIVEL 1 · INICIAL',
            'Sendero directo al refugio del valle',
            'Traza una ruta corta por casillas evitando las barreras de roca.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Cruce de puentes y elección de desvío',
            'Compara dos caminos posibles y elige el que requiere menos casillas.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Rescate contrarreloj con parada intermedia',
            'Recoge el botiquín y llega a la cima antes de que termine la cuenta atrás.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'tesoro_secreto',
        orderNumber: 5,
        title: 'El tesoro secreto',
        competencyTag: 'Leyendas y pistas',
        shortDescription: 'Descifra el pergamino de pistas encadenadas para desenterrar la reliquia cartográfica.',
        howToPlayObjective: 'Sigue en orden las 3 pistas del pergamino sobre el mapa de la isla para descubrir en qué casilla está escondido el cofre.',
        howToPlaySteps: const <String>[
          'Empieza en el punto de partida indicado en la primera pista del pergamino.',
          'Aplica cada desplazamiento por casillas y orientación sobre el mapa.',
          'Marca la casilla final para abrir el cofre del tesoro secreto.',
        ],
        achievementTitle: 'Buscatesoros',
        medalNumber: 5,
        tintColor: AppColors.adventureTesoroTint,
        icon: Icons.diamond_rounded,
        levels: buildLevels('tesoro_secreto', const [
          (
            'NIVEL 1 · INICIAL',
            'Pergamino de 2 pistas cardinales',
            'Sigue dos instrucciones sencillas desde el faro hasta la palmera.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Pergamino de 3 pistas con símbolos de leyenda',
            'Combina puntos cardinales y símbolos del mapa para hallar el cofre.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Enigma del cartógrafo antiguo',
            'Descarta lugares falsos usando pistas de distancia por casillas.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'construye_mapa',
        orderNumber: 6,
        title: 'Construye el mapa',
        competencyTag: 'Cartografía',
        shortDescription: 'Coloca cada símbolo cartográfico en la zona correcta según la descripción geográfica.',
        howToPlayObjective: 'Selecciona los símbolos de la leyenda (cordillera, río, capital, bosque, puerto) y ubícalos en las casillas indicadas del mapa mudo.',
        howToPlaySteps: const <String>[
          'Elige un símbolo cartográfico del panel inferior de herramientas.',
          'Lee dónde debe situarse (por ejemplo: la cordillera al Norte del valle).',
          'Toca la casilla del mapa para estampar el símbolo y completar el plano.',
        ],
        achievementTitle: 'Cartografía',
        medalNumber: 6,
        tintColor: AppColors.adventureConstruyeTint,
        icon: Icons.grid_on_rounded,
        levels: buildLevels('construye_mapa', const [
          (
            'NIVEL 1 · INICIAL',
            'Cuatro elementos físicos básicos',
            'Sitúa las montañas al Norte, el puerto al Sur, el bosque al Oeste y el lago al Este.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Plano comarcal con localidades y puentes',
            'Construye un mapa completo respetando las relaciones entre río y poblaciones.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Restauración de un mapa histórico incompleto',
            'Deduce la posición de todos los símbolos a partir del cuaderno del explorador.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'donde_estoy',
        orderNumber: 7,
        title: '¿Dónde estoy?',
        competencyTag: 'Posición y límites',
        shortDescription: 'Lee con qué territorios o relieves limita tu posición y adivina dónde te encuentras.',
        howToPlayObjective: 'Analiza las pistas de límites geográficos (al Norte, al Sur, al Este y al Oeste) e identifica la región o punto exacto en el mapa.',
        howToPlaySteps: const <String>[
          'Lee atentamente las 3 pistas sobre qué mares, montañas o comunidades tienes alrededor.',
          'Observa el mapa de España y busca qué territorio cumple todas las condiciones.',
          'Toca la región en el mapa o selecciónala para confirmar tu deducción.',
        ],
        achievementTitle: 'Detective del mapa',
        medalNumber: 7,
        tintColor: AppColors.adventureDondeTint,
        icon: Icons.travel_explore_rounded,
        levels: buildLevels('donde_estoy', const [
          (
            'NIVEL 1 · INICIAL',
            'Pistas de mar, frontera y puntos cardinales',
            'Identifica comunidades costeras y fronterizas con pistas muy claras.',
            40,
          ),
          (
            'NIVEL 2 · INTERMEDIO',
            'Límites entre comunidades del interior',
            'Deduce en qué comunidad estás sabiendo qué territorios tienes al Norte y al Sur.',
            40,
          ),
          (
            'NIVEL 3 · AVANZADO',
            'Detective de provincias y relieves ibéricos',
            'Resuelve acertijos geográficos combinando ríos, sistemas montañosos y límites.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'espana_en_tus_manos',
        orderNumber: 8,
        title: 'España en tus manos',
        competencyTag: 'Territorio',
        shortDescription: 'Puzle interactivo del mapa de España: Comunidades Autónomas, Castilla y León y Provincias.',
        howToPlayObjective: 'Identifica y coloca cada territorio sobre el mapa vectorial de España o de Castilla y León según el nivel seleccionado.',
        howToPlaySteps: const <String>[
          'En el Nivel 1 explorarás las 17 Comunidades Autónomas y las ciudades autónomas de Ceuta y Melilla.',
          'En el Nivel 2 dominarás las 9 provincias de nuestra comunidad: Castilla y León.',
          'En el Nivel 3 pondrás a prueba tu dominio de las provincias de toda España.',
        ],
        achievementTitle: 'Explorador de España',
        medalNumber: 8,
        tintColor: AppColors.adventureEspanaTint,
        icon: Icons.map_rounded,
        levels: buildLevels('espana_en_tus_manos', const [
          (
            'TERRITORIO AUTONÓMICO',
            'Comunidades autónomas',
            'Sitúa las 17 comunidades autónomas y Ceuta y Melilla en el mapa de España.',
            40,
          ),
          (
            'NUESTRA COMUNIDAD',
            'Castilla y León',
            'Localiza las 9 provincias de Castilla y León: León, Palencia, Burgos, Zamora, Valladolid, Soria, Salamanca, Ávila y Segovia.',
            40,
          ),
          (
            'MAPA PROVINCIAL',
            'Provincias de España',
            'Reto avanzado sobre las provincias de España (habilitable por el docente para la clase).',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'viaje_por_espana',
        orderNumber: 9,
        title: 'El viaje por España',
        competencyTag: 'Itinerario y sellos',
        shortDescription: 'Traza una ruta pasando de una comunidad autónoma a otra limítrofe y colecciona postales.',
        howToPlayObjective: 'Conecta la comunidad de origen con la comunidad de destino tocando paso a paso comunidades autónomas vecinas en el mapa.',
        howToPlaySteps: const <String>[
          'Observa la comunidad de salida y la comunidad meta de tu viaje.',
          'Toca en el mapa una comunidad limítrofe (vecina) para avanzar un tramo de la ruta.',
          'Cada comunidad visitada sellará tu pasaporte y desbloqueará su postal cultural.',
        ],
        achievementTitle: 'Viajero peninsular',
        medalNumber: 8,
        tintColor: AppColors.adventureViajeTint,
        icon: Icons.route_rounded,
        levels: buildLevels('viaje_por_espana', const [
          (
            'NIVEL 1 · RUTA NORTE-CENTRO',
            'De Galicia a Madrid por comunidades vecinas',
            'Conecta el noroeste con el centro pasando por Castilla y León.',
            40,
          ),
          (
            'NIVEL 2 · RUTA DE COSTA A COSTA',
            'Del Cantábrico al Mediterráneo y Andalucía',
            'Traza un itinerario continuo sin saltar fronteras no colindantes.',
            40,
          ),
          (
            'NIVEL 3 · GRAN VUELTA IBÉRICA',
            'Ruta con parada obligatoria intermedia',
            'Completa el viaje visitando las comunidades indicadas en el menor número de tramos.',
            60,
          ),
        ]),
      ),
      AdventureGameModel(
        id: 'gran_reto',
        orderNumber: 10,
        title: 'El gran reto del explorador',
        competencyTag: 'Expedición final',
        shortDescription: 'Supera las 7 pruebas combinadas de orientación, mapas y territorio para graduarte como Gran Explorador.',
        howToPlayObjective: 'Demuestra todo lo aprendido superando una expedición de 7 preguntas variadas que combinan brújula, planos por casillas, comunidades y provincias.',
        howToPlaySteps: const <String>[
          'Responderás 7 retos seguidos de todos los bloques de Geografía.',
          'Puedes abrir tu mochila en cualquier prueba para usar lupas, reloj o brújula especial.',
          'Al completar la expedición recibirás el título de ¡Gran explorador! y +300 monedas.',
        ],
        achievementTitle: '¡Gran explorador!',
        medalNumber: 8,
        tintColor: AppColors.adventureGranRetoTint,
        icon: Icons.workspace_premium_rounded,
        levels: buildLevels('gran_reto', const [
          (
            'EXPEDICIÓN OFICIAL',
            'Las 7 pruebas del Gran Explorador',
            'Supera el recorrido completo de 7 retos para desbloquear el diploma y +300 monedas.',
            300,
          ),
          (
            'EXPEDICIÓN EXPERTA',
            'Reto de precisión cartográfica',
            'Supera las 7 pruebas con rumbos de 8 puntas y provincias de Castilla y León.',
            300,
          ),
          (
            'EXPEDICIÓN MAESTRA',
            'Desafío nacional completo',
            'Combina orientación avanzada, lectura de mapas y todas las comunidades autónomas.',
            300,
          ),
        ]),
      ),
    ];
  }
}
