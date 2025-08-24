import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/data/datasources/local/task_local_data_source.dart';
import 'package:taskmanager/data/models/task_model.dart';

import 'task_local_data_source_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late TaskLocalDataSource dataSource;
  late MockHiveInterface mockHive;
  late MockBox<TaskModel> mockTaskBox;
  late MockBox<List<String>> mockDeletedBox;

  const taskBoxName = TaskLocalDataSource.boxName;
  const deletedBoxName = TaskLocalDataSource.deletedBoxName;

  final task1 = TaskModel(
    id: '1',
    title: 'Task 1',
    description: 'desc',
    status: TaskStatus.toDo,
    userId: 'user1',
    pendingSync: false,
  );

  final task2 = TaskModel(
    id: '2',
    title: 'Task 2',
    description: 'desc',
    status: TaskStatus.done,
    userId: 'user1',
    pendingSync: true,
  );

  setUp(() {
    mockHive = MockHiveInterface();
    mockTaskBox = MockBox<TaskModel>();
    mockDeletedBox = MockBox<List<String>>();
    dataSource = TaskLocalDataSource(hive: mockHive);
  });

  group('cacheTasks', () {
    test('should clear box and cache tasks', () async {
      when(mockHive.openBox<TaskModel>(taskBoxName))
          .thenAnswer((_) async => mockTaskBox);
      when(mockTaskBox.clear()).thenAnswer((_) async => 0);
      when(mockTaskBox.put(any, any)).thenAnswer((_) async => {});

      await dataSource.cacheTasks([task1, task2]);

      verify(mockTaskBox.clear()).called(1);
      verify(mockTaskBox.put(task1.id, task1)).called(1);
      verify(mockTaskBox.put(task2.id, task2)).called(1);
    });
  });

  group('getCachedTasks', () {
    test('should return cached tasks from box', () async {
      when(mockHive.openBox<TaskModel>(taskBoxName))
          .thenAnswer((_) async => mockTaskBox);
      when(mockTaskBox.values).thenReturn([task1, task2]);

      final result = await dataSource.getCachedTasks();

      expect(result, [task1, task2]);
    });
  });

  group('getPendingTasks', () {
    test('should return only tasks with pendingSync = true', () async {
      when(mockHive.openBox<TaskModel>(taskBoxName))
          .thenAnswer((_) async => mockTaskBox);
      when(mockTaskBox.values).thenReturn([task1, task2]);

      final result = await dataSource.getPendingTasks();

      expect(result, [task2]);
    });
  });

  group('updateTask', () {
    test('should update task in box by id', () async {
      when(mockHive.openBox<TaskModel>(taskBoxName))
          .thenAnswer((_) async => mockTaskBox);
      when(mockTaskBox.put(task1.id, task1)).thenAnswer((_) async => {});

      await dataSource.updateTask(task1);

      verify(mockTaskBox.put(task1.id, task1)).called(1);
    });
  });

  group('deleteTask', () {
    test('should delete task and add ID to deleted box', () async {
      when(mockHive.openBox<TaskModel>(taskBoxName))
          .thenAnswer((_) async => mockTaskBox);
      when(mockHive.openBox<List<String>>(deletedBoxName))
          .thenAnswer((_) async => mockDeletedBox);
      when(mockTaskBox.delete('1')).thenAnswer((_) async => {});
      when(mockDeletedBox.add(['1'])).thenAnswer((_) async => 1);

      await dataSource.deleteTask('1');

      verify(mockTaskBox.delete('1')).called(1);
      verify(mockDeletedBox.add(['1'])).called(1);
    });
  });

  group('getDeletedTasksIds', () {
    test('should return flattened list of all deleted IDs', () async {
      when(mockHive.openBox<List<String>>(deletedBoxName))
          .thenAnswer((_) async => mockDeletedBox);
      when(mockDeletedBox.values).thenReturn([
        ['1', '2'],
        ['3']
      ]);

      final result = await dataSource.getDeletedTasksIds();

      expect(result, ['1', '2', '3']);
    });
  });

  group('clearDeletedTasksIds', () {
    test('should clear deleted box', () async {
      when(mockHive.openBox<List<String>>(deletedBoxName))
          .thenAnswer((_) async => mockDeletedBox);
      when(mockDeletedBox.clear()).thenAnswer((_) async => 0);

      await dataSource.clearDeletedTasksIds();

      verify(mockDeletedBox.clear()).called(1);
    });
  });
}
