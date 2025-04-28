import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/organisms/forms/contact_data_form.dart';
import 'package:ser_manos/design_system/organisms/forms/personal_data.dart';
import 'package:ser_manos/design_system/organisms/headers/header_modal.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';

class ProfileModalScreen extends StatelessWidget {
  const ProfileModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderModal(onClose: () => context.pop()),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppGrid.horizontalMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PersonalData(birthDateController: TextEditingController()),

                    const SizedBox(height: 24),

                    ContactDataFormSermanos(
                      emailController: TextEditingController(),
                      telephoneController: TextEditingController(),
                    ),

                    const SizedBox(height: 24),

                    CTAButton(
                      text: 'Guardar datos',
                      onPressed: () {
                        // TODO: actually save data
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
