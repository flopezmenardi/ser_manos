import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/organisms/cards/news_card.dart';
import '../../../design_system/organisms/headers/header.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../models/news_model.dart';
import '../controller/news_controller.dart';

// Add this FutureProvider outside the widget
final newsListProvider = FutureProvider.autoDispose<List<News>>((ref) {
  final newsController = ref.read(newsControllerProvider);
  return newsController.getNewsOrderedByDate();
});

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = 2;
    final newsAsync = ref.watch(newsListProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: newsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data:
                  (novedades) => RefreshIndicator(
                    onRefresh: () async {
                      await ref.refresh(newsListProvider.future);
                    },
                    child: ListView.separated(
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
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
