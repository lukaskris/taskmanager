import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/domain/usecases/delete_task_usecase.dart';

import 'delete_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;
  late DeleteTaskUsecase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = DeleteTaskUsecase(mockRepository);
  });

  var task = TaskEntity(
    id: '1',
    title: 'Task to delete',
    description: 'desc',
    status: TaskStatus.toDo,
    userId: 'user1',
  );

  group('DeleteTaskUsecase', () {
    test('should return Right(null) when deletion is successful', () async {
      when(mockRepository.deleteTask(task.id))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(task);

      expect(result, const Right(null));
      verify(mockRepository.deleteTask(task.id)).called(1);
    });

    test('should return Left(ServerFailure) on error', () async {
      final failure = ServerFailure('Failed to delete task');
      when(mockRepository.deleteTask(task.id))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(task);

      expect(result, Left(failure));
      verify(mockRepository.deleteTask(task.id)).called(1);
    });
  });
}
