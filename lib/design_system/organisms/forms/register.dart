import 'package:flutter/material.dart';
import '../../molecules/inputs/inputs.dart';

class RegisterForms extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterForms({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
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
          label: 'Nombre',
          placeholder: 'Ej: Juan',
          controller: widget.nameController,
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
          validator: (value) {
            if (value == null || value.isEmpty) return 'Apellido requerido';
            return null;
          },
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Email',
          placeholder: 'Ej: juan@mail.com',
          controller: widget.emailController,
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
            if (value == null || value.isEmpty) return 'Contraseña requerido';
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