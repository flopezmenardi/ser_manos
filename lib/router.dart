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

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: AppRoutes.initial, builder: (context, state) => const InitialScreen()),
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: AppRoutes.volunteerings, builder: (context, state) => const VolunteeringListPage()),
    GoRoute(path: AppRoutes.news, builder: (context, state) => const NewsScreen()),
    GoRoute(
      path: '${AppRoutes.news}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NewsDetailsScreen(newsId: id);
      },
      name: 'news',
    ),
    GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
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