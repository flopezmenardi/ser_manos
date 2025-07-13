import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ser_manos/core/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/core/design_system/organisms/headers/header_section.dart';
import 'package:ser_manos/core/design_system/tokens/colors.dart';
import 'package:ser_manos/core/design_system/tokens/typography.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/news_controller_impl.dart';

class NewsDetailsScreen extends ConsumerWidget {
  final String newsId;

  const NewsDetailsScreen({required this.newsId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailNotifierProvider(newsId));

    return newsAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (e, _) => const Scaffold(
            body: Center(
              child: Text(
                'Error al cargar la novedad.',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      data: (news) {
        if (news == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Novedad no encontrada.',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.neutral0,
          body: Column(
            children: [
              Container(
                color: AppColors.secondary90,
                child: SafeArea(
                  bottom: false,
                  child: HeaderSection(
                    title: 'Novedades',
                    onBack: () => context.pop(),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(newsDetailNotifierProvider(newsId).notifier)
                        .fetchNewsDetail();
                  },
                  color: AppColors.secondary100,
                  backgroundColor: AppColors.secondary25,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.creator,
                          style: AppTypography.overline.copyWith(
                            color: AppColors.neutral75,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          news.title,
                          style: AppTypography.headline2.copyWith(
                            color: AppColors.neutral100,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            news.imageURL,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            news.summary,
                            style: AppTypography.subtitle1.copyWith(
                              color: AppColors.secondary200,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          news.description,
                          style: AppTypography.body1.copyWith(
                            color: AppColors.neutral100,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "Comparte esta nota",
                            style: AppTypography.headline2.copyWith(
                              color: AppColors.neutral100,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CTAButton(
                          text: "Compartir",
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            File? tempFile;

                            try {
                              final response = await http.get(
                                Uri.parse(news.imageURL),
                              );
                              final bytes = response.bodyBytes;

                              final tempDir = await getTemporaryDirectory();
                              tempFile = File(
                                '${tempDir.path}/shared_news.jpg',
                              );
                              await tempFile.writeAsBytes(bytes);

                              final url = 'http://sermanos.app/news/${news.id}';

                              final params = ShareParams(
                                text: '${news.summary}\n\n$url',
                                subject: news.title,
                                files: [XFile(tempFile.path)],
                              );

                              final result = await SharePlus.instance.share(
                                params,
                              );

                              if (result.status == ShareResultStatus.success) {
                                debugPrint(
                                  '¡Gracias por compartir la novedad!',
                                );
                              }
                            } catch (e) {
                              debugPrint('Error al compartir la novedad: $e');
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error al compartir la novedad.',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            } finally {
                              // Always clean up the temporary file
                              if (tempFile != null && await tempFile.exists()) {
                                try {
                                  await tempFile.delete();
                                } catch (e) {
                                  debugPrint('Error deleting temporary file: $e');
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
