import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/modal_conta/conta_simples_modal.dart';
import 'package:path/path.dart';

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

  Future<Map> getFuture() async {
    var items = await widget.controller.getEntities(Conta.empty());
    int ano = DateTime.now().year;
    var res = items.where((element) {
      if ((element as Conta).dataPagamento == null) {
        if (element.dataVencimento.year == ano &&
            element.dataVencimento.month == widget.month) {
          return true;
        }
      } else if (element.dataPagamento!.month == widget.month &&
          element.dataPagamento!.year == ano) {
        return true;
      }
      return false;
    }).toList();
    var contas = res.map((e) => e as Conta).toList();

    return {'contas': contas};
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
    ).then((value) {
      setState(() {
        getFuture();
      });
    });
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
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder(
      future: getFuture(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError) return Container();
            return buildListView(context, snapshot);
        }
      },
    );
  }

  Widget buildListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: snapshot.data['contas'].length,
      itemBuilder: (context, index) {
        return contaCard(context, snapshot.data['contas'][index]);
      },
    );
  }

  Widget contaCard(BuildContext context, Conta conta) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          Icon(
            conta.tipoConta!.iconTipoConta!.icon,
            size: 50,
          ),
          const VerticalDivider(),
          Column(
            children: [
              Text(
                'R\$ ${conta.valorConta}',
                style: Theme.of(context).textTheme.headlineLarge,
              )
            ],
          )
        ],
      ),
    );
  }
}
