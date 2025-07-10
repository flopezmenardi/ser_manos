import 'package:flutter/material.dart';
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
          label: 'Nombre',
          placeholder: 'Ej: Juan',
          controller: widget.nameController,
          focusNode: _nameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _lastNameFocusNode.requestFocus(),
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Nombre requerido';
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Apellido',
          placeholder: 'Ej: Barcena',
          controller: widget.lastNameController,
          focusNode: _lastNameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _emailFocusNode.requestFocus(),
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Apellido requerido';
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Email',
          placeholder: 'Ej: juanbarcena@mail.com',
          controller: widget.emailController,
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: () => _passwordFocusNode.requestFocus(),
          supportingText: widget.emailError,
          hasError: widget.emailError != null,
          autovalidateMode: widget.enableValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email requerido';
            if (!value.contains('@')) return 'Email inválido';
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Contraseña',
          placeholder: 'Ej: Abcd123!',
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
            if (value == null || value.isEmpty) return 'Contraseña requerida';
            if (value.length < 8) return 'Contraseña debe contener al menos 8 caracteres';
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Contraseña debe contener al menos una letra mayúscula, una minúscula y un número';
            }
            return null;
          },
        ),
      ],
    );
  }
}