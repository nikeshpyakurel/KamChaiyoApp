import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color.fromARGB(255, 127, 152, 243),
    fontFamily: 'Nunito Regular',

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Color(0xFF7F98F3),
      titleTextStyle: TextStyle(
        fontFamily: 'Philosopher Bold',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Philosopher Bold',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Philosopher Medium',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Philosopher Regular',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Nunito Medium',
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Nunito Regular',
        fontSize: 14,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Nunito Bold',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF7F98F3),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF7F98F3),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),

    iconTheme: const IconThemeData(color: Color(0xFF7F98F3)),
  );
}
