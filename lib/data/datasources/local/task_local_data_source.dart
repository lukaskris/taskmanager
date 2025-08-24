import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/data/models/task_model.dart';

@Injectable()
class TaskLocalDataSource {
  final HiveInterface hive;
  static const String boxName = 'tasksBox';
  static const String deletedBoxName = 'deletedTasksIdsBox';

  TaskLocalDataSource({required this.hive});

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await hive.openBox<TaskModel>(boxName);
    await box.clear();
    for (var task in tasks) {
      await box.put(task.id, task);
    }
  }

  Future<List<TaskModel>> getCachedTasks() async {
    final box = await hive.openBox<TaskModel>(boxName);
    return box.values.toList();
  }

  Future<List<TaskModel>> getPendingTasks() async {
    final box = await hive.openBox<TaskModel>(boxName);
    return box.values.where((task) => task.pendingSync).toList();
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await hive.openBox<TaskModel>(boxName);
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    final box = await hive.openBox<TaskModel>(boxName);
    final deletedBox = await hive.openBox<List<String>>(deletedBoxName);
    await box.delete(taskId);
    await deletedBox.add([taskId]);
  }

  Future<List<String>> getDeletedTasksIds() async {
    final deletedBox = await hive.openBox<List<String>>(deletedBoxName);
    return deletedBox.values.expand((list) => list).toList();
  }

  Future<void> clearDeletedTasksIds() async {
    final deletedBox = await hive.openBox<List<String>>(deletedBoxName);
    await deletedBox.clear();
  }
}
