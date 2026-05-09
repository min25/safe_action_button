import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_action_button/safe_action_button.dart';

void main() {
  testWidgets('Example app smoke test — renders list', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SafeButtonLoader())),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
