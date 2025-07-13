import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_assets.dart';
import 'package:ser_manos/constants/app_routes.dart';

import 'features/users/controllers/user_controller_impl.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(
            image: AssetImage(AppAssets.logoSquare),
            width: 150,
            height: 150,
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.currentUser != null) {
        context.go(AppRoutes.volunteerings);
      } else {
        context.go(AppRoutes.initial);
      }
    });

    // Temporary placeholder while redirection triggers
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(
            image: AssetImage(AppAssets.logoSquare),
            width: 150,
            height: 150,
          ),
        ),
    );
  }
}
