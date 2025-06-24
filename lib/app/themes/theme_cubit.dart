import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../core/storage/local_storage.dart';
import 'app_theme.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

@singleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.initial());

  /// Load saved theme mode from local storage
  Future<void> loadTheme() async {
    try {
      final savedThemeMode = LocalStorage.getThemeMode();
      ThemeMode themeMode;

      switch (savedThemeMode) {
        case 'light':
          themeMode = ThemeMode.light;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          themeMode = ThemeMode.system;
          break;
      }

      emit(ThemeState.loaded(
        themeMode: themeMode,
        lightTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ));
    } catch (e) {
      // If loading fails, use system theme as default
      emit(ThemeState.loaded(
        themeMode: ThemeMode.system,
        lightTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ));
    }
  }

  /// Change theme mode and save to local storage
  Future<void> changeTheme(ThemeMode themeMode) async {
    try {
      // Save to local storage
      String themeModeString;
      switch (themeMode) {
        case ThemeMode.light:
          themeModeString = 'light';
          break;
        case ThemeMode.dark:
          themeModeString = 'dark';
          break;
        case ThemeMode.system:
          themeModeString = 'system';
          break;
      }

      await LocalStorage.saveThemeMode(themeModeString);

      // Update state
      emit(state.copyWith(themeMode: themeMode));
    } catch (e) {
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    ThemeMode newMode;

    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.system:
      // For system mode, we'll switch to light mode
        newMode = ThemeMode.light;
        break;
    }

    await changeTheme(newMode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await changeTheme(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await changeTheme(ThemeMode.dark);
  }

  /// Set system theme (follows device setting)
  Future<void> setSystemTheme() async {
    await changeTheme(ThemeMode.system);
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    return state.themeMode == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    return state.themeMode == ThemeMode.light;
  }

  /// Check if current theme follows system
  bool get isSystemMode {
    return state.themeMode == ThemeMode.system;
  }

  /// Get theme mode as string
  String get themeModeString {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}