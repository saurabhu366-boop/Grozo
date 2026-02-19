class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status code: $statusCode)';
    }
    return 'ApiException: $message';
  }

  // Factory constructors for common error scenarios
  factory ApiException.serverError() {
    return ApiException(
      message: 'Server error. Please try again later.',
      statusCode: 500,
    );
  }

  factory ApiException.networkError() {
    return ApiException(
      message: 'Network error. Please check your internet connection.',
    );
  }

  factory ApiException.notFound() {
    return ApiException(
      message: 'Resource not found.',
      statusCode: 404,
    );
  }

  factory ApiException.unauthorized() {
    return ApiException(
      message: 'Unauthorized access.',
      statusCode: 401,
    );
  }

  factory ApiException.badRequest(String message) {
    return ApiException(
      message: message,
      statusCode: 400,
    );
  }

  factory ApiException.timeout() {
    return ApiException(
      message: 'Request timeout. Please try again.',
    );
  }
}