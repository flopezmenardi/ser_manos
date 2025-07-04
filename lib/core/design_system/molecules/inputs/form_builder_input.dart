import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'inputs.dart';

class FormBuilderAppInput extends StatelessWidget {
  final String name;
  final String label;
  final String? placeholder;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const FormBuilderAppInput({
    super.key,
    required this.name,
    required this.label,
    this.placeholder,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
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
            ..selection = TextSelection.fromPosition(TextPosition(offset: field.value?.length ?? 0)),
          hasError: field.hasError,
          supportingText: field.errorText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: field.didChange,
          inputFormatters: inputFormatters, // nuevo
        );
      },
    );
  }
}
