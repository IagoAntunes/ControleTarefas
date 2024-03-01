import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/models/login_request_model.dart';

abstract class IAuthRepository {
  Future<IServiceState> login(
    LoginRequestModel requestModel,
  );
  Future<IServiceState> createAccount(
    LoginRequestModel requestModel,
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
  ) {
    return service.login(requestModel);
  }

  @override
  Future<IServiceState> createAccount(LoginRequestModel requestModel) {
    return service.createAccount(requestModel);
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
