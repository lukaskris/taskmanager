import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/domain/usecases/get_tasks_usecase.dart';

import 'get_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;
  late GetTasksUsecase usecase;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTasksUsecase(mockRepository);
  });

  final tasks = [
    TaskEntity(
      id: '1',
      title: 'Task 1',
      description: 'Description',
      status: TaskStatus.toDo,
      userId: 'user1',
    ),
    TaskEntity(
      id: '2',
      title: 'Task 2',
      description: 'Another',
      status: TaskStatus.inProgress,
      userId: 'user1',
    ),
  ];

  group('GetTasksUsecase', () {
    test('should return Right(List<TaskEntity>) when successful', () async {
      // Arrange
      when(mockRepository.getTasks(null)).thenAnswer((_) async => Right(tasks));

      // Act
      final result = await usecase(null);

      // Assert
      expect(result, Right(tasks));
      verify(mockRepository.getTasks(null)).called(1);
    });

    test('should return Left(ServerFailure) when repository fails', () async {
      final failure = ServerFailure('Get failed');
      when(mockRepository.getTasks(null))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(null);

      expect(result, Left(failure));
      verify(mockRepository.getTasks(null)).called(1);
    });
  });
}
