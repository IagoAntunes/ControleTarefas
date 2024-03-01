import 'package:demarco_teste_pratico/core/models/user_model.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/states/app_service_state.dart';

abstract class IAuthDao {
  Future<IServiceState> storeUser(UserModel user);
  Future<IServiceState> geteUser();
  Future<IServiceState> deleteUser();
}

class AuthDao extends IAuthDao {
  @override
  Future<IServiceState> deleteUser() async {
    await AppDatabase.deleteUser();
    return SuccessServiceState(data: '');
  }

  @override
  Future<IServiceState> geteUser() async {
    final user = await AppDatabase.getUser();
    return SuccessServiceState(data: user);
  }

  @override
  Future<IServiceState> storeUser(UserModel user) async {
    final result = await AppDatabase.insertUser(user);

    return result
        ? SuccessServiceState(data: null)
        : FailureServiceState(message: 'Erro ao Inserir');
  }
}
