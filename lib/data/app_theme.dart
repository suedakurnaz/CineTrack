import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg       = Color(0xFF0D0F14);
  static const Color surface  = Color(0xFF161820);
  static const Color elevated = Color(0xFF1E2028);
  static const Color card     = Color(0xFF1A1C24);
  static const Color border   = Color(0xFF2A2C38);

  static const Color primary     = Color(0xFFE8B84B);  // altın sarısı
  static const Color primaryDim  = Color(0x33E8B84B);
  static const Color accent      = Color(0xFF4F63D2);
  static const Color accentDim   = Color(0x334F63D2);
  static const Color red         = Color(0xFFE84855);
  static const Color green       = Color(0xFF2ECC71);

  static const Color text1   = Color(0xFFEDEDEF);
  static const Color text2   = Color(0xFF8B8B9A);
  static const Color text3   = Color(0xFF4A4A57);

  static const Color star    = Color(0xFFE8B84B);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surface,
      background: bg,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      foregroundColor: text1,
      elevation: 0,
      scrolledUnderElevation: 0,
      // Ensure no hairline divider or shadow is drawn under the AppBar
      shadowColor: Colors.transparent,
      surfaceTintColor: bg,
      titleTextStyle: TextStyle(
        color: text1,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
  );
}
