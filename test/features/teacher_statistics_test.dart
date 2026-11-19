import 'package:flutter_test/flutter_test.dart';
import 'package:smov/core/di/app_dependencies.dart';

void main() {
  group('Espacio docente y estadísticas', () {
    late AppDependencies dependencies;

    setUp(() {
      dependencies = AppDependencies();
    });

    tearDown(() {
      dependencies.dispose();
    });

    test('el curso bloquea niveles y el docente no puede saltar el límite', () {
      dependencies.teacherViewModel.selectCourseGrade(1);
      dependencies.teacherViewModel.toggleGameLevel(
        gameId: 'espana_en_tus_manos',
        levelNumber: 3,
        enabled: true,
      );

      expect(
        dependencies.teacherService.getEnabledLevels(
          '4.º A',
          'espana_en_tus_manos',
        ),
        <int>{1},
      );
      expect(
        dependencies.adventuresViewModel
            .findGame('espana_en_tus_manos')!
            .levels[2]
            .isAvailableForCourse,
        isFalse,
      );

      dependencies.teacherViewModel.selectCourseGrade(3);
      dependencies.teacherViewModel.toggleGameLevel(
        gameId: 'espana_en_tus_manos',
        levelNumber: 3,
        enabled: true,
      );
      final levelThree = dependencies.adventuresViewModel
          .findGame('espana_en_tus_manos')!
          .levels[2];
      expect(levelThree.isAvailableForCourse, isTrue);
      expect(levelThree.isEnabledByTeacher, isTrue);
    });

    test('el docente puede bloquear un minijuego completo', () {
      dependencies.teacherViewModel.toggleGame(
        gameId: 'donde_estoy',
        enabled: false,
      );

      final policy = dependencies.teacherViewModel.levelPolicies.singleWhere(
        (item) => item.gameId == 'donde_estoy',
      );
      expect(policy.isGameEnabled, isFalse);
      expect(policy.enabledLevels, isEmpty);
      expect(
        dependencies.adventuresViewModel
            .findGame('donde_estoy')!
            .levels
            .every((level) => !level.isEnabledByTeacher),
        isTrue,
      );
    });

    test(
      'la pista y el territorio publicados se usan en la ronda de su clase',
      () {
        dependencies.teacherViewModel.updateDraftGame('donde_estoy');
        dependencies.teacherViewModel.updateDraftLevel(2);
        dependencies.teacherViewModel.updateDraftPrompt(
          '¿Qué comunidad autónoma tiene Madrid como capital?',
        );
        dependencies.teacherViewModel.updateDraftCorrectOption(
          'Comunidad de Madrid',
        );
        dependencies.teacherViewModel.updateDraftHint(
          'Está en el centro de la península.',
        );
        dependencies.teacherViewModel.updateDraftTargetRegion('madrid');

        expect(dependencies.teacherViewModel.publishQuestionToClass(), isTrue);

        final rounds = dependencies.gameplayService.buildRoundsForGame(
          gameId: 'donde_estoy',
          levelNumber: 2,
        );
        final customRound = rounds.last;
        expect(customRound.instruction, contains('tiene Madrid como capital'));
        expect(customRound.hint, 'Está en el centro de la península.');
        expect(customRound.targetRegionId, 'madrid');
        expect(customRound.options.first, 'Comunidad de Madrid');
      },
    );

    test('las métricas individual y grupal agregan sesiones y dificultad', () {
      final studentActivity = dependencies.statisticsViewModel.activity!;
      final classActivity = dependencies.teacherRepository.loadClassActivity(
        '4.º A',
      );

      expect(studentActivity.totalSessionsCount, 4);
      expect(studentActivity.totalCoinsEarned, 160);
      expect(studentActivity.mostDifficultGameTitle, 'El tesoro secreto');
      expect(classActivity.isSuccess, isTrue);
      final dashboard = classActivity.data!;
      expect(dashboard.completedChallengesCount, 66);
      expect(dashboard.totalCoinsEarned, 320);
      expect(dashboard.activeStudentsCount, 5);
      expect(dashboard.mostDifficultGameTitle, '¿Dónde estoy?');
    });
  });
}
