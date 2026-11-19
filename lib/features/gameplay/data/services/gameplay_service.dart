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
    if (level <= 1) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridNavigation,
          title: 'Colegio · Rumbo al patio',
          instruction: 'Desde el inicio, avanza 3 casillas al Norte (N) hasta el patio del colegio.',
          hint: 'El Norte está arriba. Avanza hacia arriba tres veces.',
          startCoord: GridCoord(4, 1),
          targetCoord: GridCoord(1, 1),
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.gridNavigation,
          title: 'Parque · Rumbo a la fuente',
          instruction:
              'Avanza 2 casillas al Este (E) hasta la fuente del parque.',
          hint: 'El Este está a la derecha. Avanza hacia la derecha dos veces.',
          startCoord: GridCoord(1, 1),
          targetCoord: GridCoord(1, 3),
        ),
      ];
    }

    if (level == 2) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridNavigation,
          title: 'Bosque · Rumbo a la cabaña',
          instruction: 'Combina dos rumbos: avanza 3 casillas al Norte y 2 al Este para llegar a la cabaña del bosque.',
          hint: 'Combina dos rumbos: primero Norte y después Este.',
          startCoord: GridCoord(4, 0),
          targetCoord: GridCoord(1, 2),
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.gridNavigation,
          title: 'Bosque · Rumbo al claro',
          instruction: 'Avanza 3 casillas al Norte y 3 al Oeste hasta el claro del bosque.',
          hint: 'Combina Norte y Oeste siguiendo las instrucciones.',
          startCoord: GridCoord(4, 4),
          targetCoord: GridCoord(1, 1),
        ),
      ];
    }

    return <GameRoundChallenge>[
      const GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Ciudad · Diagonal al colegio',
        instruction: 'Avanza 3 casillas en diagonal al Noroeste (NO) hasta el colegio. Evita las obras.',
        hint: 'El Noroeste combina Norte y Oeste. Rodea las obras.',
        startCoord: GridCoord(4, 4),
        targetCoord: GridCoord(1, 1),
        obstacles: <GridCoord>[GridCoord(3, 3)],
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridNavigation,
        title: 'Ciudad · Diagonal a la plaza',
        instruction: 'Avanza 3 casillas en diagonal al Sureste (SE) hasta la plaza, sin entrar en las obras.',
        hint: 'El Sureste combina Sur y Este. Rodea las obras de la avenida central.',
        startCoord: const GridCoord(0, 0),
        targetCoord: const GridCoord(3, 3),
        obstacles: const <GridCoord>[GridCoord(1, 1), GridCoord(2, 2)],
      ),
    ];
  }

  List<GameRoundChallenge> _buildBrujulaRounds(int level) {
    if (level <= 1) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.compassCalibration,
          title: 'Brújula · El Sol del Este',
          instruction: 'El Sol sale por el Este. Gira la aguja roja y blanca hacia el Este (E).',
          hint: 'El Este está a la derecha de la brújula.',
          targetDirection: CardinalDirection.e,
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.compassCalibration,
          title: 'Brújula · La Estrella Polar',
          instruction: 'La Estrella Polar señala el Norte. Orienta la punta roja hacia el Norte (N).',
          hint: 'El Norte está arriba de la brújula.',
          targetDirection: CardinalDirection.n,
        ),
      ];
    }

    if (level == 2) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.compassCalibration,
          title: 'Brújula · Rumbo entre Norte y Este',
          instruction: 'El faro está entre el Norte y el Este. Gira la brújula hacia el Noreste (NE).',
          hint: 'El Noreste está entre el Norte y el Este.',
          targetDirection: CardinalDirection.ne,
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.compassCalibration,
          title: 'Brújula · Rumbo entre Sur y Oeste',
          instruction: 'La cueva está entre el Sur y el Oeste. Orienta la aguja hacia el Suroeste (SO).',
          hint: 'El Suroeste está entre el Sur y el Oeste.',
          targetDirection: CardinalDirection.so,
        ),
      ];
    }

    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Brújula · Gira desde el Norte',
        instruction: 'Empieza mirando al Norte y gira la brújula 90° en sentido horario para fijar el rumbo.',
        hint:
            'Un giro de 90° en sentido horario desde el Norte apunta al Este.',
        targetDirection: CardinalDirection.e,
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.compassCalibration,
        title: 'Brújula · Gira desde el Este',
        instruction: 'Empieza mirando al Este y gira la brújula 135° en sentido horario para fijar el rumbo.',
        hint: 'Desde el Este, gira pasando por el Sureste hasta llegar al Suroeste.',
        startDirection: CardinalDirection.e,
        targetDirection: CardinalDirection.so,
      ),
    ];
  }

  List<GameRoundChallenge> _buildEncuentraLugarRounds(int level) {
    if (level == 1) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridCoordinateFind,
          title: 'Lectura 1 · El Puente',
          instruction: 'En el plano sencillo, encuentra y toca el puente en la casilla B4.',
          hint: 'La fila B está debajo de A y la columna 4 está hacia la derecha.',
          startCoord: GridCoord(4, 0),
          targetCoord: GridCoord(1, 3),
          symbolLabel: 'Puente',
          landmarks: <GridLandmarkPlacement>[
            GridLandmarkPlacement(GridCoord(1, 3), GridLandmark.bridge),
            GridLandmarkPlacement(GridCoord(3, 3), GridLandmark.park),
          ],
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.gridCoordinateFind,
          title: 'Lectura 2 · El Parque',
          instruction: 'El plano tiene pocos elementos: toca el parque en D4.',
          hint: 'Cuenta desde la izquierda: estás buscando la fila D y la columna 4.',
          startCoord: GridCoord(1, 3),
          targetCoord: GridCoord(3, 3),
          symbolLabel: 'Parque',
          landmarks: <GridLandmarkPlacement>[
            GridLandmarkPlacement(GridCoord(1, 3), GridLandmark.bridge),
            GridLandmarkPlacement(GridCoord(3, 3), GridLandmark.park),
          ],
        ),
      ];
    }

    if (level == 2) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridCoordinateFind,
          title: 'Posición relativa · Al sur del parque',
          instruction: '¿Qué hay al sur del parque? Toca el bosque en E4.',
          hint: 'Mira hacia abajo desde el parque: la primera casilla al Sur es el bosque.',
          startCoord: GridCoord(4, 0),
          targetCoord: GridCoord(4, 3),
          symbolLabel: 'Bosque',
          landmarks: <GridLandmarkPlacement>[
            GridLandmarkPlacement(GridCoord(3, 3), GridLandmark.park),
            GridLandmarkPlacement(GridCoord(4, 3), GridLandmark.forest),
          ],
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.gridCoordinateFind,
          title: 'Posición relativa · Al oeste del colegio',
          instruction:
              '¿Qué lugar está al oeste del colegio? Toca el hospital.',
          hint: 'El oeste está a la izquierda: busca la casilla anterior al colegio.',
          startCoord: GridCoord(3, 3),
          targetCoord: GridCoord(2, 0),
          symbolLabel: 'Hospital',
          landmarks: <GridLandmarkPlacement>[
            GridLandmarkPlacement(GridCoord(2, 0), GridLandmark.hospital),
            GridLandmarkPlacement(GridCoord(2, 1), GridLandmark.school),
          ],
        ),
      ];
    }

    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Leyenda y escala · El Puente',
        instruction: 'Usa la leyenda: el símbolo de puente vale 1 tramo. Localiza el puente a 2 tramos al Este del río.',
        hint: 'Desde el río, avanza 2 casillas hacia el Este hasta el puente.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 3),
        symbolLabel: 'Puente',
        landmarks: <GridLandmarkPlacement>[
          GridLandmarkPlacement(GridCoord(1, 1), GridLandmark.river),
          GridLandmarkPlacement(GridCoord(1, 3), GridLandmark.bridge),
        ],
      ),
      GameRoundChallenge(
        roundNumber: 2,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Leyenda y escala · Interpretación completa',
        instruction: 'La leyenda muestra pinos en verde. Toca el bosque situado a 2 casillas al Sur del puente.',
        hint: 'En la escala sencilla, baja 2 casillas desde el puente para llegar al bosque.',
        startCoord: GridCoord(1, 3),
        targetCoord: GridCoord(3, 3),
        symbolLabel: 'Bosque',
        landmarks: <GridLandmarkPlacement>[
          GridLandmarkPlacement(GridCoord(1, 3), GridLandmark.bridge),
          GridLandmarkPlacement(GridCoord(3, 3), GridLandmark.forest),
        ],
      ),
    ];
  }

  List<GameRoundChallenge> _buildLlegarATiempoRounds(int level) {
    if (level == 1) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridTimedPath,
          title: 'Ruta 1 · Colegio al polideportivo',
          instruction: 'Avanza desde el colegio (E1) hasta el polideportivo (B4) antes de que terminen 02:00 minutos.',
          hint: 'Rodea las rocas grises y sigue por casillas despejadas.',
          startCoord: GridCoord(4, 0),
          targetCoord: GridCoord(1, 3),
          obstacles: <GridCoord>[GridCoord(3, 1), GridCoord(2, 2)],
        ),
      ];
    }

    if (level == 2) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.gridTimedPath,
          title: 'Ruta alternativa · Puente del río',
          instruction: 'Llega al polideportivo usando el puente. El camino directo por el río está bloqueado.',
          hint: 'Cruza por la fila C y evita las casillas de agua.',
          startCoord: GridCoord(4, 0),
          targetCoord: GridCoord(1, 3),
          obstacles: <GridCoord>[
            GridCoord(3, 1),
            GridCoord(2, 2),
            GridCoord(2, 3),
          ],
            obstacleType: GridObstacleType.river,
        ),
      ];
    }

    return const <GameRoundChallenge>[
      GameRoundChallenge(
        roundNumber: 1,
        mechanic: ChallengeMechanicType.gridTimedPath,
        title: 'Restricción dinámica · Parque cerrado',
        instruction: 'Paso prohibido en el parque. Busca una ruta alternativa desde el colegio hasta el polideportivo antes de 02:00.',
        hint: 'Rodea el parque central cruzando por el norte o por el este.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 3),
        obstacles: <GridCoord>[
          GridCoord(1, 2),
          GridCoord(2, 1),
          GridCoord(2, 2),
          GridCoord(2, 3),
        ],
        obstacleType: GridObstacleType.park,
      ),
    ];
  }

  List<GameRoundChallenge> _buildTesoroSecretoRounds(int level) {
    if (level == 1) {
      return <GameRoundChallenge>[
        _buildTreasureRound(
          roundNumber: 1,
          title: 'Pergamino 1 · Dos pistas',
          startCoord: GridCoord(3, 1),
          pathSteps: <GridPathStep>[
            GridPathStep(CardinalDirection.n, 2),
            GridPathStep(CardinalDirection.e, 2),
          ],
        ),
      ];
    }

    if (level == 2) {
      return <GameRoundChallenge>[
        _buildTreasureRound(
          roundNumber: 1,
          title: 'Pergamino 2 · Pistas y leyenda',
          startCoord: GridCoord(3, 1),
          pathSteps: <GridPathStep>[
            GridPathStep(CardinalDirection.n, 2),
            GridPathStep(CardinalDirection.e, 2),
            GridPathStep(CardinalDirection.s, 1),
          ],
        ),
      ];
    }

    return <GameRoundChallenge>[
      _buildTreasureRound(
        roundNumber: 1,
        title: 'Pergamino 1 · El Cofre del Cartógrafo',
        startCoord: GridCoord(3, 1),
        pathSteps: <GridPathStep>[
          GridPathStep(CardinalDirection.n, 2),
          GridPathStep(CardinalDirection.e, 2),
        ],
      ),
      _buildTreasureRound(
        roundNumber: 2,
        title: 'Pergamino 2 · La Reliquia del Valle',
        startCoord: GridCoord(0, 4),
        pathSteps: <GridPathStep>[
          GridPathStep(CardinalDirection.s, 3),
          GridPathStep(CardinalDirection.o, 3),
        ],
      ),
    ];
  }

  GameRoundChallenge _buildTreasureRound({
    required int roundNumber,
    required String title,
    required GridCoord startCoord,
    required List<GridPathStep> pathSteps,
  }) {
    final clues = <String>[
      for (var index = 0; index < pathSteps.length; index++)
        '${index + 1}. Avanza ${pathSteps[index].distance} '
            'casillas al ${pathSteps[index].direction.label}.',
    ];

    return GameRoundChallenge(
      roundNumber: roundNumber,
      mechanic: ChallengeMechanicType.gridTreasureClues,
      title: title,
      instruction: 'Sigue las pistas desde el explorador del tablero y toca la casilla del tesoro.',
      hint: clues.join(' '),
      startCoord: startCoord,
      pathSteps: pathSteps,
      clues: clues,
    );
  }

  List<GameRoundChallenge> _buildConstruyeMapaRounds(int level) {
    if (level == 1) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.cartographyBuilder,
          title: 'Plano 1 · Parque al Norte',
          instruction:
              'Arrastra el parque al norte del colegio, en la casilla A3.',
          hint: 'El Norte está en la primera fila, encima del colegio.',
          startCoord: GridCoord(2, 2),
          targetCoord: GridCoord(0, 2),
          symbolLabel: 'Parque',
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.cartographyBuilder,
          title: 'Plano 2 · Hospital al Este',
          instruction:
              'Arrastra el hospital al este del parque, en la casilla A5.',
          hint: 'El Este está a la derecha del parque.',
          startCoord: GridCoord(0, 2),
          targetCoord: GridCoord(0, 4),
          symbolLabel: 'Hospital',
        ),
      ];
    }

    if (level == 2) {
      return const <GameRoundChallenge>[
        GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.cartographyBuilder,
          title: 'Plano comarcal · Hospital al Este',
          instruction:
              'Arrastra el hospital al este del parque. Colócalo en D4.',
          hint: 'El Este está a la derecha del parque.',
          startCoord: GridCoord(2, 2),
          targetCoord: GridCoord(3, 3),
          symbolLabel: 'Hospital',
        ),
        GameRoundChallenge(
          roundNumber: 2,
          mechanic: ChallengeMechanicType.cartographyBuilder,
          title: 'Plano comarcal · Casa al Oeste',
          instruction: 'Arrastra una casa al oeste del colegio.',
          hint: 'El Oeste está a la izquierda.',
          startCoord: GridCoord(3, 3),
          targetCoord: GridCoord(2, 0),
          symbolLabel: 'Casa',
        ),
      ];
    }

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
    if (custom != null &&
        custom.isPublished &&
        custom.gameId == 'donde_estoy' &&
        custom.level == level &&
        custom.classId == _store.currentUser.classId) {
      rounds.add(
        GameRoundChallenge(
          roundNumber: 3,
          mechanic: ChallengeMechanicType.whereAmIRiddle,
          title: 'Reto de tu docente · Clase ${custom.classId}',
          instruction: custom.prompt,
          hint: custom.hint,
          targetRegionId: custom.targetRegionId,
          clues: <String>[
            'Pregunta adaptada especialmente para la clase ${custom.classId}.',
            'Pista de tu docente: ${custom.prompt}',
            'Cruza esta pista con la indicación adicional: ${custom.hint}',
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
      final provinceRounds = SpainMapCatalog.castillaYLeonProvinces
          .asMap()
          .entries
          .map((entry) {
            final region = entry.value;
            final borderHint = switch (region.id) {
              'zamora' => 'Zamora limita con Portugal al oeste y está al noroeste de Salamanca.',
              'salamanca' => 'Salamanca limita con Portugal al oeste, en el suroeste de Castilla y León.',
              _ =>
                'La capital de ${region.name} también se llama ${region.capital}.',
            };
            return GameRoundChallenge(
              roundNumber: entry.key + 2,
              mechanic: ChallengeMechanicType.spainTerritoryMap,
              mapMode: SpainMapMode.castillaYLeonProvinces,
              title:
                  'Castilla y León · Provincia ${entry.key + 1} de ${SpainMapCatalog.castillaYLeonProvinces.length}',
              instruction:
                  'Arrastra el nombre ${region.name} hasta su provincia en el mapa.',
              hint: borderHint,
              targetRegionId: region.id,
            );
          })
          .toList(growable: false);

      return <GameRoundChallenge>[
        const GameRoundChallenge(
          roundNumber: 1,
          mechanic: ChallengeMechanicType.spainTerritoryMap,
          mapMode: SpainMapMode.autonomousCommunities,
          title: 'Pista de límites · Comunidad con Portugal',
          instruction: 'Arrastra al mapa la comunidad autónoma que limita con Portugal al oeste.',
          hint: 'Es Castilla y León, que comparte frontera con Portugal y contiene nueve provincias.',
          targetRegionId: 'castilla_y_leon',
        ),
        ...provinceRounds,
      ];
    }

    if (level == 3) {
      const uniprovincialIds = <String>{
        'asturias_prov',
        'cantabria_prov',
        'illes_balears',
        'la_rioja_prov',
        'madrid_prov',
        'murcia_prov',
        'navarra_prov',
      };
      return SpainMapCatalog.spainProvinces
          .asMap()
          .entries
          .map((entry) {
            final region = entry.value;
            final uniprovincialHint = uniprovincialIds.contains(region.id)
                ? ' ${region.name} también es una comunidad uniprovincial.'
                : '';
            return GameRoundChallenge(
              roundNumber: entry.key + 1,
              mechanic: ChallengeMechanicType.spainTerritoryMap,
              mapMode: SpainMapMode.spainProvinces,
              title:
                  'Provincias de España · ${entry.key + 1} de ${SpainMapCatalog.spainProvinces.length}',
              instruction:
                  'Arrastra ${region.name} a su lugar. Su capital es ${region.capital}.',
              hint:
                  'Orienta el mapa con el norte hacia arriba y busca ${region.name}.$uniprovincialHint',
              targetRegionId: region.id,
            );
          })
          .toList(growable: false);
    }

    return SpainMapCatalog.autonomousCommunities
        .asMap()
        .entries
        .map((entry) {
          final region = entry.value;
          final isAutonomousCity =
              region.id == 'ceuta' || region.id == 'melilla';
          return GameRoundChallenge(
            roundNumber: entry.key + 1,
            mechanic: ChallengeMechanicType.spainTerritoryMap,
            mapMode: SpainMapMode.autonomousCommunities,
            title:
                'Comunidades y ciudades autónomas · ${entry.key + 1} de ${SpainMapCatalog.autonomousCommunities.length}',
            instruction: isAutonomousCity
                ? 'Arrastra el nombre de ${region.name} hasta su lugar en el mapa.'
                : 'Arrastra ${region.name} hasta su comunidad autónoma en el mapa.',
            hint: 'La capital de ${region.name} es ${region.capital}.',
            targetRegionId: region.id,
          );
        })
        .toList(growable: false);
  }

  List<GameRoundChallenge> _buildViajePorEspanaRounds(int level) {
    final stages = switch (level) {
      1 => const <(String, String)>[
        ('castilla_y_leon', 'galicia'),
        ('galicia', 'asturias'),
      ],
      2 => const <(String, String)>[
        ('castilla_y_leon', 'galicia'),
        ('galicia', 'asturias'),
        ('asturias', 'madrid'),
      ],
      _ => const <(String, String)>[
        ('castilla_y_leon', 'galicia'),
        ('galicia', 'asturias'),
        ('asturias', 'madrid'),
        ('madrid', 'andalucia'),
      ],
    };
    return stages.indexed
        .map((entry) {
          final (originId, targetId) = entry.$2;
          final origin = SpainMapCatalog.findById(originId)!;
          final target = SpainMapCatalog.findById(targetId)!;
          final isFirstStage = entry.$1 == 0;
          return GameRoundChallenge(
            roundNumber: entry.$1 + 1,
            mechanic: ChallengeMechanicType.spainNeighborRoute,
            mapMode: SpainMapMode.autonomousCommunities,
            title: isFirstStage
                ? 'Etapa 1 · Desde Valladolid hasta Galicia'
                : 'Etapa ${entry.$1 + 1} · ${origin.name} hasta ${target.name}',
            instruction: isFirstStage
                ? 'Comienzas en Valladolid, en Castilla y León. Viaja hasta Galicia tocando comunidades vecinas.'
                : 'Desde ${origin.name}, viaja hasta ${target.name} sin saltarte ninguna frontera.',
            hint: isFirstStage
                ? 'Castilla y León limita con Galicia. Después, Asturias también limita con Castilla y León.'
                : 'Toca solo una comunidad que comparta frontera con la última etapa.',
            originRegionId: originId,
            targetRegionId: targetId,
          );
        })
        .toList(growable: false);
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
        mechanic: ChallengeMechanicType.cartographyBuilder,
        title: 'Prueba 3 de 7 · Interpreta la leyenda',
        instruction: 'Según la leyenda del mapa, coloca el símbolo del parque en la casilla A4.',
        hint: 'Busca el símbolo verde del parque en la leyenda y arrástralo a la primera fila, columna 4.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(0, 3),
        symbolLabel: 'Parque',
      ),
      GameRoundChallenge(
        roundNumber: 4,
        mechanic: ChallengeMechanicType.gridTimedPath,
        title: 'Prueba 4 de 7 · Sigue el recorrido',
        instruction: 'Sigue la ruta por casillas desde E1 hasta B5 y evita el obstáculo del bosque.',
        hint: 'El norte está arriba; rodea el obstáculo antes de avanzar hacia el este.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(1, 4),
        obstacles: <GridCoord>[GridCoord(2, 1), GridCoord(3, 3)],
      ),
      GameRoundChallenge(
        roundNumber: 5,
        mechanic: ChallengeMechanicType.gridCoordinateFind,
        title: 'Prueba 5 de 7 · Encuentra el lugar',
        instruction: 'Usa la leyenda para encontrar el refugio de montaña en la casilla A4.',
        hint: 'A4 es la fila superior y la cuarta columna.',
        startCoord: GridCoord(4, 0),
        targetCoord: GridCoord(0, 3),
        symbolLabel: 'Refugio',
        landmarks: <GridLandmarkPlacement>[
          GridLandmarkPlacement(GridCoord(0, 3), GridLandmark.shelter),
        ],
      ),
      GameRoundChallenge(
        roundNumber: 6,
        mechanic: ChallengeMechanicType.whereAmIRiddle,
        title: 'Prueba 6 de 7 · Adivina la comunidad',
        instruction:
            'Resuelve las pistas para encontrar la Comunidad Autónoma.',
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
        roundNumber: 7,
        mechanic: ChallengeMechanicType.spainNeighborRoute,
        mapMode: SpainMapMode.autonomousCommunities,
        title: 'Prueba 7 de 7 · El Gran Viaje Ibérico',
        instruction: 'Conecta el PRINCIPADO DE ASTURIAS con ARAGÓN avanzando tramo a tramo por comunidades autónomas limítrofes.',
        hint: 'Puedes ir de Asturias -> Castilla y León -> Aragón (o por Cantabria -> País Vasco -> Navarra -> Aragón).',
        originRegionId: 'asturias',
        targetRegionId: 'aragon',
      ),
    ];
  }
}
