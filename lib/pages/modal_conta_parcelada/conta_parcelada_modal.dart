import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/conta_parcelada.dart';
import 'package:help_mei/main.dart';
import 'package:help_mei/widgets/conta_textfield.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class ContaParceladaModal extends StatefulWidget {
  const ContaParceladaModal({super.key, required this.controller});
  final EntityControllerGeneric controller;

  @override
  State<ContaParceladaModal> createState() => _ContaParceladaModalState();
}

class _ContaParceladaModalState extends State<ContaParceladaModal> {
  final _descicaoController = TextEditingController();

  final _valorTotalController = TextEditingController();

  final _numeroParcelasController = TextEditingController();

  final _valorParcelasController = TextEditingController();

  final _dataParcelaController = TextEditingController();

  double valorParcelas = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ContaTextField(
              labelText: 'Descrição',
              controller: _descicaoController,
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Valor Total',
              controller: _valorTotalController,
              onChanged: _onChangedValorTotal,
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Número de Parcelas',
              controller: _numeroParcelasController,
              onChanged: _onChangedNumeroParcelas,
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Valor das Parcelas',
              controller: _valorParcelasController,
            ),
            const Divider(),
            ContaTextField(
              labelText: 'Vencimento da 1ª parcela',
              controller: _dataParcelaController,
              onTap: _onTapDataParcela,
              readOnly: true,
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: _onPressedAdicionar,
                    child: const Text('Adicionar'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onPressedAdicionar() async {
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

    String descricao = _descicaoController.text;
    double valorTotal = double.parse(_valorTotalController.text);
    int numParcelas = int.parse(_numeroParcelasController.text);
    double valorParcela = double.parse(_valorParcelasController.text);
    DateTime vencimentoParcela =
        DateFormat('dd-MM-yyyy').parse(_dataParcelaController.text);
    var parcelada = ContaParcelada.noPrimaryKey(
      descricaoConta: descricao,
      numeroParcelas: numParcelas,
      dataPrimeiraParcela: vencimentoParcela,
      valorTotal: valorTotal,
    );
    await widget.controller.insertEntity(parcelada);
    for (int i = 0; i < numParcelas; i++) {
      DateTime vencimento =
          Jiffy.parseFromDateTime(vencimentoParcela).add(months: i).dateTime;

      Conta conta = Conta.noPrimaryKey(
        idTipoConta: 13,
        descricaoConta: descricao,
        valorConta: valorParcela,
        totalParcelas: (i + 1),
        dataVencimento: vencimento,
        quitadaConta: false,
        ativaConta: true,
        idContaParcelada: parcelada.idContaParcelada,
      );
      await widget.controller.insertEntity(conta);
    }

    var c = navigatorKey.currentState!.context;

    if (c.mounted) {
      Navigator.of(c).pop();
      Navigator.of(c).pop();
    }
  }

  void _onChangedValorTotal(String text) {
    var value = double.tryParse(text);
    var numParcelas = int.tryParse(_numeroParcelasController.text);
    if (value != null && numParcelas != null) {
      setState(() {
        valorParcelas = value / numParcelas;
        _valorParcelasController.text = valorParcelas.toStringAsFixed(2);
      });
    }
  }

  void _onChangedNumeroParcelas(String text) {
    var numParcelas = int.tryParse(text);
    var value = double.tryParse(_valorTotalController.text);
    if (value != null && numParcelas != null) {
      setState(() {
        valorParcelas = value / numParcelas;
        _valorParcelasController.text = valorParcelas.toStringAsFixed(2);
      });
    }
  }

  void _onTapDataParcela() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _dataParcelaController.text = formattedDate;
      });
    }
  }
}
