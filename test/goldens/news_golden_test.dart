import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/constants/app_assets.dart';
import 'package:ser_manos/features/news/controller/news_controller_impl.dart';
import 'package:ser_manos/features/news/screens/news_screen.dart';
import 'package:ser_manos/core/models/news_model.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../mocks/news_service_mock.mocks.dart';

void main() {
  testWidgets('NewsScreen golden test with mock data', (
    WidgetTester tester,
  ) async {
    // Arrange: mock NewsService and NewsController
    final mockNewsService = MockNewsService();
    final mockNews = [
      News(
        id: '1',
        title: 'Título de prueba 1',
        description: 'Descripción de prueba 1',
        summary: 'Resumen de prueba 1',
        creator: 'Emisor 1',
        imageURL: AppAssets.novedades2,
        creationDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
      ),
      News(
        id: '2',
        title: 'Título de prueba 2',
        description: 'Descripción de prueba 2',
        summary: 'Resumen de prueba 2',
        creator: 'Emisor 2',
        imageURL: AppAssets.novedades3,
        creationDate: Timestamp.fromDate(DateTime(2024, 1, 2)),
      ),
    ];

    when(
      mockNewsService.getNewsOrderedByDate(),
    ).thenAnswer((_) async => mockNews);

    final container = ProviderContainer(
      overrides: [
        newsControllerProvider.overrideWith(
          (ref) => NewsControllerImpl(mockNewsService),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const NewsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert
    await expectLater(
      find.byType(NewsScreen),
      matchesGoldenFile('goldens/news_screen.png'),
    );
  });
}
