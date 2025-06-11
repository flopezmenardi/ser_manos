import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    await authNotifier.initialize();

    await Future.delayed(const Duration(seconds: 2)); // para mostrar el logo

    final user = ref.read(currentUserProvider);
    if (user != null) {
      context.go('/volunteerings');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/logos/logo_square.png'),
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
