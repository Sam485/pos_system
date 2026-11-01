import '../network/api_client.dart';

class ServiceLocator {
  ServiceLocator._();

  static ApiClient? _apiClient;
  static ApiClient get apiClient {
    if (_apiClient == null) {
      throw StateError('ServiceLocator not initialized. Call setup() first.');
    }
    return _apiClient!;
  }

  static void setup() {
    _apiClient = ApiClient();
  }

  /// Reinitialize the ApiClient with fresh instance (use after logout/login)
  static void reinitialize() {
    // Dispose old client if exists
    _apiClient?.dispose();
    // Create new fresh client
    _apiClient = ApiClient();
  }

  static void setToken(String token) => apiClient.setAuthToken(token);
  static Future<void> clearToken() async => await apiClient.clearTokens();
  static void dispose() {
    _apiClient?.dispose();
    _apiClient = null;
  }
}
