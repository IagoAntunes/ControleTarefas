import 'package:demarco_teste_pratico/core/models/user_model.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/login/presenter/event/auth_bloc_event.dart';
import 'package:demarco_teste_pratico/features/login/presenter/state/auth_option_state.dart';
import 'package:demarco_teste_pratico/features/login/presenter/utils/auth_options_enum.dart';
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
    on<ChangeOptionAuthBlocEvent>((event, emit) {
      if (event.authOption == AuthOption.login) {
        emit(LoginAuthOptionState());
      } else {
        emit(RegisterAuthOptionState());
      }
    });
    on<LoginLoginBlocEvent>((event, emit) async {
      emit(LoadingLoginBlocState());
      var request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );
      IServiceState result = await repository.login(
        request,
        event.firebaseAuth,
      );
      if (result is SuccessServiceState<UserCredential>) {
        await event.shared.setBool('isLogged', true);
        var user = UserModel(
          uid: result.data.user!.uid,
          email: result.data.user!.email!,
        );
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

    on<CreateAuthBlocEvent>((event, emit) async {
      emit(LoadingLoginBlocState());
      var request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );
      final result = await repository.createAccount(
        request,
        event.firebaseAuth,
        event.firestore,
      );
      if (result is SuccessServiceState) {
        await event.shared.setBool('isLogged', true);
        var user = UserModel(
          uid: result.data.user!.uid,
          email: result.data.user!.email!,
        );

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
    on<LogoutAuthBlocEvent>((event, emit) async {
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

  Future<void> userLogged(bool value, SharedPreferences shared) async {
    await shared.setBool('isLogged', value);
  }

  // Future<void> storeUserFunc(UserModel user) async {
  //   await repository.storeUser(user, AppDatabase());
  // }

  bool isAuthLogin() => state.authOption == AuthOption.login;
}
