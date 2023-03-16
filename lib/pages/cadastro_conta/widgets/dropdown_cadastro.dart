import 'package:flutter/material.dart';

Widget dropdownCadastro(String dropdownValue, List<String> dropdownItens,
    Function(String? value) onChanged) {
  return Column(
    children: [
      DropdownButton<String>(
        value: dropdownValue,
        onChanged: onChanged,
        items: dropdownItens.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList(),
      ),
      if (dropdownValue == 'Outro')
        TextFormField(
          decoration: const InputDecoration(labelText: 'Descrição'),
        )
    ],
  );
}
