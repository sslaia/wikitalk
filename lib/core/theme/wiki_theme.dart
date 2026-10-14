import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wikipedia Codex-inspired Theme & Design System for Wiki Talk.
class WikiTheme {
  // Brand colors
  static const Color wikiBlue = Color(0xFF3366CC);
  static const Color wikiBlueDark = Color(0xFF447FF5);
  static const Color wikiRed = Color(0xFFD33D33);
  static const Color wikiGreen = Color(0xFF00AF89);
  static const Color wikiYellow = Color(0xFFFFCC33);

  // Light Mode Colors (Codex Light)
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEAECF0);
  static const Color lightBorder = Color(0xFFC8CCD1);
  static const Color lightTextPrimary = Color(0xFF202122);
  static const Color lightTextSecondary = Color(0xFF54595D);

  // Dark Mode Colors (Codex Dark)
  static const Color darkBg = Color(0xFF101418);
  static const Color darkSurface = Color(0xFF202122);
  static const Color darkSurfaceVariant = Color(0xFF2A2B2E);
  static const Color darkBorder = Color(0xFF3C4043);
  static const Color darkTextPrimary = Color(0xFFEAECF0);
  static const Color darkTextSecondary = Color(0xFFA2A9B1);

  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: wikiBlue,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFEAF3FF),
        onPrimaryContainer: Color(0xFF0C3278),
        surface: lightSurface,
        onSurface: lightTextPrimary,
        surfaceContainerHighest: lightSurfaceVariant,
        outline: lightBorder,
        outlineVariant: Color(0xFFEAECF0),
        error: wikiRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: lightBorder, width: 0.8)),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: lightBorder, width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 0.8,
        space: 1,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.literata(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleMedium: GoogleFonts.literata(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: lightTextPrimary,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: lightTextSecondary,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: wikiBlueDark,
        onPrimary: Color(0xFF001E4D),
        primaryContainer: Color(0xFF1B3B6F),
        onPrimaryContainer: Color(0xFFD6E3FF),
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceContainerHighest: darkSurfaceVariant,
        outline: darkBorder,
        outlineVariant: Color(0xFF2A2B2E),
        error: Color(0xFFFFB4AB),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: darkBorder, width: 0.8)),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: darkBorder, width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 0.8,
        space: 1,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.literata(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleMedium: GoogleFonts.literata(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: darkTextPrimary,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: darkTextSecondary,
        ),
      ),
    );
  }
}
