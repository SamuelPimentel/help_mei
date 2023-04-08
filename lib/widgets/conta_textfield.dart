import 'package:flutter/material.dart';

class ContaTextField extends StatelessWidget {
  const ContaTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });
  final String labelText;
  final TextEditingController controller;
  final void Function(String text)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}
