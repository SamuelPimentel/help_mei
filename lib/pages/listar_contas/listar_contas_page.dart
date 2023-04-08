import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/main.dart';
import 'package:help_mei/pages/modal_conta/conta_simples_modal.dart';
import 'package:help_mei/pages/modal_conta_parcelada/conta_parcelada_modal.dart';
import 'package:intl/intl.dart';

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
      if (!(element as Conta).ativaConta) {
        return false;
      }
      if (element.dataPagamento == null) {
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

  void onPressedParcelada(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ContaParceladaModal(
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.attach_money),
            label: 'Adicionar Despesa',
            onTap: () {
              floatingActionButtonOnPressed(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.credit_card),
            label: 'Adicionar Despesa Parcelada',
            onTap: () {
              onPressedParcelada(context);
            },
          )
        ],
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              conta.tipoConta!.iconTipoConta!.icon,
              size: 50,
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'R\$ ${conta.valorConta.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
            ),
            const VerticalDivider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Pagamento:'),
                    const SizedBox(
                      width: 5,
                    ),
                    if (conta.dataPagamento != null)
                      Text(
                          DateFormat('dd-MM-yyyy').format(conta.dataPagamento!))
                    else
                      const Text('Não Pago')
                  ],
                ),
                Row(
                  children: [
                    const Text('Tipo:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(conta.tipoConta!.nomeTipoConta)
                  ],
                )
              ],
            ),
            const VerticalDivider(),
            InkWell(
              splashColor: Theme.of(context).colorScheme.secondary,
              onTap: () {
                onTapCard(conta);
              },
              child: const SizedBox(
                height: 50,
                child: Icon(
                  Icons.delete,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTapCard(Conta conta) {
    var context = navigatorKey.currentState!.context;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                onTapExcluiDespesa(conta);
              },
              child: const Text('Sim'),
            )
          ],
          content: const Text('Deseja excluir a despesa?'),
        );
      },
    );
  }

  void onTapExcluiDespesa(Conta conta) async {
    var context = navigatorKey.currentState!.context;
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: SizedBox(
            width: 50,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
    conta.ativaConta = false;
    await widget.controller.updateEntity(conta);
    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {
        getFuture();
      });
    }
  }
}
