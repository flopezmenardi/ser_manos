import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/features/auth/screens/enter_screen.dart';
import 'package:ser_manos/features/auth/screens/login_screen.dart';

import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      color: Colors.white,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}