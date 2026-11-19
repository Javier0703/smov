import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smov/core/di/app_dependencies.dart';
import 'package:smov/features/adventures/data/models/adventure_game_model.dart';
import 'package:smov/features/gameplay/data/models/gameplay_models.dart';
import 'package:smov/shared/models/user_model.dart';
import 'package:smov/shared/widgets/vector/spain_vector_map_widget.dart';

void main() {
  group('Reglas de Negocio y Contratos MVVM — Brújula Quest', () {
    late AppDependencies deps;

    setUp(() {
      deps = AppDependencies();
    });

    tearDown(() {
      deps.dispose();
    });

    test('Los tres niveles de Rumbo progresan de puntos cardinales a diagonales con obstáculos', () {
      final game = deps.adventuresViewModel.findGame('rumbo_desconocido')!;

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 1);
      expect(deps.gameplayViewModel.rounds, hasLength(2));
      expect(
        deps.gameplayViewModel.rounds.every(
          (round) => !round.instruction.contains('diagonal'),
        ),
        isTrue,
      );

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 2);
      expect(
        deps.gameplayViewModel.rounds.any(
          (round) => round.instruction.toLowerCase().contains('combina'),
        ),
        isTrue,
      );

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 3);
      expect(
        deps.gameplayViewModel.rounds.every(
          (round) => round.obstacles.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        deps.gameplayViewModel.rounds.any(
          (round) => round.instruction.contains('diagonal'),
        ),
        isTrue,
      );
    });

    test('La brújula mantiene aguja bicolor y ¿Dónde estoy? siempre ofrece tres pistas', () async {
      final compassGame = deps.adventuresViewModel.findGame('brujula_perdida')!;
      deps.gameplayViewModel.startNewSession(game: compassGame, levelNumber: 1);
      expect(
        deps.gameplayViewModel.rounds.every(
          (round) => round.targetDirection.degrees % 90 == 0,
        ),
        isTrue,
      );

      deps.gameplayViewModel.startNewSession(game: compassGame, levelNumber: 3);
      expect(
        deps.gameplayViewModel.rounds.first.instruction,
        contains('gira la brújula'),
      );
      deps.gameplayViewModel.setCompassDirection(
        deps.gameplayViewModel.rounds.first.targetDirection,
      );
      expect(await deps.gameplayViewModel.submitCompassDirection(), isFalse);
      expect(deps.gameplayViewModel.compassDirection.degrees, 90);

      final whereAmIGame = deps.adventuresViewModel.findGame('donde_estoy')!;
      expect(
        whereAmIGame.howToPlayObjective,
        contains('tres pistas espaciales'),
      );
      deps.gameplayViewModel.startNewSession(
        game: whereAmIGame,
        levelNumber: 1,
      );
      expect(
        deps.gameplayViewModel.rounds.every((round) => round.clues.length == 3),
        isTrue,
      );
    });

    test(
      'Una llegada equivocada en Rumbo activa el desvío divertido',
      () async {
        final game = deps.adventuresViewModel.findGame('rumbo_desconocido')!;
        deps.gameplayViewModel.startNewSession(game: game, levelNumber: 1);

        expect(await deps.gameplayViewModel.confirmRumboDestination(), isFalse);
        expect(deps.gameplayViewModel.isFunnyDetourActive, isTrue);
        expect(deps.gameplayViewModel.funnyDetourMessage, contains('charca'));
      },
    );

    test('Los juegos 3-6 aplican nivel, temporizador, pistas y colocación de símbolos', () async {
      final findPlace = deps.adventuresViewModel.findGame('encuentra_lugar')!;
      deps.gameplayViewModel.startNewSession(game: findPlace, levelNumber: 1);
      expect(
        deps.gameplayViewModel.rounds.first.instruction,
        contains('plano sencillo'),
      );
      deps.gameplayViewModel.startNewSession(game: findPlace, levelNumber: 2);
      expect(
        deps.gameplayViewModel.rounds.first.instruction,
        contains('al sur del parque'),
      );
      deps.gameplayViewModel.startNewSession(game: findPlace, levelNumber: 3);
      expect(
        deps.gameplayViewModel.rounds.first.title,
        contains('Leyenda y escala'),
      );

      final timedGame = deps.adventuresViewModel.findGame('llegar_a_tiempo')!;
      deps.gameplayViewModel.startNewSession(game: timedGame, levelNumber: 3);
      expect(deps.gameplayViewModel.remainingSeconds, 120);
      expect(
        deps.gameplayViewModel.rounds.first.instruction,
        contains('Paso prohibido en el parque'),
      );

      final treasure = deps.adventuresViewModel.findGame('tesoro_secreto')!;
      deps.gameplayViewModel.startNewSession(game: treasure, levelNumber: 1);
      expect(deps.gameplayViewModel.rounds.first.clues, hasLength(2));

      final mapBuilder = deps.adventuresViewModel.findGame('construye_mapa')!;
      deps.gameplayViewModel.startNewSession(game: mapBuilder, levelNumber: 1);
      expect(
        await deps.gameplayViewModel.placeCartographySymbol(
          'Hospital',
          const GridCoord(0, 2),
        ),
        isFalse,
      );
      await deps.gameplayViewModel.placeCartographySymbol(
        'Parque',
        const GridCoord(0, 2),
      );
      expect(
        deps.gameplayViewModel.placedCartographySymbols[const GridCoord(0, 2)],
        'Parque',
      );
      expect(
        deps.gameplayViewModel.currentRound?.mechanic,
        ChallengeMechanicType.cartographyBuilder,
      );
    });

    test('1. Política docente de niveles: bloquear o habilitar Nivel 3 en 4.º A actualiza inmediatamente el acceso del alumno', () async {
      // Por defecto en 4.º A, España en tus manos tiene niveles 1 y 2 activos y el 3 desactivado
      expect(
        deps.adventuresViewModel.canStartGameLevel('espana_en_tus_manos', 1),
        isTrue,
      );
      expect(
        deps.adventuresViewModel.canStartGameLevel('espana_en_tus_manos', 2),
        isTrue,
      );
      expect(
        deps.adventuresViewModel.canStartGameLevel('espana_en_tus_manos', 3),
        isFalse,
      );

      // El docente habilita el Nivel 3 (Provincias de España) para 4.º A
      deps.teacherViewModel.toggleGameLevel(
        gameId: 'espana_en_tus_manos',
        levelNumber: 3,
        enabled: true,
      );

      // Además marcamos el nivel 2 como completado para desbloquear progresión
      await deps.stateStore.recordGameSession(
        sessionId: 'unlock_lvl2',
        gameId: 'espana_en_tus_manos',
        gameTitle: 'España en tus manos',
        level: 2,
        correctAnswers: 4,
        totalAttempts: 4,
        durationSeconds: 60,
        rewardCoins: 40,
      );

      expect(
        deps.adventuresViewModel.canStartGameLevel('espana_en_tus_manos', 3),
        isTrue,
      );
    });

    test('España en tus manos cubre todas las regiones y acepta etiquetas arrastradas', () async {
      final game = deps.adventuresViewModel.findGame('espana_en_tus_manos')!;

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 1);
      expect(deps.gameplayViewModel.rounds, hasLength(19));
      expect(
        deps.gameplayViewModel.rounds
            .map((round) => round.targetRegionId)
            .toSet(),
        hasLength(19),
      );

      final firstRound = deps.gameplayViewModel.currentRound!;
      final correctRegion = SpainMapCatalog.findById(
        firstRound.targetRegionId,
      )!;
      final wrongRegion = SpainMapCatalog.findById('asturias')!;
      expect(
        await deps.gameplayViewModel.handleSpainRegionDrop(
          wrongRegion,
          correctRegion,
        ),
        isFalse,
      );
      expect(
        deps.gameplayViewModel.feedbackMessage,
        contains('no corresponde'),
      );
      expect(
        await deps.gameplayViewModel.handleSpainRegionDrop(
          correctRegion,
          correctRegion,
        ),
        isFalse,
      );
      expect(deps.gameplayViewModel.currentRoundIndex, 1);

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 2);
      expect(deps.gameplayViewModel.rounds, hasLength(10));
      expect(
        deps.gameplayViewModel.rounds.first.targetRegionId,
        'castilla_y_leon',
      );
      expect(
        deps.gameplayViewModel.rounds.where(
          (round) => round.mapMode == SpainMapMode.castillaYLeonProvinces,
        ),
        hasLength(9),
      );

      deps.gameplayViewModel.startNewSession(game: game, levelNumber: 3);
      expect(SpainMapCatalog.spainProvinces, hasLength(50));
      expect(deps.gameplayViewModel.rounds, hasLength(50));
      expect(
        deps.gameplayViewModel.rounds
            .map((round) => round.targetRegionId)
            .toSet(),
        hasLength(50),
      );
    });

    test(
      'Los juegos 9 y 10 siguen las etapas y las siete fases especificadas',
      () async {
        final travelGame = deps.adventuresViewModel.findGame(
          'viaje_por_espana',
        )!;
        deps.gameplayViewModel.startNewSession(
          game: travelGame,
          levelNumber: 1,
        );
        expect(deps.gameplayViewModel.rounds, hasLength(2));
        expect(
          deps.gameplayViewModel.rounds.first.originRegionId,
          'castilla_y_leon',
        );
        expect(deps.gameplayViewModel.rounds.first.targetRegionId, 'galicia');
        expect(deps.gameplayViewModel.rounds[1].targetRegionId, 'asturias');

        final finalGame = deps.adventuresViewModel.findGame('gran_reto')!;
        deps.gameplayViewModel.startNewSession(game: finalGame, levelNumber: 1);
        expect(
          deps.gameplayViewModel.rounds.map((round) => round.mechanic).toList(),
          <ChallengeMechanicType>[
            ChallengeMechanicType.compassCalibration,
            ChallengeMechanicType.gridNavigation,
            ChallengeMechanicType.cartographyBuilder,
            ChallengeMechanicType.gridTimedPath,
            ChallengeMechanicType.gridCoordinateFind,
            ChallengeMechanicType.whereAmIRiddle,
            ChallengeMechanicType.spainNeighborRoute,
          ],
        );

        final vm = deps.gameplayViewModel;
        vm.setCompassDirection(vm.currentRound!.targetDirection);
        await vm.submitCompassDirection();
        await vm.handleGridCellTap(vm.currentRound!.targetCoord);
        await vm.placeCartographySymbol('Parque', const GridCoord(0, 3));
        await vm.handleGridCellTap(vm.currentRound!.targetCoord);
        await vm.handleGridCellTap(vm.currentRound!.targetCoord);
        await vm.handleSpainRegionTap(
          SpainMapCatalog.findById(vm.currentRound!.targetRegionId)!,
        );
        await vm.handleSpainRegionTap(
          SpainMapCatalog.findById('castilla_y_leon')!,
        );
        await vm.handleSpainRegionTap(SpainMapCatalog.findById('aragon')!);

        expect(vm.lastResult?.isFinalExpedition, isTrue);
        expect(deps.stateStore.unlockedMedalNumbers, contains(8));
        expect(deps.stateStore.stampedCommunities, contains('castilla_y_leon'));
      },
    );

    testWidgets('el nombre de una región se arrastra hasta el mapa', (
      tester,
    ) async {
      final region = SpainMapCatalog.findById('galicia')!;
      SpainMapRegion? droppedRegion;
      const mapKey = ValueKey<String>('interactive-map');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  width: 264,
                  child: SpainVectorMapWidget(
                    key: mapKey,
                    onRegionDrop: (dragged, target) {
                      expect(dragged.id, 'galicia');
                      droppedRegion = target;
                    },
                  ),
                ),
                Draggable<SpainMapRegion>(
                  data: region,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: const Material(child: Text('pieza en movimiento')),
                  child: const Text('pieza para arrastrar'),
                ),
              ],
            ),
          ),
        ),
      );

      final mapBounds = tester.getRect(find.byKey(mapKey));
      final dropPoint = Offset(
        mapBounds.left + (45 / 264) * mapBounds.width,
        mapBounds.top + (26 / 136) * mapBounds.height,
      );
      final startPoint = tester.getCenter(find.text('pieza para arrastrar'));
      await tester.dragFrom(startPoint, dropPoint - startPoint);
      await tester.pumpAndSettle();

      expect(droppedRegion?.id, 'galicia');
    });

    test('España en tus manos limita niveles según el curso escolar', () {
      AdventureGameModel gameForGrade(int grade) {
        return AdventuresCatalogDefinitions.buildCatalog(
          completedByGame: const <String, Set<int>>{},
          enabledByTeacher: const <String, Set<int>>{
            'espana_en_tus_manos': <int>{1, 2, 3},
          },
          courseGrade: grade,
        ).firstWhere((game) => game.id == 'espana_en_tus_manos');
      }

      final firstGrade = gameForGrade(1);
      expect(firstGrade.levels[0].canPlay, isTrue);
      expect(firstGrade.levels[1].canPlay, isFalse);

      final secondGrade = gameForGrade(2);
      expect(secondGrade.levels[1].canPlay, isTrue);
      expect(secondGrade.levels[2].canPlay, isFalse);

      expect(gameForGrade(3).levels[2].isAvailableForCourse, isTrue);
    });

    test('2. Idempotencia de recompensas: cerrar la misma sesión dos veces no duplica las monedas', () async {
      final initialCoins = deps.stateStore.currentUser.coins; // 240
      final rumboGame = deps.adventuresViewModel.findGame('rumbo_desconocido')!;

      deps.gameplayViewModel.startNewSession(
        game: rumboGame,
        levelNumber: 1,
        customSessionId: 'idempotent_session_001',
      );

      final firstResult = await deps.gameplayViewModel.finishCurrentSession();
      expect(firstResult, isNotNull);
      expect(firstResult!.coinsAwarded, equals(40));
      expect(deps.stateStore.currentUser.coins, equals(initialCoins + 40));

      // Segunda llamada con el mismo sessionId
      final secondResult = await deps.gameplayViewModel.finishCurrentSession();
      expect(secondResult, isNotNull);
      expect(secondResult!.coinsAwarded, equals(0));
      expect(deps.stateStore.currentUser.coins, equals(initialCoins + 40));
    });

    test('3. Economía de Mi mochila: canje válido descuenta monedas e incrementa inventario; saldo insuficiente rechaza el canje', () async {
      // Saldo inicial: 240 monedas, 2 lupas
      expect(deps.inventoryViewModel.coinsBalance, equals(240));

      // Canjea 1 Lupa de pistas (coste 120 monedas)
      final receipt = await deps.inventoryViewModel.confirmRedeem(
        'magnifying_glass',
        customTransactionId: 'tx_lupa_1',
      );
      expect(receipt, isNotNull);
      expect(receipt!.remainingCoins, equals(120));
      expect(receipt.newOwnedCount, equals(3));

      // Intenta canjear Brújula especial (coste 300 monedas) con saldo 120
      final failedReceipt = await deps.inventoryViewModel.confirmRedeem(
        'special_compass',
        customTransactionId: 'tx_brujula_fail',
      );
      expect(failedReceipt, isNull);
      expect(deps.inventoryViewModel.errorMessage, contains('insuficiente'));
      expect(deps.inventoryViewModel.coinsBalance, equals(120));
    });

    test('La tienda desbloquea cosméticos y exige la medalla requerida para el avatar especial', () async {
      final initialCoins = deps.inventoryViewModel.coinsBalance;
      deps.avatarViewModel.setSpecialStyle(AvatarSpecialStyle.goldenExplorer);
      expect(
        deps.avatarViewModel.draftConfig.specialStyle,
        AvatarSpecialStyle.classic,
      );

      final lockedAvatar = await deps.inventoryViewModel.confirmRedeem(
        'golden_avatar',
        customTransactionId: 'tx_avatar_locked',
      );
      expect(lockedAvatar, isNull);
      expect(deps.inventoryViewModel.errorMessage, contains('medalla'));
      expect(deps.inventoryViewModel.coinsBalance, equals(initialCoins));

      final jacket = await deps.inventoryViewModel.confirmRedeem(
        'explorer_jacket',
        customTransactionId: 'tx_jacket',
      );
      expect(jacket, isNotNull);
      expect(deps.stateStore.currentUser.coins, equals(initialCoins - 100));
      deps.avatarViewModel.loadState();
      expect(deps.avatarViewModel.ownedCosmetics, contains('explorer_jacket'));
      final badge = await deps.inventoryViewModel.confirmRedeem(
        'compass_badge',
        customTransactionId: 'tx_compass_badge',
      );
      expect(badge, isNotNull);
      deps.avatarViewModel.loadState();
      deps.avatarViewModel.setAccessory(AvatarAccessory.compassBadge);
      expect(await deps.avatarViewModel.saveChanges(), isTrue);

      await deps.stateStore.recordGameSession(
        sessionId: 'unlock_medal_8',
        gameId: 'gran_reto',
        gameTitle: 'El gran reto del explorador',
        level: 1,
        correctAnswers: 7,
        totalAttempts: 7,
        durationSeconds: 60,
        rewardCoins: 300,
        unlockedMedalNumber: 8,
      );
      final goldenAvatar = await deps.inventoryViewModel.confirmRedeem(
        'golden_avatar',
        customTransactionId: 'tx_avatar_unlocked',
      );
      expect(goldenAvatar, isNotNull);
      deps.avatarViewModel.loadState();
      deps.avatarViewModel.setSpecialStyle(AvatarSpecialStyle.goldenExplorer);
      expect(await deps.avatarViewModel.saveChanges(), isTrue);
      expect(
        deps.stateStore.currentUser.avatarConfig.specialStyle,
        AvatarSpecialStyle.goldenExplorer,
      );
    });

    test('4. Precisión ponderada: Mi actividad y Espacio docente calculan sum(correctAnswers) / sum(totalAttempts)', () {
      final activity = deps.statisticsViewModel.activity!;
      // Semilla de Alex: (9+8+15+7) = 39 aciertos sobre (10+10+17+9) = 46 intentos -> 85%
      expect(activity.totalCorrectAnswers, equals(39));
      expect(activity.totalAttempts, equals(46));
      expect(activity.weightedAccuracyPercent, equals(85));
    });

    test('5. Editor de avatar y Editor docente de preguntas validan y persisten cambios en vivo', () async {
      expect(deps.avatarViewModel.hasUnsavedChanges, isFalse);
      deps.avatarViewModel.setGlasses(AvatarGlasses.round);
      deps.avatarViewModel.setOutfit(AvatarOutfit.redHoodie);
      deps.avatarViewModel.setExplorerName('  Luna  ');
      expect(deps.avatarViewModel.hasUnsavedChanges, isTrue);

      final saved = await deps.avatarViewModel.saveChanges();
      expect(saved, isTrue);
      expect(deps.avatarViewModel.hasUnsavedChanges, isFalse);
      expect(
        deps.stateStore.currentUser.avatarConfig.glasses,
        equals(AvatarGlasses.round),
      );
      expect(deps.stateStore.currentUser.displayName, equals('Luna'));

      // Validación en el Editor de preguntas
      deps.teacherViewModel.updateDraftPrompt('Corto');
      expect(deps.teacherViewModel.saveDraftOnly(), isFalse);
      expect(deps.teacherViewModel.promptError, isNotNull);

      deps.teacherViewModel.updateDraftPrompt(
        'Si avanzas 4 casillas al Norte desde el campamento, ¿qué encuentras?',
      );
      expect(deps.teacherViewModel.publishQuestionToClass(), isTrue);
      expect(deps.teacherViewModel.questionDraft.isPublished, isTrue);
    });
  });
}
