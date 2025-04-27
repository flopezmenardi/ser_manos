import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/atoms/logos/logo_square.dart';
import '../../../design_system/tokens/typography.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/buttons/text_button.dart';
import '../../../design_system/organisms/forms/login.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                  LoginForms(
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                ],
              ),
              Column(
                children: [
                  CTAButton(
                    text: 'Iniciar sesión',
                    onPressed: _isFormFilled
                        ? () {
                            // Example: GoRouter navigation
                            context.go('/home');
                          }
                        : null, // disabled when inputs are empty
                  ),
                  const SizedBox(height: 16),
                  TextOnlyButton(
                    text: 'No tengo cuenta',
                    onPressed: () {
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