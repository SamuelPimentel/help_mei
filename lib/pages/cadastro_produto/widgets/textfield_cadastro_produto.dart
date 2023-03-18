import 'package:flutter/material.dart';

Widget textfieldCadastroProduto(
    BuildContext context, String labelText, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
    ),
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (_) {
      FocusScope.of(context).requestFocus();
    },
  );
}
