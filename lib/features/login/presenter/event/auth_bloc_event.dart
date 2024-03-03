import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences shared;
  FirebaseAuth firebaseAuth;

  LoginLoginBlocEvent({
    required this.email,
    required this.password,
    required this.shared,
    required this.firebaseAuth,
  }) : super(authOption: AuthOption.login);
}

class CreateAuthBlocEvent extends IAuthBlocEvent {
  String email;
  String password;
  SharedPreferences shared;
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firestore;
  CreateAuthBlocEvent({
    required this.email,
    required this.password,
    required this.shared,
    required this.firebaseAuth,
    required this.firestore,
  }) : super(authOption: AuthOption.register);
}

class LogoutAuthBlocEvent extends IAuthBlocEvent {
  LogoutAuthBlocEvent({required super.authOption});
}
