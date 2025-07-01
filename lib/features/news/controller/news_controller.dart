import '../../../core/models/news_model.dart';

abstract class NewsController {
  Future<List<News>> getNewsOrderedByDate();
  Future<News?> getNewsById(String newsId);
}
