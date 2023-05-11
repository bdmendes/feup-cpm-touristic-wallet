import 'package:flutter/material.dart';

ColorScheme lightCustomColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  primary: Colors.deepPurpleAccent,
);

ThemeData lightCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightCustomColorScheme,
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        return states.contains(MaterialState.selected) ?
          const TextStyle(fontWeight: FontWeight.bold) : const TextStyle();
      },
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
  ),
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
);

ColorScheme darkCustomColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  brightness: Brightness.dark,
  primary: Colors.deepPurpleAccent,
  surface: Colors.black,
);

ThemeData darkCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkCustomColorScheme,
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        return states.contains(MaterialState.selected) ?
          const TextStyle(fontWeight: FontWeight.bold) : const TextStyle();
      },
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
  ),
  canvasColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
);