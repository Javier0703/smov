# Prompt 04: Minijuegos de Lectura y Construcción de Mapas (Juegos 3, 4, 5 y 6)

## Instrucción rápida para pegar en Copilot:
> Confirma la estructura real en `lib/features/adventures/` y `lib/features/gameplay/`, además de los assets en `assets/icons/` e `info/img/`. Lee `info/doc/requisitos_profesoras.md` y `info/doc/resumen_prototipo_ui.md` e implementa los juegos 3, 4, 5 y 6.

## Especificaciones Técnicas:
1. **Juego 3: ¡Encuentra el lugar!**:
   - N1: mapa muy visual con pocos elementos. N2: más elementos y preguntas de posición relativa (*"¿Qué hay al sur del parque?"*).
   - N3: incluir componente visual de **Leyenda** y **Escala sencilla** que el niño deba interpretar para responder.
2. **Juego 4: Misión: llegar a tiempo**:
   - Temporizador visible (`02:00`) para llevar al avatar del colegio al polideportivo interpretando calles, ríos, puentes y parques.
   - En niveles altos, activar restricciones dinámicas (*"Paso prohibido en el parque. Busca una ruta alternativa"*).
3. **Juego 5: El tesoro secreto**:
   - Mapa con marca `X` y pistas secuenciales encadenadas por puntos cardinales. Al completarlo, otorga **Brújulas**, medallas o piezas de mapa para desbloquear nuevos mundos.
4. **Juego 6: Construye el mapa**:
   - Interacción `Draggable` / `DragTarget` para colocar elementos (colegio, árbol, hospital, parque, casas) siguiendo instrucciones (*"Coloca el parque al norte del colegio"*). En niveles altos, proporcionar solo una leyenda para construir el plano completo.