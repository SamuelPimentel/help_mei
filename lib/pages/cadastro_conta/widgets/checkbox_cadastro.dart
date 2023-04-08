import 'package:flutter/material.dart';

Widget checkboxCadastro(
    bool value, String checkboxText, void Function(bool? value)? onChanged) {
  return Row(children: [
    Text(checkboxText),
    Checkbox(
      value: value,
      onChanged: onChanged,
    ),
  ]);
}
