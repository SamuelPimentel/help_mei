import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/entrada_saida.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_movimentacao.dart';
import 'package:help_mei/main.dart';
import 'package:help_mei/widgets/conta_textfield.dart';
import 'package:intl/intl.dart';

class CompraProduto extends StatefulWidget {
  const CompraProduto(
      {super.key, required this.produto, required this.controller});
  final Produto produto;
  final EntityControllerGeneric controller;

  @override
  State<CompraProduto> createState() => _CompraProdutoState();
}

class _CompraProdutoState extends State<CompraProduto> {
  final _quantidadeController = TextEditingController();
  final _totalController = TextEditingController();
  final _valorUnitarioController = TextEditingController();

  double valorUnitario = 0;
  bool _compradoHoje = true;

  String _dataCompra = '';
  @override
  void initState() {
    super.initState();
    _dataCompra = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  void _onChangedQuantidadeComprada(String value) {
    var qtde = int.tryParse(value);
    var total = double.tryParse(_totalController.text);
    if (qtde != null && total != null) {
      setState(() {
        valorUnitario = total / qtde;
        _valorUnitarioController.text = valorUnitario.toStringAsFixed(2);
      });
    }
  }

  void _onChangedValorTotal(String value) {
    var qtde = int.tryParse(_quantidadeController.text);
    var total = double.tryParse(value);
    if (qtde != null && total != null) {
      setState(() {
        valorUnitario = total / qtde;
        _valorUnitarioController.text = valorUnitario.toStringAsFixed(2);
      });
    }
  }

  Widget contaCheckBox(
      String title, bool valor, void Function(bool? v) onChanged) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        Checkbox(value: valor, onChanged: onChanged)
      ],
    );
  }

  void onTapDate(
      BuildContext context, void Function(String v) changeState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      changeState(formattedDate);
    }
  }

  Widget dataTextBox({
    required String text,
    required void Function(String v) changeState,
    required BuildContext context,
    required String dataVencimento,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Text(text),
          const Spacer(),
          TextButton(
              onPressed: () {
                onTapDate(context, changeState);
              },
              child: Text(dataVencimento))
        ],
      ),
    );
  }

  void onTapCadasrar() async {
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
    TipoMovimentacao tipoMovimentacao = TipoMovimentacao.empty();
    tipoMovimentacao.id = 1;
    var quantidade = double.parse(_quantidadeController.text);
    var total = double.parse(_totalController.text);
    EntradaSaida entrada;
    if (_compradoHoje) {
      entrada = EntradaSaida.noPrimaryKeyToday(
          produto: widget.produto,
          tipoMovimentacao: tipoMovimentacao,
          quantidade: quantidade,
          total: total,
          valorUnitario: valorUnitario);
    } else {
      entrada = EntradaSaida.noPrimaryKey(
          produto: widget.produto,
          tipoMovimentacao: tipoMovimentacao,
          dataMovimentacao: DateFormat('dd-MM-yyyy').parse(_dataCompra),
          quantidade: quantidade,
          total: total,
          valorUnitario: valorUnitario);
    }

    await widget.controller.insertEntity(entrada);
    var c = navigatorKey.currentState!.context;
    if (c.mounted) {
      Navigator.of(c).pop();
      Navigator.of(c).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Compra de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Hero(
              tag: widget.produto.nomeProduto,
              child: Text(
                widget.produto.nomeProduto,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Quantidade Comprada',
              controller: _quantidadeController,
              onChanged: (text) => _onChangedQuantidadeComprada(text),
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Total Pago',
              controller: _totalController,
              onChanged: (text) => _onChangedValorTotal(text),
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Valor Unitário',
              controller: _valorUnitarioController,
            ),
            const Divider(),
            contaCheckBox('Foi Comprado Hoje?', _compradoHoje, (v) {
              setState(() {
                _compradoHoje = v!;
              });
            }),
            if (!_compradoHoje)
              dataTextBox(
                text: 'Data da compra',
                changeState: (v) {
                  setState(() {
                    _dataCompra = v;
                  });
                },
                context: context,
                dataVencimento: _dataCompra,
              ),
            const SizedBox(height: 40),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onTapCadasrar,
                  child: const Text('Cadastrar'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
