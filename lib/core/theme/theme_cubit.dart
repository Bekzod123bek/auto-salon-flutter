import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_storage.dart';

/// Light or dark mode, remembered between launches. Dark by default.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage)
      : super((_storage.darkMode ?? true) ? ThemeMode.dark : ThemeMode.light);

  final LocalStorage _storage;

  bool get isDark => state == ThemeMode.dark;

  Future<void> setDark(bool dark) async {
    emit(dark ? ThemeMode.dark : ThemeMode.light);
    await _storage.setDarkMode(dark);
  }
}
