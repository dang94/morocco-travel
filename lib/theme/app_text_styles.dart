import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const _displayFamily = 'Montserrat';
  static const _bodyFamily = 'Inter';

  static TextStyle get display => const TextStyle(
        fontFamily: _displayFamily,
        fontFamilyFallback: [_bodyFamily, 'sans-serif'],
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -0.96,
        color: AppColors.textPrimary,
      );

  static TextStyle get dataDisplay => const TextStyle(
        fontFamily: _displayFamily,
        fontFamilyFallback: [_bodyFamily, 'sans-serif'],
        fontSize: 64,
        fontWeight: FontWeight.w300,
        height: 1,
        letterSpacing: -2.56,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingLarge => const TextStyle(
        fontFamily: _displayFamily,
        fontFamilyFallback: [_bodyFamily, 'sans-serif'],
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontFamily: _displayFamily,
        fontFamilyFallback: [_bodyFamily, 'sans-serif'],
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: _bodyFamily,
        fontFamilyFallback: [_displayFamily, 'sans-serif'],
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: _bodyFamily,
        fontFamilyFallback: [_displayFamily, 'sans-serif'],
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelCaps => const TextStyle(
        fontFamily: _bodyFamily,
        fontFamilyFallback: [_displayFamily, 'sans-serif'],
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.96,
        color: AppColors.textMuted,
      );

  static TextStyle get button => const TextStyle(
        fontFamily: _displayFamily,
        fontFamilyFallback: [_bodyFamily, 'sans-serif'],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
      );
}
