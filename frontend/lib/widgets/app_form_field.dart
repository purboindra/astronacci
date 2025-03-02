import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.readOnly,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      readOnly: readOnly ?? false,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }

            if (value.isNotEmpty &&
                (!value.contains('@') || !value.contains('.'))) {
              return 'Please enter a valid email';
            }

            return null;
          },
    );
  }
}
