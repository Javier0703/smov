# ARQUITECTURA DE SOFTWARE: COLEGIO APP (FLUTTER)

> **DIRECTIVA DE SISTEMA PARA ARGON (ANTIGRAVITY IDE):**
> Este documento constituye la especificación arquitectónica obligatoria del proyecto. Ningún archivo creado o modificado puede violar las capas, responsabilidades o reglas de estructura aquí definidas.

---

## 1. Patrón Arquitectónico Base: MVVM por Capas (2 Capas / 4 Roles)

El proyecto implementa una arquitectura **Feature-First** gobernada internamente por el patrón oficial **MVVM (Model-View-ViewModel)** dividido estrictamente en **dos grandes capas** y **cuatro papeles fundamentales**:

```
┌─────────────────────────────────────────────────────────────────┐
│                         CAPA DE UI (Presentation)               │
│                                                                 │
│  ┌─────────────────────────┐       ┌─────────────────────────┐  │
│  │      1. VISTA (View)    │ ◄───► │  2. VIEWMODEL (Estado)  │  │
│  │  (Widgets declarativos) │       │ (ChangeNotifier / Bloc) │  │
│  └─────────────────────────┘       └────────────┬────────────┘  │
└─────────────────────────────────────────────────┼───────────────┘
                                                  │
                                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                         CAPA DE DATOS (Data)                    │
│                                                                 │
│  ┌─────────────────────────┐       ┌─────────────────────────┐  │
│  │     3. REPOSITORIO      │ ◄───► │       4. SERVICIO       │  │
│  │ (Única fuente de verdad)│       │ (Cliente HTTP/Local DB) │  │
│  └─────────────────────────┘       └─────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Definición Estricta de los 4 Roles:
1. **Vista (`View` - Screens & Widgets):**
   * **Responsabilidad:** Describir exclusivamente cómo se ve el estado actual ($UI = f(state)$) y capturar eventos de interacción del usuario (toques, scroll, entrada de texto) delegándolos al `ViewModel`.
   * **Prohibiciones:** Cero lógica de negocio, cero validaciones complejas, cero llamadas directas a repositorios o servicios, cero valores de diseño *hardcodeados*.
2. **ViewModel (`ViewModel` / `Controller`):**
   * **Responsabilidad:** Almacenar el estado de la pantalla (`isLoading`, `errorMessage`, datos listos para pintar) y exponer los métodos/acciones ejecutables por la Vista.
   * **Prohibiciones:** No importa `material.dart` (salvo tipos básicos si usa `ChangeNotifier`), **no conoce ni devuelve `Widgets`**, ni manipula el `BuildContext`.
3. **Repositorio (`Repository`):**
   * **Responsabilidad:** Actuar como **única fuente de verdad** para un dominio de datos (ej. `HorarioRepository`, `CalificacionesRepository`). Decide si el dato proviene de memoria caché, datos Mock o red, y transforma los DTOs brutos en **Modelos de Dominio** limpios e inmutables.
4. **Servicio (`Service` / `DataSource`):**
   * **Responsabilidad:** Envoltorio fino (*thin wrapper*) sobre una fuente externa concreta (cliente HTTP REST, almacenamiento local, sensores o generador de JSON Mock). No toma decisiones de negocio.

---

## 2. Estructura de Directorios del Proyecto (`lib/` y `test/`)

Todo el código Dart vive en `lib/`. Las carpetas nativas (`android/`, `ios/`) son *wrappers* de plataforma y **no deben modificarse** salvo para declarar permisos de sistema o plugins nativos.

```text
colegio_app/
├── assets/
│   ├── images/                         # Imágenes rasterizadas (.png, .webp) exportadas de Figma
│   ├── icons/                          # Vectores e iconografía (.svg) exportados de Figma
│   └── fonts/                          # Tipografías corporativas locales (.ttf, .otf)
│
├── lib/
│   ├── main.dart                       # Punto de entrada: inicializa bindings, DI y arranca App
│   ├── app.dart                        # Widget raíz: MaterialApp.router, ThemeData y rutas
│   │
│   ├── core/                           # NÚCLEO TRANSVERSAL Y DESIGN SYSTEM
│   │   ├── config/                     # Variables de entorno (--dart-define), configuración global
│   │   ├── constants/                  # Rutas de assets (app_assets.dart), textos fijos, constantes
│   │   ├── di/                         # Inyección de dependencias / Service Locator / Providers globales
│   │   ├── errors/                     # Clases de manejo de errores (AppException, Failure, Result<T>)
│   │   ├── router/                     # Navegación declarativa centralizada (app_router.dart)
│   │   ├── theme/                      # SISTEMA DE DISEÑO (Tokens extraídos de Figma)
│   │   │   ├── app_colors.dart         # Paleta semántica y colores de marca
│   │   │   ├── app_typography.dart     # Escala tipográfica (TextStyles mapeados a TextTheme)
│   │   │   ├── app_spacing.dart        # Sistema de espaciado (8pt grid), radios y bordes
│   │   │   ├── app_shadows.dart        # Sombras y elevaciones de tarjetas según Figma
│   │   │   └── app_theme.dart          # Construcción de ThemeData (Material 3)
│   │   └── utils/                      # Formateadores de fecha/hora, validadores puros de formularios
│   │
│   ├── shared/                         # UI KIT GLOBAL REUTILIZABLE (Átomos y Moléculas de Figma)
│   │   ├── models/                     # Modelos transversales (ej. UserModel, RoleEnum, CicloEscolar)
│   │   ├── services/                   # Clientes compartidos (HttpClientService, LocalStorageService)
│   │   └── widgets/                    # Componentes visuales agnósticos al negocio:
│   │       ├── buttons/                # AppPrimaryButton, AppSecondaryButton, AppIconButton
│   │       ├── cards/                  # AppBaseCard, StatusBadge, InfoTile
│   │       ├── feedback/               # AppLoadingSkeleton, AppErrorView, AppEmptyState
│   │       ├── inputs/                 # AppTextField, AppDropdownField, AppSearchBar
│   │       └── navigation/             # AppTopBar, AppBottomNavigationBar, AppDrawer
│   │
│   └── features/                       # MÓDULOS DE NEGOCIO (Feature-First)
│       ├── auth/                       # Autenticación, Login, Selección de Hijo/Perfil
│       ├── dashboard/                  # Inicio / Resumen escolar del día
│       ├── horario/                    # Horario semanal de clases y eventos
│       ├── calificaciones/             # Boletín de notas, asignaturas y evaluaciones
│       ├── asistencia/                 # Faltas de asistencia, retrasos y justificaciones
│       ├── comunicados/                # Circulares del colegio, avisos y tutorías
│       └── perfil/                     # Ficha del estudiante, configuración y cierre de sesión
│
└── test/                               # Espejo exacto de la carpeta lib/ para Widget y Unit tests
```

---

## 3. Anatomía Interna Obligatoria de cada `Feature`

Cada módulo dentro de `lib/features/<nombre_feature>/` debe estructurarse de forma idéntica:

```text
lib/features/calificaciones/
├── data/
│   ├── models/
│   │   └── calificacion_model.dart         # Modelo inmutable (final fields, fromJson, toJson, copyWith)
│   ├── services/
│   │   └── calificaciones_service.dart     # Fuente de datos (Mock data realista o llamada API)
│   └── repositories/
│       └── calificaciones_repository.dart  # Coordina el servicio, gestiona caché y captura excepciones
│
└── presentation/
    ├── viewmodels/
    │   └── calificaciones_viewmodel.dart   # Estado reactivo de la pantalla (loading, data, error, filtros)
    ├── screens/
    │   └── calificaciones_screen.dart      # Scaffold principal de la pantalla (Frame completo de Figma)
    └── widgets/
        ├── asignatura_grade_card.dart      # Sub-widget específico de esta feature
        └── trimestre_selector_bar.dart     # Sub-widget específico de esta feature
```

---

## 4. Arquitectura del Sistema de Diseño (Single Source of Truth)

Toda propiedad visual en la capa de presentación debe referenciar los *Design Tokens* ubicados en `lib/core/theme/`:

1. **`AppColors` (`app_colors.dart`):**
   * Colores de Identidad: `primary`, `primaryContainer`, `secondary`, `secondaryContainer`.
   * Superficies y Fondos: `background`, `surface`, `surfaceVariant`, `cardBackground`.
   * Textos e Iconos: `textPrimary`, `textSecondary`, `textDisabled`, `textOnPrimary`.
   * Estados Semánticos (Notas/Asistencia): `success` (Sobresaliente/Asiste), `warning` (Retraso/ Suficiente), `error` (Suspenso/Falta injustificada), `info` (Comunicado).
2. **`AppSpacing` y `AppRadius` (`app_spacing.dart`):**
   * Escala espacial estricta: `xxs = 4.0`, `xs = 8.0`, `sm = 12.0`, `md = 16.0`, `lg = 24.0`, `xl = 32.0`, `xxl = 48.0`.
   * Radios de curvatura: `radiusSm = 8.0`, `radiusMd = 12.0`, `radiusLg = 16.0`, `radiusFull = 999.0`.
3. **`AppTypography` (`app_typography.dart`):**
   * Jerarquía tipográfica centralizada conectada al `TextTheme` de Material 3 (`displayLarge`, `headlineMedium`, `titleLarge`, `titleMedium`, `bodyLarge`, `bodyMedium`, `labelSmall`).

---

## 5. Gestión de Estado, Navegación y Ciclo de Vida

1. **Estados de UI Estandarizados:**
   Cada `ViewModel` que cargue datos asíncronos debe contemplar explícitamente 4 estados visuales en la `Vista`:
   * **Cargando (`Loading`):** Mostrar indicadores o *skeletons* de carga coherentes con el diseño.
   * **Éxito con Datos (`Loaded`):** Renderizar los widgets con los datos del modelo.
   * **Vacío (`Empty`):** Si la lista está vacía (ej. "No hay comunicados nuevos"), mostrar `AppEmptyState`.
   * **Error (`Error`):** Mostrar `AppErrorView` con botón de reintento conectado al `ViewModel`.
2. **Navegación Declarativa:**
   * Todas las rutas deben estar registradas en `lib/core/router/app_router.dart` con nombres y paths constantes.
   * Prohibido construir llamadas dispersas a `Navigator.of(context).push(MaterialPageRoute(...))` con lógica incrustada en los botones.
3. **Limpieza de Recursos (`Lifecycle`):**
   * Todo `TextEditingController`, `ScrollController`, `AnimationController` o `FocusNode` instanciado en un `StatefulWidget` o `ViewModel` **debe liberarse obligatoriamente** en el método `dispose()`.