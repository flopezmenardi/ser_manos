import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ser_manos/design_system/molecules/inputs/inputs.dart';

class FormBuilderAppInput extends StatelessWidget {
  final String name;
  final String label;
  final String? placeholder;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  const FormBuilderAppInput({
    super.key,
    required this.name,
    required this.label,
    this.placeholder,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: name,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return AppInput(
          label: label,
          placeholder: placeholder,
          controller: TextEditingController(text: field.value ?? '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: field.value?.length ?? 0),
            ),
          hasError: field.hasError,
          supportingText: field.errorText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: field.didChange,
        );
      },
    );
  }
}
