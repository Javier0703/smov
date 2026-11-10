# AGENT SKILLS & REGLAS DE EJECUCIÓN (FIGMA TO FLUTTER)

> **DIRECTIVA DE SISTEMA PARA ARGON (ANTIGRAVITY IDE):**
> Este documento define tus habilidades técnicas (*skills*), heurísticas de traducción visual desde Figma, reglas de rendimiento del motor de Flutter y protocolos de control de calidad. Aplícalas automáticamente en cada iteración.

## SKILL 1: Traducción Exacta de Figma a Árboles de Widgets

Cuando el usuario proporcione capturas de pantalla, exportaciones o especificaciones de **Figma**, ejecuta el siguiente mapeo matemático y estructural:

### 1.1. Motor de Layout: *"Constraints go down. Sizes go up. Parent sets position."*

Respeta siempre la ley fundamental de diseño de Flutter para evitar errores de `RenderFlex overflowed`:

* **Auto Layout Vertical (Figma)** $\rightarrow$ `Column` (si los elementos caben en pantalla) o `ListView` / `CustomScrollView` (si el contenido es dinámico o supera el alto del dispositivo).

* **Auto Layout Horizontal (Figma)** $\rightarrow$ `Row`. Si contiene textos dinámicos (ej. nombre largo de una asignatura o de un alumno), envuelve siempre el `Text` en un `Expanded` o `Flexible` con `overflow: TextOverflow.ellipsis`.

* **Auto Layout Wrap (Figma)** $\rightarrow$ `Wrap` con `spacing` y `runSpacing` vinculados a `AppSpacing`.

* **Auto Layout Gap (Espacio entre hijos)** $\rightarrow$ Usa la propiedad nativa `spacing: AppSpacing.md` en `Column` y `Row` (Flutter 3.27+), o `ListView.separated` con `separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm)`.

* **Resizing en Figma:**

  * *Fixed Width / Height* $\rightarrow$ `SizedBox(width: x, height: y)` (solo para avatares, iconos o miniaturas; nunca para contenedores de pantalla completa).

  * *Hug Contents* $\rightarrow$ `mainAxisSize: MainAxisSize.min` en `Row`/`Column`.

  * *Fill Container* $\rightarrow$ `Expanded` o `width: double.infinity` dentro de restricciones acotadas.

* **Posición Absoluta / Elementos Flotantes (Badges de notificaciones, avatares superpuestos)** $\rightarrow$ `Stack` + `Positioned` o `Align`.

### 1.2. Traducción de Propiedades Visuales (Inspect Panel de Figma)

* **Fill & Stroke** $\rightarrow$ `DecoratedBox` o `Container` con `BoxDecoration(color: ..., border: Border.all(...), borderRadius: BorderRadius.circular(AppRadius.md))`.

* **Drop Shadow (Figma)** $\rightarrow$ `BoxShadow(color: Colors.black.withValues(alpha: opacidad), blurRadius: blur, offset: Offset(x, y), spreadRadius: spread)`.

* **Line Height (Figma)** $\rightarrow$ En Flutter, la propiedad `height` de `TextStyle` es un multiplicador:
  

  $$
  \text{height en Flutter} = \frac{\text{Line Height en Figma (px)}}{\text{Font Size en Figma (px)}}
  $$

## SKILL 2: Composición Modular y Rendimiento de Widgets

1. **Prohibidos los Métodos Helper que devuelven Widgets:**

   * ❌ **Incorrecto:** `Widget _buildHeader() { return Container(...); }`

   * ✅ **Correcto:** Crear una clase independiente `class _HeaderSection extends StatelessWidget { const _HeaderSection(); ... }`. Esto permite a Flutter optimizar el árbol de elementos (`Element Tree`) y evita reconstrucciones innecesarias.

2. **Uso Obligatorio de `const`:**

   * Añade siempre constructores `const` a todos los `StatelessWidget` y a las llamadas de instanciación de widgets estáticos (`const SizedBox(...)`, `const Padding(...)`, `const Icon(...)`).

3. **Listas Eficientes (Lazy Loading):**

   * Para horarios, listados de notas o comunicados, usa siempre constructores perezosos (`ListView.builder`, `ListView.separated`, `GridView.builder` o `SliverList`). Nunca uses `.map().toList()` dentro de un `Column` si la lista puede crecer.

## SKILL 3: Accesibilidad, Usabilidad y Responsividad Escolar

1. **Adaptabilidad de Pantalla y Teclado:**

   * Toda pantalla principal debe envolver su cuerpo en un `SafeArea`.

   * Toda pantalla con campos de texto (`Form`, `TextFormField`) debe permitir scroll (`SingleChildScrollView`) y gestionar el inset del teclado para evitar que el teclado tape los botones de acción.

2. **Áreas Táctiles y Accesibilidad:**

   * Todo botón o icono interactivo debe tener un área mínima de pulsación de $48 \times 48\text{ dp}$.

   * Añade etiquetas `Semantics` o `tooltip` en botones que solo contengan iconos (ej. botón de descargar boletín en PDF o filtrar horario).

3. **Formularios y Validación:**

   * Usa `Form` con `GlobalKey<FormState>()`, `TextInputAction.next` / `TextInputAction.done` para mejorar la navegación por teclado, y validadores limpios extraídos en `lib/core/utils/validators.dart`.

## SKILL 4: Generación de Datos Mock Escolares Realistas (Modo Prototipo Funcional)

Mientras no se conecte la API definitiva del colegio, debes lograr que la aplicación sea **100% navegable, interactiva y visualmente idéntica a Figma** poblando los `Services` con datos Mock realistas del ámbito académico:

* **Asignaturas reales:** *Matemáticas, Lengua Castellana y Literatura, Inglés, Física y Química, Historia, Educación Física*.

* **Horarios coherentes:** Bloques lectivos reales (ej. $08:30 - 09:25$, $09:25 - 10:20$, *Recreo*, etc.) filtrables por día de la semana (Lunes a Viernes).

* **Calificaciones y Evaluaciones:** Notas numéricas ($0.0 - 10.0$), estados cualitativos (*Sobresaliente, Notable, Bien, Suficiente, Insuficiente*), medias por evaluación ($1^{\text{a}}$, $2^{\text{a}}$, $3^{\text{a}}$ Evaluación) y comentarios del profesor tutor.

* **Comunicados y Avisos:** Circulares de dirección, autorizaciones de excursiones, avisos de comedor o solicitud de tutorías con estados de "Leído / No leído".

## SKILL 5: Protocolo de Autoverificación en Antigravity (Quality Gate)

Antes de dar por finalizada cualquier tarea pedida por el usuario en Antigravity, ejecuta mentalmente y por terminal el siguiente *checklist*:

1. **Verificación de Assets en `pubspec.yaml`:** Si has usado una imagen, icono SVG o fuente nueva, verifica que esté declarada correctamente en `pubspec.yaml` respetando la indentación de 2 espacios.

2. **Análisis Estático:** Ejecuta en la terminal integrada:

   ```
   flutter analyze
   
   ```

   *Si aparece algún error o warning (por ejemplo, `unused_import`, `prefer_const_constructors`, o APIs deprecadas como `.withOpacity()` en lugar de `.withValues(alpha: ...)`), corrígelo de inmediato antes de responder al usuario.*

3. **Formateo Estándar:** Ejecuta:

   ```
   dart format lib/
   
   ```

4. **Testing Básico de Widgets:** Mantén actualizado `test/widget_test.dart` para que no falle al eliminar el código por defecto del contador de Flutter.