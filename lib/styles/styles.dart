import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  primarySwatch: primaryColor,
  // fontFamily: 'louis',
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0.0,
    color: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.black54,
    showUnselectedLabels: true,
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: primaryColor,
  primarySwatch: primaryColor,
  scaffoldBackgroundColor: Colors.black45,
  // fontFamily: 'louis',
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black45,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0.0,
    color: Colors.black45,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black45,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
);
