import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/organisms/headers/header_section.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/services/firestore_service.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailsScreen({required this.newsId, super.key});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late Future<News?> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = FirestoreService().getNewsById(widget.newsId);
  }

  Future<void> _refresh() async {
    setState(() {
      _newsFuture = FirestoreService().getNewsById(widget.newsId);
    });
    await _newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<News?>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final novedad = snapshot.data;
        if (novedad == null) {
          return const Scaffold(body: Center(child: Text('Novedad no encontrada.')));
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Reporte "+novedad.emisor, style: AppTypography.overline.copyWith(color: AppColors.neutral75)),
                        Text(novedad.titulo, style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            novedad.imagenURL,
                            width: 328,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 328,
                          child: Text(novedad.resumen, style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 16),
                        Text(novedad.descripcion, style: AppTypography.body1.copyWith(color: AppColors.neutral100)),
                        const SizedBox(height: 24),
                        Text("Comparte esta nota", style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
                        const SizedBox(height: 16),
                        CTAButton(text: "Compartir", onPressed: () async {
                          // TODO: implement share
                        }),
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
