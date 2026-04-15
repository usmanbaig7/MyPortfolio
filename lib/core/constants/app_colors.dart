import 'package:flutter/material.dart';

/// Named color constants used throughout the application.
/// Centralising colors here ensures a consistent design language.
class AppColors {
  AppColors._();

  /// Deep navy — primary background
  static const Color background = Color(0xFF0A0E1A);

  /// Slightly lighter navy — card & surface backgrounds
  static const Color cardBackground = Color(0xFF12172B);

  /// Purple accent — primary interactive color
  static const Color accent = Color(0xFF6C63FF);

  /// Lighter purple — secondary accent, chip labels
  static const Color accentLight = Color(0xFF9D97FF);

  /// Primary text (white)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text (muted)
  static const Color textSecondary = Color(0xFFB0B7C3);

  /// Divider / border lines
  static const Color divider = Color(0xFF1E2640);

  /// Chip backgrounds
  static const Color chipBackground = Color(0xFF1A2035);

  /// Semi-transparent shadow used for glow effects
  static const Color shadow = Color(0x406C63FF);
}
