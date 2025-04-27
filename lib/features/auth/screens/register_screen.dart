import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/organisms/forms/register.dart';
import '../../../design_system/atoms/logos/logo_square.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/buttons/text_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get _isFormFilled =>
      nameController.text.isNotEmpty && lastNameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateState);
    lastNameController.addListener(_updateState);
    emailController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 24),
                  const LogoSquare(size: 150),
                  const SizedBox(height: 32),
                  RegisterForms(
                    nameController: nameController,
                    lastNameController: lastNameController,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                ],
              ),
              Column(
                children: [
                  CTAButton(
                    text: 'Registrarse',
                    isEnabled: _isFormFilled,
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                  const SizedBox(height: 16),
                  TextOnlyButton(
                    text: 'Ya tengo cuenta',
                    onPressed: () {
                      context.go('/login');
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