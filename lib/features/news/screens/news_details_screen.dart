import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/organisms/headers/header_section.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/news_controller_impl.dart';

class NewsDetailsScreen extends ConsumerWidget {
  final String newsId;

  const NewsDetailsScreen({required this.newsId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailNotifierProvider(newsId));

    return newsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => const Scaffold(body: Center(child: Text('Error al cargar la novedad.', overflow: TextOverflow.ellipsis,))),
      data: (novedad) {
        if (novedad == null) {
          return const Scaffold(body: Center(child: Text('Novedad no encontrada.', overflow: TextOverflow.ellipsis,)));
        }

        return Scaffold(
          backgroundColor: AppColors.neutral0,
          body: Column(
            children: [
              Container(
                color: AppColors.secondary90,
                child: SafeArea(bottom: false, child: HeaderSection(title: 'Novedades', onBack: () => context.pop())),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(newsDetailNotifierProvider(newsId).notifier).fetchNewsDetail();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reporte ${novedad.emisor}",
                          style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(novedad.titulo, style: AppTypography.headline2.copyWith(color: AppColors.neutral100), overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            novedad.imagenURL,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            novedad.resumen,
                            style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(novedad.descripcion, style: AppTypography.body1.copyWith(color: AppColors.neutral100), overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: 24),
                        Text(
                          "Comparte esta nota",
                          style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        CTAButton(
                          text: "Compartir",
                          onPressed: () async {
                            try {
                              final response = await http.get(Uri.parse(novedad.imagenURL));
                              final bytes = response.bodyBytes;

                              final tempDir = await getTemporaryDirectory();
                              final file = File('${tempDir.path}/shared_news.jpg');
                              await file.writeAsBytes(bytes);

                              final url = 'http://sermanos.app/news/${novedad.id}';

                              await Share.shareXFiles(
                                [XFile(file.path)],
                                text: novedad.resumen + '\n\n' + url,
                                subject: novedad.titulo,
                              );
                            } catch (e) {
                              debugPrint('Error al compartir la novedad: $e');
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Error al compartir la novedad.', overflow: TextOverflow.ellipsis,)));
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
