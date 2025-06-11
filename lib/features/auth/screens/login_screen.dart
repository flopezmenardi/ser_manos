import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/organisms/modal.dart';
import '../../../design_system/atoms/logos/logo_square.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/buttons/text_button.dart';
import '../../../design_system/organisms/forms/login.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // 🆕

  bool get _isFormFilled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {}); 
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 96),
                  const LogoSquare(size: 150),
                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: LoginForms(
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CTAButton(
                    text: 'Iniciar Sesión',
                    isEnabled: _isFormFilled && !authState.isLoading,
                    onPressed: () async {
                      final isValid = _formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      await authNotifier.login(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      final error = ref.read(authStateProvider).errorMessage;
                      if (error == null) {
                        context.go('/home');
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => Center(
                            child: ModalSermanos(
                              title: 'Error al iniciar sesión',
                              subtitle: 'El email o la contraseña son incorrectos.',
                              confimationText: 'Reintentar',
                              cancelText: 'Cancelar',
                              onCancel: () => Navigator.of(context).pop(),
                              onConfirm: () => Navigator.of(context).pop(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextOnlyButton(
                    text: 'No tengo cuenta',
                    onPressed: () async {
                      context.go('/register');
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}