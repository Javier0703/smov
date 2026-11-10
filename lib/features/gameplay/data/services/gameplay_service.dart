import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../../../../shared/widgets/vector/compass_rose_widget.dart';
import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';
import '../models/gameplay_models.dart';

/// Servicio de misiones interactivas, consumo de mochila y cierre idempotente de partida.
class GameplayService {
  GameplayService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;
  Map<String, int> getInventoryCounts() => _store.inventoryCounts;

  bool consumeHelperItem(String itemId) => _store.consumeInventoryItem(itemId);

  void stampCommunity(String communityId) =>
      _store.addStampedCommunity(communityId);

  Future<int> completeSession({
    required String sessionId,
    required String gameId,
    required String gameTitle,
    required int levelNumber,
    required int correctAnswers,
    required int totalAttempts,
    required int durationSeconds,
    required int rewardCoins,
    int? unlockedMedalNumber,
    List<String> newlyStampedCommunities = const <String>[],
  }) {
    return _store.recordGameSession(
      sessionId: sessionId,
      gameId: gameId,
      gameTitle: gameTitle,
      level: levelNumber,
      correctAnswers: correctAnswers,
      totalAttempts: totalAttempts,
      durationSeconds: durationSeconds,
      rewardCoins: rewardCoins,
      unlockedMedalNumber: unlockedMedalNumber,
      newlyStampedCommunities: newlyStampedCommunities,
    );
  }

  /// Genera la secuencia de rondas para cualquiera de los 10 juegos.
  List<GameRoundChallenge> buildRoundsForGame({
    required String gameId,
    required int levelNumber,
  }) {
    switch (gameId) {
      case 'rumbo_desconocido':
        return _buildRumboRounds(levelNumber);
      case 'brujula_perdida':
        return _buildBrujulaRounds(levelNumber);
      case 'encuentra_lugar':
        return _buildEncuentraLugarRounds(levelNumber);
      case 'llegar_a_tiempo':
        return _buildLlegarATiempoRounds(levelNumber);
      case 'tesoro_secreto':
        return _buildTesoroSecretoRounds(levelNumber);
      case 'construye_mapa':
        return _buildConstruyeMapaRounds(levelNumber);
      case 'donde_estoy':
        return _buildDondeEstoyRounds(levelNumber);
      case 'espana_en_tus_manos':
        return _buildEspanaEnTusManosRounds(levelNumber);
      case 'viaje_por_espana':
        return _buildViajePorEspanaRounds(levelNumber);
      case 'gran_reto':
        return _buildGranRetoRounds(levelNumber);
      default:
        return _buildRumboRounds(levelNumber);
    }
  }

  List<GameRoundChallenge> _buildRumboRounds(int level) {
    return <GameRoundChallenge>[
      const GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Tramo 1 · Hacia el Refugio del Norte',
        instruction: 'Desde tu casilla actual (E2), desplázate 3 casillas al Norte (N) y 2 casillas al Este (E) hasta llegar a la bandera del refugio.',
        hint: 'En el tablero, subir 1 fila es avanzar 1 casilla al Norte y moverte a la derecha es ir al Este.',
        startCoord: GridCoord(4, 1),
        targetCoord: GridCoord(1, 3),
        obstacles: <GridCoord>[GridCoord(2, 1), GridCoord(3, 4)],
      ),
      const GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Tramo 2 · Rodeando el Lago Azul',
        instruction: 'Avanza por casillas desde el campamento (B1) hasta el mirador (D5), evitando caer en las casillas de agua y roca.',
        hint: 'El mirador está en la fila D (cuarta fila) y columna 5 (quinta columna).',
        startCoord: GridCoord(1, 0),
        targetCoord: GridCoord(3, 4),
        obstacles: <GridCoord>[
          GridCoord(2, 2),
          GridCoord(2, 3),
          GridCoord(1, 3),
        ],
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Tramo 3 · Rumbo combinado Nivel $level',
        instruction: 'Desplázate desde (E5) 3 casillas al Noroeste (NO) hasta alcanzar la cumbre señalizada en (B2).',
        hint: 'Ir al Noroeste combina Norte (arriba) y Oeste (izquierda): llega a la fila B, columna 2.',
        startCoord: const GridCoord(4, 4),
        targetCoord: const GridCoord(1, 1),
        obstacles: const <GridCoord>[GridCoord(3, 2), GridCoord(2, 4)],
      ),
    ];
  }

  List<GameRoundChallenge> _buildBrujulaRounds(int level) {
    return <GameRoundChallenge>[
      const GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Calibración 1 · Amanecer en la sierra',
        instruction: 'El Sol acaba de salir por las montañas. Gira la aguja magnética roja y blanca para apuntar exactamente hacia el Este (E).',
        hint: 'El Sol sale por el Este (E), a la derecha de la rosa de los vientos (90°).',
        targetDirection: CardinalDirection.e,
      ),
      const GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Calibración 2 · Rumbo entre Norte y Este',
        instruction: 'El faro costero se encuentra justo a mitad de camino entre el Norte y el Este. Apunta la brújula al Noreste (NE).',
        hint:
            'Busca las siglas NE en la esquina superior derecha de la esfera.',
        targetDirection: CardinalDirection.ne,
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Calibración 3 · Viento del Suroeste (Nivel $level)',
        instruction: 'Una tormenta se acerca entre el Sur y el Oeste. Orienta la aguja hacia el Suroeste (SO) para avisar al campamento.',
        hint: 'El Suroeste (SO) está entre el Sur (S, abajo) y el Oeste (O, izquierda).',
        targetDirection: CardinalDirection.so,
      ),
    ];
  }

  List<GameRoundChallenge> _buildEncuentraLugarRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Lectura 1 · El Puente Colgante',
        instruction: 'Localiza y toca en el plano la casilla donde se encuentra el Puente Colgante: fila B, columna 4 (B4).',
        hint: 'Mira la letra B en el borde izquierdo y sigue hasta la columna número 4.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 3),
        symbolLabel: 'Puente',
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Lectura 2 · El Bosque de Pinos',
        instruction: 'El Bosque de Pinos está situado 2 casillas al Sur del Puente (B4). Toca su casilla exacta (D4).',
        hint: 'Bajar 2 casillas desde la fila B te lleva a la fila D en la misma columna 4.',
        startCoord: GridCoord(1, 3),
        targetCoord: GridCoord(3, 3),
        symbolLabel: 'Bosque',
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Lectura 3 · El Observatorio Astronómico',
        instruction: 'Toca la casilla del Observatorio situado en el extremo Noroeste del mapa: coordenada A1.',
        hint:
            'El Noroeste es la esquina superior izquierda (Fila A, Columna 1).',
        startCoord: GridCoord(3, 3),
        targetCoord: GridCoord(0, 0),
        symbolLabel: 'Cumbre',
      ),
    ];
  }

  List<GameRoundChallenge> _buildLlegarATiempoRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridTimedPath,
        title: 'Ruta 1 · Sendero antes del anochecer',
        instruction: 'Avanza casilla a casilla desde (E1) hasta la cabaña (B4) sin pisar las rocas grises para llegar a tiempo.',
        hint: 'Puedes subir por la columna 1 hasta la fila B y luego avanzar al Este hasta B4.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 3),
        obstacles: <GridCoord>[GridCoord(3, 1), GridCoord(2, 2)],
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridTimedPath,
        title: 'Ruta 2 · Paso del desfiladero',
        instruction: 'Guía al equipo desde (A2) hasta el helipuerto en (E5) eligiendo casillas despejadas.',
        hint: 'Rodea la barrera central por el Este hasta alcanzar la esquina inferior derecha (E5).',
        startCoord: GridCoord(0, 1),
        targetCoord: GridCoord(4, 4),
        obstacles: <GridCoord>[
          GridCoord(2, 1),
          GridCoord(2, 2),
          GridCoord(2, 3),
        ],
      ),
    ];
  }

  List<GameRoundChallenge> _buildTesoroSecretoRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridTreasureClues,
        title: 'Pergamino 1 · El Cofre del Cartógrafo',
        instruction: 'Lee las 3 pistas del pergamino y toca la casilla exacta donde está enterrado el tesoro.',
        hint: 'Empieza en D2 -> sube 2 casillas al Norte (B2) -> avanza 2 casillas al Este (B4).',
        startCoord: GridCoord(3, 1),
        targetCoord: GridCoord(1, 3),
        clues: <String>[
          '1. Parte desde el Faro Antiguo en la casilla D2.',
          '2. Camina 2 casillas hacia el Norte (N) siguiendo la costa.',
          '3. Gira al Este (E) y avanza 2 casillas más: ¡ahí brilla el cofre (B4)!',
        ],
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridTreasureClues,
        title: 'Pergamino 2 · La Reliquia del Valle',
        instruction: 'Sigue las pistas encadenadas desde la casilla A5 para descubrir el escondite secreto.',
        hint: 'Desde A5 baja 3 casillas al Sur (D5) y muévete 3 casillas al Oeste (D2).',
        startCoord: GridCoord(0, 4),
        targetCoord: GridCoord(3, 1),
        clues: <String>[
          '1. Empieza en la Cumbre Nevada de la casilla A5.',
          '2. Desciende 3 casillas hacia el Sur (S).',
          '3. Avanza 3 casillas hacia el Oeste (O) hasta la casilla D2.',
        ],
      ),
    ];
  }

  List<GameRoundChallenge> _buildConstruyeMapaRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.cartographyBuilder,
        title: 'Plano 1 · La Cordillera del Norte',
        instruction: 'Selecciona el símbolo "Cordillera" y colócalo en la frontera Norte central del mapa (casilla A3).',
        hint: 'El Norte está en la primera fila (Fila A). Toca la columna central (3).',
        startCoord: GridCoord(2, 2),
        targetCoord: GridCoord(0, 2),
        symbolLabel: 'Cordillera',
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.cartographyBuilder,
        title: 'Plano 2 · El Puerto Marítimo del Sur',
        instruction: 'Ahora coloca el símbolo "Puerto" en la costa Sur del mapa (casilla E3).',
        hint: 'El Sur corresponde a la fila inferior (Fila E), columna 3.',
        startCoord: GridCoord(0, 2),
        targetCoord: GridCoord(4, 2),
        symbolLabel: 'Puerto',
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.cartographyBuilder,
        title: 'Plano 3 · El Bosque del Oeste',
        instruction: 'Completa la cartografía ubicando el símbolo "Bosque" en el límite Oeste (casilla C1).',
        hint: 'El Oeste está a la izquierda (Columna 1). Busca la fila C.',
        startCoord: GridCoord(4, 2),
        targetCoord: GridCoord(2, 0),
        symbolLabel: 'Bosque',
      ),
    ];
  }

  List<GameRoundChallenge> _buildDondeEstoyRounds(int level) {
    final rounds = <GameRoundChallenge>[
      const GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.whereAmIRiddle,
        title: 'Acertijo 1 · Entre el Cantábrico y la Meseta',
        instruction: 'Lee las pistas de posición y límites y toca la comunidad autónoma correcta en el mapa o en las opciones.',
        hint: 'Está en el norte de España, entre Galicia y Cantabria, famosa por los Picos de Europa.',
        targetRegionId: 'asturias',
        clues: <String>[
          'Al Norte me baña el Mar Cantábrico.',
          'Al Oeste limito con Galicia y al Este con Cantabria.',
          'Al Sur me separa la Cordillera Cantábrica de Castilla y León.',
        ],
        options: <String>['Principado de Asturias', 'Aragón', 'Extremadura'],
        correctOptionIndex: 0,
      ),
      const GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.whereAmIRiddle,
        title: 'Acertijo 2 · El corazón de la submeseta norte',
        instruction: '¿En qué comunidad autónoma te encuentras si estás rodeado por 9 provincias históricas y el río Duero?',
        hint: 'Es la comunidad más extensa de España y en ella están León, Burgos, Salamanca y Valladolid.',
        targetRegionId: 'castilla_y_leon',
        clues: <String>[
          'Soy la comunidad autónoma más extensa de España.',
          'Al Norte tengo Asturias, Cantabria y País Vasco; al Oeste, Galicia y Portugal.',
          'Estoy formada por 9 provincias como León, Valladolid, Burgos y Salamanca.',
        ],
        options: <String>['Castilla-La Mancha', 'Castilla y León', 'La Rioja'],
        correctOptionIndex: 1,
      ),
    ];

    // Si el docente ha publicado una pregunta personalizada para la clase, la añadimos
    final custom = _store.customQuestions['q_default'];
    if (custom != null && custom.isPublished) {
      rounds.add(
        GameRoundChallenge(
          roundNumber: 3,
          mechanic: ChallengeMechanicType.whereAmIRiddle,
          title: 'Reto de tu docente · Clase ${custom.classId}',
          instruction: custom.prompt,
          hint: custom.hint,
          targetRegionId: 'madrid',
          clues: <String>[
            'Pregunta adaptada especialmente para la clase ${custom.classId}.',
          ],
          options: <String>[
            custom.correctOption,
            custom.distractorA,
            custom.distractorB,
          ],
          correctOptionIndex: 0,
        ),
      );
    }
    return rounds;
  }

  List<GameRoundChallenge> _buildEspanaEnTusManosRounds(int level) {
    if (level == 2) {
      // Nivel 2: Las 9 provincias de Castilla y León
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.castillaYLeonProvinces,
          title: 'Castilla y León · Provincia 1 de 4',
          instruction: 'Toca en el mapa de Castilla y León la provincia de VALLADOLID, situada en el centro de la comunidad.',
          hint: 'Valladolid está en el corazón de Castilla y León, rodeada por León, Palencia, Burgos, Segovia, Ávila, Salamanca y Zamora.',
          targetRegionId: 'valladolid',
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.castillaYLeonProvinces,
          title: 'Castilla y León · Provincia 2 de 4',
          instruction: 'Localiza y toca en el mapa la provincia de LEÓN, situada en el extremo Noroeste de Castilla y León.',
          hint: 'León está arriba a la izquierda (Noroeste), limitando con Galicia y Asturias.',
          targetRegionId: 'leon',
        ),
        GameRoundChallenge(
          roundNumber: 3,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.castillaYLeonProvinces,
          title: 'Castilla y León · Provincia 3 de 4',
          instruction: 'Ahora toca la provincia de SALAMANCA, en el Suroeste de Castilla y León.',
          hint: 'Salamanca está abajo a la izquierda (Suroeste), debajo de Zamora.',
          targetRegionId: 'salamanca',
        ),
        GameRoundChallenge(
          roundNumber: 4,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.castillaYLeonProvinces,
          title: 'Castilla y León · Provincia 4 de 4',
          instruction: 'Por último, localiza la provincia de BURGOS en el Noreste de nuestra comunidad.',
          hint: 'Burgos está en la zona Norte-Este, entre Palencia y Soria.',
          targetRegionId: 'burgos',
        ),
      ];
    } else if (level == 3) {
      // Nivel 3: Provincias de España
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.spainProvinces,
          title: 'Provincias de España · Reto 1 de 3',
          instruction: 'Localiza en el mapa provincial la provincia de ZARAGOZA, en el valle del Ebro.',
          hint: 'Zaragoza está en el centro de Aragón (Noreste peninsular).',
          targetRegionId: 'zaragoza',
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.spainProvinces,
          title: 'Provincias de España · Reto 2 de 3',
          instruction: 'Toca en el mapa la provincia de SEVILLA, en el valle del Guadalquivir (Andalucía).',
          hint: 'Sevilla está en el Suroeste peninsular.',
          targetRegionId: 'sevilla',
        ),
        GameRoundChallenge(
          roundNumber: 3,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.spainProvinces,
          title: 'Provincias de España · Reto 3 de 3',
          instruction: 'Localiza la provincia de A CORUÑA, en el extremo Noroeste de Galicia.',
          hint: 'Busca la esquina superior izquierda de la península.',
          targetRegionId: 'a_coruna',
        ),
      ];
    }

    // Nivel 1: Comunidades Autónomas
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.spainTerritoryMap,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Comunidades Autónomas · 1 de 3',
        instruction:
            'Toca en el mapa de España nuestra comunidad: CASTILLA Y LEÓN.',
        hint: 'Ocupa la gran submeseta norte en el interior noroccidental de la península.',
        targetRegionId: 'castilla_y_leon',
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.spainTerritoryMap,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Comunidades Autónomas · 2 de 3',
        instruction: 'Localiza y toca en el sur peninsular la comunidad autónoma de ANDALUCÍA.',
        hint: 'Andalucía se extiende por todo el Sur de la península ibérica.',
        targetRegionId: 'andalucia',
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.spainTerritoryMap,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Comunidades Autónomas · 3 de 3',
        instruction: 'Localiza el archipiélago atlántico de las ISLAS CANARIAS para completar el mapa.',
        hint: 'Las Islas Canarias están en el recuadro inferior izquierdo del mapa.',
        targetRegionId: 'canarias',
      ),
    ];
  }

  List<GameRoundChallenge> _buildViajePorEspanaRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.spainNeighborRoute,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Itinerario 1 · De Galicia a la Comunidad de Madrid',
        instruction: 'Estás en GALICIA. Toca comunidades autónomas limítrofes (vecinas) paso a paso hasta llegar a la COMUNIDAD DE MADRID.',
        hint: 'Desde Galicia puedes pasar a Castilla y León, y desde Castilla y León entrar en Madrid.',
        originRegionId: 'galicia',
        targetRegionId: 'madrid',
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.spainNeighborRoute,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Itinerario 2 · De Madrid hasta Andalucía',
        instruction: 'Continúa tu expedición desde la COMUNIDAD DE MADRID hasta llegar a ANDALUCÍA tocando comunidades vecinas.',
        hint: 'Pasa por Castilla-La Mancha (o Castilla y León -> Extremadura) hasta alcanzar Andalucía.',
        originRegionId: 'madrid',
        targetRegionId: 'andalucia',
      ),
    ];
  }

  List<GameRoundChallenge> _buildGranRetoRounds(int level) {
    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Prueba 1 de 7 · La Rosa de los Vientos',
        instruction: 'Apunta la aguja magnética roja y blanca hacia el Noroeste (NO) para iniciar la Gran Expedición.',
        hint: 'El Noroeste (NO) se sitúa entre el Norte (N) y el Oeste (O).',
        targetDirection: CardinalDirection.no,
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Prueba 2 de 7 · Rumbo por casillas',
        instruction: 'Desplaza al explorador desde (E1) hasta el campamento avanzado en (B3) avanzando por casillas libres.',
        hint: 'Sube 3 casillas al Norte y avanza 2 casillas al Este hasta la fila B, columna 3.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 2),
        obstacles: <GridCoord>[GridCoord(2, 0), GridCoord(3, 2)],
      ),
      GameRoundChallenge(
        roundNumber: 3,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Prueba 3 de 7 · Coordenada Cartográfica',
        instruction: 'Localiza en el plano topográfico el Refugio de Alta Montaña situado en la casilla A4.',
        hint: 'Fila A (primera fila superior), columna 4.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(0, 3),
        symbolLabel: 'Refugio',
      ),
      GameRoundChallenge(
        roundNumber: 4,
        mechanic: ChallengeMechanicType.whereAmIRiddle,
        title: 'Prueba 4 de 7 · Detective de Fronteras',
        instruction: '¿Qué comunidad autónoma tiene los Pirineos al Norte, Cataluña al Este y está atravesada por el río Ebro?',
        hint: 'Su capital es Zaragoza.',
        targetRegionId: 'aragon',
        clues: <String>[
          'Al Norte limito con Francia a través de los Pirineos.',
          'Al Este limito con Cataluña y al Oeste con Navarra, La Rioja y Castilla y León.',
          'El río Ebro cruza mi territorio pasando por Zaragoza.',
        ],
        options: <String>['Aragón', 'Región de Murcia', 'Galicia'],
        correctOptionIndex: 0,
      ),
      GameRoundChallenge(
        roundNumber: 5,
        mechanic: ChallengeMechanicType.spainTerritoryMap,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Prueba 5 de 7 · Territorio Autonómico',
        instruction: 'Toca en el mapa de España la COMUNIDAD VALENCIANA, en la costa del mar Mediterráneo.',
        hint: 'Está en la costa Este, al sur de Cataluña y al este de Castilla-La Mancha.',
        targetRegionId: 'valencia',
      ),
      GameRoundChallenge(
        roundNumber: 6,
        mechanic: ChallengeMechanicType.spainTerritoryMap,
        mapMode: SpainMapMode.castillaYLeonProvinces,
        title: 'Prueba 6 de 7 · Provincias de Castilla y León',
        instruction: 'En el mapa de Castilla y León, toca la provincia de SEGOVIA, famosa por su Acueducto romano.',
        hint: 'Segovia se encuentra en el sureste de Castilla y León, entre Ávila, Valladolid, Burgos y Soria.',
        targetRegionId: 'segovia',
      ),
      GameRoundChallenge(
        roundNumber: 7,
        mechanic: ChallengeMechanicType.spainNeighborRoute,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Prueba 7 de 7 · El Gran Viaje Ibérico',
        instruction: 'Conecta el PRINCIPADO DE ASTURIAS con ARAGÓN avanzando paso a paso por comunidades autónomas limítrofes.',
        hint: 'Puedes ir de Asturias -> Castilla y León -> Aragón (o por Cantabria -> País Vasco -> Navarra -> Aragón).',
        originRegionId: 'asturias',
        targetRegionId: 'aragon',
      ),
    ];
  }
}
