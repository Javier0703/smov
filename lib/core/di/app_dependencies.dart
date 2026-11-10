import '../../features/achievements/data/repositories/achievements_repository.dart';
import '../../features/achievements/data/services/achievements_service.dart';
import '../../features/achievements/presentation/viewmodels/achievements_viewmodel.dart';
import '../../features/adventures/data/repositories/adventures_repository.dart';
import '../../features/adventures/data/services/adventures_service.dart';
import '../../features/adventures/presentation/viewmodels/adventures_viewmodel.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/avatar/data/repositories/avatar_repository.dart';
import '../../features/avatar/data/services/avatar_service.dart';
import '../../features/avatar/presentation/viewmodels/avatar_viewmodel.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/services/dashboard_service.dart';
import '../../features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import '../../features/gameplay/data/repositories/gameplay_repository.dart';
import '../../features/gameplay/data/services/gameplay_service.dart';
import '../../features/gameplay/presentation/viewmodels/gameplay_viewmodel.dart';
import '../../features/inventory/data/repositories/inventory_repository.dart';
import '../../features/inventory/data/services/inventory_service.dart';
import '../../features/inventory/presentation/viewmodels/inventory_viewmodel.dart';
import '../../features/passport/data/repositories/passport_repository.dart';
import '../../features/passport/data/services/passport_service.dart';
import '../../features/passport/presentation/viewmodels/passport_viewmodel.dart';
import '../../features/statistics/data/repositories/statistics_repository.dart';
import '../../features/statistics/data/services/statistics_service.dart';
import '../../features/statistics/presentation/viewmodels/statistics_viewmodel.dart';
import '../../features/teacher/data/repositories/teacher_repository.dart';
import '../../features/teacher/data/services/teacher_service.dart';
import '../../features/teacher/presentation/viewmodels/teacher_viewmodel.dart';
import '../../shared/services/expedition_state_store.dart';
import '../../shared/services/http_client_service.dart';
import '../../shared/services/local_storage_service.dart';

/// Contenedor centralizado de Inyección de Dependencias por constructor.
///
/// Conecta `Service` -> `Repository` -> `ViewModel` respetando la regla
/// de dependencias unidireccional de `ARQUITECTURA.md`.
class AppDependencies {
  AppDependencies() {
    localStorageService = LocalStorageService();
    httpClientService = HttpClientService();
    stateStore = ExpeditionStateStore(localStorage: localStorageService);

    // 1. Auth
    authService = AuthService(store: stateStore);
    authRepository = AuthRepository(service: authService);
    authViewModel = AuthViewModel(repository: authRepository);

    // 2. Avatar
    avatarService = AvatarService(store: stateStore);
    avatarRepository = AvatarRepository(service: avatarService);
    avatarViewModel = AvatarViewModel(repository: avatarRepository);

    // 3. Dashboard
    dashboardService = DashboardService(store: stateStore);
    dashboardRepository = DashboardRepository(service: dashboardService);
    dashboardViewModel = DashboardViewModel(
      repository: dashboardRepository,
      externalStoreListenable: stateStore,
    );

    // 4. Adventures
    adventuresService = AdventuresService(store: stateStore);
    adventuresRepository = AdventuresRepository(service: adventuresService);
    adventuresViewModel = AdventuresViewModel(
      repository: adventuresRepository,
      externalStoreListenable: stateStore,
    );

    // 5. Gameplay
    gameplayService = GameplayService(store: stateStore);
    gameplayRepository = GameplayRepository(service: gameplayService);
    gameplayViewModel = GameplayViewModel(repository: gameplayRepository);

    // 6. Achievements (Medallero)
    achievementsService = AchievementsService(store: stateStore);
    achievementsRepository = AchievementsRepository(
      service: achievementsService,
    );
    achievementsViewModel = AchievementsViewModel(
      repository: achievementsRepository,
      externalStoreListenable: stateStore,
    );

    // 7. Passport
    passportService = PassportService(store: stateStore);
    passportRepository = PassportRepository(service: passportService);
    passportViewModel = PassportViewModel(
      repository: passportRepository,
      externalStoreListenable: stateStore,
    );

    // 8. Inventory (Mochila)
    inventoryService = InventoryService(store: stateStore);
    inventoryRepository = InventoryRepository(service: inventoryService);
    inventoryViewModel = InventoryViewModel(
      repository: inventoryRepository,
      externalStoreListenable: stateStore,
    );

    // 9. Statistics (Mi actividad)
    statisticsService = StatisticsService(store: stateStore);
    statisticsRepository = StatisticsRepository(service: statisticsService);
    statisticsViewModel = StatisticsViewModel(
      repository: statisticsRepository,
      externalStoreListenable: stateStore,
    );

    // 10. Teacher (Espacio docente)
    teacherService = TeacherService(store: stateStore);
    teacherRepository = TeacherRepository(service: teacherService);
    teacherViewModel = TeacherViewModel(
      repository: teacherRepository,
      externalStoreListenable: stateStore,
    );
  }

  late final LocalStorageService localStorageService;
  late final HttpClientService httpClientService;
  late final ExpeditionStateStore stateStore;

  late final AuthService authService;
  late final AuthRepository authRepository;
  late final AuthViewModel authViewModel;

  late final AvatarService avatarService;
  late final AvatarRepository avatarRepository;
  late final AvatarViewModel avatarViewModel;

  late final DashboardService dashboardService;
  late final DashboardRepository dashboardRepository;
  late final DashboardViewModel dashboardViewModel;

  late final AdventuresService adventuresService;
  late final AdventuresRepository adventuresRepository;
  late final AdventuresViewModel adventuresViewModel;

  late final GameplayService gameplayService;
  late final GameplayRepository gameplayRepository;
  late final GameplayViewModel gameplayViewModel;

  late final AchievementsService achievementsService;
  late final AchievementsRepository achievementsRepository;
  late final AchievementsViewModel achievementsViewModel;

  late final PassportService passportService;
  late final PassportRepository passportRepository;
  late final PassportViewModel passportViewModel;

  late final InventoryService inventoryService;
  late final InventoryRepository inventoryRepository;
  late final InventoryViewModel inventoryViewModel;

  late final StatisticsService statisticsService;
  late final StatisticsRepository statisticsRepository;
  late final StatisticsViewModel statisticsViewModel;

  late final TeacherService teacherService;
  late final TeacherRepository teacherRepository;
  late final TeacherViewModel teacherViewModel;

  void dispose() {
    authViewModel.dispose();
    avatarViewModel.dispose();
    dashboardViewModel.dispose();
    adventuresViewModel.dispose();
    gameplayViewModel.dispose();
    achievementsViewModel.dispose();
    passportViewModel.dispose();
    inventoryViewModel.dispose();
    statisticsViewModel.dispose();
    teacherViewModel.dispose();
    stateStore.dispose();
  }
}
