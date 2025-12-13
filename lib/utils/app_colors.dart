import 'package:flutter/material.dart';

/// App Colors - Extracted from Figma Design
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4169E1); // Royal Blue
  static const Color primaryDark = Color(0xFF2952CC);
  static const Color primaryLight = Color(0xFF6B8AFF);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald Green
  static const Color secondaryDark = Color(0xFF059669);
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green for "Helped"
  static const Color urgent = Color(0xFFEF4444); // Red for "Needy"
  static const Color upcoming = Color(0xFF8B5CF6); // Purple for "Upcoming"
  static const Color warning = Color(0xFFF59E0B); // Orange for warnings
  
  // Gradient Colors
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4169E1), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Border & Divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);
  
  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFF4169E1), // Blue
    'Medical': Color(0xFFEF4444), // Red
    'Shelter': Color(0xFFF59E0B), // Orange
    'Clothing': Color(0xFF10B981), // Green
    'Financial': Color(0xFF8B5CF6), // Purple
    'Education': Color(0xFF6366F1), // Indigo
  };
  
  // Badge Colors
  static const Color badgeGold = Color(0xFFFBBF24);
  static const Color badgeSilver = Color(0xFFD1D5DB);
  static const Color badgeBronze = Color(0xFFF97316);
  
  // Chat Colors
  static const Color chatSent = Color(0xFF4169E1);
  static const Color chatReceived = Color(0xFFF3F4F6);
  static const Color chatAnonymous = Color(0xFF8B5CF6);
  
  // Verification Badge
  static const Color verified = Color(0xFF10B981);
}
