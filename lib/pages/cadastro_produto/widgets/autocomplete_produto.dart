import 'package:flutter/material.dart';

Widget autoCompleteProduto(
    TextEditingController controller, List<String> options, String labelText) {
  return Autocomplete<String>(
    fieldViewBuilder:
        (context, textEditingController, focusNode, onFieldSubmitted) {
      return TextField(
        controller: textEditingController,
        focusNode: focusNode,
        onEditingComplete: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          controller.text = value;
        },
      );
    },
    onSelected: (option) {
      controller.text = option;
    },
    optionsBuilder: (controller) {
      if (controller.text.isEmpty) {
        return const Iterable<String>.empty();
      }

      return options.where((String option) {
        return option.toLowerCase().contains(controller.text.toLowerCase());
      });
    },
  );
}
