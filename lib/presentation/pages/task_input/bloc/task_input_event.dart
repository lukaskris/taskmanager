part of 'task_input_bloc.dart';

abstract class TaskInputEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitNewTask extends TaskInputEvent {
  final TaskEntity task;

  SubmitNewTask(this.task);

  @override
  List<Object> get props => [task];
}

class SubmitUpdatedTask extends TaskInputEvent {
  final TaskEntity task;

  SubmitUpdatedTask(this.task);

  @override
  List<Object> get props => [task];
}
