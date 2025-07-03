import 'package:flutter/material.dart';
import 'package:kamchaiyo/app/constant/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ThemeConstant.primaryColor,
      error: ThemeConstant.errorColor,
     
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito Regular', 
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background, 
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF7F98F3), 
        titleTextStyle: TextStyle(
          fontFamily: 'Philosopher Bold', 
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary, 
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF7F98F3), 
          foregroundColor: colorScheme.onPrimary, 
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Nunito Bold',
            fontWeight: FontWeight.bold, 
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: BorderSide(color: colorScheme.outline), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Nunito Regular',
          color: colorScheme.onSurfaceVariant, 
        ),
      ),
    );
  }
}