/// Roles de usuario soportados en la aplicación escolar colaborativa.
enum RoleEnum {
  estudiante('Alumnado'),
  docente('Docente'),
  student('Alumnado'),
  teacher('Docente');

  final String label;
  const RoleEnum(this.label);
}

/// Estado visual estandarizado para todos los ViewModels (ARQUITECTURA.md §5.1).
enum UiViewState { loading, loaded, empty, error }
