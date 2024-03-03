import 'package:demarco_teste_pratico/core/models/user_model.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/states/app_service_state.dart';

abstract class IAuthDao {
  Future<IServiceState> storeUser(UserModel user, AppDatabase database);
  Future<IServiceState> geteUser(AppDatabase database);
  Future<IServiceState> deleteUser(AppDatabase database);
}

class AuthDao extends IAuthDao {
  @override
  Future<IServiceState> deleteUser(AppDatabase database) async {
    await database.deleteUser();
    return SuccessServiceState(data: '');
  }

  @override
  Future<IServiceState> geteUser(AppDatabase database) async {
    final user = await database.getUser();
    return SuccessServiceState(data: user);
  }

  @override
  Future<IServiceState> storeUser(UserModel user, AppDatabase database) async {
    final result = await database.insertUser(user);

    return result
        ? SuccessServiceState(data: null)
        : FailureServiceState(message: 'Erro ao Inserir');
  }
}
