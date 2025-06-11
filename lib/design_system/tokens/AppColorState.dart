import 'package:flutter/material.dart';

class AppColorsState {
  final bool isDarkMode;

  const AppColorsState({required this.isDarkMode});

  Color get neutral0 => isDarkMode ? const Color(0xFF121212) : const Color(0xFFFFFFFF);
  Color get neutral10 => isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
  Color get neutral25 => isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
  Color get neutral50 => isDarkMode ? const Color(0xFF555555) : const Color(0xFF9E9E9E);
  Color get neutral75 => isDarkMode ? const Color(0xFF999999) : const Color(0xFF666666);
  Color get neutral100 => isDarkMode ? const Color(0xFFE0E0E0) : const Color(0xFF191919);

  // Primary
  Color get primary100 => isDarkMode ? const Color(0xFF1DB954) : const Color(0xFF14903F);

  // Secondary
  Color get secondary90 => isDarkMode ? const Color(0xFF005BB5) : const Color(0xFF4AA9F5);
  Color get secondary200 => isDarkMode ? const Color(0xFF003377) : const Color(0xFF0D47A1);
}
