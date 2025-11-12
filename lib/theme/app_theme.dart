import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: BrandColors.primary,
      primary: BrandColors.primary,
      secondary: BrandColors.secondary,
      tertiary: BrandColors.accent,
    );

    final colorScheme = baseScheme.copyWith(
      background: BrandColors.background,
      onBackground: BrandColors.textPrimary,
      surface: BrandColors.surface,
      onSurface: BrandColors.textPrimary,
      surfaceVariant: BrandColors.surfaceAlt,
      onSurfaceVariant: BrandColors.textSecondary,
      primaryContainer: BrandColors.primaryBright,
      secondaryContainer: BrandColors.secondaryBright,
      tertiaryContainer: BrandColors.accentBright,
      onPrimary: BrandColors.textPrimary,
      onSecondary: BrandColors.textPrimary,
      onTertiary: BrandColors.textPrimary,
      error: BrandColors.error,
      onError: BrandColors.textPrimary,
      outline: BrandColors.outline,
      outlineVariant: BrandColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BrandColors.scaffold,
      canvasColor: BrandColors.background,
      dialogBackgroundColor: BrandColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: BrandColors.scaffold,
        foregroundColor: BrandColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: BrandColors.textPrimary,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: BrandColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: BrandColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: BrandColors.textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: BrandColors.textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: BrandColors.textPrimary,
          letterSpacing: 1.2,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: BrandColors.textPrimary,
          letterSpacing: 1.1,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: BrandColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: BrandColors.accentBright, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: BrandColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: BrandColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: BrandColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: BrandColors.textMuted,
          fontWeight: FontWeight.w400,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        prefixIconColor: BrandColors.textMuted,
        suffixIconColor: BrandColors.textMuted,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.primary,
          foregroundColor: BrandColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 8;
              if (states.contains(MaterialState.hovered)) return 4;
              return 0;
            },
          ),
          shadowColor: MaterialStateProperty.all(BrandColors.accentSoft),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.primary,
          foregroundColor: BrandColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 8;
              if (states.contains(MaterialState.hovered)) return 4;
              return 2;
            },
          ),
          shadowColor: MaterialStateProperty.all(BrandColors.accentSoft),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.accentBright,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: BrandColors.accentBright,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: BrandColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: IconThemeData(
        color: BrandColors.textPrimary,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: BrandColors.divider,
        thickness: 1,
      ),
    );
  }

  static BoxDecoration neuromorphicDecoration({
    Color? color,
    double borderRadius = 20,
    bool isPressed = false,
  }) {
    final baseColor = color ?? BrandColors.surface;
    final glowOpacity = isPressed ? 0.2 : 0.12;
    return BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: BrandColors.accent.withOpacity(glowOpacity),
          blurRadius: isPressed ? 12 : 20,
          spreadRadius: isPressed ? -2 : -5,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration inputFocusDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: BrandColors.accent.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration inputDecoration({
    bool isFocused = false,
    Color? color,
    double borderRadius = 20,
  }) {
    final List<BoxShadow> shadows = [
      BoxShadow(
        color: BrandColors.accent.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: -5,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];

    if (isFocused) {
      shadows.insert(
        0,
        BoxShadow(
          color: BrandColors.accent.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      );
    }

    return BoxDecoration(
      color: color ?? BrandColors.surfaceAlt,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows,
    );
  }
}
