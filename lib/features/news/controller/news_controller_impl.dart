import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/news/controller/news_controller.dart';
import 'package:ser_manos/models/news_model.dart';

import '../service/news_service.dart';
import '../service/news_service_impl.dart';

final newsControllerProvider = Provider<NewsController>((ref) {
  final newsService = ref.read(newsServiceProvider);
  return NewsControllerImpl(newsService);
});

final newsListNotifierProvider = StateNotifierProvider<NewsListNotifier, AsyncValue<List<News>>>((ref) {
  final controller = ref.read(newsControllerProvider);
  return NewsListNotifier(controller);
});

final newsDetailNotifierProvider = StateNotifierProvider.family<NewsDetailNotifier, AsyncValue<News?>, String>((
  ref,
  newsId,
) {
  final controller = ref.read(newsControllerProvider);
  return NewsDetailNotifier(controller, newsId);
});

class NewsControllerImpl implements NewsController {
  final NewsService _newsService;

  NewsControllerImpl(this._newsService);

  @override
  Future<List<News>> getNewsOrderedByDate() {
    return _newsService.getNewsOrderedByDate();
  }

  @override
  Future<News?> getNewsById(String id) {
    return _newsService.getNewsById(id);
  }
}

class NewsListNotifier extends StateNotifier<AsyncValue<List<News>>> {
  NewsListNotifier(this._controller) : super(const AsyncValue.loading()) {
    fetchNews();
  }

  final NewsController _controller;

  Future<void> fetchNews() async {
    try {
      final data = await _controller.getNewsOrderedByDate();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class NewsDetailNotifier extends StateNotifier<AsyncValue<News?>> {
  NewsDetailNotifier(this._controller, this.newsId) : super(const AsyncValue.loading()) {
    fetchNewsDetail();
  }

  final NewsController _controller;
  final String newsId;

  Future<void> fetchNewsDetail() async {
    try {
      final news = await _controller.getNewsById(newsId);
      state = AsyncValue.data(news);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
