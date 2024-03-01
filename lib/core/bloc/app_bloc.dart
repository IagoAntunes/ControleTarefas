import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demarco_teste_pratico/core/bloc/states/app_bloc_state.dart';

import 'events/app_bloc_event.dart';

class AppBloc extends Bloc<ChangeThemeAppBlocEvent, IAppBlocState> {
  AppBloc() : super(AppBlocState(themeMode: ThemeMode.dark)) {
    on<ChangeThemeAppBlocEvent>((event, emit) {
      if (state.themeMode == ThemeMode.light) {
        emit(ChangedThemeBlocState(themeMode: ThemeMode.dark));
      } else {
        emit(ChangedThemeBlocState(themeMode: ThemeMode.light));
      }
    });
  }

  Future<bool> isLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogged') == null ? false : true;
  }

  bool isDark() => state.themeMode == ThemeMode.dark;
}
