import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/news/service/news_service_impl.dart';
import 'package:ser_manos/models/news_model.dart';

void main() {
  group('NewsServiceImpl', () {
    late FakeFirebaseFirestore fakeFirestore;
    late NewsServiceImpl newsService;

    final news1 = News(
      id: '1',
      titulo: 'Primera noticia',
      descripcion: 'Descripción 1',
      resumen: 'Resumen 1',
      emisor: 'Emisor 1',
      imagenURL: 'https://image1.com',
      fechaCreacion: Timestamp.fromDate(DateTime(2023, 1, 1)),
    );

    final news2 = News(
      id: '2',
      titulo: 'Segunda noticia',
      descripcion: 'Descripción 2',
      resumen: 'Resumen 2',
      emisor: 'Emisor 2',
      imagenURL: 'https://image2.com',
      fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
    );

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      newsService = NewsServiceImpl(fakeFirestore);

      await fakeFirestore.collection('novedades').doc(news1.id).set(news1.toMap());
      await fakeFirestore.collection('novedades').doc(news2.id).set(news2.toMap());
    });

    test('getNewsOrderedByDate returns news sorted by fechaCreacion desc', () async {
      final result = await newsService.getNewsOrderedByDate();

      expect(result, isA<List<News>>());
      expect(result.length, 2);
      expect(result.first.titulo, 'Segunda noticia'); // más nueva
      expect(result.last.titulo, 'Primera noticia');  // más vieja
    });

    test('getNewsById returns News if found', () async {
      final result = await newsService.getNewsById('1');

      expect(result, isNotNull);
      expect(result?.titulo, 'Primera noticia');
    });

    test('getNewsById returns null if not found', () async {
      final result = await newsService.getNewsById('nonexistent');

      expect(result, isNull);
    });
  });
}