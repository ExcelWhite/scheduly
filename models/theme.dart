import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final String name;
  final Color primaryTextColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color buttonShadeColor;
  final Color backgroundColor;
  final Color clockColor;
  final Color iconColor;

  AppTheme({
    required this.name,
    required this.primaryTextColor, 
    required this.buttonTextColor, 
    required this.buttonColor, 
    required this.buttonShadeColor, 
    required this.backgroundColor, 
    required this.clockColor, 
    required this.iconColor,
  });

  ThemeData getTheme() {
    var outlineInputBorder = OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        );
    return ThemeData(
      textTheme: TextTheme(
        bodySmall: GoogleFonts.cabin(color: primaryTextColor),
        bodyMedium: GoogleFonts.cabin(color: primaryTextColor, fontSize: 16),
        bodyLarge: GoogleFonts.cabin(color: primaryTextColor),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        color: backgroundColor,
        foregroundColor: primaryTextColor,
        titleTextStyle: GoogleFonts.cabin(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 24)
      ),

      iconTheme: IconThemeData(
        color: iconColor,
      ),

      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),

    );
  }


}