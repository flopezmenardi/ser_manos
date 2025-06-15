import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/inputs/inputs.dart';
import 'package:ser_manos/design_system/tokens/typography.dart'; 

class ContactDataFormSermanos extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController telephoneController;

  const ContactDataFormSermanos({
    super.key,
    required this.emailController,
    required this.telephoneController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Datos de contacto',
            style: AppTypography.headline1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Estos datos serán compartidos con la organización para ponerse en contacto contigo',
            style: AppTypography.subtitle1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),

          // Phone Input
          AppInput(
            label: 'Teléfono',
            placeholder: 'Ej: +541178445459',
            controller: telephoneController,
            // keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Email Input
          AppInput(
            label: 'Mail',
            placeholder: 'Ej: mimail@mail.com',
            controller: emailController,
            // keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}