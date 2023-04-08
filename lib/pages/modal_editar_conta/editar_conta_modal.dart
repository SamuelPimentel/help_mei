import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/main.dart';
import 'package:help_mei/widgets/conta_textfield.dart';
import 'package:intl/intl.dart';

class EditarContaModal extends StatefulWidget {
  const EditarContaModal(
      {super.key, required this.conta, required this.controller});
  final Conta conta;
  final EntityControllerGeneric controller;

  @override
  State<EditarContaModal> createState() => _EditarContaModalState();
}

class _EditarContaModalState extends State<EditarContaModal> {
  final _valorContaController = TextEditingController();
  bool _estaQuitada = true;
  String dataPagamento = '';
  String _dataVencimento = '';

  @override
  void initState() {
    super.initState();
    _valorContaController.text = widget.conta.valorConta.toStringAsFixed(2);
    _estaQuitada = widget.conta.quitadaConta;
    dataPagamento = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dataVencimento =
        DateFormat('dd-MM-yyyy').format(widget.conta.dataVencimento);
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ContaTextField(
              labelText: 'Valor da Despesa',
              controller: _valorContaController,
            ),
            const Divider(),
            contaCheckBox(
              'Já foi pago?',
              _estaQuitada,
              (v) {
                setState(() {
                  _estaQuitada = v!;
                });
              },
            ),
            if (_estaQuitada && !widget.conta.quitadaConta)
              dataTextBox(
                  text: 'Data Pagamento',
                  changeState: (v) {
                    setState(() {
                      dataPagamento = v;
                    });
                  },
                  context: context,
                  dataVencimento: dataPagamento),
            const Divider(),
            dataTextBox(
                text: 'Data Vencimento',
                changeState: (v) {
                  setState(() {
                    _dataVencimento = v;
                  });
                },
                context: context,
                dataVencimento: _dataVencimento),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: onTapAtualizar, child: const Text('Atualizar'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onTapAtualizar() async {
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

    var conta = widget.conta;
    conta.valorConta = double.parse(_valorContaController.text);
    conta.dataVencimento = DateFormat('dd-MM-yyyy').parse(_dataVencimento);
    if (conta.quitadaConta && !_estaQuitada) {
      conta.quitadaConta = false;
      conta.dataPagamento = null;
    } else if (!conta.quitadaConta) {
      conta.quitadaConta = true;
      conta.dataPagamento = DateFormat('dd-MM-yyyy').parse(dataPagamento);
    }

    await widget.controller.updateEntity(conta);

    var c = navigatorKey.currentState!.context;
    if (c.mounted) {
      Navigator.of(c).pop();
      Navigator.of(c).pop();
    }
  }
}
