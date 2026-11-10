/// Servicio compartido de almacenamiento local en memoria con claves idempotentes
/// para garantizar persistencia durante toda la sesión y pruebas de integración.
class LocalStorageService {
  final Map<String, Object?> _store = <String, Object?>{};
  final Set<String> _idempotencyKeys = <String>{};

  T? read<T>(String key) {
    final value = _store[key];
    if (value is T) return value;
    return null;
  }

  void write<T>(String key, T value) {
    _store[key] = value;
  }

  /// Registra una clave idempotente (ej. completion:student/game/level o redeem:requestId).
  /// Devuelve true si es la primera vez que se registra; false si ya fue procesada.
  bool registerIdempotentOperation(String idempotencyKey) {
    if (_idempotencyKeys.contains(idempotencyKey)) {
      return false;
    }
    _idempotencyKeys.add(idempotencyKey);
    return true;
  }

  bool hasProcessedKey(String idempotencyKey) =>
      _idempotencyKeys.contains(idempotencyKey);

  bool isKeyProcessed(String idempotencyKey) =>
      _idempotencyKeys.contains(idempotencyKey);

  Future<void> markKeyProcessed(String idempotencyKey) async {
    _idempotencyKeys.add(idempotencyKey);
  }
}
