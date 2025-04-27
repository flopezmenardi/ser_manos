import 'package:flutter/material.dart';

import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: const Scaffold(
        backgroundColor: Colors.red,
        body: VolunteeringListPage(),
      ),
    );
  }
}
