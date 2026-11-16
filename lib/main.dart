import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/app_providers.dart';
import 'data/local/database.dart';
import 'data/local/database_provider.dart';
import 'data/local/seed_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();

  try {
    await SeedLoader(db: database, prefs: prefs).ensureSeeded();
  } on Object catch (error, stackTrace) {
    // Seeding only fills the ingredient catalog. A failure must not block the
    // user from opening their pantry, so it is logged and retried next launch
    // because the seed version was not written.
    debugPrint('Gagal memuat seed katalog: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
      child: const SegarApp(),
    ),
  );
}
