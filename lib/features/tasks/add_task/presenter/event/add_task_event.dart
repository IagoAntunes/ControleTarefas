abstract class IAddTaskEvent {}

class AddTaskEvent extends IAddTaskEvent {
  String nameTask;
  AddTaskEvent({
    required this.nameTask,
  });
}

class AddDateTaskEvent extends IAddTaskEvent {
  String date;
  AddDateTaskEvent({
    required this.date,
  });
}

class SelectImageEvent extends IAddTaskEvent {
  //
}
