import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smov/app.dart';
import 'package:smov/core/constants/app_strings.dart';
import 'package:smov/core/di/app_dependencies.dart';
import 'package:smov/core/router/app_router.dart';

void main() {
  group(
    'BrujulaQuestApp — Pruebas de Integración de Vistas (Widget Tests)',
    () {
      testWidgets(
        'Renderiza Bienvenida y navega al Inicio del alumno mostrando pasaporte, sellos y monedas',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(900, 1200));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final dependencies = AppDependencies();
          addTearDown(dependencies.dispose);

          await tester.pumpWidget(BrujulaQuestApp(dependencies: dependencies));
          await tester.pumpAndSettle();

          // Verifica textos clave de Bienvenida
          expect(find.text(AppStrings.appBrandTag), findsOneWidget);
          expect(find.text(AppStrings.welcomeSubtitle), findsOneWidget);
          expect(find.text(AppStrings.welcomeStartButton), findsOneWidget);

          // Pulsa "Soy alumno · Empezar expedición"
          await tester.tap(find.text(AppStrings.welcomeStartButton));
          await tester.pumpAndSettle();

          // Verifica que estamos en Inicio — Pasaporte y progreso
          expect(find.text('¡Hola, Alex!'), findsOneWidget);
          expect(
            find.text(AppStrings.homeOrientationStampsTitle),
            findsOneWidget,
          );
          expect(find.text(AppStrings.homeNextMissionBadge), findsOneWidget);
          expect(find.text('240'), findsWidgets);
        },
      );

      testWidgets(
        'Navega al catálogo de las 10 aventuras y abre España en tus manos',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(900, 1200));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final dependencies = AppDependencies();
          addTearDown(dependencies.dispose);

          await tester.pumpWidget(
            BrujulaQuestApp(
              dependencies: dependencies,
              initialRoute: AppRouter.adventures,
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text(AppStrings.adventuresScreenTitle), findsOneWidget);
          expect(find.text('¡Rumbo desconocido!'), findsOneWidget);
          expect(find.text('La brújula perdida'), findsOneWidget);

          // Filtra por "España en tus manos"
          await tester.enterText(find.byType(TextField), 'España en tus manos');
          await tester.pumpAndSettle();

          expect(find.text('España en tus manos'), findsWidgets);
          await tester.tap(find.text('España en tus manos').last);
          await tester.pumpAndSettle();

          // Verifica los 3 niveles territoriales
          expect(find.text('Comunidades autónomas'), findsOneWidget);
          expect(find.text('Castilla y León'), findsOneWidget);
          expect(find.text('Provincias de España'), findsOneWidget);
        },
      );

      testWidgets(
        'Renderiza el Espacio Docente con actividad ponderada de 4.º A y navegación a Niveles y Editor',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1024, 1200));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final dependencies = AppDependencies();
          addTearDown(dependencies.dispose);

          await tester.pumpWidget(
            BrujulaQuestApp(
              dependencies: dependencies,
              initialRoute: AppRouter.teacherClassActivity('4A'),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            find.text('Espacio docente — Actividad de 4.º A'),
            findsOneWidget,
          );
          expect(find.text('Alex'), findsOneWidget);
          expect(find.text('Lucía'), findsOneWidget);

          // Navega a Niveles de clase
          await tester.tap(find.text('Niveles de clase'));
          await tester.pumpAndSettle();

          expect(
            find.text(
              'Niveles para mi clase — Configura el recorrido de 4.º A',
            ),
            findsOneWidget,
          );
          expect(
            find.text('02 · Castilla y León (9 provincias)'),
            findsOneWidget,
          );
        },
      );
    },
  );
}
