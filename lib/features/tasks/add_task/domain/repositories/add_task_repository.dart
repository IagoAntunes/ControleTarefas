import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/data/service/add_task_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class IAddTaskRepository {
  Future<IServiceState> addTask(
    TaskModel task,
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  );
}

class AddTaskRepository extends IAddTaskRepository {
  IAddTaskFirebaseService service;
  AddTaskRepository({
    required this.service,
  });
  @override
  Future<IServiceState> addTask(
    TaskModel task,
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  ) async {
    return await service.addTask(
      task,
      user,
      firestore,
      storage,
    );
  }
}
