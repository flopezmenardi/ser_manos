import 'package:flutter/material.dart';
import '../../molecules/inputs/inputs.dart';
import '../../tokens/colors.dart';

class LoginForms extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForms({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginForms> createState() => _LoginFormsState();
}

class _LoginFormsState extends State<LoginForms> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  @override
  void dispose() {
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
          label: 'Email',
          placeholder: 'Ej: juanbarcena@mail.com',
          controller: widget.emailController,
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _passwordFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email requerido';
            if (!value.contains('@')) return 'Email inválido';
            return null;
          },
        ),
        const SizedBox(height: 24),
        _PasswordInput(
          controller: widget.passwordController,
          focusNode: _passwordFocusNode,
        ),
      ],
    );
  }
}

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const _PasswordInput({
    required this.controller,
    this.focusNode,
  });

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
      label: 'Contraseña',
      placeholder: 'Ej: Abcd123!',
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.done,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.neutral75,
        ),
        onPressed: _toggleVisibility,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Contraseña requerida';
        return null;
      },
    );
  }
}