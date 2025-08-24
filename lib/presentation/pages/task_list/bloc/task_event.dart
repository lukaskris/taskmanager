part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}
class Logout extends TaskEvent {}

class TaskDeleted extends TaskEvent {
  final TaskEntity task;
  const TaskDeleted(this.task);
  @override
  List<Object> get props => [task];
}

class TaskFiltered extends TaskEvent {
  final TaskStatus? state;
  const TaskFiltered({this.state});
}
