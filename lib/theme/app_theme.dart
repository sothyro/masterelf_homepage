import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Master Elf brand colors (Joey Yap–style: dark, gold accent).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFFC9A227); // gold
  static const Color accentLight = Color(0xFFE5D4A1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0D0D0D);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onAccent = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFF666666);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        outline: AppColors.onSurfaceVariant,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
              return AppColors.onAccent.withValues(alpha: 0.15);
            }
            return null;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.accent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surface,
      ),
    );
  }
}

/// Font families by locale. Used by [AppTypography].
class AppFonts {
  AppFonts._();

  static const String enHeading = 'Exo 2';
  static const String enBody = 'Exo 2';
  static const String kmHeading = 'Dangrek';
  static const String kmBody = 'Siemreap';
  static const String zhHeading = 'Noto Sans SC';
  static const String zhBody = 'Noto Sans SC';

  static String headingFamily(String languageCode) {
    switch (languageCode) {
      case 'km':
        return kmHeading;
      case 'zh':
        return zhHeading;
      default:
        return enHeading;
    }
  }

  static String bodyFamily(String languageCode) {
    switch (languageCode) {
      case 'km':
        return kmBody;
      case 'zh':
        return zhBody;
      default:
        return enBody;
    }
  }
}

/// Builds a [TextTheme] for the given language code (EN/KM/ZH).
TextTheme textThemeForLocale(String languageCode) {
  final headingFamily = AppFonts.headingFamily(languageCode);
  final bodyFamily = AppFonts.bodyFamily(languageCode);

  TextStyle headingStyle(double size, FontWeight w) {
    switch (headingFamily) {
      case 'Dangrek':
        return GoogleFonts.dangrek(fontSize: size, fontWeight: w);
      case 'Noto Sans SC':
        return GoogleFonts.notoSansSc(fontSize: size, fontWeight: w);
      default:
        return GoogleFonts.exo2(fontSize: size, fontWeight: w);
    }
  }

  TextStyle bodyStyle(double size, FontWeight w) {
    switch (bodyFamily) {
      case 'Siemreap':
        return GoogleFonts.siemreap(fontSize: size, fontWeight: w);
      case 'Noto Sans SC':
        return GoogleFonts.notoSansSc(fontSize: size, fontWeight: w);
      default:
        return GoogleFonts.exo2(fontSize: size, fontWeight: w);
    }
  }

  return TextTheme(
    displayLarge: headingStyle(57, FontWeight.w400),
    displayMedium: headingStyle(45, FontWeight.w400),
    displaySmall: headingStyle(36, FontWeight.w400),
    headlineLarge: headingStyle(32, FontWeight.w600),
    headlineMedium: headingStyle(28, FontWeight.w600),
    headlineSmall: headingStyle(24, FontWeight.w600),
    titleLarge: headingStyle(22, FontWeight.w600),
    titleMedium: bodyStyle(16, FontWeight.w600),
    titleSmall: bodyStyle(14, FontWeight.w600),
    bodyLarge: bodyStyle(16, FontWeight.w400),
    bodyMedium: bodyStyle(14, FontWeight.w400),
    bodySmall: bodyStyle(12, FontWeight.w400),
    labelLarge: bodyStyle(14, FontWeight.w500),
    labelMedium: bodyStyle(12, FontWeight.w500),
    labelSmall: bodyStyle(11, FontWeight.w500),
  );
}

/// Typography that respects locale (EN: Exo 2, KM: Dangrek/Siemreap, ZH: Noto Sans SC).
TextStyle textStyleWithLocale(
  BuildContext context, {
  required bool isHeading,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  final locale = Localizations.localeOf(context);
  final lang = locale.languageCode;
  final family = isHeading ? AppFonts.headingFamily(lang) : AppFonts.bodyFamily(lang);

  TextStyle base;
  switch (family) {
    case 'Dangrek':
      base = GoogleFonts.dangrek(fontSize: fontSize, fontWeight: fontWeight);
      break;
    case 'Siemreap':
      base = GoogleFonts.siemreap(fontSize: fontSize, fontWeight: fontWeight);
      break;
    case 'Noto Sans SC':
      base = GoogleFonts.notoSansSc(fontSize: fontSize, fontWeight: fontWeight);
      break;
    default:
      base = GoogleFonts.exo2(fontSize: fontSize, fontWeight: fontWeight);
  }
  if (color != null) base = base.copyWith(color: color);
  return base;
}
