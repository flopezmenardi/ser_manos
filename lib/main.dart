import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/organisms/cards/news_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsCard(
        report: "REPORTE 2820",
        title: "Ser donante voluntario",
        description:
            "Desde el Hospoital Centenario recalcan la importancia de la sangre donacion voluntaria de Sangre",
        imagePath: 'assets/images/novedades.jpg',
        onConfirm: () {
          print("GOT THAT DOG");
        },
      ),
    );
  }
}
