import 'package:flutter/material.dart';

/// Design tokens translated from the Segar "Fresh Pantry" design system.
class AppColors {
  AppColors._();

  static const surface = Color(0xFFFBF9F4);
  static const surfaceDim = Color(0xFFDBDAD5);
  static const surfaceBright = Color(0xFFFBF9F4);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF5F3EE);
  static const surfaceContainer = Color(0xFFEFEEE9);
  static const surfaceContainerHigh = Color(0xFFEAE8E3);
  static const surfaceContainerHighest = Color(0xFFE4E2DD);
  static const surfaceVariant = Color(0xFFE4E2DD);
  static const onSurface = Color(0xFF1B1C19);
  static const onSurfaceVariant = Color(0xFF3E4A3F);
  static const inverseSurface = Color(0xFF30312D);
  static const inverseOnSurface = Color(0xFFF2F1EB);
  static const outline = Color(0xFF6E7A6F);
  static const outlineVariant = Color(0xFFBDCABC);
  static const surfaceTint = Color(0xFF006D38);

  static const primary = Color(0xFF006A36);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF018646);
  static const onPrimaryContainer = Color(0xFFF6FFF4);
  static const primaryFixed = Color(0xFF8DF9AC);
  static const primaryFixedDim = Color(0xFF71DC92);
  static const onPrimaryFixed = Color(0xFF00210D);
  static const onPrimaryFixedVariant = Color(0xFF005229);

  static const secondary = Color(0xFF855300);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFEA619);
  static const onSecondaryContainer = Color(0xFF684000);
  static const secondaryFixed = Color(0xFFFFDDB8);
  static const secondaryFixedDim = Color(0xFFFFB95F);
  static const onSecondaryFixed = Color(0xFF2A1700);
  static const onSecondaryFixedVariant = Color(0xFF653E00);

  static const tertiary = Color(0xFFB1212D);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFD43C42);
  static const onTertiaryContainer = Color(0xFFFFFBFF);
  static const tertiaryFixed = Color(0xFFFFDAD8);
  static const tertiaryFixedDim = Color(0xFFFFB3B0);
  static const onTertiaryFixed = Color(0xFF410006);
  static const onTertiaryFixedVariant = Color(0xFF92011A);

  static const error = Color(0xFFBA1A1A);
  static const background = Color(0xFFFBF9F4);
  static const onBackground = Color(0xFF1B1C19);

  static const cardBorder = Color(0xFFEAEAE5);
}

/// Typography scale from the design system (Plus Jakarta Sans).
class AppText {
  AppText._();

  static const family = 'PlusJakartaSans';

  static const displayLarge = TextStyle(
    fontFamily: family,
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.64,
    color: AppColors.onSurface,
  );

  static const headlineLarge = TextStyle(
    fontFamily: family,
    fontSize: 24,
    height: 1.333,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.36,
    color: AppColors.onSurface,
  );

  static const headlineMedium = TextStyle(
    fontFamily: family,
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.onSurface,
  );

  static const headlineSmall = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 1.333,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.09,
    color: AppColors.onSurface,
  );

  static const bodyLarge = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const bodyMedium = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 1.429,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const bodySmall = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 1.333,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const labelLarge = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 1.429,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.14,
    color: AppColors.onSurface,
  );

  static const labelMedium = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 1.333,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.24,
    color: AppColors.onSurface,
  );

  static const labelSmall = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 1.273,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.22,
    color: AppColors.onSurface,
  );
}

class AppShadows {
  AppShadows._();

  static const card = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A18231C),
      blurRadius: 16,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0518231C),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(
      color: Color(0x1418231C),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A18231C),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 3),
    ),
  ];

  static const primary = <BoxShadow>[
    BoxShadow(
      color: Color(0x59006A36),
      blurRadius: 28,
      spreadRadius: -6,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x26006A36),
      blurRadius: 12,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  static const bottomBar = <BoxShadow>[
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppText.family,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,
      splashColor: AppColors.primary.withValues(alpha: 0.06),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      textTheme: const TextTheme(
        displayLarge: AppText.displayLarge,
        headlineLarge: AppText.headlineLarge,
        headlineMedium: AppText.headlineMedium,
        headlineSmall: AppText.headlineSmall,
        bodyLarge: AppText.bodyLarge,
        bodyMedium: AppText.bodyMedium,
        bodySmall: AppText.bodySmall,
        labelLarge: AppText.labelLarge,
        labelMedium: AppText.labelMedium,
        labelSmall: AppText.labelSmall,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: AppText.bodyMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
