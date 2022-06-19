import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TokyoTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.w200,
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 11.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF393e45),
    ),
  );

  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF393e45),
      ),
      primaryColor: const Color(0xFF393e45),
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return const Color(0xFF393e45);
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF393e45),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF393e45),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF393e45),
      ),
      textTheme: lightTextTheme,
    );
  }
}