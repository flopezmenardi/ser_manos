import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/news_model.dart';

import '../../../services/firestore_service.dart';

final newsProvider = FutureProvider<List<News>>((ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return await firestore.getNewsOrderedByDate();
});
