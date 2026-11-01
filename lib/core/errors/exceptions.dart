class AppException implements Exception {
  final String message;
  final int?   statusCode;
  const AppException(this.message, [this.statusCode]);
  @override String toString() => 'AppException($statusCode): $message';
}

class NetworkException    extends AppException { const NetworkException([super.message = 'No internet connection']); }
class ServerException     extends AppException { const ServerException([super.message  = 'Server error', super.statusCode]); }
class UnauthorizedException extends AppException { const UnauthorizedException() : super('Unauthorized', 401); }
class NotFoundException   extends AppException { const NotFoundException()   : super('Not found', 404); }
class TimeoutException    extends AppException { const TimeoutException()    : super('Request timeout'); }
class CacheException      extends AppException { const CacheException([super.message = 'Cache error']); }