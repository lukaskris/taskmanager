import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/core/usecase/usecase.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';

import '../repositories/task_repository.dart';

@injectable
class DeleteTaskUsecase extends UseCase<void, TaskEntity> {
  final TaskRepository repository;

  DeleteTaskUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(TaskEntity params) {
    return repository.deleteTask(params.id);
  }
}
