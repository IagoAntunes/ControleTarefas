// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:controle_tarefas/features/login/presenter/utils/auth_options_enum.dart';

abstract class IAuthBlocState {
  AuthOption authOption;
  IAuthBlocState({
    required this.authOption,
  });
}

class LoginAuthOptionState extends IAuthBlocState {
  LoginAuthOptionState() : super(authOption: AuthOption.login);
}

class RegisterAuthOptionState extends IAuthBlocState {
  RegisterAuthOptionState() : super(authOption: AuthOption.register);
}

abstract class IAuthListeners extends IAuthBlocState {
  IAuthListeners({required super.authOption});
}

class SuccessAuthListener extends IAuthListeners {
  SuccessAuthListener({required super.authOption});
}

class FailureAuthListener extends IAuthListeners {
  String message;
  FailureAuthListener({
    required this.message,
    required super.authOption,
  });
}

class LogoutAuthListener extends IAuthListeners {
  LogoutAuthListener({required super.authOption});
}

//Login
abstract class ILoginBlocState extends IAuthBlocState {
  ILoginBlocState() : super(authOption: AuthOption.login);
}

class IdleLoginBlocState extends ILoginBlocState {}

class LoadingLoginBlocState extends ILoginBlocState {}

class LoggedLoginState extends ILoginBlocState {}

class FailureLoginState extends ILoginBlocState {
  String message;
  FailureLoginState({required this.message});
}

abstract class ILoginListeners extends ILoginBlocState {
  ILoginListeners();
}
