import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/di/app_dependencies.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Widget raíz de la aplicación educativa colaborativa `Brújula Quest · Sociales`.
class BrujulaQuestApp extends StatefulWidget {
  const BrujulaQuestApp({
    super.key,
    this.dependencies,
    this.initialRoute = AppRouter.welcome,
  });

  final AppDependencies? dependencies;
  final String initialRoute;

  @override
  State<BrujulaQuestApp> createState() => _BrujulaQuestAppState();
}

class _BrujulaQuestAppState extends State<BrujulaQuestApp> {
  late final AppDependencies _dependencies;
  late final AppRouter _router;
  late final bool _ownsDependencies;

  @override
  void initState() {
    super.initState();
    _ownsDependencies = widget.dependencies == null;
    _dependencies = widget.dependencies ?? AppDependencies();
    _router = AppRouter(dependencies: _dependencies);
  }

  @override
  void dispose() {
    if (_ownsDependencies) {
      _dependencies.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dependencies.stateStore,
      builder: (context, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(palette: _dependencies.stateStore.palette),
          initialRoute: widget.initialRoute,
          onGenerateRoute: _router.onGenerateRoute,
        );
      },
    );
  }
}
