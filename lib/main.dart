import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/organisms/cards/input_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Material(color: Colors.white, child: InputCard()));
  }
}
