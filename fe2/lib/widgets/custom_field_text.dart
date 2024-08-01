import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Function(String) onSaved;
  final String? Function(String?)? validator;

  CustomTextField({required this.label, required this.onSaved, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: validator,
      onSaved: (value) => onSaved(value!),
    );
  }
}
