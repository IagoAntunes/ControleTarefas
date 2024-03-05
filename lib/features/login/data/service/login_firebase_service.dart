import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/login_request_model.dart';

abstract class IAuthService {
  Future<IServiceState> login(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
  );
  Future<IServiceState> createAccount(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  );
}

class AuthFirebaseService extends IAuthService {
  @override
  Future<IServiceState> login(
      LoginRequestModel requestModel, FirebaseAuth firebaseAuth) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
        email: requestModel.email,
        password: requestModel.password,
      );
      return SuccessServiceState<UserCredential>(data: user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return FailureServiceState(message: "Usuário invalido");
        case 'user-not-found':
          return FailureServiceState(message: 'Usuário não encontrado');
        case 'wrong-password':
          return FailureServiceState(message: 'Senha Incorreta');
        case 'invalid-email':
          return FailureServiceState(message: 'Email Invalido');
      }
      return FailureServiceState(message: "Erro inesperado");
    }
  }

  @override
  Future<IServiceState> createAccount(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  ) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: requestModel.email,
        password: requestModel.password,
      );
      UserModel userModel = UserModel(
        uid: user.user!.uid,
        email: user.user!.email!,
      );
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
      return SuccessServiceState<UserCredential>(data: user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return FailureServiceState(message: "Email ja em uso");
        case 'invalid-email':
          return FailureServiceState(message: 'Email invalido');
        case 'operation-not-allowed':
          return FailureServiceState(message: 'Erro interno');
        case 'weak-password':
          return FailureServiceState(message: 'Senha Fraca');
      }
      return FailureServiceState(message: "Erro inesperado");
    }
  }
}
