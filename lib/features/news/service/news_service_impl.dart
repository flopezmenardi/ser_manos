import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/news_model.dart';

import 'news_service.dart';

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsServiceImpl();
});

class NewsServiceImpl implements NewsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<News>> getNewsOrderedByDate() async {
    final snapshot = await _db.collection('novedades').orderBy('fechaCreacion', descending: true).get();

    return snapshot.docs.map((doc) => News.fromDocumentSnapshot(doc)).toList();
  }

  Future<News?> getNewsById(String id) async {
    final doc = await _db.collection('novedades').doc(id).get();
    if (!doc.exists) return null;
    return News.fromDocumentSnapshot(doc);
  }
}
