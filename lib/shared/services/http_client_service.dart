/// Cliente HTTP simulado compartido para peticiones de sincronización con el servidor escolar.
class HttpClientService {
  bool isOnline = true;

  Future<Map<String, dynamic>> getJson(String endpoint) async {
    return <String, dynamic>{'endpoint': endpoint, 'status': 200};
  }

  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    return <String, dynamic>{
      'endpoint': endpoint,
      'status': isOnline ? 200 : 202,
      'synced': isOnline,
      'payload': payload,
    };
  }
}
