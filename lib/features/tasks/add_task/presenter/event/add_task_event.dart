import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:controle_tarefas/core/database/app_database.dart';

abstract class IAddTaskEvent {}

class AddTaskEvent extends IAddTaskEvent {
  String nameTask;
  AppDatabase database;
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  AddTaskEvent({
    required this.nameTask,
    required this.database,
    required this.firestore,
    required this.storage,
  });
}

class AddDateTaskEvent extends IAddTaskEvent {
  String date;
  AddDateTaskEvent({
    required this.date,
  });
}

class SelectImageEvent extends IAddTaskEvent {
  ImagePicker imagePicker;
  SelectImageEvent({
    required this.imagePicker,
  });
}
