import 'package:flutter/material.dart';

Color primaryColor = Color(0xFF440D7E);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: primaryColor.withOpacity(0.8),
    onSecondary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black87,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: primaryColor.withOpacity(0.8),
    onSecondary: Colors.white,
    background: Color(0xFF121212),
    onBackground: Colors.white70,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white70,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
);
