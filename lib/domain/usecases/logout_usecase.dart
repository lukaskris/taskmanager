import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/core/usecase/usecase.dart';

@injectable
class LogoutUsecase extends NoParamUseCase<void> {
  final SecureStorageService secureStorageService;

  LogoutUsecase(this.secureStorageService);

  @override
  Future<Either<Failure, void>> call() async {
    await secureStorageService.clearAll();
    return Right(null);
  }
}
