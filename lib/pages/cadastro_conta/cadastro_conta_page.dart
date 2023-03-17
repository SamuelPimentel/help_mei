import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/pages/cadastro_conta/cadastro_conta_step.dart';

class CadastroContaPage extends StatelessWidget {
  const CadastroContaPage(
      {super.key, required this.dropDownItens, required this.controller});
  final double size = 0.8;
  final List<String> dropDownItens;
  final EntityControllerGeneric controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro da Conta')),
      body: CadastroContaStep(
          dropDownItens: dropDownItens, controller: controller),
    );
  }
}
