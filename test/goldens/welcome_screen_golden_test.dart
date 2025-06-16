import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/users/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WelcomeScreen),
      matchesGoldenFile('goldens/welcome_screen.png'),
    );
  });
}