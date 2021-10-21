import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    canvasColor: const Color(0xFF131826),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0xFF664FF0),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFF4F4F4),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      headline2: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      button: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      bodyText2: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF1E1F21),
    ),
    canvasColor: const Color(0xFF131826),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0xFF664FF0),
    scaffoldBackgroundColor: const Color(0xFF151618),
    backgroundColor: const Color(0xFF151618),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      headline2: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      button: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
    ),
  );
}
