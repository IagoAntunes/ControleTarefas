// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class IAppBlocState {
  ThemeMode themeMode;
  IAppBlocState({
    required this.themeMode,
  });
}

class AppBlocState extends IAppBlocState {
  AppBlocState({required super.themeMode});
}

class ChangedThemeBlocState extends IAppBlocState {
  ChangedThemeBlocState({required super.themeMode});
  //
}
