import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/modal_conta/conta_simples_modal.dart';

class ListarContasPage extends StatefulWidget {
  const ListarContasPage(
      {super.key, required this.month, required this.controller});
  final int month;

  final EntityControllerGeneric controller;

  @override
  State<ListarContasPage> createState() => _ListarContasPageState();
}

class _ListarContasPageState extends State<ListarContasPage> {
  List<TipoConta> tipoContas = [];
  @override
  void initState() {
    super.initState();
    recuperaListaTipoConta();
  }

  void recuperaListaTipoConta() async {
    var result = await widget.controller.getEntities(TipoConta.empty());
    tipoContas = result.map((e) => e as TipoConta).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas do mês ${widget.month}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          floatingActionButtonOnPressed(context);
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  void floatingActionButtonOnPressed(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ContaSimplesModal(
          tipoContas: tipoContas,
          controller: widget.controller,
        );
      },
    );
  }
}
