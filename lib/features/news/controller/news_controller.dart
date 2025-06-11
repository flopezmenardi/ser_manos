import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/news_model.dart';

import '../service/news_service.dart';

final newsControllerProvider = Provider<NewsController>((ref) {
  final newsService = ref.read(newsServiceProvider);
  return NewsController(newsService);
});

class NewsController {
  final NewsService _newsService;

  NewsController(this._newsService);

  Future<List<News>> getNewsOrderedByDate() {
    return _newsService.getNewsOrderedByDate();
  }

  Future<News?> getNewsById(String id) {
    return _newsService.getNewsById(id);
  }
}
