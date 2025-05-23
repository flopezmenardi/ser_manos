import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/services/firestore_service.dart';

import '../../../design_system/organisms/cards/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int selectedIndex = 2; // Default to "Novedades"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: StreamBuilder<List<News>>(
              stream: FirestoreService().getNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final novedades = snapshot.data ?? [];

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: novedades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final novedad = novedades[index];
                    return NewsCard(
                      imagePath: novedad.imagenURL,
                      report: novedad.emisor,
                      title: novedad.titulo,
                      description: novedad.resumen,
                      onConfirm: () {
                        context.push('/news/${novedad.id}');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
