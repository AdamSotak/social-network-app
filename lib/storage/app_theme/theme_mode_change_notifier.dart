import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:social_network/storage/app_storage.dart';

class ThemeModeChangeNotifier with ChangeNotifier {
  ThemeModeChangeNotifier() {
    AppStorage().getThemeMode().then((value) {
      themeMode = value;
      notifyListeners();
    });
  }

  static ThemeMode themeMode = ThemeMode.system;

  bool get darkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void setTheme(ThemeMode appThemeMode) {
    AppStorage().setThemeMode(appThemeMode);
    themeMode = appThemeMode;
    notifyListeners();
  }
}
