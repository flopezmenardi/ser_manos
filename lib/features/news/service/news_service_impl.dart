import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/core/models/news_model.dart';

import 'news_service.dart';

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsServiceImpl();
});

class NewsServiceImpl implements NewsService {
  final FirebaseFirestore _db;

  NewsServiceImpl([FirebaseFirestore? db])
    : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<List<News>> getNewsOrderedByDate() async {
    final snapshot =
        await _db
            .collection('novedades')
            .orderBy('fechaCreacion', descending: true)
            .get();

    return snapshot.docs.map((doc) => News.fromDocumentSnapshot(doc)).toList();
  }

  @override
  Future<News?> getNewsById(String newsId) async {
    try {
      final doc = await _db.collection('novedades').doc(newsId).get();
      if (!doc.exists) return null;
      return News.fromDocumentSnapshot(doc);
    } catch (e) {
      debugPrint('Error al obtener la novedad: $e');
      return null;
    }
  }
}
