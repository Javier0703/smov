import 'package:flutter_test/flutter_test.dart';
import 'package:smov/core/di/app_dependencies.dart';
import 'package:smov/shared/models/user_model.dart';

void main() {
  group('Reglas de Negocio y Contratos MVVM — Brújula Quest', () {
    late AppDependencies deps;

    setUp(() {
      deps = AppDependencies();
    });

    tearDown(() {
      deps.dispose();
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
      expect(deps.avatarViewModel.hasUnsavedChanges, isTrue);

      final saved = await deps.avatarViewModel.saveChanges();
      expect(saved, isTrue);
      expect(deps.avatarViewModel.hasUnsavedChanges, isFalse);
      expect(
        deps.stateStore.currentUser.avatarConfig.glasses,
        equals(AvatarGlasses.round),
      );

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
