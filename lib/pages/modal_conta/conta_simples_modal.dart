import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/main.dart';
import 'package:intl/intl.dart';

class ContaSimplesModal extends StatefulWidget {
  const ContaSimplesModal(
      {super.key, required this.tipoContas, required this.controller});
  final List<TipoConta> tipoContas;
  final EntityControllerGeneric controller;

  @override
  State<ContaSimplesModal> createState() => _ContaSimplesModalState();
}

class _ContaSimplesModalState extends State<ContaSimplesModal> {
  String _nomeTipoConta = '';
  String _dataVencimento = '';
  bool _vencida = false;
  final _valorDespesa = TextEditingController();
  String? _valorDespesaError;

  @override
  void initState() {
    super.initState();
    _nomeTipoConta = widget.tipoContas.first.nomeTipoConta;
    _dataVencimento = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      contaTextBox('Valor da despesa', _valorDespesa,
                          _valorDespesaError),
                      const Divider(),
                      contaDropdown(
                          'Tipo',
                          _nomeTipoConta,
                          widget.tipoContas
                              .map((e) => e.nomeTipoConta)
                              .toList(), (v) {
                        setState(() {
                          _nomeTipoConta = v!;
                        });
                      }),
                      const Divider(),
                      contaCheckBox('Ainda vai vencer?', _vencida, (v) {
                        setState(() {
                          _vencida = v!;
                        });
                      }),
                      if (_vencida)
                        dataTextBox(
                            text: 'Data do vencimento',
                            changeState: (v) {
                              setState(() {
                                _dataVencimento = v;
                              });
                            },
                            context: context,
                            dataVencimento: _dataVencimento)
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar')),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        salvarConta(context);
                      },
                      child: const Text('Salvar'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void salvarConta(BuildContext context) async {
    if (_valorDespesa.text.isEmpty) {
      setState(() {
        _valorDespesaError = 'Digite um valor';
      });
      return;
    } else {
      setState(() {
        _valorDespesaError = null;
      });
    }

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

    var result = widget.tipoContas
        .where((element) => element.nomeTipoConta == _nomeTipoConta);
    TipoConta tipoConta = result.first;
    double valor = double.parse(_valorDespesa.text);
    DateTime dataVencimento = DateFormat('dd-MM-yyyy').parse(_dataVencimento);

    Conta conta = Conta.noPrimaryKey(
      idTipoConta: tipoConta.idTipoConta,
      descricaoConta: tipoConta.nomeTipoConta,
      valorConta: valor,
      totalParcelas: 1,
      dataVencimento: dataVencimento,
      dataPagamento: DateTime.now(),
      quitadaConta: true,
      ativaConta: true,
    );
    var c = navigatorKey.currentState!.context;
    await widget.controller.insertEntity(conta);
    if (c.mounted) {
      Navigator.of(c).pop();
      Navigator.of(c).pop();
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

  Widget contaDropdown(String title, String value, List<String> values,
      void Function(String? v) onChanged) {
    List<DropdownMenuItem<String>> items = values.map(
      (e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      },
    ).toList();
    return Row(
      children: [
        Text(title),
        const Spacer(),
        DropdownButton(value: value, items: items, onChanged: onChanged),
      ],
    );
  }

  Widget contaTextBox(
      String labelText, TextEditingController controller, String? errorText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText, errorText: errorText),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*'))
      ],
      keyboardType: TextInputType.number,
    );
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
}
