import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/users/controllers/user_controller_impl.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Image(image: AssetImage('assets/logos/logo_square.png'), width: 120, height: 120)),
      );
    }

    Future.microtask(() {
      if (authState.currentUser != null) {
        context.go('/volunteerings');
      } else {
        context.go('/initial');
      }
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image(image: AssetImage('assets/logos/logo_square.png'), width: 120, height: 120)),
    );
  }
}
