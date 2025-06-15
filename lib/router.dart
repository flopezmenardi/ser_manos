import 'package:go_router/go_router.dart';
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
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/initial', builder: (context, state) => const InitialScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/volunteerings', builder: (context, state) => const VolunteeringListPage()),
    GoRoute(path: '/news', builder: (context, state) => const NewsScreen()),
    GoRoute(
      path: '/news/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NewsDetailsScreen(newsId: id);
      },
      name: 'news',
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/profile/edit', builder: (context, state) => const ProfileModalScreen()),
    GoRoute(
      path: '/volunteering/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VolunteeringDetailScreen(id: id);
      },
    ),
  ],
); 