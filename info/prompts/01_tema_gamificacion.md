# Prompt 01: Tema Visual (`lib/core/theme/`), Gamificación y Pasaporte

## Instrucción rápida para pegar en Copilot:
> Revisa `ARQUITECTURA.md` y confirma la estructura real en `lib/core/theme/`, `lib/core/router/app_router.dart`, `lib/features/dashboard/`, `lib/features/achievements/`, `lib/features/passport/` y `lib/features/inventory/`. Lee `info/doc/resumen_prototipo_ui.md`, `info/doc/cambios_09_11_mapas.md` e `info/doc/ideas_post_cocreacion.md` y aplica las mejoras descritas en este archivo.

## Especificaciones Técnicas:
1. **Identidad y Tema (`lib/core/theme/`)**:
   - Asegura que toda referencia a *"Natu"* se reemplace por **Brújula Quest · Sociales (GeoExplorer)**.
   - Configura la tipografía **Nunito** y los colores exactos `#17257C`, `#19D88D`, `#29E1B4`, `#AFC6DD` y `#23C450` en los archivos de tema existentes (`colors`, `typography`, `spacing`, `theme`).
   - Añade soporte para que el alumno alterne entre 3 paletas predefinidas (*Aventura*, *Pastel*, *Calmado*) sin fondos blancos puros, optimizando tamaños para **Tablet**.
2. **Gamificación (`dashboard`, `achievements`, `passport`, `inventory`)**:
   - **Moneda y Rachas**: Gestiona el saldo de **Brújulas**, recompensa diaria al iniciar sesión y contador de **racha de días consecutivos** (estilo Duolingo, visible en `/home`).
   - **Medallero (`/medals`) y Pasaporte (`/passport`)**: Medallas de distintos colores/rangos (usando los assets de `assets/icons/` e `info/img/`, evitando iconos confusos) que tengan utilidad real (canjeables por recompensas en `/inventory`).
   - **Widgets Compartidos (`lib/shared/`)**: Crea o actualiza el modal explicativo inicial de cada juego y la pantalla/diálogo de logro superado mostrando brújulas ganadas e insignias.