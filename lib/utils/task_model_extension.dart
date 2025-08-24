import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';

/// Extension for checking dark mode
extension TaskModelExtensions on TaskModel {
  TaskEntity toTaskEntity() {
    return TaskEntity(
        id: id,
        title: title,
        description: description,
        status: status,
        userId: userId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'userId': userId
    };
  }
}

extension TaskStatusExtensions on TaskStatus {
  String get toShort {
    return this == TaskStatus.toDo
        ? 'To Do'
        : this == TaskStatus.inProgress
            ? 'In Progress'
            : 'Done';
  }
}
