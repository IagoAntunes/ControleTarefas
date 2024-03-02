// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';

abstract class ITaskListEvent {}

class GetTasksListEvent extends ITaskListEvent {}

class AddTaskListEvent extends ITaskListEvent {
  TaskModel task;
  AddTaskListEvent({
    required this.task,
  });
}

class DeleteTaskListEvent extends ITaskListEvent {
  TaskModel task;
  DeleteTaskListEvent({
    required this.task,
  });
}

class DoneTasksListEvent extends ITaskListEvent {}

class SelectedTaskListEvent extends ITaskListEvent {
  bool value;
  int index;
  SelectedTaskListEvent({
    required this.value,
    required this.index,
  });
}

class FilterTaskListEvent extends ITaskListEvent {
  String text;
  FilterTaskListEvent({
    required this.text,
  });
}
