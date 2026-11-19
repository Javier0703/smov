# Prompt 03: Minijuegos de Orientación Espacial (Juegos 1, 2 y 7)

## Instrucción rápida para pegar en Copilot:
> Confirma la estructura real en `lib/features/adventures/`, `lib/features/gameplay/`, `lib/core/router/app_router.dart` (`play/:sessionId`, `games/:gameId/levels`) y los iconos en `assets/icons/` e `info/img/`. Lee `info/doc/requisitos_profesoras.md` e `info/doc/ideas_post_cocreacion.md` e implementa los juegos 1, 2 y 7.

## Especificaciones Técnicas:
1. **Reglas Transversales**:
   - Hablar siempre de **"casillas"** en desplazamientos sobre cuadrícula (nunca "pasos").
   - Mantener separación estricta entre `data/` (lógica de cuadrícula, pistas y validación) y `presentation/` (widgets UI).
   - Usar fondos temáticos ilustrados (nunca blanco plano) y mostrar una pantalla/modal inicial explicando cómo se juega antes de empezar.
2. **Juego 1: ¡Rumbo desconocido!**:
   - Escenarios (colegio, parque, bosque, ciudad). N1: N, S, E, O sencillos; N2: combinaciones; N3: diagonales (NE, NO, SE, SO) + obstáculos.
   - **Error divertido**: Si el alumno se equivoca de casilla destino, mostrar animación humorística donde el avatar acaba en una charca o en el tejado del colegio.
3. **Juego 2: La brújula perdida**:
   - Brújula virtual con aguja bicolor en **rojo (Norte) y blanco (Sur)**.
   - Pistas relativas (*"El tesoro está al ESTE del árbol"*). En niveles superiores, permitir girar la brújula dentro del juego para fijar el rumbo.
4. **Juego 7: ¿Dónde estoy?**:
   - Explicar claramente en la pantalla inicial el funcionamiento del **sistema de 3 pistas**.
   - Icono de ubicación con punto central marcado (que no parezca una gota). El alumno deduce la posición exacta cruzando 3 pistas espaciales.