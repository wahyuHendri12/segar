import 'package:flutter/material.dart';

/// Brand palette for Segar. Feature widgets should read colors from
/// [ThemeData.colorScheme] or [SegarColors] instead of hardcoding these.
class AppPalette {
  AppPalette._();

  static const primary = Color(0xFF2E9E5B);
  static const warning = Color(0xFFF59E0B);
  static const expired = Color(0xFFE5484D);
  static const lightSurface = Color(0xFFFAFAF7);
  static const lightOnSurface = Color(0xFF1A1A1A);
  static const darkSurface = Color(0xFF121412);
  static const darkOnSurface = Color(0xFFE8EAE6);
}

/// Extra semantic colors that are not part of Material's [ColorScheme].
@immutable
class SegarColors extends ThemeExtension<SegarColors> {
  const SegarColors({
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.expired,
    required this.onExpired,
    required this.expiredContainer,
    required this.onExpiredContainer,
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.cardBorder,
  });

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color expired;
  final Color onExpired;
  final Color expiredContainer;
  final Color onExpiredContainer;
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color cardBorder;

  static const light = SegarColors(
    warning: Color(0xFFF59E0B),
    onWarning: Color(0xFF3A2500),
    warningContainer: Color(0xFFFFF1D6),
    onWarningContainer: Color(0xFF5C3D00),
    expired: Color(0xFFE5484D),
    onExpired: Color(0xFFFFFFFF),
    expiredContainer: Color(0xFFFFE3E3),
    onExpiredContainer: Color(0xFF7A1014),
    success: Color(0xFF2E9E5B),
    successContainer: Color(0xFFDFF6E7),
    onSuccessContainer: Color(0xFF0B3D20),
    cardBorder: Color(0xFFECECE6),
  );

  static const dark = SegarColors(
    warning: Color(0xFFFFC65C),
    onWarning: Color(0xFF3A2500),
    warningContainer: Color(0xFF4A3410),
    onWarningContainer: Color(0xFFFFE3B0),
    expired: Color(0xFFFF7A7D),
    onExpired: Color(0xFF450A0C),
    expiredContainer: Color(0xFF4A1416),
    onExpiredContainer: Color(0xFFFFDAD9),
    success: Color(0xFF6FD693),
    successContainer: Color(0xFF12351F),
    onSuccessContainer: Color(0xFFC7F5D6),
    cardBorder: Color(0xFF2B302B),
  );

  @override
  SegarColors copyWith({
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? expired,
    Color? onExpired,
    Color? expiredContainer,
    Color? onExpiredContainer,
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? cardBorder,
  }) {
    return SegarColors(
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      expired: expired ?? this.expired,
      onExpired: onExpired ?? this.onExpired,
      expiredContainer: expiredContainer ?? this.expiredContainer,
      onExpiredContainer: onExpiredContainer ?? this.onExpiredContainer,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      cardBorder: cardBorder ?? this.cardBorder,
    );
  }

  @override
  SegarColors lerp(covariant SegarColors? other, double t) {
    if (other == null) return this;
    return SegarColors(
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      expired: Color.lerp(expired, other.expired, t)!,
      onExpired: Color.lerp(onExpired, other.onExpired, t)!,
      expiredContainer: Color.lerp(
        expiredContainer,
        other.expiredContainer,
        t,
      )!,
      onExpiredContainer: Color.lerp(
        onExpiredContainer,
        other.onExpiredContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
    );
  }
}

/// Spacing scale. All values are multiples of 4.
class AppSpacing {
  AppSpacing._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
}

/// Shape tokens.
class AppRadius {
  AppRadius._();

  static const button = 12.0;
  static const card = 16.0;
  static const sheet = 24.0;
  static const pill = 999.0;
}

class AppDurations {
  AppDurations._();

  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 260);
  static const slow = Duration(milliseconds: 300);
}

class AppTheme {
  AppTheme._();

  static const fontFamily = 'PlusJakartaSans';

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = _scheme(brightness);
    final segarColors = isLight ? SegarColors.light : SegarColors.dark;
    final textTheme = _textTheme(scheme);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: fontFamily,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[segarColors],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: segarColors.cardBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: buttonShape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
          shape: buttonShape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: buttonShape,
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: buttonShape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          iconSize: 24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        insetPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xxs,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
    );
  }

  static ColorScheme _scheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(
      primary: isLight ? AppPalette.primary : const Color(0xFF6FD693),
      onPrimary: isLight ? Colors.white : const Color(0xFF00391B),
      primaryContainer: isLight
          ? const Color(0xFFD7F5E2)
          : const Color(0xFF14532D),
      onPrimaryContainer: isLight
          ? const Color(0xFF0B3D20)
          : const Color(0xFFC7F5D6),
      secondary: isLight ? AppPalette.warning : const Color(0xFFFFC65C),
      onSecondary: const Color(0xFF3A2500),
      secondaryContainer: isLight
          ? const Color(0xFFFFF1D6)
          : const Color(0xFF4A3410),
      onSecondaryContainer: isLight
          ? const Color(0xFF5C3D00)
          : const Color(0xFFFFE3B0),
      error: isLight ? AppPalette.expired : const Color(0xFFFF7A7D),
      onError: isLight ? Colors.white : const Color(0xFF450A0C),
      errorContainer: isLight
          ? const Color(0xFFFFE3E3)
          : const Color(0xFF4A1416),
      onErrorContainer: isLight
          ? const Color(0xFF7A1014)
          : const Color(0xFFFFDAD9),
      surface: isLight ? AppPalette.lightSurface : AppPalette.darkSurface,
      onSurface: isLight ? AppPalette.lightOnSurface : AppPalette.darkOnSurface,
      surfaceContainerLowest: isLight ? Colors.white : const Color(0xFF0C0E0C),
      surfaceContainerLow: isLight
          ? const Color(0xFFF4F4EF)
          : const Color(0xFF181B18),
      surfaceContainer: isLight
          ? const Color(0xFFEFEFEA)
          : const Color(0xFF1E211E),
      surfaceContainerHigh: isLight
          ? const Color(0xFFE9E9E3)
          : const Color(0xFF252925),
      surfaceContainerHighest: isLight
          ? const Color(0xFFE3E3DC)
          : const Color(0xFF2C302C),
      outline: isLight ? const Color(0xFF6B726C) : const Color(0xFF8A928B),
      outlineVariant: isLight
          ? const Color(0xFFD8DAD2)
          : const Color(0xFF3A403A),
      inverseSurface: isLight
          ? const Color(0xFF2F312E)
          : const Color(0xFFE8EAE6),
      onInverseSurface: isLight
          ? const Color(0xFFF4F4EF)
          : const Color(0xFF2F312E),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final base =
        (scheme.brightness == Brightness.light
                ? Typography.material2021().black
                : Typography.material2021().white)
            .apply(
              fontFamily: fontFamily,
              bodyColor: scheme.onSurface,
              displayColor: scheme.onSurface,
            );

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 34,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 28,
        height: 1.25,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 20,
        height: 1.35,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        height: 1.35,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

extension SegarThemeX on BuildContext {
  SegarColors get segarColors =>
      Theme.of(this).extension<SegarColors>() ?? SegarColors.light;

  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
}
