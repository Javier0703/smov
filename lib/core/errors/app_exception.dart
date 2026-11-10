/// Excepciones tipadas de la capa de datos y dominio.
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException(${code ?? 'GENERIC'}): $message';
}

class ValidationException extends AppException {
  const ValidationException(super.message) : super(code: 'VALIDATION_ERROR');
}

class InsufficientBalanceException extends AppException {
  const InsufficientBalanceException(super.message)
    : super(code: 'INSUFFICIENT_BALANCE');
}

class PolicyLockedException extends AppException {
  const PolicyLockedException(super.message) : super(code: 'POLICY_LOCKED');
}
