import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';

abstract class ITaskListEvent {}

class GetTasksListEvent extends ITaskListEvent {
  AppDatabase database;
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  Connectivity connectivity;
  GetTasksListEvent({
    required this.database,
    required this.firestore,
    required this.storage,
    required this.connectivity,
  });
}

class AddTaskListEvent extends ITaskListEvent {
  TaskModel task;
  FirebaseFirestore firestore;
  AddTaskListEvent({
    required this.task,
    required this.firestore,
  });
}

class DeleteTaskListEvent extends ITaskListEvent {
  AppDatabase database;
  TaskModel task;
  FirebaseFirestore firestore;
  DeleteTaskListEvent({
    required this.database,
    required this.task,
    required this.firestore,
  });
}

class DoneTasksListEvent extends ITaskListEvent {
  AppDatabase database;
  FirebaseFirestore firestore;
  DoneTasksListEvent({
    required this.database,
    required this.firestore,
  });
}

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
