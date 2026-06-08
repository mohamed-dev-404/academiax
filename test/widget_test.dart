import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CI smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('CI OK'),
        ),
      ),
    );

    expect(find.text('CI OK'), findsOneWidget);
  });
}