import 'package:flutter/material.dart';

Step stepCadastro(
  BuildContext context,
  String title,
  int currentIndex,
  int stepIndex,
  Widget content,
) {
  return Step(
    state: currentIndex > stepIndex ? StepState.complete : StepState.indexed,
    isActive: currentIndex >= stepIndex,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
    content: content,
  );
}
