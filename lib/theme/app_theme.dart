import 'package:flutter/material.dart';

/// Design System Theme Configuration
/// Based on DESIGN.md specifications
class AppTheme {
  // Border Radius
  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;

  // Spacing
  static const double space1 = 8;
  static const double space2 = 16;
  static const double space3 = 24;
  static const double space4 = 32;

  // Shadow helpers
  static List<BoxShadow> shadowPlayful(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          offset: const Offset(0, 0),
          blurRadius: 8,
          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
        ),
      ];
    }
    return const [
      BoxShadow(
        offset: Offset(6, 0),
        blurRadius: 0,
        color: Color(0xFFD1D5DB),
      ),
    ];
  }

  static List<BoxShadow> shadowFocus(Color primaryColor) {
    return [
      BoxShadow(
        offset: const Offset(0, 0),
        blurRadius: 4,
        color: primaryColor.withValues(alpha: 0.35),
      ),
    ];
  }

  // Light Theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFEF4444),
      primary: const Color(0xFFEF4444),
      secondary: const Color(0xFF3B82F6),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF1F2937),
      onSurfaceVariant: const Color(0xFF9CA3AF),
      error: const Color(0xFFEF4444),
      outline: const Color(0xFFE5E7EB),
      surfaceContainerHighest: const Color(0xFFF9FAFB),
    );

    return _buildTheme(colorScheme);
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFEF4444),
      brightness: Brightness.dark,
      primary: const Color(0xFFEF4444),
      secondary: const Color(0xFF3B82F6),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFE5E7EB),
      onSurfaceVariant: const Color(0xFF6B7280),
      error: const Color(0xFFEF4444),
      outline: const Color(0xFF3B3B3B),
      surfaceContainerHighest: const Color(0xFF1E1E1E),
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: colorScheme.outline, width: 2),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
      ),
    );
  }

  // Custom decorators
  static BoxDecoration cardDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(color: colorScheme.outline, width: 2),
      boxShadow: shadowPlayful(colorScheme.brightness),
    );
  }
}
