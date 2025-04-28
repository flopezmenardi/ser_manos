import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';

import '../../../design_system/organisms/cards/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int selectedIndex = 2; // Default to "Novedades"

  final List<Map<String, String>> newsList = [
    {
      'imagePath': 'assets/images/novedades.jpg',
      'report': 'Reporte 2820',
      'title': 'Ser donante voluntario',
      'description':
          'Desde el Hospital Centenario destacan la importancia de la donación voluntaria de sangre.',
    },
    {
      'imagePath': 'assets/images/novedades_2.jpg',
      'report': 'Noticias de Cuyo',
      'title': 'Juntamos residuos',
      'description':
          'Voluntarios de Godoy Cruz limpiaron un cauce en las inmediaciones.',
    },
    {
      'imagePath': 'assets/images/novedades_3.jpg',
      'report': 'Diario La Nación',
      'title': 'Adoptar mascotas',
      'description':
          'Ayudamos a adoptar perros callejeros y evitar su sobrepoblación.',
    },
    {
      'imagePath': 'assets/images/novedades_4.jpg',
      'report': 'La Voz del Interior',
      'title': 'Preservamos la fauna',
      'description':
          'Córdoba se suma a la campaña de protección de especies autóctonas.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = newsList[index];
                return NewsCard(
                  imagePath: item['imagePath']!,
                  report: item['report']!,
                  title: item['title']!,
                  description: item['description']!,
                  onConfirm: () {
                    // You can navigate to a detail page or show a dialog here
                    context.go('/news/1');
                    print('Clicked on ${item['title']}');
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
