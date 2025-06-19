import 'package:flutter/material.dart';
import 'package:kamchaiyo/app/constant/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: ThemeConstant.primaryColor,
      scaffoldBackgroundColor: ThemeConstant.scaffoldBackgroundColor,
      fontFamily: ThemeConstant.fontFamilyNunito,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeConstant.primaryColor,
        error: ThemeConstant.errorColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        backgroundColor: ThemeConstant.primaryColor,
        titleTextStyle: TextStyle(
          fontFamily: ThemeConstant.fontFamilyPhilosopher,
          fontSize: 20,
          color: ThemeConstant.textOnPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: ThemeConstant.textOnPrimaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstant.lightPrimaryColor,
          foregroundColor: ThemeConstant.textOnPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontFamily: ThemeConstant.fontFamilyNunitoBold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: const BorderSide(color: ThemeConstant.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.borderRadius),
          borderSide: const BorderSide(color: ThemeConstant.errorColor, width: 1.5),
        ),
        labelStyle: const TextStyle(fontFamily: ThemeConstant.fontFamilyNunito, color: ThemeConstant.secondaryTextColor),
        filled: true,
        fillColor: ThemeConstant.surfaceColor,
      ),
    );
  }
}