# Resumen Visual y Arquitectura del Prototipo UI (`Resumen.pdf`)

## 1. Flujo de Pantallas Detectado en Prototipo
1. **Bienvenida / Home (`/welcome`, `/home`)**:
   - Título: *"¿Exploramos? ¡Tu gran aventura empieza aquí!"*
   - Accesos principales: *"Elige tu aventura"* (`/adventures`), *"Preparar mi pasaporte"* (`/passport`), *"Mi medallero (5 insignias conseguidas)"* (`/medals`).
   - Indicador superior de racha diaria (ej. *"2 días explorando"*) y barra de progreso (`68%`).
2. **Selector de Aventura y Niveles (`/adventures`, `/levels`, `/games/:gameId/levels`)**:
   - Tarjetas de los 10 minijuegos con estado de progreso, medalla (bronce/plata/oro) y selector de nivel (*"Elige tu nivel"*, *"Jugar al nivel 2"*, *"Puedes volver a practicar"*).
3. **Pantalla de Juego Activo (`/play/:sessionId`)**:
   - Cabecera con título del reto, temporizador cuando aplica (`02:00`), progreso y botón de ayuda.
   - Zona central interactiva (mapa, cuadrícula, drag & drop) con tarjetas de pistas/instrucciones en la parte inferior y botón principal de acción (`Comprobar`, `Empezar recorrido`, `Seguir`, `Guardar`).
4. **Pasaporte y Medallero (`/passport`, `/medals`, `/inventory`)**:
   - Vista de insignias desbloqueadas, sellos de comunidades visitadas y progreso global.
5. **Pantalla de Victoria Final**:
   - Banner: *"AVENTURA COMPLETADA - ¡Gran explorador!"* con insignia destacada y botón *"Ver mi pasaporte"*.

## 2. Directrices Técnicas de Implementación
- **Tema y espaciado compartido (`lib/core/theme/`)**: Centralizar `ThemeData` (fuente `Nunito`, colores `#17257C`, `#19D88D`, `#29E1B4`, `#AFC6DD`, `#23C450`) y tokens de espaciado/radios para consistencia en tablet y móvil.
- **SVGs Configurables**: Los mapas, medallas y componentes gráficos en `assets/icons/` e `info/img/` deben cargarse como SVGs parametrizables (colores dinámicos según selección/acierto/error).
- **Separación de Responsabilidades**: Separar estrictamente `presentation/` (widgets UI) de `data/` (lógica de negocio/validación de mapas y rutas).