import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/theme/app_theme.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/barcode_lookup.dart';
import 'package:segar/data/repositories/barcode_repository.dart';
import 'package:segar/data/repositories/repository_providers.dart';
import 'package:segar/features/barcode/barcode_lookup_sheet.dart';
import 'package:segar/l10n/app_localizations.dart';

import '../helpers/fake_online_sources.dart';
import '../helpers/test_database.dart';

const _lookup = BarcodeLookup(
  barcode: '8991002101234',
  name: 'Susu UHT Cokelat',
  brand: 'Segar Dairy',
  category: IngredientCategory.telurSusu,
  quantityText: '1 L',
  quantity: 1,
  unit: Unit.liter,
);

void main() {
  late AppDatabase db;
  BarcodeLookup? captured;

  setUp(() {
    db = openTestDatabase();
    captured = null;
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpHost(
    WidgetTester tester, {
    required FakeBarcodeRemoteSource remote,
    required FakeConnectivityChecker connectivity,
    bool enabled = true,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = BarcodeRepository(
      dao: db.barcodeCacheDao,
      remote: remote,
      connectivity: connectivity,
      isEnabled: () => enabled,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [barcodeRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () async {
                    captured = await showBarcodeLookupSheet(context);
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  }

  testWidgets('manual lookup shows the product and returns it', (tester) async {
    await pumpHost(
      tester,
      remote: FakeBarcodeRemoteSource(result: _lookup),
      connectivity: FakeConnectivityChecker(),
    );

    await tester.enterText(find.byType(TextField), '8991002101234');
    await tester.tap(find.text('Cari produk'));
    await tester.pumpAndSettle();

    expect(find.text('Susu UHT Cokelat'), findsOneWidget);
    expect(find.text('Merek: Segar Dairy'), findsOneWidget);
    expect(find.text('Isi: 1 L'), findsOneWidget);
    expect(find.text('Pakai data ini'), findsOneWidget);

    await tester.tap(find.text('Pakai data ini'));
    await tester.pumpAndSettle();

    expect(captured, isNotNull);
    expect(captured!.barcode, '8991002101234');
    expect(captured!.name, 'Susu UHT Cokelat');
    expect(captured!.category, IngredientCategory.telurSusu);

    await dispose(tester);
  });

  testWidgets('rejects barcodes that are too short', (tester) async {
    await pumpHost(
      tester,
      remote: FakeBarcodeRemoteSource(result: _lookup),
      connectivity: FakeConnectivityChecker(),
    );

    await tester.enterText(find.byType(TextField), '123');
    await tester.tap(find.text('Cari produk'));
    await tester.pumpAndSettle();

    expect(find.text('Barcode harus 8–14 digit angka.'), findsOneWidget);

    await dispose(tester);
  });

  testWidgets('explains offline and disabled states', (tester) async {
    await pumpHost(
      tester,
      remote: FakeBarcodeRemoteSource(),
      connectivity: FakeConnectivityChecker(online: false),
    );

    await tester.enterText(find.byType(TextField), '8991002101234');
    await tester.tap(find.text('Cari produk'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Sedang offline. Coba lagi saat ada internet atau isi nama manual.',
      ),
      findsOneWidget,
    );

    await dispose(tester);
  });

  testWidgets('disabled lookup suggests enabling the feature', (tester) async {
    await pumpHost(
      tester,
      remote: FakeBarcodeRemoteSource(result: _lookup),
      connectivity: FakeConnectivityChecker(),
      enabled: false,
    );

    await tester.enterText(find.byType(TextField), '8991002101234');
    await tester.tap(find.text('Cari produk'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Fitur online dimatikan. Aktifkan di Pengaturan atau isi nama manual.',
      ),
      findsOneWidget,
    );

    await dispose(tester);
  });
}
