import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/news_model.dart';

import '../../../providers/firestore_provider.dart';

final newsProvider = StreamProvider<List<News>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getNewsOrderedByDate();
});
