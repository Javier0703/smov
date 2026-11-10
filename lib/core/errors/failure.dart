/// Representación inmutable de un fallo en la capa de repositorio/presentación.
class Failure {
  final String message;
  final String code;

  const Failure({required this.message, this.code = 'UNKNOWN_FAILURE'});
}

/// Fallo de validación de reglas de negocio o formularios.
class ValidationFailure extends Failure {
  const ValidationFailure(String message)
    : super(message: message, code: 'VALIDATION_FAILURE');
}

/// Fallo de lectura o escritura en caché/almacenamiento local.
class CacheFailure extends Failure {
  const CacheFailure(String message)
    : super(message: message, code: 'CACHE_FAILURE');
}

/// Fallo de autenticación o permisos de rol escolar.
class AuthFailure extends Failure {
  const AuthFailure(String message)
    : super(message: message, code: 'AUTH_FAILURE');
}
