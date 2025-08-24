import 'package:flutter/material.dart';

import 'all_themes.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = allThemes.values.first;

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
