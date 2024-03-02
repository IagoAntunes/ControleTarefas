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
        print("Oi");
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
      IServiceState result = await repository.login(request);
      if (result is SuccessServiceState<UserCredential>) {
        _userLogged(true);
        var user = UserModel(
            uid: result.data.user!.uid, email: result.data.user!.email!);
        await _storeUser(user);
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
      final result = await repository.createAccount(request);
      if (result is SuccessServiceState) {
        _userLogged(true);
        var user = UserModel(
          uid: result.data.user!.uid,
          email: result.data.user!.email!,
        );
        await _storeUser(user);
        emit(SuccessAuthListener(authOption: state.authOption));
        emit(LoggedLoginState());
      } else if (result is FailureServiceState) {
        emit(
          FailureAuthListener(
              authOption: state.authOption, message: result.message),
        );
        emit(FailureLoginState(message: result.message));
      }
    });
    on<LogoutAuthBlocEvent>((event, emit) async {
      final result = await repository.logout();
      if (result is SuccessServiceState) {
        emit(LogoutAuthListener(authOption: AuthOption.login));
      }
    });
  }

  Future<void> _userLogged(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', value);
  }

  Future<void> _storeUser(UserModel user) async {
    await repository.storeUser(user);
  }

  bool isAuthLogin() => state.authOption == AuthOption.login;
}
