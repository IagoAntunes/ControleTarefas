import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/login_request_model.dart';

abstract class IAuthService {
  Future<IServiceState> login(LoginRequestModel requestModel);
  Future<IServiceState> createAccount(LoginRequestModel requestModel);
}

class AuthFirebaseService extends IAuthService {
  @override
  Future<IServiceState> login(LoginRequestModel requestModel) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
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
  Future<IServiceState> createAccount(LoginRequestModel requestModel) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: requestModel.email,
        password: requestModel.password,
      );
      UserModel userModel =
          UserModel(uid: user.user!.uid, email: user.user!.email!);
      firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
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
}
