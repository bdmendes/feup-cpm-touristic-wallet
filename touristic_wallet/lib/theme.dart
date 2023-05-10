import 'package:flutter/material.dart';

var lightCustomColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  primary: Colors.deepPurpleAccent,
);

var lightCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightCustomColorScheme,
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(fontWeight: FontWeight.bold);
        }
        return const TextStyle();
      },
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
  ),
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
);

var darkCustomColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  brightness: Brightness.dark,
  primary: Colors.deepPurpleAccent,
  surface: Colors.black,
);

var darkCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkCustomColorScheme,
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(fontWeight: FontWeight.bold);
        }
        return const TextStyle();
      },
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
  ),
  canvasColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
);