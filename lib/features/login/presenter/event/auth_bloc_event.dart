import '../utils/auth_options_enum.dart';

abstract class IAuthBlocEvent {
  AuthOption authOption;
  IAuthBlocEvent({
    required this.authOption,
  });
}

class ChangeOptionAuthBlocEvent extends IAuthBlocEvent {
  ChangeOptionAuthBlocEvent({required super.authOption});
}

class LoginLoginBlocEvent extends IAuthBlocEvent {
  String email;
  String password;
  LoginLoginBlocEvent({
    required this.email,
    required this.password,
  }) : super(authOption: AuthOption.login);
}

class CreateAuthBlocEvent extends IAuthBlocEvent {
  String email;
  String password;
  CreateAuthBlocEvent({
    required this.email,
    required this.password,
  }) : super(authOption: AuthOption.register);
}

class LogoutAuthBlocEvent extends IAuthBlocEvent {
  LogoutAuthBlocEvent({required super.authOption});
}
