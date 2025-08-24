import 'package:flutter/material.dart';
import 'package:permi_app/controller.dart'; 

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const _themeKey = 'isDarkMode';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadThemeFromPrefs();
  }

  void toggleTheme(bool isDark) async {
    value = isDark ? ThemeMode.dark : ThemeMode.light; 
    await  box.write(_themeKey, isDark);
 
  }

  void _loadThemeFromPrefs() async {
 
    final isDark = box.read(_themeKey) ?? false;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
