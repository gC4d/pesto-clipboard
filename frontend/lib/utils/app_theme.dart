import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Utility class for defining the application theme with minimal elegant styling
class AppTheme {
  // Minimal Elegant theme colors
  static const Color lightBackground = Color(0xFFF7F7F7); // Fundo cinza bem claro
  static const Color lightSurface = Color(0xFFFFFFFF); // Surface
  static const Color lightOnBackground = Color(0xFF1A1A1A); // Texto quase preto
  static const Color lightOnSurface = Color(0xFF1A1A1A); // Texto quase preto
  static const Color lightPrimary = Color(0xFF6B8E23); // Verde oliva
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // Texto branco no verde
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF1C1C1C); // Fundo cinza grafite
  static const Color darkSurface = Color(0xFF2A2A2A); // Surface
  static const Color darkOnBackground = Color(0xFFEAEAEA); // Texto off-white
  static const Color darkOnSurface = Color(0xFFEAEAEA); // Texto off-white
  static const Color darkPrimary = Color(0xFF98C379); // Verde oliva mais forte
  static const Color darkOnPrimary = Color(0xFF000000); // Texto preto no verde
  
  // Error colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);
  
  /// Get the light theme for the application
  static ThemeData lightTheme() {
    final baseTheme = ThemeData.light();
    
    // Define minimal elegant color scheme
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimary,
      onPrimary: lightOnPrimary,
      primaryContainer: lightPrimary.withOpacity(0.1),
      onPrimaryContainer: lightPrimary,
      secondary: lightPrimary,
      onSecondary: lightOnPrimary,
      secondaryContainer: lightPrimary.withOpacity(0.1),
      onSecondaryContainer: lightPrimary,
      tertiary: lightPrimary,
      onTertiary: lightOnPrimary,
      error: error,
      onError: onError,
      background: lightBackground,
      onBackground: lightOnBackground,
      surface: lightSurface,
      onSurface: lightOnSurface,
      surfaceVariant: lightBackground,
      onSurfaceVariant: lightOnBackground,
      outline: lightOnBackground.withOpacity(0.1),
      shadow: Colors.black,
      inverseSurface: darkSurface,
      onInverseSurface: darkOnSurface,
      inversePrimary: darkPrimary,
    );
    
    // Create text theme with Google Fonts - Using Poppins for modern look
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: colorScheme.surface,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 0.5,
        indent: 0,
        endIndent: 0,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
    );
  }

  /// Get the dark theme for the application
  static ThemeData darkTheme() {
    final baseTheme = ThemeData.dark();
    
    // Define minimal elegant dark color scheme
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: darkOnPrimary,
      primaryContainer: darkPrimary.withOpacity(0.1),
      onPrimaryContainer: darkPrimary,
      secondary: darkPrimary,
      onSecondary: darkOnPrimary,
      secondaryContainer: darkPrimary.withOpacity(0.1),
      onSecondaryContainer: darkPrimary,
      tertiary: darkPrimary,
      onTertiary: darkOnPrimary,
      error: error,
      onError: onError,
      background: darkBackground,
      onBackground: darkOnBackground,
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceVariant: darkBackground,
      onSurfaceVariant: darkOnBackground,
      outline: darkOnBackground.withOpacity(0.1),
      shadow: Colors.black,
      inverseSurface: lightSurface,
      onInverseSurface: lightOnSurface,
      inversePrimary: lightPrimary,
    );
    
    // Create text theme with Google Fonts
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: colorScheme.surface,
        surfaceTintColor: Colors.black.withOpacity(0.1),
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 0.5,
        indent: 0,
        endIndent: 0,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
    );
  }
}
