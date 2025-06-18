part of 'theme_cubit.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState.initial() = ThemeInitial;

  const factory ThemeState.loaded({
    required ThemeMode themeMode,
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) = ThemeLoaded;

  const factory ThemeState.error(String message) = ThemeError;
}

// Extension for easier access to properties
extension ThemeStateX on ThemeState {
  ThemeMode get themeMode => when(
    initial: () => ThemeMode.system,
    loaded: (themeMode, _, __) => themeMode,
    error: (_) => ThemeMode.system,
  );

  ThemeData get lightTheme => when(
    initial: () => AppTheme.lightTheme,
    loaded: (_, lightTheme, __) => lightTheme,
    error: (_) => AppTheme.lightTheme,
  );

  ThemeData get darkTheme => when(
    initial: () => AppTheme.darkTheme,
    loaded: (_, __, darkTheme) => darkTheme,
    error: (_) => AppTheme.darkTheme,
  );
 ThemeState copyWith({
     ThemeMode? themeMode,
     ThemeData? lightTheme,
     ThemeData? darkTheme,
   }) {
     return when(
       initial: () => const ThemeState.initial(),
       loaded: (currentThemeMode, currentLightTheme, currentDarkTheme) =>
           ThemeState.loaded(
             themeMode: themeMode ?? currentThemeMode,
             lightTheme: lightTheme ?? currentLightTheme,
             darkTheme: darkTheme ?? currentDarkTheme,
           ),
       error: (message) => ThemeState.error(message),
     );
   }
}