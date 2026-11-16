import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:segar/main.dart';

void main() {
  testWidgets('Main tabs, detail, and add form render without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SegarApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mulai Menjaga Kulkas'));
    await tester.pumpAndSettle();

    expect(find.text('Status Dapur'), findsOneWidget);

    await tester.tap(find.text('Resep'));
    await tester.pumpAndSettle();
    expect(find.text('Saran Resep Anti-Mubazir'), findsOneWidget);

    await tester.tap(find.text('Statistik'));
    await tester.pumpAndSettle();
    expect(find.text('Distribusi Bahan Makanan'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Dina Pratiwi'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bayam Hijau'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bayam Hijau'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Bahan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text('Tambah Bahan Makanan'), findsOneWidget);
  });
}
