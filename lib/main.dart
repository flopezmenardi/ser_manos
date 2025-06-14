import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/features/auth/screens/enter_screen.dart';
import 'package:ser_manos/features/auth/screens/login_screen.dart';
import 'package:ser_manos/features/auth/screens/profile_modal_screen.dart';
import 'package:ser_manos/features/auth/screens/register_screen.dart';
import 'package:ser_manos/features/auth/screens/welcome_screen.dart';
import 'package:ser_manos/features/news/screens/news_details_screen.dart';
import 'package:ser_manos/features/news/screens/news_screen.dart';
import 'package:ser_manos/splash_screen.dart';

import 'features/auth/screens/profile_screen.dart';
import 'features/volunteerings/screens/volunteering_detail_screen.dart';
import 'features/volunteerings/screens/volunteerings_screen.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await initializeRemoteConfig();

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      runApp(const ProviderScope(child: MainApp()));
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class FirebaseInitWrapper extends StatelessWidget {
  const FirebaseInitWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MainApp();
        } else if (snapshot.hasError) {
          return const MaterialApp(home: Scaffold(body: Center(child: Text('Firebase init failed'))));
        } else {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
      },
    );
  }
}

final GoRouter _router = GoRouter(
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(color: Colors.white, routerConfig: _router, debugShowCheckedModeBanner: false);
  }
}

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setDefaults({
    'show_proximity_button': false,
    'show_like_counter': false,
    'enable_dark_mode': false,
  });

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(minutes: 1)),
  );

  await remoteConfig.fetchAndActivate();

  print('[RemoteConfig Init] enable_dark_mode: ${remoteConfig.getBool('enable_dark_mode')}');
  print('[RemoteConfig Init] show_proximity_button: ${remoteConfig.getBool('show_proximity_button')}');
  print('[RemoteConfig Init] show_like_counter: ${remoteConfig.getBool('show_like_counter')}');
}
