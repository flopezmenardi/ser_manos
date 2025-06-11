import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/news/controller/news_controller.dart';
import 'package:ser_manos/models/news_model.dart';

import '../service/news_service_impl.dart';

final newsControllerProvider = Provider<NewsController>((ref) {
  final newsService = ref.read(newsServiceProvider);
  return NewsControllerImpl(newsService);
});

class NewsControllerImpl implements NewsController {
  final NewsServiceImpl _newsService;

  NewsControllerImpl(this._newsService);

  Future<List<News>> getNewsOrderedByDate() {
    return _newsService.getNewsOrderedByDate();
  }

  Future<News?> getNewsById(String id) {
    return _newsService.getNewsById(id);
  }
}
