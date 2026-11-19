# Guía de Prompts Modulares — Brújula Quest · Sociales (GeoExplorer)

Ejecuta estos prompts en **GitHub Copilot Edits / Agent Mode** (uno por sesión) pegando únicamente la **Instrucción rápida** de cada archivo. Así Copilot leerá los `.md` ligeros en `info/doc/` y respetará la arquitectura real de `lib/features/` sin gastar tokens leyendo PDFs.

## Orden de Ejecución
1. `01_tema_y_gamificacion.md` -> Ajusta `lib/core/theme/` (Nunito + paleta `#17257C`, `#19D88D`, `#29E1B4`, `#AFC6DD`, `#23C450`), `dashboard`, `achievements`, `passport` e `inventory`.
2. `02_avatar_y_tienda.md` -> Implementa personalización del avatar con chándal escolar y tienda en `lib/features/avatar/` e `inventory`.
3. `03_juegos_orientacion_basica.md` -> Implementa Juegos 1, 2 y 7 en `lib/features/adventures/` y `lib/features/gameplay/`.
4. `04_juegos_mapas_y_rutas.md` -> Implementa Juegos 3, 4, 5 y 6 en `lib/features/adventures/` y `lib/features/gameplay/`.
5. `05_juegos_espana_y_reto_final.md` -> Implementa Juegos 8, 9 y 10 en `lib/features/adventures/` y `lib/features/gameplay/`.
6. `06_espacio_docente.md` -> Implementa el control docente y métricas en `lib/features/teacher/` y `lib/features/statistics/`.