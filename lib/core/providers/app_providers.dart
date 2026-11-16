import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Overridden in `main()` (and in tests) with a loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before use.',
  );
});

class OnboardingDoneNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(PrefKeys.onboardingDone) ??
        false;
  }

  Future<void> complete() async {
    state = true;
    await ref
        .read(sharedPreferencesProvider)
        .setBool(PrefKeys.onboardingDone, true);
  }

  Future<void> reset() async {
    state = false;
    await ref
        .read(sharedPreferencesProvider)
        .setBool(PrefKeys.onboardingDone, false);
  }
}

final onboardingDoneProvider = NotifierProvider<OnboardingDoneNotifier, bool>(
  OnboardingDoneNotifier.new,
);

class UserNameNotifier extends Notifier<String> {
  @override
  String build() {
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(PrefKeys.userName);
    if (stored == null || stored.trim().isEmpty) {
      return AppConstants.defaultUserName;
    }
    return stored;
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = trimmed;
    await ref
        .read(sharedPreferencesProvider)
        .setString(PrefKeys.userName, trimmed);
  }
}

final userNameProvider = NotifierProvider<UserNameNotifier, String>(
  UserNameNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final raw = ref
        .watch(sharedPreferencesProvider)
        .getString(PrefKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(PrefKeys.themeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class LastBackupAtNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    final raw = ref
        .watch(sharedPreferencesProvider)
        .getString(PrefKeys.lastBackupAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> markNow() async {
    final now = DateTime.now();
    state = now;
    await ref
        .read(sharedPreferencesProvider)
        .setString(PrefKeys.lastBackupAt, now.toIso8601String());
  }
}

final lastBackupAtProvider = NotifierProvider<LastBackupAtNotifier, DateTime?>(
  LastBackupAtNotifier.new,
);

/// Optional Open Food Facts lookups. Enabled by default because a request only
/// happens after an explicit scan or manual lookup.
class OnlineBarcodeEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(PrefKeys.onlineBarcodeEnabled) ??
        true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await ref
        .read(sharedPreferencesProvider)
        .setBool(PrefKeys.onlineBarcodeEnabled, enabled);
  }
}

final onlineBarcodeEnabledProvider =
    NotifierProvider<OnlineBarcodeEnabledNotifier, bool>(
      OnlineBarcodeEnabledNotifier.new,
    );

/// Optional TheMealDB recipe lookups.
class OnlineRecipeEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(PrefKeys.onlineRecipeEnabled) ??
        true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await ref
        .read(sharedPreferencesProvider)
        .setBool(PrefKeys.onlineRecipeEnabled, enabled);
  }
}

final onlineRecipeEnabledProvider =
    NotifierProvider<OnlineRecipeEnabledNotifier, bool>(
      OnlineRecipeEnabledNotifier.new,
    );
