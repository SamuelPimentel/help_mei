import 'package:flutter/material.dart';

Widget textFieldCadastro(BuildContext context, String labelText, Icon icon,
    TextEditingController controller,
    {void Function()? onTap,
    bool readOnly = false,
    TextInputType? keyboardType}) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            icon: icon,
          ),
          keyboardType: keyboardType,
          onTap: onTap,
          readOnly: readOnly,
        ),
      ),
    ],
  );
}
