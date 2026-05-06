import 'package:flutter/material.dart';

/// Bright, vibrant color scheme for CineHub
class AppColors {
  // Primary brand colors - Bright Cyan/Blue
  static const Color primary = Color(0xFF00D9FF); // Bright Cyan
  static const Color primaryLight = Color(0xFF66E8FF);
  static const Color primaryDark = Color(0xFF00A8CC);

  // Secondary - Bright Purple/Magenta
  static const Color secondary = Color(0xFFFF006E); // Bright Magenta
  static const Color secondaryLight = Color(0xFFFF4D8C);

  // Bright palette - Light backgrounds
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Color(0xFFFFFFFF);   // White
  static const Color surfaceAlt = Color(0xFFF5F5F5); // Light gray
  static const Color surfaceHover = Color(0xFFEEEEEE); // Hover gray

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textTertiary = Color(0xFF888888);
  static const Color textHint = Color(0xFFB0B0B0);

  // Semantic colors - Bright versions
  static const Color success = Color(0xFF00D084); // Bright Green
  static const Color error = Color(0xFFFF3B30);   // Bright Red
  static const Color warning = Color(0xFFFFB800); // Bright Orange
  static const Color info = Color(0xFF007AFF);    // Bright Blue

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFF0F0F0);

  // Overlay
  static const Color overlay = Color(0x00000000);
  static const Color overlayDark = Color(0x3F000000);
}

/// Modern, bold typography - Fireship-style design
class AppTypography {
  // Heading styles - Large & Bold
  static const TextStyle headline1 = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.43,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textTertiary,
  );

  // Caption styles
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textSecondary,
  );
}

/// Spacing & Layout constants
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

/// Border radius values
class AppRadii {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double full = 9999;
}

/// Shadows for depth and elevation
class AppShadows {
  static const BoxShadow xs = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const BoxShadow sm = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow xl = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 20,
    offset: Offset(0, 8),
  );

  static const List<BoxShadow> elevation1 = [xs];
  static const List<BoxShadow> elevation2 = [sm];
  static const List<BoxShadow> elevation3 = [md];
  static const List<BoxShadow> elevation4 = [lg];
  static const List<BoxShadow> elevation5 = [xl];
}

/// Create the complete theme (Bright, vibrant light theme)
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.background,

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.headline4,
    ),

    // Text themes
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1,
      displayMedium: AppTypography.headline2,
      displaySmall: AppTypography.headline3,
      headlineSmall: AppTypography.headline4,
      titleLarge: AppTypography.bodyLarge,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textHint,
      ),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceAlt,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.border,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelStyle: AppTypography.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.full),
      ),
    ),

    // TabBar theme
    tabBarTheme: TabBarThemeData(
      labelStyle: AppTypography.labelMedium,
      unselectedLabelStyle: AppTypography.labelMedium,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 3,
        ),
      ),
    ),
  );
}
