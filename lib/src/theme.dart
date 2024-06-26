import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeApp {
  ThemeApp._();

  static final _themeApp = ThemeApp._();

  factory ThemeApp() => _themeApp;

  final theme = ValueNotifier<Brightness>(
      WidgetsBinding.instance.platformDispatcher.platformBrightness);

  bool get isDarkThemeApp => theme.value == Brightness.dark;

  void changeTheme(Brightness newTheme) => theme.value = newTheme;

  void dispose() => theme.dispose();

  void getThemePreference() => SharedPreferences.getInstance().then(
        (value) {
          final String? preference = value.getString('theme');
          if (preference != null) {
            if (preference == 'system') {
              _themeApp.theme.value =
                  WidgetsBinding.instance.platformDispatcher.platformBrightness;
            } else if (preference == 'dark') {
              _themeApp.theme.value = Brightness.dark;
            } else if (preference == 'light') {
              _themeApp.theme.value = Brightness.light;
            }
          }
        },
      );

  Future<String?> getThemeSaved() => SharedPreferences.getInstance().then(
        (value) {
          final String? preference = value.getString('theme');
          if (preference != null) {
            return preference;
          } else {
            return null;
          }
        },
      );
}
