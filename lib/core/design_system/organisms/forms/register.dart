import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import '../../molecules/inputs/inputs.dart';

class RegisterForms extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;

  const RegisterForms({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    this.emailError,
  });

  @override
  State<RegisterForms> createState() => _RegisterFormsState();
}

class _RegisterFormsState extends State<RegisterForms> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: AppLocalizations.of(context)!.name,
          placeholder: AppLocalizations.of(context)!.namePlaceholder,
          controller: widget.nameController,
          validator: (value) {
            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.nameRequired;
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: AppLocalizations.of(context)!.lastName,
          placeholder: AppLocalizations.of(context)!.lastNamePlaceholder,
          controller: widget.lastNameController,
          validator: (value) {
            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.lastNameRequired;
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: AppLocalizations.of(context)!.email,
          placeholder: AppLocalizations.of(context)!.emailPlaceholder,
          controller: widget.emailController,
          supportingText: widget.emailError,
          hasError: widget.emailError != null,
          validator: (value) {
            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
            if (!value.contains('@')) return AppLocalizations.of(context)!.emailInvalid;
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: AppLocalizations.of(context)!.password,
          placeholder: AppLocalizations.of(context)!.passwordPlaceholder,
          controller: widget.passwordController,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
            if (value.length < 8) return AppLocalizations.of(context)!.passwordMinLength;
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return AppLocalizations.of(context)!.passwordComplexity;
            }
            return null;
          },
        ),
      ],
    );
  }
}