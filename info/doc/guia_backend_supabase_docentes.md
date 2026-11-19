# Guía de backend Supabase para el Espacio Docente

## Objetivo y alcance

Esta guía orienta la implementación de un backend Supabase para que el personal
docente autenticado consulte la actividad del alumnado de sus propias clases.
El alcance inicial es de **solo lectura para el docente**: listado de alumnos,
resumen del grupo, ficha individual y sesiones recientes. No pretende sustituir
la revisión de privacidad y protección de datos del centro.

La app es Flutter y su estructura efectiva sigue el patrón
`Service → Repository → ViewModel → Screen`. La base actual es local/de
demostración: Supabase aún no está en `pubspec.yaml` ni inicializado.

## Estado actual que afecta a la integración

- `TeacherService` obtiene datos de `ExpeditionStateStore`; contiene un roster
  fijo de cinco alumnos y sesiones de ejemplo.
- `TeacherRepository` calcula aciertos ponderados a partir de las sesiones, pero
  la ficha seleccionada hace fallback al primer alumno si no encuentra el ID.
- La pantalla de actividad docente presenta resumen de clase, alumnos,
  medallas, sellos, monedas y fortalezas.
- `averageRouteProgressPercent`, fortalezas, áreas de refuerzo, medallas,
  sellos y parte de las monedas hoy son valores fijos o derivan del estado de
  demostración. No deben persistirse como métricas reales sin acordar su
  definición y fuente de verdad.
- El acceso de bienvenida permite elegir un rol; eso es solo un flujo de
  prototipo, **no autenticación ni autorización**.
- Los IDs de clase visibles (`4A`, `4.º A`) son identificadores de interfaz.
  En Supabase, usar UUIDs y cargar las clases autorizadas desde membresías.

Referencias de implementación: [TeacherService](../../lib/features/teacher/data/services/teacher_service.dart),
[TeacherRepository](../../lib/features/teacher/data/repositories/teacher_repository.dart),
[TeacherViewModel](../../lib/features/teacher/presentation/viewmodels/teacher_viewmodel.dart),
[ExpeditionStateStore](../../lib/shared/services/expedition_state_store.dart),
[TeacherClassActivityScreen](../../lib/features/teacher/presentation/screens/teacher_class_activity_screen.dart)
y [AppDependencies](../../lib/core/di/app_dependencies.dart).

## Arquitectura recomendada

1. **Supabase Auth** identifica al usuario; su UUID (`auth.uid()`) es la
   identidad. No confiar en un `role`, `studentId` o `classId` enviados por la
   app como prueba de permisos.
2. **Postgres** es la fuente de verdad de perfiles mínimos, clases,
   asignaciones de clase y sesiones de juego.
3. **RLS (Row Level Security)** restringe cada fila. La aplicación no debe
   descargar toda la base para filtrar los alumnos localmente.
4. En Flutter, el servicio de datos habla con Supabase; el repositorio adapta
   filas/DTOs a modelos de dominio y calcula los agregados pedagógicos; el
   ViewModel comunica carga, éxito, vacío y error a la interfaz.
5. Para informes grandes, usar una vista segura o una función RPC de lectura
   que respete RLS; no dar permisos de escritura al docente sobre sesiones.

Dependencia orientativa: `supabase_flutter`. Inicializar Supabase una vez antes
de `runApp` y proveer el cliente mediante la composición de dependencias en
`AppDependencies`, siguiendo el ciclo de vida de la app.

### Configuración del cliente

- Leer `SUPABASE_URL` y `SUPABASE_ANON_KEY` de configuración de build, por
  ejemplo `--dart-define`. No escribirlos en el código ni en un archivo
  versionado de secretos.
- La clave `anon`/publishable está diseñada para estar en el cliente **solo
  junto con Auth y RLS correctamente configurados**; no es una autorización.
- **Nunca** distribuir `service_role`, claves secretas ni credenciales de base
  de datos en Flutter, APKs, repositorio o CI de cliente. La clave de servicio
  omite RLS.
- Los errores de red, sesión vencida y permisos deben reflejarse como errores
  visibles/reintentables; no reemplazarlos por roster de ejemplo ni por una
  ficha de otro alumno.

## Modelo de datos inicial

Usar UUIDs y guardar únicamente los campos necesarios para el seguimiento
educativo. Un modelo inicial puede contener:

| Tabla | Campos principales | Uso |
| --- | --- | --- |
| `profiles` | `id` (igual a `auth.users.id`), `display_name`, `role`, `created_at` | Identidad mínima y rol provisionado. |
| `school_classes` | `id`, `name`, `school_year`, `active` | Aulas/grupos. |
| `class_memberships` | `class_id`, `user_id`, `member_role`, `active` | Relaciona docentes y alumnos con sus clases. |
| `game_sessions` | `id`, `client_session_id`, `student_id`, `class_id`, `game_id`, `level`, `correct_answers`, `total_attempts`, `duration_seconds`, `completed_at` | Registro mínimo para los informes de actividad. |

Añadir a `game_sessions` una restricción única para la idempotencia, por ejemplo
`unique (student_id, client_session_id)`. Validar en base de datos que nivel,
aciertos, intentos y duración no sean negativos, y que
`correct_answers <= total_attempts`. Conservar `completed_at` como
`timestamptz` UTC; convertirlo a hora local solo al presentarlo.

La membresía debe tener una restricción única `(class_id, user_id)`. Si se
necesita guardar progreso detallado (medallas, sellos, inventario o monedas),
definirlo en una fase posterior. Para monedas y recompensas, preferir un libro
de movimientos append-only o una RPC transaccional; no aceptar del cliente el
saldo final o la cantidad de monedas ganadas como dato confiable.

No persistir las respuestas completas, datos de contacto, fecha de nacimiento,
ubicación ni texto libre del menor salvo necesidad educativa aprobada. Para la
primera pantalla docente bastan un nombre de pila o alias autorizado por el
centro y métricas de juego.

## Autenticación, alta y autorización

- **Docentes:** cuentas invitadas/provisionadas por el centro; la app no debe
  permitir que cualquiera elija “docente” desde la pantalla de bienvenida.
- **Alumnado:** asignar identidades y membresías de forma controlada (por
  ejemplo desde herramientas administrativas del centro o una Edge Function
  autenticada). Un código de aula, si se usa, debe ser de un solo uso,
  expirar y canjearse del lado servidor. No convertirlo en acceso permanente a
  los datos de toda la clase.
- El perfil y el rol se establecen mediante un flujo de confianza. No aceptar
  `role=teacher` en `user_metadata` editable por el propio usuario ni exponer
  una operación cliente para cambiar roles o asignarse clases.
- El docente solo puede consultar clases con membresía activa de docente; el
  alumno solo sus propias filas. Denegar por defecto.
- Proteger también rutas y acciones en la app para UX, pero considerar RLS la
  barrera de seguridad efectiva.

### RLS: patrón que debe probarse

Activar RLS en **todas** las tablas expuestas por la API (incluidas las nuevas)
y crear políticas explícitas para cada operación. La política no debe confiar
en un filtro del cliente como `.eq('class_id', ...)`.

El patrón de las consultas de lectura es:

```sql
-- Esquema ilustrativo: adaptar nombres y roles al esquema final.
-- La función se ejecuta con privilegios controlados para evitar recursión
-- cuando una política consulta class_memberships.
create or replace function public.is_teacher_of_class(target_class_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.class_memberships m
    where m.class_id = target_class_id
      and m.user_id = (select auth.uid())
      and m.member_role = 'teacher'
      and m.active
  );
$$;

revoke all on function public.is_teacher_of_class(uuid) from public;
grant execute on function public.is_teacher_of_class(uuid) to authenticated;

alter table public.game_sessions enable row level security;

create policy "teacher reads sessions in assigned classes"
on public.game_sessions
for select to authenticated
using (public.is_teacher_of_class(class_id));
```

La función `SECURITY DEFINER` es un ejemplo sensible: propiedad de un rol
administrativo confiable, nombres de tabla/esquema calificados, `search_path`
fijo y permisos de ejecución mínimos. No otorgarle escritura ni usarla para
devolver filas. Crear funciones equivalentes y pruebas para:

- lectura del alumno de sus propios datos;
- lectura por docente de perfiles/membresías de alumnos de su clase;
- lectura de la lista de clases solo si existe membresía activa;
- operaciones administrativas de alta/cambio de roles, no ejecutables por
  usuarios ordinarios.

Para sesiones, el docente necesita **solo `SELECT`**. Si la app va a insertar
sesiones del alumno, crear una política `INSERT` cuyo `WITH CHECK` exija que
`student_id = auth.uid()` y que ese usuario tenga membresía activa de alumno
en el `class_id` de la fila. No permitir que el alumno cambie
`student_id`, `class_id`, fecha o recompensa mediante `UPDATE`. Si se requiere
actualizar/cerrar sesiones, preferir una RPC transaccional con validación e
idempotencia. No habilitar `UPDATE`/`DELETE` por conveniencia.

**Antes del despliegue:** probar con dos docentes de clases distintas, dos
alumnos y una sesión sin membresía. Desde el cliente autenticado, intentar
consultar, insertar, cambiar y borrar filas ajenas. Verificar que todas las
operaciones no autorizadas devuelven cero filas o error de permisos y que no
hay una ruta mediante vistas/RPC que evada RLS.

## Contrato de lectura del Espacio Docente

Las pantallas actuales requieren estos resultados:

### Actividad del aula

Consultar la clase autorizada y sus membresías activas de alumno; obtener perfil
mínimo y sesiones del aula. Para cada alumno, sumar `correct_answers` e
`total_attempts`; el porcentaje ponderado es:

```text
100 * suma(correct_answers) / suma(total_attempts)
```

Si no hay intentos, mostrar “Sin datos” (no `0 %` como si se hubiese evaluado).
El porcentaje de clase se calcula de la misma forma sobre todos los intentos,
no como media simple de los porcentajes individuales. Definir explícitamente
qué significa “activo”, “reto completado” y “avance de ruta” antes de publicar
esos KPIs.

### Ficha del alumno

Leer por `student_id` **y** clase autorizada; devolver perfil mínimo, sesiones
recientes ordenadas por `completed_at desc` y agregados. Si el alumno no
pertenece a la clase o no existe, devolver estado vacío/no encontrado; nunca
seleccionar el primer registro como fallback.

### No convertir inferencias de demo en datos

Fortalezas y áreas de refuerzo hoy son cadenas fijas por personaje, y el
progreso promedio de ruta también está fijado. O bien implementar y documentar
una regla pedagógica explicable basada en sesiones reales, o bien ocultar esos
campos hasta que exista una fuente fiable. Mostrar al docente cuándo faltan
datos. Las métricas se usan como apoyo pedagógico, no como diagnóstico
automático del niño.

## Integración propuesta en Flutter

1. Incorporar el cliente Supabase y configuración de entorno; inicializarlo
   antes de crear `AppDependencies`.
2. Sustituir `AuthService.signInWithRole` por autenticación real y cargar el
   perfil/membresías de la identidad autenticada. El rol visible debe venir del
   perfil provisionado y no del selector de bienvenida.
3. Crear un servicio de datos del docente (o adaptar `TeacherService`) que
   consulte memberships, perfiles y sesiones con filtros/paginación. Mantener
   Supabase fuera de las pantallas y del ViewModel.
4. Adaptar `TeacherRepository` para convertir la respuesta en los modelos
   existentes `ClassActivityDashboardModel` y `StudentRosterSummary`, o ajustar
   esos modelos si el contrato real lo exige. No introducir modelos JSON de
   Supabase directamente en la UI.
5. Hacer asíncronas las cargas de `TeacherViewModel` y exponer estados
   explícitos de carga/error/vacío. Al cambiar de clase o alumno, limpiar el
   dato anterior mientras carga para no mostrar temporalmente datos de otro
   contexto.
6. Eliminar roster/sesiones seed del camino de producción. Mantener fixtures
   solo en pruebas o en un modo demo claramente aislado.
7. Añadir límites y orden estable a sesiones recientes, y refrescar el informe
   tras iniciar sesión/volver a la pantalla. No descargar el historial completo
   si solo se muestran las últimas sesiones.
8. Reemplazar `4A` y `4.º A` en enlaces de backend por el UUID real de clase;
   conservar el nombre legible como etiqueta de presentación.

## Migraciones y despliegue

- Mantener cambios de esquema como migraciones versionadas de Supabase CLI en
  el repositorio, no como modificaciones manuales irreproducibles del panel.
- Desarrollar y probar primero en un proyecto local/staging con datos sintéticos.
- Revisar cada migración: constraints, índices sobre `class_id`, `student_id` y
  `completed_at`, RLS activada, grants mínimos y rollback razonable.
- No copiar los alumnos ni sesiones de demostración al proyecto productivo.
- Separar configuración/credenciales de desarrollo, staging y producción;
  restringir acceso al dashboard de Supabase y activar backups/retención
  acordados con el centro.
- Añadir pruebas de repositorio (mapeo, agregados, lista vacía y errores) y
  pruebas de integración de RLS con identidades distintas.

## Protección de datos de menores

Antes de cargar datos reales, acordar con el centro quién determina fines y
medios, quién presta el servicio, base jurídica, información a familias,
retención, atención de derechos, procedimiento de brechas y eliminación al
finalizar la relación. Confirmar con el responsable de protección de datos del
centro los requisitos aplicables (incluidos RGPD y LOPDGDD); esta guía técnica
no es asesoramiento legal.

Aplicar minimización, control de acceso por clase, transporte cifrado, acceso
administrativo restringido y registros de auditoría apropiados. Usar cuentas
ficticias durante desarrollo. No registrar nombres, tokens, respuestas de
menores ni payloads sensibles en logs. Definir una política de retención y
borrado verificable antes de producción.

## Criterios de aceptación para la primera entrega

- Una persona sin sesión no ve actividad de clase.
- Un docente ve solo sus clases y alumnos asignados; no puede leer otra clase
  cambiando UUIDs, rutas o filtros.
- Un alumno no puede leer la actividad de compañeros ni atribuirse sesiones de
  otro usuario.
- Las cargas manejan explícitamente loading, error, vacío y alumno no
  encontrado; sin datos demo como fallback.
- Los porcentajes de clase/alumno son ponderados desde sesiones reales y los
  casos sin intentos se muestran como “Sin datos”.
- No hay `service_role` ni secreto de base de datos en el cliente, build o
  repositorio.
- Las políticas RLS se prueban con más de una clase/identidad y las migraciones
  están versionadas.
