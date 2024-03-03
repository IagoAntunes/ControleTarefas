import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/models/login_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<IServiceState> login(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
  );
  Future<IServiceState> createAccount(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  );
  Future<IServiceState> storeUser(UserModel user);
  Future<IServiceState> getUser();
  Future<IServiceState> logout();
}

class AuthRepository extends IAuthRepository {
  AuthRepository({
    required this.service,
    required this.dao,
  });
  IAuthService service;
  IAuthDao dao;
  @override
  Future<IServiceState> login(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
  ) {
    return service.login(
      requestModel,
      firebaseAuth,
    );
  }

  @override
  Future<IServiceState> createAccount(
    LoginRequestModel requestModel,
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  ) {
    return service.createAccount(requestModel, firebaseAuth, firestore);
  }

  @override
  Future<IServiceState> storeUser(UserModel user) {
    return dao.storeUser(user);
  }

  @override
  Future<IServiceState> getUser() {
    return dao.geteUser();
  }

  @override
  Future<IServiceState> logout() {
    return dao.deleteUser();
  }
}
