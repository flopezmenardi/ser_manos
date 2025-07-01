import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/features/news/controller/news_controller_impl.dart';
import 'package:ser_manos/features/news/controller/news_controller.dart';
import 'package:ser_manos/models/news_model.dart';

import '../mocks/news_service_mock.mocks.dart';

void main() {
  late MockNewsService mockService;
  late NewsController controller;

  final mockNews = News(
    id: '1',
    title: 'Título de prueba',
    description: 'Descripción de prueba',
    summary: 'Resumen de prueba',
    creator: 'Emisor',
    imageURL: 'https://example.com/image.jpg',
    creationDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
  );

  setUp(() {
    mockService = MockNewsService();
    controller = NewsControllerImpl(mockService);
  });

  group('NewsController', () {
    test('getNewsOrderedByDate returns list of News', () async {
      when(mockService.getNewsOrderedByDate()).thenAnswer((_) async => [mockNews]);

      final result = await controller.getNewsOrderedByDate();

      expect(result, isA<List<News>>());
      expect(result.length, 1);
      expect(result.first.id, mockNews.id);
    });

    test('getNewsById returns a News when it exists', () async {
      when(mockService.getNewsById('1')).thenAnswer((_) async => mockNews);

      final result = await controller.getNewsById('1');

      expect(result, isA<News>());
      expect(result?.title, mockNews.title);
    });

    test('getNewsById returns null when not found', () async {
      when(mockService.getNewsById('nonexistent')).thenAnswer((_) async => null);

      final result = await controller.getNewsById('nonexistent');

      expect(result, isNull);
    });
  });

    group('NewsListNotifier', () {
    test('fetchNews sets state with list of news', () async {
      final mockService = MockNewsService();
      final controller = NewsControllerImpl(mockService);

      when(mockService.getNewsOrderedByDate()).thenAnswer((_) async => [mockNews]);

      final notifier = NewsListNotifier(controller);

      await Future.delayed(Duration.zero); // Esperamos al fetchNews del constructor
      expect(notifier.state.value?.length, 1);
    });
  });

  group('NewsDetailNotifier', () {
    test('fetchNewsDetail sets state with news detail', () async {
      final mockService = MockNewsService();
      final controller = NewsControllerImpl(mockService);

      when(mockService.getNewsById('1')).thenAnswer((_) async => mockNews);

      final notifier = NewsDetailNotifier(controller, '1');
      await Future.delayed(Duration.zero);

      expect(notifier.state.value?.title, 'Título de prueba');
    });

    test('fetchNewsDetail sets state to null if not found', () async {
      final mockService = MockNewsService();
      final controller = NewsControllerImpl(mockService);

      when(mockService.getNewsById('missing')).thenAnswer((_) async => null);

      final notifier = NewsDetailNotifier(controller, 'missing');
      await Future.delayed(Duration.zero);

      expect(notifier.state.value, isNull);
    });
  });
}