import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/molecules/inputs/form_builder_input.dart';
import 'package:ser_manos/design_system/organisms/modal.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller_impl.dart';

import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/organisms/cards/input_card.dart';
import '../../../design_system/organisms/headers/header_modal.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/grid.dart';
import '../controllers/auth_controller_impl.dart';

class ProfileModalScreen extends ConsumerStatefulWidget {
  const ProfileModalScreen({super.key});

  @override
  ConsumerState<ProfileModalScreen> createState() => _ProfileModalScreenState();
}

class _ProfileModalScreenState extends ConsumerState<ProfileModalScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int? _sexoIndex;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).currentUser;
    if (user != null) {
      _sexoIndex = _genderToIndex(user.genero);
    }
  }

  int? _genderToIndex(String? genero) {
    const options = ['Hombre', 'Mujer', 'No binario'];
    return genero != null ? options.indexOf(genero) : null;
  }

  String? _indexToGender(int? index) {
    const options = ['Hombre', 'Mujer', 'No binario'];
    return (index != null && index >= 0 && index < options.length) ? options[index] : null;
  }

  @override
  Widget build(BuildContext context) {
    final fromVolunteering = GoRouterState.of(context).uri.queryParameters['fromVolunteering'];
    final user = ref.watch(authNotifierProvider).currentUser;
    final authController = ref.read(authControllerProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Column(
          children: [
            HeaderModal(onClose: () => context.pop()),
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: {'birthDate': user.fechaNacimiento, 'email': user.email, 'phone': user.telefono},
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text('Datos de perfil', style: AppTypography.headline1.copyWith(color: AppColors.neutral100)),
                      const SizedBox(height: 24),

                      // Fecha de nacimiento
                      FormBuilderAppInput(
                        name: 'birthDate',
                        label: 'Fecha de nacimiento',
                        placeholder: 'DD/MM/YYYY',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(
                            RegExp(r'^(\d{2})/(\d{2})/(\d{4})$'),
                            errorText: 'Fecha inválida',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Genero
                      InputCard(
                        selectedGender: _indexToGender(_sexoIndex),
                        onGenderChanged: (value) {
                          setState(() {
                            _sexoIndex = _genderToIndex(value);
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      Text('Datos de contacto', style: AppTypography.headline1.copyWith(color: AppColors.neutral100)),
                      const SizedBox(height: 24),

                      // Teléfono
                      FormBuilderAppInput(
                        name: 'phone',
                        label: 'Teléfono',
                        placeholder: 'Ej: 1133445566',
                        keyboardType: TextInputType.phone,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(RegExp(r'^\d{7,15}$'), errorText: 'Teléfono inválido'),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      FormBuilderAppInput(
                        name: 'email',
                        label: 'Email',
                        placeholder: 'ejemplo@mail.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(errorText: 'Email inválido'),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // Botón guardar
                      CTAButton(
                        text: 'Guardar datos',
                        onPressed: () async {
                          final isValid = _formKey.currentState?.saveAndValidate() ?? false;
                          if (!isValid || _sexoIndex == null) {
                            if (_sexoIndex == null) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Seleccioná un género')));
                            }
                            return;
                          }

                          final values = _formKey.currentState!.value;

                          await authController.updateUser(user.uuid, {
                            'fechaNacimiento': values['birthDate'],
                            'telefono': values['phone'],
                            'email': values['email'],
                            'genero': _indexToGender(_sexoIndex),
                          });

                          await ref.read(authNotifierProvider.notifier).refreshUser();

                          if (fromVolunteering != null) {
                            final confirm =
                                await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (_) => Center(
                                        child: ModalSermanos(
                                          title: 'Confirmar postulación',
                                          subtitle: '¿Querés postularte al voluntariado?',
                                          confimationText: 'Sí, postularme',
                                          cancelText: 'Cancelar',
                                          onCancel: () => Navigator.of(context).pop(false),
                                          onConfirm: () => Navigator.of(context).pop(true),
                                        ),
                                      ),
                                ) ??
                                false;

                            if (confirm) {
                              final controller = ref.read(volunteeringsControllerProvider);
                              await controller.applyToVolunteering(fromVolunteering);
                              await ref.read(authNotifierProvider.notifier).refreshUser();
                              context.go('/volunteering/$fromVolunteering');
                              return;
                            }
                          }

                          // Si no vino desde voluntariado, comportamiento normal
                          context.go('/profile');
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
