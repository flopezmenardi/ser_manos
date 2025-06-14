import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/news/controller/news_controller_impl.dart';
import 'package:ser_manos/features/news/service/news_service_impl.dart';
import 'package:ser_manos/models/news_model.dart';

void main() {
  group('NewsController Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late NewsControllerImpl controller;

    final mockNews = News(
      id: '1',
      titulo: 'Título de prueba',
      descripcion: 'Descripción de prueba',
      resumen: 'Resumen de prueba',
      emisor: 'Emisor',
      imagenURL: 'https://example.com/image.jpg',
      fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
    );

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      await fakeFirestore.collection('novedades').doc(mockNews.id).set(mockNews.toMap());

      final newsService = NewsServiceImpl(fakeFirestore);
      controller = NewsControllerImpl(newsService);
    });

    test('getNewsOrderedByDate returns list of News ordered by date', () async {
      final result = await controller.getNewsOrderedByDate();
      expect(result, isA<List<News>>());
      expect(result.length, 1);
      expect(result.first.id, mockNews.id);
    });

    test('getNewsById returns a News item when it exists', () async {
      final result = await controller.getNewsById('1');
      expect(result, isA<News>());
      expect(result?.titulo, mockNews.titulo);
    });

    test('getNewsById returns null when it does not exist', () async {
      final result = await controller.getNewsById('nonexistent');
      expect(result, isNull);
    });
  });

  group('NewsListNotifier Tests', () {
    test('fetchNews sets state with list of news', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final news = News(
        id: '1',
        titulo: 'Test',
        descripcion: 'Desc',
        resumen: 'Resumen',
        emisor: 'Emisor',
        imagenURL: 'https://image.com',
        fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
      );
      await fakeFirestore.collection('novedades').doc(news.id).set(news.toMap());

      final service = NewsServiceImpl(fakeFirestore);
      final controller = NewsControllerImpl(service);
      final notifier = NewsListNotifier(controller);

      await Future.delayed(Duration.zero);
      expect(notifier.state.value?.length, 1);
    });
  });

  group('NewsDetailNotifier Tests', () {
    test('fetchNewsDetail sets state with news detail', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final news = News(
        id: '1',
        titulo: 'Detalle',
        descripcion: 'Desc',
        resumen: 'Resumen',
        emisor: 'Emisor',
        imagenURL: 'https://image.com',
        fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
      );
      await fakeFirestore.collection('novedades').doc(news.id).set(news.toMap());

      final service = NewsServiceImpl(fakeFirestore);
      final controller = NewsControllerImpl(service);
      final notifier = NewsDetailNotifier(controller, '1');

      await Future.delayed(Duration.zero);
      expect(notifier.state.value?.titulo, 'Detalle');
    });

    test('fetchNewsDetail sets state to null if news not found', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final service = NewsServiceImpl(fakeFirestore);
      final controller = NewsControllerImpl(service);
      final notifier = NewsDetailNotifier(controller, 'missing');

      await Future.delayed(Duration.zero);
      expect(notifier.state.value, isNull);
    });
  });
}
