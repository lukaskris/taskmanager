import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/core/usecase/usecase.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';

import '../repositories/task_repository.dart';

@injectable
class GetTasksUsecase extends UseCase<List<TaskEntity>, TaskStatus?> {
  final TaskRepository repository;

  GetTasksUsecase(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(TaskStatus? params) {
    return repository.getTasks(params);
  }
}
