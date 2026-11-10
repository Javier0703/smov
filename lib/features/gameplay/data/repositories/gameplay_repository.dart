import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/gameplay_models.dart';
import '../services/gameplay_service.dart';

/// Repositorio de ejecución de partidas, uso de ayudas e idempotencia de recompensas.
class GameplayRepository {
  GameplayRepository({required this._service});

  final GameplayService _service;

  UserModel getCurrentUser() => _service.getCurrentUser();
  Map<String, int> getInventoryCounts() => _service.getInventoryCounts();

  Result<List<GameRoundChallenge>> loadGameRounds({
    required String gameId,
    required int levelNumber,
  }) {
    try {
      final rounds = _service.buildRoundsForGame(
        gameId: gameId,
        levelNumber: levelNumber,
      );
      return Success<List<GameRoundChallenge>>(rounds);
    } catch (e) {
      return Error<List<GameRoundChallenge>>(
        CacheFailure('No se pudieron cargar las rondas de la misión: $e'),
      );
    }
  }

  Result<bool> useBackpackItem(String itemId) {
    try {
      final consumed = _service.consumeHelperItem(itemId);
      if (!consumed) {
        return const Error<bool>(
          ValidationFailure(
            'No te quedan unidades de esta ayuda en tu mochila.',
          ),
        );
      }
      return const Success<bool>(true);
    } catch (e) {
      return Error<bool>(
        CacheFailure('Error al usar el objeto de la mochila: $e'),
      );
    }
  }

  void registerCommunityStamp(String communityId) =>
      _service.stampCommunity(communityId);

  Future<Result<GameSessionResultModel>> finishSession({
    required String sessionId,
    required String gameId,
    required String gameTitle,
    required String achievementTitle,
    required int medalNumber,
    required int levelNumber,
    required int correctAnswers,
    required int totalAttempts,
    required int durationSeconds,
    required int baseRewardCoins,
    required List<String> stampedCommunitiesEarned,
  }) async {
    try {
      final awarded = await _service.completeSession(
        sessionId: sessionId,
        gameId: gameId,
        gameTitle: gameTitle,
        levelNumber: levelNumber,
        correctAnswers: correctAnswers,
        totalAttempts: totalAttempts,
        durationSeconds: durationSeconds,
        rewardCoins: baseRewardCoins,
        unlockedMedalNumber: medalNumber,
        newlyStampedCommunities: stampedCommunitiesEarned,
      );
      final userAfter = _service.getCurrentUser();
      return Success<GameSessionResultModel>(
        GameSessionResultModel(
          sessionId: sessionId,
          gameId: gameId,
          gameTitle: gameTitle,
          achievementTitle: achievementTitle,
          medalNumber: medalNumber,
          levelNumber: levelNumber,
          correctAnswers: correctAnswers,
          totalAttempts: totalAttempts,
          durationSeconds: durationSeconds,
          coinsAwarded: awarded,
          totalCoinsAfter: userAfter.coins,
          isFinalExpedition: gameId == 'gran_reto',
          stampedCommunitiesEarned: stampedCommunitiesEarned,
        ),
      );
    } catch (e) {
      return Error<GameSessionResultModel>(
        CacheFailure('No se pudo registrar el resultado de la misión: $e'),
      );
    }
  }
}
