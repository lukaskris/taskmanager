import 'package:dartz/dartz.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/models/task_model.dart';

import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(TaskStatus? status);
  Future<Either<Failure, void>> addTask(TaskEntity task);
  Future<Either<Failure, void>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, void>> syncTasks();
  Future<void> syncPendingTasks();
}
