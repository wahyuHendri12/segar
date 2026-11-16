import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:segar/main.dart';

void main() {
  testWidgets('Onboarding screen renders Segar content', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SegarApp());
    await tester.pumpAndSettle();

    expect(find.text('Segar.'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
    expect(find.text('Bebas Guilt'), findsOneWidget);
  });
}
