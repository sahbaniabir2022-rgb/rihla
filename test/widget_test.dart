import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rihla/main.dart';

void main() {
  testWidgets('L\'app se lance', (WidgetTester tester) async {
    await tester.pumpWidget(const RihlaApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}