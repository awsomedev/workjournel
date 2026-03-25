import 'package:flutter/material.dart';

enum ResponsiveSize { sm, md, lg }

class AppBreakpoints {
  static const double smMax = 600;
  static const double mdMax = 1024;
  static const double desktopMinWidth = 375;

  static ResponsiveSize fromWidth(double width) {
    if (width < smMax) {
      return ResponsiveSize.sm;
    }
    if (width < mdMax) {
      return ResponsiveSize.md;
    }
    return ResponsiveSize.lg;
  }
}

class AppColors {
  static const Color primary = Color(0xFFBCFF5F);
  static const Color primaryContainer = Color(0xFF3D6100);
  static const Color primaryDim = Color(0xFF95E400);
  static const Color secondary = Color(0xFF00FBFB);
  static const Color secondaryContainer = Color(0xFF006A6A);
  static const Color onSecondary = Color(0xFF005C5C);
  static const Color surface = Color(0xFF0E0E0E);
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow = Color(0xFF141414);
  static const Color surfaceContainer = Color(0xFF191919);
  static const Color surfaceContainerHigh = Color(0xFF1F1F1F);
  static const Color surfaceContainerHighest = Color(0xFF262626);
  static const Color surfaceBright = Color(0xFF2C2C2C);
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color onSurfaceVariant = Color(0xFFABABAB);
  static const Color outlineVariant = Color(0xFF484848);
}

class AppFonts {
  static const String plusJakartaSansFamily = 'PlusJakartaSans';
  static const String lexendFamily = 'Lexend';

  static TextStyle plusJakartaSans({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: plusJakartaSansFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
    );
  }

  static TextStyle lexend({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: lexendFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
    );
  }
}

extension AppTextStyles on TextStyle {
  static TextStyle get h1 => AppFonts.plusJakartaSans(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.04 * 72,
    color: Colors.white,
    height: 1.1,
  );

  static TextStyle get h2 => AppFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle get displaySm => AppFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle get bodyMd => AppFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get bodySm => AppFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get labelMd => AppFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle get labelSm => AppFonts.lexend(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
