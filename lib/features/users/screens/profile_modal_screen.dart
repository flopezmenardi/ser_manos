import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ser_manos/constants/app_routes.dart';
import 'package:ser_manos/design_system/molecules/inputs/form_builder_input.dart';
import 'package:ser_manos/design_system/organisms/cards/change_profile_picture.dart';
import 'package:ser_manos/design_system/organisms/cards/upload_profile_picture.dart';
import 'package:ser_manos/design_system/organisms/modal.dart';
import 'package:ser_manos/design_system/organisms/utils/photo_picker_model.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller_impl.dart';

import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/organisms/cards/input_card.dart';
import '../../../design_system/organisms/headers/header_modal.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/grid.dart';
import '../controllers/user_controller_impl.dart';

class ProfileModalScreen extends ConsumerStatefulWidget {
  const ProfileModalScreen({super.key});

  @override
  ConsumerState<ProfileModalScreen> createState() => _ProfileModalScreenState();
}

class _ProfileModalScreenState extends ConsumerState<ProfileModalScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int? _sexoIndex;
  bool _hasChanges = false;

  XFile? _newPhoto; 
  String? _newPhotoPath; //  local preview path

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

  Future<void> _pickPhoto() async {
    final XFile? photo = await PhotoPickerUtil.selectFromCameraOrGallery(context);
    if (photo == null) return;

    setState(() {
      _newPhoto = photo;
      _newPhotoPath = photo.path;
    });
    _checkForChanges();
  }

  @override
  Widget build(BuildContext context) {
    final fromVolunteering = GoRouterState.of(context).uri.queryParameters['fromVolunteering'];
    final user = ref.watch(authNotifierProvider).currentUser;
    final authController = ref.read(userControllerProvider);

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
                onChanged: _checkForChanges,
                initialValue: {'birthDate': user.fechaNacimiento, 'email': user.email, 'phone': user.telefono},
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Datos de perfil',
                        style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),

                      // Fecha de nacimiento
                      FormBuilderAppInput(
                        name: 'birthDate',
                        label: 'Fecha de nacimiento',
                        placeholder: 'DD/MM/YYYY',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        ],
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
                          _checkForChanges();
                        },
                      ),

                      const SizedBox(height: 24),
                      if (user.photoUrl != null || _newPhotoPath != null)
                        ChangeProfilePictureCellule(
                          // show the freshly picked photo if present, otherwise the current one
                          imagePath: _newPhotoPath ?? user.photoUrl!,
                          onChangePressed: _pickPhoto,
                        )
                      else
                        UploadProfilePicture(onUploadPressed: _pickPhoto),
                      const SizedBox(height: 24),
                      Text(
                        'Datos de contacto',
                        style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Estos datos serán compartidos con la organización para ponerse en contacto contigo',
                        style: AppTypography.subtitle1,
                      ),
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
                        isEnabled: _hasChanges,
                        onPressed: _hasChanges ? () async {
                          final isValid = _formKey.currentState?.saveAndValidate() ?? false;
                          if (!isValid || _sexoIndex == null) {
                            if (_sexoIndex == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Seleccioná un género', overflow: TextOverflow.ellipsis)),
                              );
                            }
                            return;
                          }

                          final values = _formKey.currentState!.value;

                          if (_newPhoto != null) {
                            await authController.uploadProfilePicture(user.uuid, _newPhoto!);
                            _newPhoto = null;
                          }

                          await authController.updateUser(user.uuid, {
                            'fechaNacimiento': values['birthDate'],
                            'telefono': values['phone'],
                            'email': values['email'],
                            'genero': _indexToGender(_sexoIndex),
                          });

                          await ref.read(authNotifierProvider.notifier).refreshUser();
                          setState(() {
                            _hasChanges = false;
                          });

                          if (fromVolunteering != null) {
                            final controller = ref.read(volunteeringsControllerProvider);
                            final volunteering = await controller.getVolunteeringById(fromVolunteering);
                            final confirm =
                                await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (_) => Center(
                                        child: ModalSermanos(
                                          title: 'Te estás por postular a',
                                          subtitle: volunteering.titulo,
                                          confimationText: 'Confirmar',
                                          cancelText: 'Cancelar',
                                          onCancel: () => Navigator.of(context).pop(false),
                                          onConfirm: () => Navigator.of(context).pop(true),
                                        ),
                                      ),
                                ) ??
                                false;

                            if (confirm) {
                              await controller.applyToVolunteering(fromVolunteering);
                              await ref.read(authNotifierProvider.notifier).refreshUser();
                            }
                            context.go(AppRoutes.volunteeringDetail(fromVolunteering));
                            return;
                          }

                          // Si no vino desde voluntariado, comportamiento normal
                          context.push(AppRoutes.profile);
                        } : null,
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

  void _checkForChanges() {
    final formValues = _formKey.currentState?.instantValue ?? {};
    final user = ref.read(authNotifierProvider).currentUser;
    final genderChanged = _indexToGender(_sexoIndex) != user?.genero;

    final formChanged =
      formValues['birthDate'] != user?.fechaNacimiento ||
      formValues['email'] != user?.email ||
      formValues['phone'] != user?.telefono ||
      genderChanged ||
      _newPhoto != null;

    if (formChanged != _hasChanges) {
      setState(() {
        _hasChanges = formChanged;
      });
    }
  }
}
