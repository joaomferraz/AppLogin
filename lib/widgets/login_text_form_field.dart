// lib/widgets/login_text_form_field.dart
import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final String? Function(String?) validator;

  const LoginTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          debugPrint('Campo "$label" está em foco');
        }
      },
    );
  }
}
