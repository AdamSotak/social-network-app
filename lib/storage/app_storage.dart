import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/styling/styles.dart';

class AppStorage {
  final String appThemeModeKey = "app_theme_mode";

  Future<void> setThemeMode(ThemeMode appTheme) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(appThemeModeKey, appTheme.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return Styles.getThemeMode(preferences.getString(appThemeModeKey).toString());
    } catch (error) {
      setThemeMode(ThemeMode.system);
      return ThemeMode.system;
    }
  }
}
