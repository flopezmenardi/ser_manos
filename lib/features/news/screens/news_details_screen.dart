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
import 'package:ser_manos/models/news_model.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/news_controller_impl.dart';

class NewsDetailsScreen extends ConsumerStatefulWidget {
  final String newsId;

  const NewsDetailsScreen({required this.newsId, super.key});

  @override
  ConsumerState<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends ConsumerState<NewsDetailsScreen> {
  late Future<News?> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = ref.read(newsControllerProvider).getNewsById(widget.newsId);
  }

  Future<void> _refresh() async {
    setState(() {
      _newsFuture = ref.read(newsControllerProvider).getNewsById(widget.newsId);
    });
    await _newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<News?>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final novedad = snapshot.data;
        if (novedad == null) {
          return const Scaffold(
            body: Center(child: Text('Novedad no encontrada.')),
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
                  onRefresh: _refresh,
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
                          "Reporte " + novedad.emisor,
                          style: AppTypography.overline.copyWith(
                            color: AppColors.neutral75,
                          ),
                        ),
                        Text(
                          novedad.titulo,
                          style: AppTypography.headline2.copyWith(
                            color: AppColors.neutral100,
                          ),
                        ),
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
                            style: AppTypography.subtitle1.copyWith(
                              color: AppColors.neutral100,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          novedad.descripcion,
                          style: AppTypography.body1.copyWith(
                            color: AppColors.neutral100,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Comparte esta nota",
                          style: AppTypography.headline2.copyWith(
                            color: AppColors.neutral100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CTAButton(
                          text: "Compartir",
                          onPressed: () async {
                            try {
                              final response = await http.get(
                                Uri.parse(novedad.imagenURL),
                              );
                              final bytes = response.bodyBytes;

                              final tempDir = await getTemporaryDirectory();
                              final file = File(
                                '${tempDir.path}/shared_news.jpg',
                              );
                              await file.writeAsBytes(bytes);

                              await Share.shareXFiles(
                                [XFile(file.path)],
                                text: novedad.resumen,
                                subject: novedad.titulo,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error al compartir la novedad.',
                                  ),
                                ),
                              );
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
