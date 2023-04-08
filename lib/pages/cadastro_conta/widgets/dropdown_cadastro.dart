import 'package:flutter/material.dart';

Widget dropdownCadastro(String dropdownValue, List<String> dropdownItens,
    Function(String? value) onChanged) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
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
          Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
              ),
            ],
          )
      ],
    ),
  );
}
