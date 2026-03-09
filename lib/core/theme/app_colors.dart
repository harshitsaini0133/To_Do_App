import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF22C55E);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF1F5F9);
  static const Color completed = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0EA5E9);
  static const Color shadow = Color(0x160F172A);
  static const Color glassStroke = Color(0x66FFFFFF);
  static const Color glassFill = Color(0xCCFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFF4F3FF),
      Color(0xFFEFF6FF),
    ],
  );

  static const LinearGradient darkOverlayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF312E81),
      Color(0xFF4C1D95),
    ],
  );

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: shadow,
      blurRadius: 32,
      offset: Offset(0, 18),
    ),
  ];
}
