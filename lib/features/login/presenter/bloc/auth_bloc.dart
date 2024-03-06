import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:controle_tarefas/core/states/app_service_state.dart';
import 'package:controle_tarefas/features/login/presenter/event/auth_bloc_event.dart';
import 'package:controle_tarefas/features/login/presenter/state/auth_option_state.dart';
import 'package:controle_tarefas/features/login/presenter/utils/auth_options_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/login_request_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<IAuthBlocEvent, IAuthBlocState> {
  IAuthRepository repository;
  AuthBloc({
    required this.repository,
  }) : super(LoginAuthOptionState()) {
    //ChangeOptionAuthBlocEvent | Alterar opção Login-Registro
    on<ChangeOptionAuthBlocEvent>((event, emit) {
      if (event.authOption == AuthOption.login) {
        emit(LoginAuthOptionState());
      } else {
        emit(RegisterAuthOptionState());
      }
    });
    //LoginLoginBlocEvent | Realiar login
    on<LoginLoginBlocEvent>((event, emit) async {
      emit(LoadingLoginBlocState());
      var request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );
      //Requisição para realizar LOGIN
      IServiceState result = await repository.login(
        request,
        event.firebaseAuth,
      );
      if (result is SuccessServiceState<UserCredential>) {
        //Guardar estado do usuario logado
        await event.shared.setBool('isLogged', true);
        var user = UserModel(
          uid: result.data.user!.uid,
          email: result.data.user!.email!,
        );
        //Guardar estado do usuario logado
        await repository.storeUser(user, event.database);
        emit(SuccessAuthListener(authOption: state.authOption));
      } else if (result is FailureServiceState) {
        emit(
          FailureAuthListener(
              authOption: state.authOption, message: result.message),
        );
        emit(FailureLoginState(message: result.message));
      }
    });
    //CreateAuthBlocEvent | Registrar usuario
    on<CreateAuthBlocEvent>((event, emit) async {
      emit(LoadingLoginBlocState());
      var request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );

      //Requisição para criar conta usuario
      final result = await repository.createAccount(
        request,
        event.firebaseAuth,
        event.firestore,
      );
      if (result is SuccessServiceState) {
        //Guardar estado do usuario
        await event.shared.setBool('isLogged', true);
        var user = UserModel(
          uid: result.data.user!.uid,
          email: result.data.user!.email!,
        );
        //Guardar estado do usuario
        await repository.storeUser(user, event.database);
        emit(SuccessAuthListener(authOption: state.authOption));
        emit(LoggedLoginState());
      } else if (result is FailureServiceState) {
        emit(
          FailureAuthListener(
              authOption: state.authOption, message: result.message),
        );
        emit(FailureLoginState(message: result.message));
      } else {}
    });
    //LogoutAuthBlocEvent | Deslogar usuario
    on<LogoutAuthBlocEvent>((event, emit) async {
      //Requisição para deslogar usuario
      final result = await repository.logout(event.database);
      if (result is SuccessServiceState) {
        emit(LogoutAuthListener(authOption: AuthOption.login));
      } else if (result is FailureServiceState) {
        emit(
          FailureAuthListener(
            message: '',
            authOption: AuthOption.login,
          ),
        );
      }
    });
  }
  //Verificar se usuario esta logado
  Future<void> userLogged(bool value, SharedPreferences shared) async {
    await shared.setBool('isLogged', value);
  }

  // Future<void> storeUserFunc(UserModel user) async {
  //   await repository.storeUser(user, AppDatabase());
  // }

  bool isAuthLogin() => state.authOption == AuthOption.login;
}
