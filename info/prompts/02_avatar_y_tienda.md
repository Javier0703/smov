# Prompt 02: Personalización de Avatar (`lib/features/avatar/`) y Tienda (`lib/features/inventory/`)

## Instrucción rápida para pegar en Copilot:
> Confirma la estructura real en `lib/features/avatar/`, `lib/features/inventory/` y los assets disponibles en `assets/icons/` e `info/img/`. Lee `info/doc/cambios_09_11_mapas.md` e `info/doc/ideas_post_cocreacion.md` e implementa las mejoras de avatar y tienda descritas aquí.

## Especificaciones Técnicas:
1. **Personalización por Capas (`lib/features/avatar/`)**:
   - Permite editar el **nombre del explorador** y personalizar género, rasgos faciales, tono de piel, peinado y ropa mediante capas (`Stack`) usando los recursos gráficos existentes o SVGs configurables.
   - **Uniforme escolar obligatorio**: Incluye opciones de **chándal del colegio**, **sudadera roja** y **camiseta de manga corta** (sin mangas largas).
2. **Edición Directa**:
   - Permite acceder directamente a `/avatar` (o abrir edición rápida) pulsando sobre el avatar del alumno en `/home` o `/passport`.
3. **Tienda y Canje (`lib/features/inventory/`)**:
   - Conecta `/inventory` con el saldo de **Brújulas** y las medallas de `lib/features/achievements/` para comprar ropa nueva, accesorios o avatares especiales.
   - Respeta la fuente **Nunito**, la paleta `#17257C`, `#19D88D`, `#29E1B4`, `#AFC6DD`, `#23C450` y la vista en Tablet.