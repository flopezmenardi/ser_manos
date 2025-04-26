import 'package:flutter/material.dart';
import '../../molecules/inputs/inputs.dart';
import '../../tokens/colors.dart';

class LoginForms extends StatelessWidget {
  // final TextEditingController emailController;
  // final TextEditingController passwordController;

  const LoginForms({
    super.key,
    // required this.emailController,
    // required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: 'Email',
          placeholder: 'Ej: juanbarcena@mail.com',
          // controller: emailController,
        ),
        const SizedBox(height: 24),
        // _PasswordInput(controller: passwordController),
        _PasswordInput(),
      ],
    );
  }
}

class _PasswordInput extends StatefulWidget {
  // final TextEditingController controller;

  // const _PasswordInput({required this.controller});
  const _PasswordInput();

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
      placeholder: 'Ej: ABCD1234',
      // controller: widget.controller,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.neutral75,
        ),
        onPressed: _toggleVisibility,
      ),
      readOnly: false,
      onTap: null,
    );
  }
}