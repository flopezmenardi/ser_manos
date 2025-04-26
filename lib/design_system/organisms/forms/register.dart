import 'package:flutter/material.dart';
import '../../molecules/inputs/inputs.dart';

class RegisterForms extends StatelessWidget {
  // final TextEditingController nameController;
  // final TextEditingController lastNameController;
  // final TextEditingController emailController;
  // final TextEditingController passwordController;

  const RegisterForms({
    super.key,
    // required this.nameController,
    // required this.lastNameController,
    // required this.emailController,
    // required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: 'Nombre',
          placeholder: 'Ej: Juan',
          // controller: nameController,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Apellido',
          placeholder: 'Ej: Barcena',
          // controller: lastNameController,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Email',
          placeholder: 'Ej: juanbarcena@mail.com',
          // controller: emailController,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Contraseña',
          placeholder: 'Ej: ABCD1234',
          // controller: passwordController,
        ),
      ],
    );
  }
}