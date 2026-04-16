import 'package:flutter/material.dart';

class AppTheme {
  // � Modern & Joyful Energy Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(
      0xFF0F111A,
    ), // Deep modern midnight blue
    primaryColor: const Color(0xFF00D2FF), // Refreshing vibrant Cyan!

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00D2FF),
      secondary: Color(0xFFF9D423), // Sunny Yellow
      tertiary: Color(0xFFC77DFF), // Soft Purple
      surface: Color(0xFF1A1C29), // Smooth dark card background
    ),

    cardColor: const Color(0xFF1A1C29),
    fontFamily: 'Roboto', // Falls back to system sans-serif but feels clean
    // Modern, friendly, and energetic text styling
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 120,
        fontWeight: FontWeight.w800, // Thick but not aggressive
        letterSpacing: -2.0,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(color: Color(0xFFF0F0F0), fontSize: 18),
      bodyMedium: TextStyle(
        color: Color(0xFFB0B3C6),
        fontSize: 14,
      ), // Softer blue-grey text
    ),

    // Bubbly, inviting primary buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D2FF), // Vibrant Cyan background
        foregroundColor: Colors.black, // Dark text to pop off the cyan
        minimumSize: const Size(double.infinity, 65), // Good touch target
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ), // Super rounded & friendly
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
        elevation: 8,
        shadowColor: const Color(
          0xFF00D2FF,
        ).withValues(alpha: 0.4), // Glowing cyan
      ),
    ),
  );
}
