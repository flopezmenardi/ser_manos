import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';

import '../../../core/design_system/organisms/cards/news_card.dart';
import '../../../core/design_system/organisms/headers/header.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../controller/news_controller_impl.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = 2;
    final newsState = ref.watch(newsListNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: newsState.when(
              loading:
                  () => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary100,
                    ),
                  ),
              error:
                  (e, _) => Center(
                    child: Text('Error: $e', overflow: TextOverflow.ellipsis),
                  ),
              data:
                  (news) => RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(newsListNotifierProvider.notifier)
                          .fetchNews();
                    },
                    color: AppColors.secondary100,
                    backgroundColor: AppColors.secondary25,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: news.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final currentNews = news[index];
                        return NewsCard(
                          imagePath: currentNews.imageURL,
                          report: currentNews.creator,
                          title: currentNews.title,
                          description: currentNews.summary,
                          onConfirm: () {
                            context.push(AppRoutes.newsDetail(currentNews.id));
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
