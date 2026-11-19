# Prompt 05: Geografía de España y Reto Final (Juegos 8, 9 y 10)

## Instrucción rápida para pegar en Copilot:
> Confirma la estructura real en `lib/features/adventures/`, `lib/features/gameplay/`, `lib/features/passport/` y los mapas SVG en `assets/icons/` e `info/img/`. Lee `info/doc/requisitos_profesoras.md`, `info/doc/cambios_09_11_mapas.md` e `info/doc/ideas_post_cocreacion.md` e implementa los juegos 8, 9 y 10.

## Especificaciones Técnicas:
1. **Juego 8: España en tus manos**:
   - Mapa SVG interactivo (Península, Baleares, Canarias, Ceuta y Melilla) donde los nombres/piezas puedan **arrastrarse directamente sobre las zonas** (`DragTarget`) y las regiones cambien de color dinámicamente (`#23C450` al acertar, `#19D88D` al seleccionar).
   - **Progresión por nivel / curso escolar**:
     - Nivel 1 (Inicial): Comunidades Autónomas y Ciudades Autónomas.
     - Nivel 2 (Intermedio): Selección de provincias de **Castilla y León** + pistas de límites (*"Busca una comunidad que limita con Portugal"*).
     - Nivel 3 (Avanzado): Todas las provincias de España, capitales, comunidades uniprovinciales y orientación (*"Salimos de Castilla y León hacia el norte..."*).
2. **Juego 9: El viaje por España**:
   - Retos de ruta por etapas (*"Comienzas en Valladolid. Viaja hasta Galicia. Ahora ve a una comunidad que limite con Castilla y León"*).
   - Cada etapa superada añade una postal/sello en `lib/features/passport/`.
3. **Juego 10: El gran reto del explorador**:
   - Prueba final en 7 fases secuenciales: (1) Orientar mapa, (2) Usar puntos cardinales por casillas, (3) Interpretar leyenda, (4) Seguir recorrido, (5) Encontrar lugares, (6) Resolver pista de Comunidad Autónoma, (7) Llegar al destino final.
   - Al completar, mostrar pantalla celebratoria de **GRAN EXPLORADOR** (`#23C450` y `#17257C`) y registrar en `achievements` y `passport`.