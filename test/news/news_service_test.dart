import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/news/service/news_service_impl.dart';
import 'package:ser_manos/core/models/news_model.dart';

void main() {
  group('NewsServiceImpl', () {
    late FakeFirebaseFirestore fakeFirestore;
    late NewsServiceImpl newsService;

    final news1 = News(
      id: '1',
      title: 'Primera noticia',
      description: 'Descripción 1',
      summary: 'Resumen 1',
      creator: 'Emisor 1',
      imageURL: 'https://image1.com',
      creationDate: Timestamp.fromDate(DateTime(2023, 1, 1)),
    );

    final news2 = News(
      id: '2',
      title: 'Segunda noticia',
      description: 'Descripción 2',
      summary: 'Resumen 2',
      creator: 'Emisor 2',
      imageURL: 'https://image2.com',
      creationDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
    );

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      newsService = NewsServiceImpl(fakeFirestore);

      await fakeFirestore
          .collection('novedades')
          .doc(news1.id)
          .set(news1.toMap());
      await fakeFirestore
          .collection('novedades')
          .doc(news2.id)
          .set(news2.toMap());
    });

    test(
      'getNewsOrderedByDate returns news sorted by fechaCreacion desc',
      () async {
        final result = await newsService.getNewsOrderedByDate();

        expect(result, isA<List<News>>());
        expect(result.length, 2);
        expect(result.first.title, 'Segunda noticia'); // más nueva
        expect(result.last.title, 'Primera noticia'); // más vieja
      },
    );

    test('getNewsById returns News if found', () async {
      final result = await newsService.getNewsById('1');

      expect(result, isNotNull);
      expect(result?.title, 'Primera noticia');
    });

    test('getNewsById returns null if not found', () async {
      final result = await newsService.getNewsById('nonexistent');

      expect(result, isNull);
    });
  });
}
