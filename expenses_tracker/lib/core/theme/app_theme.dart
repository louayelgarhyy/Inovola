import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF4C6FFF);
  static const Color secondaryBlue = Color(0xFF6B8AFF);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  
  // Income & Expense Colors
  static const Color incomeColor = Color(0xFF4CAF50);
  static const Color expenseColor = Color(0xFFFF5252);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Category Colors
  static const Color categoryGroceries = Color(0xFF6B8AFF);
  static const Color categoryEntertainment = Color(0xFFFFB74D);
  static const Color categoryTransport = Color(0xFF9C27B0);
  static const Color categoryRent = Color(0xFFFF8A65);
  static const Color categoryGas = Color(0xFFE57373);
  static const Color categoryShopping = Color(0xFFFFD54F);
  
  // Utility Colors
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  static ColorScheme get colorScheme => const ColorScheme.light(
    primary: primaryBlue,
    secondary: secondaryBlue,
    surface: cardBackground,
    error: errorColor,
  );
  
  // Border Radius
  static BorderRadius cardRadius = BorderRadius.circular(16);
  static BorderRadius buttonRadius = BorderRadius.circular(12);
  static BorderRadius smallRadius = BorderRadius.circular(8);
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
