import 'package:flutter/material.dart';

import '../../features/achievements/presentation/screens/medals_screen.dart';
import '../../features/adventures/presentation/screens/adventures_catalog_screen.dart';
import '../../features/adventures/presentation/screens/level_selection_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/avatar/presentation/screens/avatar_editor_screen.dart';
import '../../features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../../features/gameplay/data/models/gameplay_models.dart';
import '../../features/gameplay/presentation/screens/gameplay_screen.dart';
import '../../features/gameplay/presentation/screens/how_to_play_screen.dart';
import '../../features/gameplay/presentation/screens/level_result_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/redeem_confirm_screen.dart';
import '../../features/inventory/presentation/screens/redeem_receipt_screen.dart';
import '../../features/passport/presentation/screens/passport_screen.dart';
import '../../features/statistics/presentation/screens/student_activity_screen.dart';
import '../../features/teacher/presentation/screens/teacher_class_activity_screen.dart';
import '../../features/teacher/presentation/screens/teacher_levels_config_screen.dart';
import '../../features/teacher/presentation/screens/teacher_question_editor_screen.dart';
import '../../features/teacher/presentation/screens/teacher_student_detail_screen.dart';
import '../di/app_dependencies.dart';

/// Enrutador declarativo centralizado con todas las rutas de `Brújula Quest · Sociales`.
class AppRouter {
  AppRouter({required this.dependencies});

  final AppDependencies dependencies;

  static const String welcome = '/welcome';
  static const String avatar = '/avatar';
  static const String home = '/home';
  static const String adventures = '/adventures';
  static const String medals = '/medals';
  static const String passport = '/passport';
  static const String inventory = '/inventory';
  static const String activity = '/activity';
  static const String levels = '/levels';

  static String gameLevels(String gameId) => '/games/$gameId/levels';
  static String gameHowTo(String gameId, {int level = 1}) =>
      '/games/$gameId/how-to?level=$level';
  static String playSession(String sessionId) => '/play/$sessionId';
  static String sessionResults(String sessionId) => '/results/$sessionId';
  static String redeemItem(String itemId) => '/inventory/redeem/$itemId';
  static String redeemReceipt(String itemId) => '/inventory/receipt/$itemId';
  static String teacherClassActivity(String classId) =>
      '/teacher/classes/$classId/activity';
  static String teacherStudentDetail(String studentId) =>
      '/students/$studentId';
  static String teacherQuestionEditor(String questionId) =>
      '/questions/$questionId';

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final rawName = settings.name ?? welcome;
    final uri = Uri.parse(rawName);
    final segments = uri.pathSegments;

    void navigate(BuildContext context, String route) {
      Navigator.of(context).pushNamed(route);
    }

    // 1. /welcome
    if (uri.path == welcome || uri.path == '/') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => WelcomeScreen(
          viewModel: dependencies.authViewModel,
          onEnterStudentHome: () =>
              Navigator.of(context).pushReplacementNamed(home),
          onOpenAvatarEditor: () => navigate(context, avatar),
          onEnterTeacherSpace: () =>
              navigate(context, teacherClassActivity('4A')),
        ),
      );
    }

    // 2. /avatar
    if (uri.path == avatar) {
      dependencies.avatarViewModel.loadState();
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => AvatarEditorScreen(
          viewModel: dependencies.avatarViewModel,
          onBackOrSaved: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(home);
            }
          },
        ),
      );
    }

    // 3. /home
    if (uri.path == home) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => HomeDashboardScreen(
          viewModel: dependencies.dashboardViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onOpenNextMission: (gameId) => navigate(context, gameLevels(gameId)),
        ),
      );
    }

    // 4. /adventures
    if (uri.path == adventures) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => AdventuresCatalogScreen(
          viewModel: dependencies.adventuresViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onSelectGame: (game) => navigate(context, gameLevels(game.id)),
        ),
      );
    }

    // 5. /games/:gameId/levels o /games/:gameId/how-to
    if (segments.length == 3 && segments[0] == 'games') {
      final gameId = segments[1];
      final subAction = segments[2];

      if (subAction == 'levels') {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => LevelSelectionScreen(
            gameId: gameId,
            viewModel: dependencies.adventuresViewModel,
            onBack: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed(adventures);
              }
            },
            onOpenHowToPlay: (game, levelNumber) {
              navigate(context, gameHowTo(game.id, level: levelNumber));
            },
            onStartLevel: (game, levelNumber) {
              dependencies.gameplayViewModel.startNewSession(
                game: game,
                levelNumber: levelNumber,
              );
              navigate(
                context,
                playSession(dependencies.gameplayViewModel.activeSessionId),
              );
            },
          ),
        );
      }

      if (subAction == 'how-to') {
        final levelParam =
            int.tryParse(uri.queryParameters['level'] ?? '1') ?? 1;
        final isResume = uri.queryParameters['resume'] == 'true';
        final game =
            dependencies.adventuresViewModel.findGame(gameId) ??
            dependencies.adventuresViewModel.games.first;

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => HowToPlayScreen(
            game: game,
            levelNumber: levelParam,
            isResumingGame: isResume,
            onBack: () => Navigator.of(context).pop(),
            onStartOrResume: () {
              if (isResume) {
                Navigator.of(context).pop();
                return;
              }
              dependencies.gameplayViewModel.startNewSession(
                game: game,
                levelNumber: levelParam,
              );
              Navigator.of(context).pushReplacementNamed(
                playSession(dependencies.gameplayViewModel.activeSessionId),
              );
            },
          ),
        );
      }
    }

    // 6. /play/:sessionId
    if (segments.length == 2 && segments[0] == 'play') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => GameplayScreen(
          viewModel: dependencies.gameplayViewModel,
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(adventures);
            }
          },
          onOpenHowToPlayModal: () {
            final activeGame = dependencies.gameplayViewModel.activeGame;
            if (activeGame == null) return;
            navigate(
              context,
              '${gameHowTo(activeGame.id, level: dependencies.gameplayViewModel.activeLevelNumber)}&resume=true',
            );
          },
          onOpenStore: () => navigate(context, inventory),
          onSessionCompleted: (result) {
            Navigator.of(context).pushReplacementNamed(
              sessionResults(result.sessionId),
              arguments: result,
            );
          },
        ),
      );
    }

    // 7. /results/:sessionId
    if (segments.length == 2 && segments[0] == 'results') {
      final resultArg = settings.arguments is GameSessionResultModel
          ? settings.arguments as GameSessionResultModel
          : dependencies.gameplayViewModel.lastResult;

      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          if (resultArg == null) {
            return HomeDashboardScreen(
              viewModel: dependencies.dashboardViewModel,
              onNavigateRoute: (route) => navigate(context, route),
              onOpenNextMission: (gameId) =>
                  navigate(context, gameLevels(gameId)),
            );
          }

          return LevelResultScreen(
            result: resultArg,
            avatarConfig: dependencies.stateStore.currentUser.avatarConfig,
            onPlayNext: () =>
                Navigator.of(context).pushReplacementNamed(adventures),
            onReplay: () {
              final game = dependencies.adventuresViewModel.findGame(
                resultArg.gameId,
              );
              if (game != null) {
                dependencies.gameplayViewModel.startNewSession(
                  game: game,
                  levelNumber: resultArg.levelNumber,
                );
                Navigator.of(context).pushReplacementNamed(
                  playSession(dependencies.gameplayViewModel.activeSessionId),
                );
              }
            },
            onOpenMedals: () =>
                Navigator.of(context).pushReplacementNamed(medals),
            onBackHome: () => Navigator.of(context).pushReplacementNamed(home),
          );
        },
      );
    }

    // 8. /medals
    if (uri.path == medals) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => MedalsScreen(
          viewModel: dependencies.achievementsViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onOpenGame: (gameId) => navigate(context, gameLevels(gameId)),
        ),
      );
    }

    // 9. /passport
    if (uri.path == passport) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => PassportScreen(
          viewModel: dependencies.passportViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onOpenTravelGame: () =>
              navigate(context, gameLevels('viaje_por_espana')),
        ),
      );
    }

    // 10. /inventory
    if (uri.path == inventory) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => InventoryScreen(
          viewModel: dependencies.inventoryViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onSelectRedeemItem: (item) => navigate(context, redeemItem(item.id)),
        ),
      );
    }

    // 11. /inventory/redeem/:itemId
    if (segments.length == 3 &&
        segments[0] == 'inventory' &&
        segments[1] == 'redeem') {
      final itemId = segments[2];
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => RedeemConfirmScreen(
          itemId: itemId,
          viewModel: dependencies.inventoryViewModel,
          onCancel: () => Navigator.of(context).pop(),
          onRedeemSuccess: (receipt) {
            Navigator.of(
              context,
            ).pushReplacementNamed(redeemReceipt(itemId), arguments: receipt);
          },
        ),
      );
    }

    // 12. /inventory/receipt/:itemId
    if (segments.length == 3 &&
        segments[0] == 'inventory' &&
        segments[1] == 'receipt') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final receipt = dependencies.inventoryViewModel.lastReceipt;
          if (receipt == null) {
            return InventoryScreen(
              viewModel: dependencies.inventoryViewModel,
              onNavigateRoute: (route) => navigate(context, route),
              onSelectRedeemItem: (item) =>
                  navigate(context, redeemItem(item.id)),
            );
          }
          return RedeemReceiptScreen(
            receipt: receipt,
            onGoToAdventures: () =>
                Navigator.of(context).pushReplacementNamed(adventures),
            onBackToInventory: () =>
                Navigator.of(context).pushReplacementNamed(inventory),
          );
        },
      );
    }

    // 13. /activity
    if (uri.path == activity) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => StudentActivityScreen(
          viewModel: dependencies.statisticsViewModel,
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(home);
            }
          },
        ),
      );
    }

    // 14. /teacher/classes/:classId/activity
    if (segments.length == 4 &&
        segments[0] == 'teacher' &&
        segments[1] == 'classes' &&
        segments[3] == 'activity') {
      final classId = segments[2];
      dependencies.teacherViewModel.selectClass(classId);
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => TeacherClassActivityScreen(
          viewModel: dependencies.teacherViewModel,
          onNavigateRoute: (route) => navigate(context, route),
          onOpenStudentDetail: (studentId) =>
              navigate(context, teacherStudentDetail(studentId)),
        ),
      );
    }

    // 15. /students/:studentId
    if (segments.length == 2 && segments[0] == 'students') {
      final studentId = segments[1];
      dependencies.teacherViewModel.selectStudent(studentId);
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => TeacherStudentDetailScreen(
          studentId: studentId,
          viewModel: dependencies.teacherViewModel,
          onNavigateRoute: (route) => navigate(context, route),
        ),
      );
    }

    // 16. /levels
    if (uri.path == levels) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => TeacherLevelsConfigScreen(
          viewModel: dependencies.teacherViewModel,
          onNavigateRoute: (route) => navigate(context, route),
        ),
      );
    }

    // 17. /questions/:questionId
    if (segments.length == 2 && segments[0] == 'questions') {
      final questionId = segments[1];
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => TeacherQuestionEditorScreen(
          questionId: questionId,
          viewModel: dependencies.teacherViewModel,
          onNavigateRoute: (route) => navigate(context, route),
        ),
      );
    }

    // Fallback seguro a Bienvenida
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => WelcomeScreen(
        viewModel: dependencies.authViewModel,
        onEnterStudentHome: () =>
            Navigator.of(context).pushReplacementNamed(home),
        onOpenAvatarEditor: () => navigate(context, avatar),
        onEnterTeacherSpace: () =>
            navigate(context, teacherClassActivity('4A')),
      ),
    );
  }
}
