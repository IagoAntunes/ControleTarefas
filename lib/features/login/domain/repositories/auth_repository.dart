import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/data/dao/auth_dao.dart';
import 'package:controle_tarefas/features/login/data/service/login_firebase_service.dart';
import 'package:controle_tarefas/features/login/domain/models/login_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/database/app_database.dart';

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
  Future<IServiceState> storeUser(UserModel user, AppDatabase database);
  Future<IServiceState> getUser(AppDatabase database);
  Future<IServiceState> logout(AppDatabase database);
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
  Future<IServiceState> storeUser(
    UserModel user,
    AppDatabase database,
  ) {
    return dao.storeUser(user, database);
  }

  @override
  Future<IServiceState> getUser(AppDatabase database) {
    return dao.geteUser(database);
  }

  @override
  Future<IServiceState> logout(AppDatabase database) {
    return dao.deleteUser(database);
  }
}
