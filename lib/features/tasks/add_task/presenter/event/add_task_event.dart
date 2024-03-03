import 'package:demarco_teste_pratico/core/database/app_database.dart';

abstract class IAddTaskEvent {}

class AddTaskEvent extends IAddTaskEvent {
  String nameTask;
  AppDatabase database;
  AddTaskEvent({
    required this.nameTask,
    required this.database,
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
