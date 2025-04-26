import 'package:flutter/material.dart';

import 'design_system/organisms/cards/volunteer_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: VolunteeringCard(
            imagePath: 'assets/images/volunteering.jpg',
            category: 'Accion Social',
            title: 'Un Techo para mi Pais',
            vacancies: 10,
            onFavoritePressed: () {
              print('Favorite pressed');
            },
            onLocationPressed: () {
              print('Location pressed');
            },
          ),
        ),
      ),
    );
  }
}
