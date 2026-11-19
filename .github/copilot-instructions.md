# Contexto Maestro: Brújula Quest · Sociales (GeoExplorer)

## 1. Arquitectura Real del Repositorio (`/workspaces/smov`)
- **Identidad**: App educativa Flutter (Android/iOS, optimizada para **Tablets**) llamada **Brújula Quest · Sociales (GeoExplorer)** para Primaria (6-12 años).
- **Regla de Oro de Exploración**: Antes de editar o crear código, consulta `ARQUITECTURA.md` como referencia conceptual, pero **confirma siempre la estructura real en `lib/`** sin asumir que los nombres de ejemplo de `ARQUITECTURA.md` existen tal cual. Limita tus cambios estrictamente a los archivos directamente relacionados.
- **Puntos Clave**:
  - Entrada y raíz: `lib/main.dart`, `lib/app.dart`.
  - Navegación centralizada: `lib/core/router/app_router.dart` (`/welcome`, `/home`, `/adventures`, `/avatar`, `/medals`, `/passport`, `/inventory`, `/activity`, `/levels`, `/games/:gameId/levels`, `/play/:sessionId`, `/teacher/classes/:classId/activity`).
  - Core compartido: `lib/core/theme/` (colores, tipografía, espaciado, tema), `lib/core/di/`, `lib/core/constants/`, `lib/core/config/`, `lib/core/errors/`, `lib/core/utils/`.
  - Módulos reales (`lib/features/<módulo>/` con capas `data/{models,repositories,services}` y `presentation/{screens,viewmodels,widgets}`):
    - `auth`, `avatar`, `dashboard`, `adventures`, `gameplay`, `achievements`, `passport`, `inventory`, `statistics`, `teacher`.
  - Compartidos: `lib/shared/` (modelos, servicios y widgets reutilizables).
  - Assets en producción: `assets/icons/` (iconos, subcarpetas de mapas y medallas).
  - Diseños y documentación de referencia: `info/img/` y `info/doc/` (leer estos `.md` en lugar de los PDFs).

## 2. Identidad Visual (Tipografía y Paleta)
- **Tipografía Oficial**: `Nunito` (configurada en `lib/core/theme/`). Tamaños grandes y alto contraste para Primaria y Tablet.
- **Paleta de Colores Base** (`lib/core/theme/`):
  - Azul Marino Principal: `#17257C`
  - Verde Esmeralda: `#19D88D`
  - Turquesa Brillante: `#29E1B4`
  - Azul Grisáceo Suave: `#AFC6DD`
  - Verde Éxito: `#23C450`
- **Temas Dinámicos**: Soportar paletas configurables por el usuario (*Aventura/Llamativo*, *Pastel*, *Calmado*) manteniendo los tokens de `lib/core/theme/` y evitando fondos blancos planos.

## 3. Reglas Pedagógicas y UX Obligatorias
- **Vocabulario**: Usar siempre **"casillas"** en desplazamientos sobre cuadrícula.
- **Iconografía**:
  - Brújula con aguja en **rojo (Norte) y blanco (Sur)**.
  - Icono de ubicación con punto central marcado (evitar que parezca una gota de agua).
  - Emblemas e iconos coloridos e intuitivos (evitar formas abstractas como círculo con semicuadrado).
- **SVGs Configurables**: Los mapas y medallas (en `assets/icons/` e `info/img/`) deben parametrizar colores dinámicamente y separar presentación (`presentation/`) de lógica (`data/`).
## Terminal y SDK
- El SDK de Flutter está en `/workspaces/flutter/bin/flutter` (y enlazado en `/usr/local/bin/flutter`). **NUNCA instales ni descargues Flutter, Java ni JDK.** Ejecuta directamente `flutter analyze` o `/workspaces/flutter/bin/flutter analyze`.