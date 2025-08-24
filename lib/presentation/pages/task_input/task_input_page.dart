import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/core/utils/toast_util.dart';
import 'package:taskmanager/core/widgets/button.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/domain/entities/task_entity.dart';
import 'package:taskmanager/injectable.dart';
import 'package:taskmanager/presentation/pages/task_input/bloc/task_input_bloc.dart';

class TaskInputPage extends StatefulWidget {
  const TaskInputPage({super.key, this.task});
  final TaskEntity? task;

  @override
  State<TaskInputPage> createState() => _TaskInputPageState();
}

class _TaskInputPageState extends State<TaskInputPage> {
  final _bloc = getIt<TaskInputBloc>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TaskStatus selectedStatus = TaskStatus.toDo;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedStatus = widget.task!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task ${widget.task != null ? 'Update' : 'Input'}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: BlocConsumer<TaskInputBloc, TaskInputState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is TaskInputSuccess) {
                showSuccessToast('Task added successfully');
                context.pop(true);
              } else if (state is TaskInputFailure) {
                showErrorToast(state.message);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter a title'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter a description'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<TaskStatus>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: TaskStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedStatus = value;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        isLoading: state is TaskInputLoading,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final newTask = TaskEntity(
                              id: widget.task?.id ??
                                  DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              status: selectedStatus,
                              userId: widget.task?.userId ?? '',
                            );
                            if (widget.task != null) {
                              _bloc.add(SubmitUpdatedTask(newTask));
                            } else {
                              _bloc.add(SubmitNewTask(newTask));
                            }
                          }
                        },
                        text: '${widget.task != null ? 'Update' : 'Add'} Task',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
