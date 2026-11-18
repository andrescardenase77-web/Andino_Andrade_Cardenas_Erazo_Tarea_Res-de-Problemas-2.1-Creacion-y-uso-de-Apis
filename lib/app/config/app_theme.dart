import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryCoffee = Color(0xFF4A2C11);
  static const Color secondaryCaramel = Color(0xFFC88A35);
  static const Color accentTerracotta = Color(0xFF9E472A);
  static const Color backgroundCream = Color(0xFFFAF7F2);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceVariantCream = Color(0xFFF3ECE3);
  static const Color textDarkEspresso = Color(0xFF2B1A0E);
  static const Color textMutedBrown = Color(0xFF7A6A5E);
  static const Color borderLight = Color(0xFFE5DACF);

  static const Color statusPendiente = Color(0xFFE67E22);
  static const Color statusPreparando = Color(0xFF2980B9);
  static const Color statusEntregado = Color(0xFF27AE60);
  static const Color statusCancelado = Color(0xFFC0392B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryCoffee,
        onPrimary: Colors.white,
        secondary: secondaryCaramel,
        onSecondary: Colors.white,
        tertiary: accentTerracotta,
        onTertiary: Colors.white,
        error: statusCancelado,
        onError: Colors.white,
        surface: surfaceWhite,
        onSurface: textDarkEspresso,
        surfaceContainerHighest: surfaceVariantCream,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryCoffee,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCoffee,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCoffee,
          side: const BorderSide(color: primaryCoffee, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryCaramel, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusCancelado),
        ),
        hintStyle: const TextStyle(color: textMutedBrown, fontSize: 14),
        labelStyle: const TextStyle(color: textDarkEspresso, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 1.5,
        shadowColor: primaryCoffee.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 0.8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
