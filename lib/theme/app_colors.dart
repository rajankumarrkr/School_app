import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Deep Navy / Royal Blue for military & academic prestige)
  static const Color primaryNavy = Color(0xFF0F243E);
  static const Color primaryNavyDark = Color(0xFF081626);
  static const Color primaryNavyLight = Color(0xFF1E3A5F);

  // Secondary & Accents
  static const Color accentBlue = Color(0xFF2563EB); // Vibrant actionable blue
  static const Color accentBlueLight = Color(0xFF3B82F6);
  static const Color accentGold = Color(0xFFD97706); // Honor & Medal gold
  static const Color accentGoldLight = Color(0xFFFBBF24);

  // Status & Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald green (Present, Completed, High Grade)
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B); // Amber (Pending, Holiday, Due soon)
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444); // Crimson (Absent, Overdue, Critical)
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF0EA5E9); // Sky blue
  static const Color infoLight = Color(0xFFF0F9FF);

  // Neutral & Background Surfaces
  static const Color background = Color(0xFFF8FAFC); // Clean slate background
  static const Color surface = Color(0xFFFFFFFF); // Pure white cards
  static const Color surfaceSecondary = Color(0xFFF1F5F9); // Light gray-blue surface
  static const Color surfaceSubtle = Color(0xFFE2E8F0); // Subtle borders & dividers

  // Typography & Content Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textOnNavy = Color(0xFFFFFFFF);
  static const Color textOnNavySubtle = Color(0xFF93C5FD);

  // Subject Pill Backgrounds
  static const Color mathColor = Color(0xFF6366F1);
  static const Color physicsColor = Color(0xFF0EA5E9);
  static const Color chemistryColor = Color(0xFFEC4899);
  static const Color biologyColor = Color(0xFF10B981);
  static const Color englishColor = Color(0xFF8B5CF6);
  static const Color computerColor = Color(0xFF14B8A6);
  static const Color sportsColor = Color(0xFFF97316);
  static const Color hindiColor = Color(0xFFE11D48);

  // Gradients
  static const LinearGradient navyHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F243E),
      Color(0xFF1E3A5F),
      Color(0xFF152C4A),
    ],
  );

  static const LinearGradient accentCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD97706),
      Color(0xFFB45309),
    ],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );
}
