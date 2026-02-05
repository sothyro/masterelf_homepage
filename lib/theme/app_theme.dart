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

  // Dark palette (rich darks for depth and glassmorphism)
  static const Color backgroundDark = Color(0xFF0A0A0C);
  static const Color surfaceElevatedDark = Color(0xFF1A1A1E);
  static const Color overlayDark = Color(0xFF0D0D0F);
  static const Color borderDark = Color(0xFF2A2A2E);
  static const Color borderLight = Color(0xFFC9A227); // gold, for glass border
  static const Color accentGlow = Color(0xFFC9A227); // use with alpha for shadows

  /// Muted text on dark backgrounds (WCAG AA–compliant on surfaceDark/backgroundDark).
  static const Color onSurfaceVariantDark = Color(0xFFB5B5B5);
}

/// Layered shadow system for cards, header, dialogs, and accent CTAs.
/// Cached as static final to avoid allocating new lists on every access.
class AppShadows {
  AppShadows._();

  static const double _blurCard = 12;
  static const double _blurCardHover = 20;
  static const double _blurHeader = 16;
  static const double _blurDialog = 24;
  static const double _blurStickyCta = 16;
  static const double _blurAccent = 12;

  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: _blurCard,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: _blurCard * 2,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> cardHover = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: _blurCardHover,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: _blurCardHover * 1.5,
      offset: const Offset(0, 3),
    ),
  ];

  static final List<BoxShadow> header = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: _blurHeader,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> dialog = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: _blurDialog,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: _blurDialog * 1.5,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> stickyCta = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: _blurStickyCta,
      offset: const Offset(-2, 0),
    ),
    BoxShadow(
      color: AppColors.accentGlow.withValues(alpha: 0.2),
      blurRadius: _blurStickyCta,
      offset: const Offset(-2, 0),
    ),
  ];

  static final List<BoxShadow> accentButton = [
    BoxShadow(
      color: AppColors.accentGlow.withValues(alpha: 0.4),
      blurRadius: _blurAccent,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: _blurAccent,
      offset: const Offset(0, 2),
    ),
  ];
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

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        surface: AppColors.surfaceElevatedDark,
        onSurface: AppColors.onPrimary,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,
        surfaceContainerHighest: AppColors.surfaceDark,
        error: AppColors.error,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      focusColor: AppColors.accent.withValues(alpha: 0.4),
      hoverColor: AppColors.accent.withValues(alpha: 0.12),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      // For accent glow on primary CTAs, wrap FilledButtons in a Container with boxShadow: AppShadows.accentButton.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
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
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.accent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.accent.withValues(alpha: 0.12);
            }
            if (states.contains(WidgetState.focused)) {
              return AppColors.accent.withValues(alpha: 0.25);
            }
            return null;
          }),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceElevatedDark,
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
