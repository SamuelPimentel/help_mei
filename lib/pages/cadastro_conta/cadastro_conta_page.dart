import 'package:flutter/material.dart';
import 'package:help_mei/pages/cadastro_conta/cadastro_conta_step.dart';

class CadastroContaPage extends StatelessWidget {
  const CadastroContaPage({super.key, required this.dropDownItens});
  final double size = 0.8;
  final List<String> dropDownItens;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro da Conta')),
      body: CadastroContaStep(dropDownItens: dropDownItens),
    );
  }
}
