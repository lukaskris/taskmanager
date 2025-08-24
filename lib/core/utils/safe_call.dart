import 'package:dartz/dartz.dart';
import 'package:taskmanager/core/error/error_handler.dart';
import 'package:taskmanager/core/error/failure.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on Exception catch (exception) {
    return Left(ErrorHandler.handle(exception));
  }
}
