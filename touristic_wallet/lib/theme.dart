import 'package:flutter/material.dart';

ThemeData lightCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.deepPurple,
    primary: Colors.deepPurpleAccent,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        return states.contains(MaterialState.selected) ?
          const TextStyle(fontWeight: FontWeight.bold) : const TextStyle();
      },
    ),
  ),
);

ThemeData darkCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
    primary: Colors.deepPurpleAccent,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        return states.contains(MaterialState.selected) ?
          const TextStyle(fontWeight: FontWeight.bold) : const TextStyle();
      },
    ),
  ),
);