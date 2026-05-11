class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return "ApiException [$statusCode]: $message";
    }
    return "ApiException: $message";
  }
}

class NetworkException extends ApiException {
  NetworkException(super.message, {super.statusCode});
}

class AuthException extends ApiException {
  AuthException(super.message, {super.statusCode});
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.statusCode});
}
