import 'package:flutter/material.dart';

TextField datepickerCadastro(
    BuildContext context, TextEditingController controller, String labelText) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      icon: const Icon(Icons.calendar_today),
    ),
    readOnly: true,
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime(2100));
    },
  );
}
