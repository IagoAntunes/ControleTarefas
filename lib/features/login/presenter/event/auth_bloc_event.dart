// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:controle_tarefas/core/database/app_database.dart';

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
  AppDatabase database;

  LoginLoginBlocEvent({
    required this.email,
    required this.password,
    required this.shared,
    required this.firebaseAuth,
    required this.database,
  }) : super(authOption: AuthOption.login);
}

class CreateAuthBlocEvent extends IAuthBlocEvent {
  String email;
  String password;
  SharedPreferences shared;
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firestore;
  AppDatabase database;
  CreateAuthBlocEvent({
    required this.email,
    required this.password,
    required this.shared,
    required this.firebaseAuth,
    required this.firestore,
    required this.database,
  }) : super(authOption: AuthOption.register);
}

class LogoutAuthBlocEvent extends IAuthBlocEvent {
  AppDatabase database;
  LogoutAuthBlocEvent({
    required super.authOption,
    required this.database,
  });
}
