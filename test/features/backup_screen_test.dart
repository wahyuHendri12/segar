import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/backup/backup_file_service.dart';
import 'package:segar/data/backup/backup_repository.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/repositories/repository_providers.dart';
import 'package:segar/features/backup/backup_screen.dart';
import 'package:segar/l10n/app_localizations.dart';

import '../helpers/test_database.dart';

class _FakeBackupFileService implements BackupFileService {
  String? sharedJson;
  String? pickedJson;

  @override
  Future<void> shareBackup({
    required String json,
    required String fileName,
    required String subject,
  }) async {
    sharedJson = json;
  }

  @override
  Future<String?> pickBackupJson() async => pickedJson;
}

Future<AppDatabase> _pumpBackup(
  WidgetTester tester,
  _FakeBackupFileService fileService,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboardingDone': true,
    'userName': 'Dina',
  });
  final prefs = await SharedPreferences.getInstance();
  final database = openTestDatabase();
  addTearDown(database.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        backupFileServiceProvider.overrideWithValue(fileService),
      ],
      child: const MaterialApp(
        locale: Locale('id'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: BackupScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return database;
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _insertItem(AppDatabase db) {
  final now = DateTime(2026, 11, 10, 9);
  return db
      .into(db.pantryItems)
      .insert(
        PantryItemsCompanion.insert(
          id: 'item-1',
          name: 'Bayam',
          category: IngredientCategory.sayur,
          quantity: 2,
          unit: Unit.ikat,
          storageLocation: StorageLocation.kulkas,
          purchaseDate: now.subtract(const Duration(days: 1)),
          expiryDate: now.add(const Duration(days: 3)),
          expirySource: ExpirySource.estimasi,
          createdAt: now,
          updatedAt: now,
        ),
      );
}

void main() {
  testWidgets('exports the database through the file service', (tester) async {
    final fileService = _FakeBackupFileService();
    final db = await _pumpBackup(tester, fileService);
    await _insertItem(db);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bagikan file cadangan'));
    await tester.pumpAndSettle();

    expect(fileService.sharedJson, isNotNull);
    expect(fileService.sharedJson, contains('Bayam'));
    expect(find.textContaining('Terakhir dicadangkan'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('restores a selected backup after confirmation', (tester) async {
    final fileService = _FakeBackupFileService();
    final db = await _pumpBackup(tester, fileService);
    await _insertItem(db);

    final prefs = await SharedPreferences.getInstance();
    final repository = BackupRepository(database: db, preferences: prefs);
    final json = await repository.exportJson();
    await repository.clearAllData();
    await tester.pumpAndSettle();

    fileService.pickedJson = json;
    await tester.tap(find.text('Pilih file cadangan'));
    await tester.pumpAndSettle();

    expect(find.text('Pulihkan data dari file?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Pilih file cadangan'));
    await tester.pumpAndSettle();

    final items = await db.pantryDao.getAll();
    expect(items, hasLength(1));
    expect(items.single.name, 'Bayam');
    expect(find.text('Cadangan berhasil dipulihkan.'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('rejects an invalid backup file', (tester) async {
    final fileService = _FakeBackupFileService()..pickedJson = '{"format":"x"}';
    await _pumpBackup(tester, fileService);

    await tester.tap(find.text('Pilih file cadangan'));
    await tester.pumpAndSettle();

    expect(
      find.text('File cadangan tidak valid atau tidak didukung.'),
      findsOneWidget,
    );

    await _dispose(tester);
  });
}
