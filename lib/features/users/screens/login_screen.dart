import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_routes.dart';
import '../../../core/design_system/atoms/logos/logo_square.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/molecules/buttons/text_button.dart';
import '../../../core/design_system/molecules/status_bar/status_bar.dart';
import '../../../core/design_system/organisms/forms/login.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../controllers/user_controller_impl.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _authError = '';

  final _formKey = GlobalKey<FormState>();

  bool get _isFormFilled => emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

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
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: Column(
        children: [
          const StatusBar(variant: StatusBarVariant.form),
          Expanded(
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 24),
                                  const LogoSquare(size: 150),
                                  const SizedBox(height: 32),
                                  Form(
                                    key: _formKey,
                                    child: LoginForms(
                                      emailController: emailController,
                                      passwordController: passwordController,
                                    ),
                                  ),
                                  if (_authError != '') ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      _authError,
                                      style: AppTypography.caption.copyWith(color: AppColors.error100),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        CTAButton(
                          text: 'Iniciar Sesión',
                          isEnabled: _isFormFilled && !authState.isLoading,
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate() ?? false;
                            if (!isValid) return;

                            final success = await authNotifier.login(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            if (!mounted) return;

                            setState(() {
                              _authError = success ? '' : 'Email o contraseña incorrectos';
                            });

                            if (success) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.go(AppRoutes.volunteerings);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextOnlyButton(
                          text: 'No tengo cuenta',
                          onPressed: () async {
                            context.go(AppRoutes.register);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
