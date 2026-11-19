# Prompt 06: Espacio Docente (`lib/features/teacher/`) y Estadísticas (`lib/features/statistics/`)

## Instrucción rápida para pegar en Copilot:
> Confirma la estructura real en `lib/features/teacher/`, `lib/features/statistics/` y la ruta `/teacher/classes/:classId/activity` en `lib/core/router/app_router.dart`. Lee `info/doc/cambios_09_11_mapas.md` e `info/doc/ideas_post_cocreacion.md` e implementa el panel docente y las métricas descritas aquí.

## Especificaciones Técnicas:
1. **Gestión de Clase y Dificultad (`lib/features/teacher/`)**:
   - Selector de curso escolar (1º a 6º de Primaria) que filtre y limite automáticamente los niveles disponibles para la clase (ej. restringiendo provincias avanzadas en cursos iniciales).
   - Controles (`SwitchListTile` / tarjetas) para activar o bloquear minijuegos y niveles concretos para el aula.
   - **Editor Rápido de Retos**: Formulario sencillo en `presentation/` para que la profesora pueda personalizar pistas o preguntas de los juegos (ej. añadir pistas personalizadas en *¿Dónde estoy?* o seleccionar provincias de Castilla y León a evaluar).
2. **Estadísticas Individuales y Grupales (`lib/features/statistics/`)**:
   - Vista de actividad en `/teacher/classes/:classId/activity` y `/activity` con métricas por alumno (retos completados, porcentaje de acierto, brújulas acumuladas, juegos con mayor dificultad) y resumen general de la clase.
   - Mantener estética consistente con **Nunito**, paleta `#17257C`, `#19D88D`, `#29E1B4`, `#AFC6DD`, `#23C450` y soporte para **Tablet**.