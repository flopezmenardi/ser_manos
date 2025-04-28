import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/features/auth/screens/enter_screen.dart';
import 'package:ser_manos/features/auth/screens/login_screen.dart';
import 'package:ser_manos/features/auth/screens/register_screen.dart';
import 'package:ser_manos/features/auth/screens/welcome_screen.dart';
import 'package:ser_manos/features/news/screens/news_details_screen.dart';
import 'package:ser_manos/features/news/screens/news_screen.dart';
import 'package:ser_manos/features/profile/profile_modal_screen.dart';

import 'features/home/screens/home_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/initial',
      builder: (context, state) => const InitialScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const VolunteeringListPage(),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: '/news/1',
      builder: (context, state) => const NewsDetailsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const ProfileModalScreen(),
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
      debugShowCheckedModeBanner: false
    );
  }
}
