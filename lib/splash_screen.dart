import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/users/controllers/user_controller_impl.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Run navigation only once after first build
    if (!_navigated) {
      _navigated = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authState = ref.read(authNotifierProvider);

        if (authState.currentUser != null) {
          context.go('/volunteerings');
        } else {
          context.go('/initial');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/logos/logo_square.png', width: 120, height: 120)),
    );
  }
}
