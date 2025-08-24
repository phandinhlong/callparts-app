import 'app_exception.dart';

class NetworkException extends AppException {
  final int? statusCode;
  final String? url;

  const NetworkException(
    String message, {
    super.code,
    super.details,
    this.statusCode,
    this.url,
  });

  factory NetworkException.fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return const NetworkException('Bad Request', code: '400');
      case 401:
        return const NetworkException('Unauthorized', code: '401');
      case 403:
        return const NetworkException('Forbidden', code: '403');
      case 404:
        return const NetworkException('Not Found', code: '404');
      case 500:
        return const NetworkException('Internal Server Error', code: '500');
      case 502:
        return const NetworkException('Bad Gateway', code: '502');
      case 503:
        return const NetworkException('Service Unavailable', code: '503');
      default:
        return NetworkException(
          message ?? 'Network Error',
          code: statusCode.toString(),
        );
    }
  }

  factory NetworkException.connectionError() {
    return const NetworkException(
      'No internet connection',
      code: 'CONNECTION_ERROR',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      'Request timeout',
      code: 'TIMEOUT',
    );
  }
}
