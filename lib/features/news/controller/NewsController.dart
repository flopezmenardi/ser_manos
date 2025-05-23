import 'package:flutter/material.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/services/firestore_service.dart';

class NewsController extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<News> novedades = [];

  void cargarNovedades() {
    _firestoreService.getNews().listen((data) {
      novedades = data;
      notifyListeners();
    });
  }
}