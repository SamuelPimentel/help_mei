import 'package:flutter/material.dart';

Widget dropDownCadastroPage(
    {required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    required String value}) {
  return DropdownButton<String>(
    items: items,
    onChanged: onChanged,
    value: value,
  );
}
