import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'inputs.dart';

class FormBuilderAppInput extends StatefulWidget {
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
  State<FormBuilderAppInput> createState() => _FormBuilderAppInputState();
}

class _FormBuilderAppInputState extends State<FormBuilderAppInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        // Only update controller text if the field value is different from controller text
        // and the controller is not currently focused (to avoid cursor jumping during typing)
        if (field.value != _controller.text && !_controller.selection.isValid) {
          _controller.text = field.value ?? '';
        }

        return AppInput(
          label: widget.label,
          placeholder: widget.placeholder,
          controller: _controller,
          hasError: field.hasError,
          supportingText: field.errorText,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: (value) {
            field.didChange(value);
          },
          inputFormatters: widget.inputFormatters,
        );
      },
    );
  }
}
