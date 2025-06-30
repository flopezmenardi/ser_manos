import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/constants/app_assets.dart';
import 'package:ser_manos/features/news/controller/news_controller_impl.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/features/news/service/news_service.dart';
import 'package:ser_manos/features/news/controller/news_controller.dart';
import 'package:ser_manos/features/news/screens/news_screen.dart';

import '../mocks/news_service_mock.mocks.dart';

void main() {
  testWidgets('NewsScreen golden test with mock data', (WidgetTester tester) async {
    // Arrange: mock NewsService and NewsController
    final mockNewsService = MockNewsService();
    final mockNews = [
      News(
        id: '1',
        titulo: 'Título de prueba 1',
        descripcion: 'Descripción de prueba 1',
        resumen: 'Resumen de prueba 1',
        emisor: 'Emisor 1',
        imagenURL: AppAssets.novedades2,
        fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
      ),
      News(
        id: '2',
        titulo: 'Título de prueba 2',
        descripcion: 'Descripción de prueba 2',
        resumen: 'Resumen de prueba 2',
        emisor: 'Emisor 2',
        imagenURL: AppAssets.novedades3,
        fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 2)),
      ),
    ];

    when(mockNewsService.getNewsOrderedByDate()).thenAnswer((_) async => mockNews);

    final container = ProviderContainer(overrides: [
      newsControllerProvider.overrideWith((ref) => NewsControllerImpl(mockNewsService)),
    ]);

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: NewsScreen()),
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
