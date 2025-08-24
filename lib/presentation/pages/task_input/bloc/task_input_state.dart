part of 'task_input_bloc.dart';

abstract class TaskInputState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskInputInitial extends TaskInputState {}

class TaskInputLoading extends TaskInputState {}

class TaskInputSuccess extends TaskInputState {}

class TaskInputFailure extends TaskInputState {
  final String message;

  TaskInputFailure({required this.message});

  @override
  List<Object> get props => [message];
}
