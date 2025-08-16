import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const _themeKey = 'isDarkMode';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadThemeFromPrefs();
  }

  void toggleTheme(bool isDark) async {
    value = isDark ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  void _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
