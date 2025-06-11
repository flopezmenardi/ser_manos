import '../../../models/news_model.dart';

abstract class NewsService {
  Future<List<News>> getNewsOrderedByDate();
  Future<News?> getNewsById(String id);
}
