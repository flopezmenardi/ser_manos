import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';
import 'package:ser_manos/features/users/screens/enter_screen.dart';
import 'package:ser_manos/features/users/screens/login_screen.dart';
import 'package:ser_manos/features/users/screens/profile_modal_screen.dart';
import 'package:ser_manos/features/users/screens/profile_screen.dart';
import 'package:ser_manos/features/users/screens/register_screen.dart';
import 'package:ser_manos/features/users/screens/welcome_screen.dart';
import 'package:ser_manos/features/news/screens/news_details_screen.dart';
import 'package:ser_manos/features/news/screens/news_screen.dart';
import 'package:ser_manos/features/volunteerings/screens/volunteering_detail_screen.dart';
import 'package:ser_manos/features/volunteerings/screens/volunteerings_screen.dart';
import 'package:ser_manos/splash_screen.dart';

/// Custom page builder that creates a page with no transition animation
Page<T> noAnimationPageBuilder<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: AppRoutes.initial, builder: (context, state) => const InitialScreen()),
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
    // Main tab routes with no animation
    GoRoute(
      path: AppRoutes.volunteerings,
      pageBuilder: (context, state) => noAnimationPageBuilder(context, state, const VolunteeringListPage()),
    ),
    GoRoute(
      path: AppRoutes.news,
      pageBuilder: (context, state) => noAnimationPageBuilder(context, state, const NewsScreen()),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) => noAnimationPageBuilder(context, state, const ProfileScreen()),
    ),
    // Detail pages can keep default animations for better UX
    GoRoute(
      path: '${AppRoutes.news}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NewsDetailsScreen(newsId: id);
      },
      name: 'news',
    ),
    GoRoute(path: AppRoutes.profileEdit, builder: (context, state) => const ProfileModalScreen()),
    GoRoute(
      path: '${AppRoutes.volunteeringBase}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VolunteeringDetailScreen(id: id);
      },
    ),
  ],
); 
