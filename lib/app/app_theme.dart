import 'package:flutter/material.dart';

class AppTheme {
  // 🌙 Hardcore Gym Theme (Dark Mode ONLY)
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF070707), // Almost pitch black
    primaryColor: const Color(0xFF39FF14), // Neon Toxic Green (Very aggressive)

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF39FF14), // Neon Green
      secondary: Color(0xFFFF003C), // Cyberpunk Red (for stop/cancel buttons)
      surface: Color(0xFF121212), // Slightly lighter black for cards/containers
    ),

    cardColor: const Color(0xFF121212),

    // Massive, aggressive text styling
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 120, // For the giant pushup counter
        fontWeight: FontWeight.w900,
        letterSpacing: -2.0,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18),
      bodyMedium: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
    ),

    // Sleek, clean and simple primary buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Plain sleek white
        foregroundColor: Colors.black, // Dark text
        minimumSize: const Size(double.infinity, 65), // Huge height
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: 1.5,
        ),
        elevation: 0,
        shadowColor: Colors.transparent, // No glow
      ),
    ),
  );
}
