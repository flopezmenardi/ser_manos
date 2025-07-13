import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/users/screens/welcome_screen.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

void main() {
  testWidgets('WelcomeScreen golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WelcomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WelcomeScreen),
      matchesGoldenFile('goldens/welcome_screen.png'),
    );
  });
}
