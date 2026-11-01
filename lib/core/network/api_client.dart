import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _http;
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  bool _isInitialized = false;
  final List<Completer<dynamic>> _pendingCompleters = [];
  final List<Future<dynamic> Function()> _pendingRequests = [];

  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  // ── Initialization ────────────────────────────────────────────

  /// Initialize the API client and load tokens
  Future<void> init() async {
    if (_isInitialized) return;
    await loadTokens();
    _isInitialized = true;
  }

  // ── Token Management ──────────────────────────────────────────

  /// Load tokens from SharedPreferences
  Future<void> loadTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('access_token');
      _refreshToken = prefs.getString('refresh_token');

      // Reset refresh state when loading tokens
      _isRefreshing = false;
      _isInitialized = true;

      // Clear any pending requests
      _pendingCompleters.clear();
      _pendingRequests.clear();
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Save tokens to SharedPreferences
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Set both tokens (called after login)
  // core/network/api_client.dart

  /// Set both tokens (called after login)
  Future<void> setTokens(String accessToken, String refreshToken) async {
    // Clear any existing state first
    _accessToken = null;
    _refreshToken = null;
    _isRefreshing = false;
    _pendingCompleters.clear();
    _pendingRequests.clear();

    // Save new tokens
    await _saveTokens(accessToken, refreshToken);
    _isInitialized = true;
  }

  /// Update access token (called after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', newAccessToken);
      _accessToken = newAccessToken;
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Clear all tokens (called on logout)
  Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      _accessToken = null;
      _refreshToken = null;
      _isRefreshing = false;
      _isInitialized = false; // Reset initialization state
      _pendingCompleters.clear();
      _pendingRequests.clear();
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Reset the client state (for reinitialization)
  void reset() {
    _accessToken = null;
    _refreshToken = null;
    _isRefreshing = false;
    _isInitialized = false;
    _pendingCompleters.clear();
    _pendingRequests.clear();
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _accessToken != null && _refreshToken != null;

  // ── Headers ────────────────────────────────────────────────────

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  // ── Multipart Headers ─────────────────────────────────────────

  Map<String, String> get _multipartHeaders => {
    'Accept': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  // ── URI Helper ────────────────────────────────────────────────

  Uri _uri(String endpoint) => Uri.parse('${AppConstants.apiBaseUrl}$endpoint');

  // ── HTTP Methods with Auto-Refresh ───────────────────────────

  Future<dynamic> get(String endpoint) async {
    await _ensureInitialized();
    return _sendWithRefresh(() => _http.get(_uri(endpoint), headers: _headers));
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    await _ensureInitialized();
    return _sendWithRefresh(
      () => _http.post(
        _uri(endpoint),
        headers: _headers,
        body: jsonEncode(body ?? {}),
      ),
    );
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    await _ensureInitialized();
    return _sendWithRefresh(
      () => _http.put(
        _uri(endpoint),
        headers: _headers,
        body: jsonEncode(body ?? {}),
      ),
    );
  }

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    await _ensureInitialized();
    return _sendWithRefresh(
      () => _http.patch(
        _uri(endpoint),
        headers: _headers,
        body: jsonEncode(body ?? {}),
      ),
    );
  }

  Future<dynamic> delete(String endpoint) async {
    await _ensureInitialized();
    return _sendWithRefresh(
      () => _http.delete(_uri(endpoint), headers: _headers),
    );
  }

  // ── Multipart/Form-Data Methods ──────────────────────────────

  /// Upload a file with multipart/form-data
  Future<dynamic> uploadFile(
    String endpoint, {
    required String fileField,
    required File file,
    Map<String, String>? fields,
    String? fileName,
    MediaType? contentType,
  }) async {
    await _ensureInitialized();

    final request = http.MultipartRequest('POST', _uri(endpoint));

    // Add headers
    request.headers.addAll(_multipartHeaders);

    // Add text fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add file
    final fileStream = http.ByteStream(file.openRead());
    final length = await file.length();

    final multipartFile = http.MultipartFile(
      fileField,
      fileStream,
      length,
      filename: fileName ?? file.path.split('/').last,
      contentType: contentType ?? _getMediaType(file.path),
    );

    request.files.add(multipartFile);

    return _sendMultipartWithRefresh(request);
  }

  /// Upload multiple files with multipart/form-data
  Future<dynamic> uploadMultipleFiles(
    String endpoint, {
    required List<UploadFile> files,
    Map<String, String>? fields,
  }) async {
    await _ensureInitialized();

    final request = http.MultipartRequest('POST', _uri(endpoint));

    // Add headers
    request.headers.addAll(_multipartHeaders);

    // Add text fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add files
    for (final file in files) {
      final fileStream = http.ByteStream(file.file.openRead());
      final length = await file.file.length();

      final multipartFile = http.MultipartFile(
        file.fieldName,
        fileStream,
        length,
        filename: file.fileName ?? file.file.path.split('/').last,
        contentType: file.contentType ?? _getMediaType(file.file.path),
      );

      request.files.add(multipartFile);
    }

    return _sendMultipartWithRefresh(request);
  }

  // ── Multipart with Auto-Refresh ───────────────────────────────

  Future<dynamic> _sendMultipartWithRefresh(
    http.MultipartRequest request,
  ) async {
    try {
      final res = await _sendMultipartRequest(request);
      return await _handleMultipartResponse(res);
    } on UnauthorizedException {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        // Update the request headers with new token
        request.headers['Authorization'] = 'Bearer $_accessToken';
        final retryRes = await _sendMultipartRequest(request);
        return await _handleMultipartResponse(retryRes);
      } else {
        await clearTokens();
        throw const UnauthorizedException();
      }
    }
  }

  Future<http.StreamedResponse> _sendMultipartRequest(
    http.MultipartRequest request,
  ) async {
    try {
      return await request.send().timeout(
        const Duration(milliseconds: AppConstants.receiveTimeout),
      );
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error');
    } on FormatException {
      throw const AppException('Invalid response format');
    } on TimeoutException {
      throw const AppException('Request timeout');
    } catch (e) {
      throw AppException('Unexpected error occurred');
    }
  }

  // ── Helper to determine media type ───────────────────────────

  MediaType _getMediaType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'svg':
        return MediaType('image', 'svg+xml');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
      case 'docx':
        return MediaType('application', 'msword');
      case 'xls':
      case 'xlsx':
        return MediaType('application', 'vnd.ms-excel');
      case 'zip':
        return MediaType('application', 'zip');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  // ── Ensure Initialized ────────────────────────────────────────

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await loadTokens();
      _isInitialized = true;
    }
  }

  // ── Core Send with Auto-Refresh ──────────────────────────────

  Future<dynamic> _sendWithRefresh(
    Future<http.Response> Function() request,
  ) async {
    try {
      final res = await _sendRequest(request);
      return _handleResponse(res);
    } on UnauthorizedException {
      if (_refreshToken == null) {
        rethrow;
      }

      if (_isRefreshing) {
        return _queueRequest(request);
      }

      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryRes = await _sendRequest(request);
        return _handleResponse(retryRes);
      } else {
        await clearTokens();
        throw const UnauthorizedException();
      }
    }
  }

  // ── Send Request with Timeout ────────────────────────────────

  Future<http.Response> _sendRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(
        const Duration(milliseconds: AppConstants.receiveTimeout),
      );
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error');
    } on FormatException {
      throw const AppException('Invalid response format');
    } on TimeoutException {
      throw const AppException('Request timeout');
    } catch (e) {
      throw AppException('Unexpected error occurred');
    }
  }

  // ── Queue Request while Refreshing ───────────────────────────

  Future<dynamic> _queueRequest(Future<http.Response> Function() request) {
    final completer = Completer<dynamic>();
    _pendingRequests.add(() async {
      final res = await _sendRequest(request);
      return _handleResponse(res);
    });
    _pendingCompleters.add(completer);
    return completer.future;
  }

  // ── Auto-Refresh Token ───────────────────────────────────────

  /// Refresh the access token using the refresh token
  Future<bool> _refreshAccessToken() async {
    if (_isRefreshing) return false;

    _isRefreshing = true;

    try {
      if (_refreshToken == null || _refreshToken!.isEmpty) {
        return false;
      }

      final refreshHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final refreshBody = {
        'refreshToken': _refreshToken,
        'refresh_token': _refreshToken,
      };

      final response = await _http
          .post(
            Uri.parse('${AppConstants.apiBaseUrl}/auth/refresh'),
            headers: refreshHeaders,
            body: jsonEncode(refreshBody),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        String? newAccessToken;
        String? newRefreshToken;

        if (body is Map<String, dynamic>) {
          newAccessToken =
              body['accessToken'] ??
              body['access_token'] ??
              body['data']?['accessToken'] ??
              body['data']?['access_token'] ??
              body['token'] ??
              body['data']?['token'];

          newRefreshToken =
              body['refreshToken'] ??
              body['refresh_token'] ??
              body['data']?['refreshToken'] ??
              body['data']?['refresh_token'];
        }

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _saveTokens(newAccessToken, newRefreshToken);
          } else {
            await updateAccessToken(newAccessToken);
          }

          // Process pending requests with new token
          _processPendingRequests();
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 401) {
        await clearTokens();
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ── Process Pending Requests ──────────────────────────────────

  void _processPendingRequests() {
    if (_pendingRequests.isEmpty) return;
    for (int i = 0; i < _pendingRequests.length; i++) {
      final request = _pendingRequests[i];
      final completer = _pendingCompleters[i];

      request()
          .then((result) {
            if (!completer.isCompleted) {
              completer.complete(result);
            }
          })
          .catchError((error) {
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
          });
    }
    _pendingRequests.clear();
    _pendingCompleters.clear();
  }

  // ── Direct Refresh Method (for manual refresh) ───────────────

  /// Manually refresh the access token - returns new access token or null
  Future<String?> refreshTokenManually() async {
    final success = await _refreshAccessToken();
    return success ? _accessToken : null;
  }

  // ── Response Handler ─────────────────────────────────────────

  dynamic _handleResponse(http.Response res) {
    if (res.body.isEmpty) return null;

    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (_) {
      throw const AppException('Invalid JSON response');
    }

    switch (res.statusCode) {
      case 200:
      case 201:
      case 204:
        return body;
      case 400:
        final msg = body is Map ? body['message'] ?? 'Bad request' : res.body;
        throw AppException(msg.toString(), res.statusCode);
      case 401:
        throw const UnauthorizedException();
      case 403:
        final msg = body is Map ? body['message'] ?? 'Forbidden' : res.body;
        throw AppException(msg.toString(), res.statusCode);
      case 404:
        throw const NotFoundException();
      case 422:
        final msg = body is Map
            ? body['message'] ?? 'Validation error'
            : res.body;
        throw AppException(msg.toString(), res.statusCode);
      case >= 500:
        throw ServerException('Server error', res.statusCode);
      default:
        final msg = body is Map ? body['message'] ?? res.body : res.body;
        throw AppException(msg.toString(), res.statusCode);
    }
  }

  // ── Handle Multipart Response ────────────────────────────────

  Future<dynamic> _handleMultipartResponse(http.StreamedResponse res) async {
    final body = await res.stream.bytesToString();

    if (body.isEmpty) return null;

    dynamic parsedBody;
    try {
      parsedBody = jsonDecode(body);
    } catch (_) {
      throw const AppException('Invalid JSON response');
    }

    switch (res.statusCode) {
      case 200:
      case 201:
      case 204:
        return parsedBody;
      case 400:
        final msg = parsedBody is Map
            ? parsedBody['message'] ?? 'Bad request'
            : body;
        throw AppException(msg.toString(), res.statusCode);
      case 401:
        throw const UnauthorizedException();
      case 403:
        final msg = parsedBody is Map
            ? parsedBody['message'] ?? 'Forbidden'
            : body;
        throw AppException(msg.toString(), res.statusCode);
      case 404:
        throw const NotFoundException();
      case 422:
        final msg = parsedBody is Map
            ? parsedBody['message'] ?? 'Validation error'
            : body;
        throw AppException(msg.toString(), res.statusCode);
      case >= 500:
        throw ServerException('Server error', res.statusCode);
      default:
        final msg = parsedBody is Map ? parsedBody['message'] ?? body : body;
        throw AppException(msg.toString(), res.statusCode);
    }
  }

  // ── Legacy Method ──────────────────────────────────────────────

  @Deprecated('Use setTokens() instead')
  void setAuthToken(String token) {
    _accessToken = token;
  }

  void dispose() {
    _http.close();
    _pendingCompleters.clear();
    _pendingRequests.clear();
  }
}

// ── Helper Classes ──────────────────────────────────────────────

/// Class for uploading multiple files
class UploadFile {
  final String fieldName;
  final File file;
  final String? fileName;
  final MediaType? contentType;

  UploadFile({
    required this.fieldName,
    required this.file,
    this.fileName,
    this.contentType,
  });
}
