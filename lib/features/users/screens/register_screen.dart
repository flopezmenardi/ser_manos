import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../../constants/app_routes.dart';
import '../../../core/design_system/atoms/logos/logo_square.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/molecules/buttons/text_button.dart';
import '../../../core/design_system/molecules/status_bar/status_bar.dart';
import '../../../core/design_system/organisms/forms/register.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../controllers/user_controller_impl.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _emailError;

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

    _emailController.addListener(() {
      if (_emailError != null) {
        setState(() => _emailError = null);
      }
    });
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
    setState(() { _emailError = null; });
    ref.read(authNotifierProvider.notifier).clearError(); // Clear error in provider's state

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .register(
          nombre: _nameController.text.trim(),
          apellido: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

@override
Widget build(BuildContext context) {
  ref.listen<AuthState>(authNotifierProvider, (previous, current) {
    if (previous?.isLoading == true && !current.isLoading) {
      if (current.currentUser != null) {
        if (_emailError != null) {
          setState(() {
            _emailError = null;
          });
        }
        if (mounted) {
          GoRouter.of(context).go(AppRoutes.welcome);
        }
      } else if (current.errorMessage != null) {
        setState(() {
          _emailError = current.errorMessage;
        });
      }
    }
  });

  final state = ref.watch(authNotifierProvider);

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
                              emailError: _emailError,
                            ),
                            const SizedBox(height: 32),
                            const Spacer(),
                            CTAButton(
                              text: state.isLoading ? AppLocalizations.of(context)!.registering : AppLocalizations.of(context)!.register,
                              isEnabled: (_formKey.currentState?.validate() ?? false) && !state.isLoading,
                              onPressed: _handleRegister,
                            ),
                            const SizedBox(height: 16),
                            TextOnlyButton(
                              text: AppLocalizations.of(context)!.alreadyHaveAccount,
                              onPressed: () async {
                                context.go(AppRoutes.login);
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
        ),
      ],
    ),
  );
}
}