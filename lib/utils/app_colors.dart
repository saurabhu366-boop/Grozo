// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- Core Palette from Reference Image ---
  static const Color background = Color(0xFFF7F8F5); // Soft off-white
  static const Color secondarySurface = Colors.white; // For cards, search bar

  // --- Accent & Action Colors ---
  static const Color primary = Color(0xFF2DB45D);     // Primary minty green
  static const Color highlight = Color(0xFF2DB45D);   // Same green for highlights
  static const Color accentBlack = Color(0xFF1A1A1A);   // Matte black for premium cards

  static const Color bottomBarBackground = accentBlack;

  // --- Text Colors ---
  static const Color textCharcoal = Color(0xFF222222);  // Primary text color
  static const Color textOnBlack = Color(0xFFFFFFFF);  // White text on black cards
  static const Color secondaryText = Color(0xFF868889); // Gray for hints/subtitles
  static const Color inactiveIcon = Color(0xFF9E9E9E); // Lighter gray for icons on black bg

  // --- UI Elements ---
  static const Color shadow = Color(0x1A686868);       // Soft, realistic shadow

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.12),
      blurRadius: 40,
      offset: const Offset(0, 15),
    ),
  ];
}