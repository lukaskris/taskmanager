// core/error/error_handler.dart
import 'package:flutter/foundation.dart';

import 'failure.dart';

class ErrorHandler {
  static Failure handle(Exception exception) {
    if (kDebugMode) return Failure(exception.toString());
    if (exception is NetworkException) {
      return const NetworkFailure("No Internet Connection");
    } else if (exception is ServerException) {
      return ServerFailure("Server Error: ${exception.message}");
    } else if (exception is CacheException) {
      return const CacheFailure("Failed to load data from cache");
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }
    // Return a default failure instead of the abstract `Failure` class
    return const UnknownFailure("Unexpected error occurred");
  }
}

// Example Exceptions
class NetworkException implements Exception {}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
