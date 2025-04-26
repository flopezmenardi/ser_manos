import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/organisms/postulation_confirmation_modal.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostulationConfirmationModal(
        projectName: "Un Techo para mi Pais",
        onConfirm: () => print("something"),
        onCancel: () => print("another something"),
      ),
    );
  }
}
