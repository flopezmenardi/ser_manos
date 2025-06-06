import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/molecules/buttons/cta_button.dart';
import '../../design_system/organisms/forms/contact_data_form.dart';
import '../../design_system/organisms/forms/personal_data.dart';
import '../../design_system/organisms/headers/header_modal.dart';
import '../../design_system/tokens/colors.dart';
import '../../design_system/tokens/grid.dart';
import '../../providers/auth_provider.dart';
import 'controller/profile_controller.dart';

class ProfileModalScreen extends ConsumerStatefulWidget {
  const ProfileModalScreen({super.key});

  @override
  ConsumerState<ProfileModalScreen> createState() => _ProfileModalScreenState();
}

class _ProfileModalScreenState extends ConsumerState<ProfileModalScreen> {
  late final TextEditingController birthDateController;
  late final TextEditingController emailController;
  late final TextEditingController telephoneController;

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    birthDateController = TextEditingController();
    emailController = TextEditingController();
    telephoneController = TextEditingController();

    final user = ref.read(currentUserProvider);
    if (user != null) {
      birthDateController.text = user.fechaNacimiento;
      emailController.text = user.email;
      telephoneController.text = user.telefono;
      selectedGender = user.genero;
    }
  }

  @override
  void dispose() {
    birthDateController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final updateUser = ref.watch(updateUserProvider);
    final refreshUser = ref.read(refreshUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                    PersonalData(
                      birthDateController: birthDateController,
                      selectedGender: selectedGender,
                      onGenderChanged: (gender) {
                        setState(() {
                          selectedGender = gender;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ContactDataFormSermanos(
                      emailController: emailController,
                      telephoneController: telephoneController,
                    ),
                    const SizedBox(height: 24),
                    CTAButton(
                      text: 'Guardar datos',
                      onPressed: () async {
                        await updateUser(user.uuid, {
                          'fechaNacimiento': birthDateController.text,
                          'email': emailController.text,
                          'telefono': telephoneController.text,
                          'genero': selectedGender,
                        });
                        await refreshUser(); // 🆕 Refresh after update
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
