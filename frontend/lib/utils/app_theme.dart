import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Utility class for defining the application theme with Windows 11 styling
class AppTheme {
  // Windows 11 color palette
  static const win11Blue = Color(0xFF0078D7);
  static const win11LightBlue = Color(0xFF429CE3);
  static const win11AccentBlue = Color(0xFF0063B1);
  static const win11Background = Color(0xFFF6F8FC);
  static const win11CardBackground = Color(0xFFFFFFFF);
  static const win11Divider = Color(0xFFE1E5EA);
  
  /// Get the light theme for the application
  static ThemeData lightTheme() {
    final baseTheme = ThemeData.light();
    
    // Define Windows 11-style color scheme
    final colorScheme = ColorScheme.fromSeed(
      seedColor: win11Blue,
      brightness: Brightness.light,
      primary: win11Blue,
      secondary: win11LightBlue,
      tertiary: win11AccentBlue,
      surface: win11CardBackground,
      background: win11Background,
      error: Colors.red.shade700,
    );
    
    // Create text theme with Google Fonts - Segoe UI is Windows 11's font
    // but we'll use Inter which is similar and available in Google Fonts
    final textTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      // Windows 11 uses subtle app bars that blend with content
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      // Windows 11 uses very rounded corners for cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Windows 11 buttons have rounded corners and subtle elevation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      // Windows 11 outlined buttons are very subtle
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dividerTheme: const DividerThemeData(
        indent: 24,
        endIndent: 24,
        thickness: 1,
      ),
    );
  }

  /// Get the dark theme for the application
  static ThemeData darkTheme() {
    final baseTheme = ThemeData.dark();
    
    // Define color scheme
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.tealAccent,
      brightness: Brightness.dark,
      primary: Colors.tealAccent,
      secondary: Colors.blueAccent,
      tertiary: Colors.deepPurpleAccent,
      error: Colors.redAccent,
    );
    
    // Create text theme with Google Fonts
    final textTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceVariant,
        foregroundColor: colorScheme.onSurfaceVariant,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dividerTheme: const DividerThemeData(
        indent: 24,
        endIndent: 24,
        thickness: 1,
      ),
    );
  }
}
