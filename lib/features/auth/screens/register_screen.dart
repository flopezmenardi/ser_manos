import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/organisms/forms/register.dart';

import '../../../design_system/atoms/logos/logo_square.dart';
import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/buttons/text_button.dart';
import '../../../design_system/tokens/colors.dart';
import '../controllers/auth_controller_impl.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.removeListener(_onFormChanged);
    _lastNameController.removeListener(_onFormChanged);
    _emailController.removeListener(_onFormChanged);
    _passwordController.removeListener(_onFormChanged);
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      print('❌ Formulario inválido');
      return;
    }

    print('🟡 Llamando a authStateProvider.register()');
    await ref
        .read(authNotifierProvider.notifier)
        .register(
          nombre: _nameController.text.trim(),
          apellido: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    final error = ref.read(authNotifierProvider).errorMessage;
    if (error == null) {
      print('✅ Registro exitoso');
      context.go('/welcome');
    } else {
      print('❌ Error en el registro: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  bool get _isFormFilled =>
      _nameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        const LogoSquare(size: 150),
                        const SizedBox(height: 32),

                        RegisterForms(
                          nameController: _nameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),

                        const SizedBox(height: 32),
                        const Spacer(),

                        CTAButton(
                          text: state.isLoading ? 'Registrando...' : 'Registrarse',
                          isEnabled: _isFormFilled && !state.isLoading,
                          onPressed: _handleRegister,
                        ),
                        const SizedBox(height: 16),
                        TextOnlyButton(
                          text: 'Ya tengo cuenta',
                          onPressed: () async {
                            context.go('/login');
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
