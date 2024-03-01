import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/states/app_service_state.dart';

abstract class IAddTaskFirebaseService {
  Future<IServiceState> addTask(TaskModel task, UserModel user);
}

class AddTaskFirebaseService extends IAddTaskFirebaseService {
  @override
  Future<IServiceState> addTask(TaskModel task, UserModel user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          firestore.collection('tasks').doc(user.uid);

      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      var imagePath = '${user.uid}/${task.id}.jpg';
      var ref = storage.ref();
      if (docSnapshot.exists) {
        // O documento existe, então atualiza
        await ref
            .child(imagePath)
            .putData(base64.decode(task.image!))
            .then((p0) {
          print(p0.toString());
        });
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
            .then((p0) {
          print(p0.toString());
        });
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
