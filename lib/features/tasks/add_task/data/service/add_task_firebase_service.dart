import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/states/app_service_state.dart';

abstract class IAddTaskFirebaseService {
  Future<IServiceState> addTask(
    TaskModel task,
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  );
}

class AddTaskFirebaseService extends IAddTaskFirebaseService {
  @override
  Future<IServiceState> addTask(
    TaskModel task,
    UserModel user,
    FirebaseFirestore firestore,
    FirebaseStorage storage,
  ) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          firestore.collection('tasks').doc(user.uid);

      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      var imagePath = '${user.uid}/${task.id}.jpg';
      var ref = storage.ref();
      if (docSnapshot.exists) {
        // O documento existe, então atualiza
        var child = ref.child(imagePath);

        await child.putData(base64.decode(task.image!));
        await docRef.update({
          'listTasks': FieldValue.arrayUnion([
            task.toMap(),
          ])
        });
      } else {
        // O documento não existe, então crie um novo
        await ref
            .child(imagePath)
            .putData(base64.decode(task.image!))
            .then((p0) {});
        await docRef.set({
          'listTasks': [
            task.toMap(),
          ]
        });
      }

      return SuccessServiceState(data: '');
    } catch (e) {
      return FailureServiceState(message: "Erro");
    }
  }
}
