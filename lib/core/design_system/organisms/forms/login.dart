import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import '../../molecules/inputs/inputs.dart';
import '../../tokens/colors.dart';

class LoginForms extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForms({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: AppLocalizations.of(context)!.email,
          placeholder: AppLocalizations.of(context)!.emailPlaceholder,
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
            if (!value.contains('@')) return AppLocalizations.of(context)!.emailInvalid;
            return null;
          },
        ),
        const SizedBox(height: 24),
        _PasswordInput(controller: passwordController),
      ],
    );
  }
}

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordInput({required this.controller});

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppInput(
      label: AppLocalizations.of(context)!.password,
      placeholder: AppLocalizations.of(context)!.passwordPlaceholder,
      controller: widget.controller,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.neutral75,
        ),
        onPressed: _toggleVisibility,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
        return null;
      },
    );
  }
}