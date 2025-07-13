import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import '../../molecules/inputs/inputs.dart';

class RegisterForms extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final bool enableValidation;

  const RegisterForms({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.enableValidation = false,
  });

  @override
  State<RegisterForms> createState() => _RegisterFormsState();
}

class _RegisterFormsState extends State<RegisterForms> {
  bool _isPasswordVisible = false;
  
  // Focus nodes for field navigation
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: AppLocalizations.of(context)!.name,
          placeholder: AppLocalizations.of(context)!.namePlaceholder,
          controller: widget.nameController,
          focusNode: _nameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _lastNameFocusNode.requestFocus(),
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
          focusNode: _lastNameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _emailFocusNode.requestFocus(),
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _passwordFocusNode.requestFocus(),
          supportingText: widget.emailError,
          hasError: widget.emailError != null,
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          obscureText: !_isPasswordVisible,
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
