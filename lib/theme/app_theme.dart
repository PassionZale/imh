import 'package:flutter/material.dart';

/// Design System Theme Configuration
class AppTheme {
  // Spacing Tokens (8px grid)
  static const spacing = (xs: 4.0, sm: 8.0, md: 16.0, lg: 24.0, xl: 32.0, xxl: 48.0);

  // Radius Tokens
  static const radius = (sm: 8.0, md: 12.0, lg: 16.0);

  // Shadow helpers
  static List<BoxShadow> shadowPlayful(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          offset: const Offset(0, 0),
          blurRadius: 8,
          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
        ),
      ];
    }
    return const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 10,
        color: Color(0x0A000000), // black@4%
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

  // Typography
  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF4F46E5),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE0E7FF),
      onPrimaryContainer: const Color(0xFF312E81),
      secondary: const Color(0xFF0EA5E9),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE0F2FE),
      onSecondaryContainer: const Color(0xFF0C4A6E),
      tertiary: const Color(0xFFEC4899),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFFCE7F3),
      onTertiaryContainer: const Color(0xFF831843),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      surface: const Color(0xFFFAFAFC),
      onSurface: const Color(0xFF1F2937),
      surfaceContainerHighest: const Color(0xFFF1F5F9),
      onSurfaceVariant: const Color(0xFF6B7280),
      outline: const Color(0xFFE5E7EB),
      outlineVariant: const Color(0xFFD1D5DB),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFF1F2937),
      onInverseSurface: const Color(0xFFF9FAFB),
    );

    return _buildTheme(colorScheme);
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF6366F1),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF4338CA),
      onPrimaryContainer: const Color(0xFFE0E7FF),
      secondary: const Color(0xFF22D3EE),
      onSecondary: const Color(0xFF083344),
      secondaryContainer: const Color(0xFF164E63),
      onSecondaryContainer: const Color(0xFFCFFAFE),
      tertiary: const Color(0xFFF472B6),
      onTertiary: const Color(0xFF500724),
      tertiaryContainer: const Color(0xFF831843),
      onTertiaryContainer: const Color(0xFFFCE7F3),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      surface: const Color(0xFF0F0F14),
      onSurface: const Color(0xFFE5E7EB),
      surfaceContainerHighest: const Color(0xFF1A1A23),
      onSurfaceVariant: const Color(0xFF9CA3AF),
      outline: const Color(0xFF2D2D3D),
      outlineVariant: const Color(0xFF3B3B3B),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFFE5E7EB),
      onInverseSurface: const Color(0xFF1F2937),
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _textTheme.apply(displayColor: colorScheme.onSurface, bodyColor: colorScheme.onSurface),

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
          borderRadius: BorderRadius.circular(radius.md),
          side: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
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
        type: BottomNavigationBarType.fixed,
        elevation: 0,
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
      borderRadius: BorderRadius.circular(radius.md),
      border: Border.all(color: colorScheme.outline, width: 1.5),
      boxShadow: shadowPlayful(colorScheme.brightness),
    );
  }
}
