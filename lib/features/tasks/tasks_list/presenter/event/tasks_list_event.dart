abstract class ITaskListEvent {}

class GetTasksListEvent extends ITaskListEvent {}

class AddTaskListEvent extends ITaskListEvent {}

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
