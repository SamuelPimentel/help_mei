import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/cadastro_conta/widgets/checkbox_cadastro.dart';
import 'package:help_mei/pages/cadastro_conta/widgets/dropdown_cadastro.dart';
import 'package:help_mei/widgets/step_cadastro.dart';
import 'package:help_mei/widgets/text_field_cadastro.dart';
import 'package:intl/intl.dart';

class CadastroContaStep extends StatefulWidget {
  const CadastroContaStep(
      {Key? key, required this.dropDownItens, required this.controller})
      : super(key: key);
  final List<String> dropDownItens;
  final EntityControllerGeneric controller;
  @override
  State<CadastroContaStep> createState() => _CadastroContaStepState();
}

class _CadastroContaStepState extends State<CadastroContaStep> {
  int _index = 0;
  String dropdownValue = '';
  bool _ehParcelada = false;

  final TextEditingController _dateEditingController = TextEditingController();
  final TextEditingController _valorEditingController = TextEditingController();
  final TextEditingController _qtdeParcelasEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.dropDownItens.add('Outro');
    dropdownValue = widget.dropDownItens.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stepper(
        elevation: 2,
        currentStep: _index,
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index < getSteps().length - 1) {
            setState(() {
              _index += 1;
            });
          } else if (_index == getSteps().length - 1) {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text('Cadastrando Usuário'),
                  content: CircularProgressIndicator(),
                );
              },
            );
            saveConta().then((value) {
              String msg = 'Inserido com sucesso';
              if (!value) {
                msg = 'Erro ap inserir';
              }
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Cadastro'),
                    content: Text(msg),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('ok'))
                    ],
                  );
                },
              );
            });
          }
        },
        onStepTapped: (index) {
          setState(() {
            _index = index;
          });
        },
        steps: getSteps(),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      stepCadastro(
        context,
        'Tipo de conta',
        _index,
        0,
        dropdownCadastro(
          dropdownValue,
          widget.dropDownItens,
          (value) {
            setState(() {
              dropdownValue = value!;
            });
          },
        ),
      ),
      stepCadastro(
        context,
        'Dados do Pagamento',
        _index,
        1,
        Column(
          children: [
            textFieldCadastro(context, 'Valor da conta', const Icon(Icons.paid),
                _valorEditingController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            textFieldCadastro(
              context,
              'Data do vencimento',
              const Icon(Icons.calendar_today),
              _dateEditingController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    _dateEditingController.text = formattedDate;
                  });
                }
              },
            ),
          ],
        ),
      ),
      stepCadastro(
        context,
        'Parcelamento',
        _index,
        2,
        Column(
          children: [
            checkboxCadastro(_ehParcelada, 'A compra será parcelada?', (value) {
              setState(() {
                _ehParcelada = value!;
              });
            }),
            if (_ehParcelada)
              Column(
                children: [
                  textFieldCadastro(context, 'Quantidade de parcelas',
                      const Icon(Icons.payment), _qtdeParcelasEditingController,
                      keyboardType: TextInputType.number)
                ],
              ),
          ],
        ),
      ),
      stepCadastro(
        context,
        'Finalizar',
        _index,
        3,
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'Hello',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<bool> saveConta() async {
    var res = await widget.controller.getEntities(TipoConta.empty());
    List<TipoConta> tipoContas = res.map((e) => (e as TipoConta)).toList();
    var tipoContaSelecionada = tipoContas
        .where((element) => element.nomeTipoConta == dropdownValue)
        .first;
    var valor = double.parse(_valorEditingController.text);
    int qtdeParcelas = 1;
    if (_ehParcelada) {
      qtdeParcelas = int.parse(_qtdeParcelasEditingController.text);
    }

    var dataVencimento =
        DateFormat('dd-MM-yyyy').parse(_dateEditingController.text);
    Conta conta = Conta.noPrimaryKey(
        idTipoConta: tipoContaSelecionada.idTipoConta,
        idProduto: null,
        descricaoConta: '',
        valorConta: valor,
        totalParcelas: qtdeParcelas,
        dataVencimento: dataVencimento,
        quitadaConta: false,
        ativaConta: true);
    try {
      widget.controller.insertEntity(conta);
    } catch (e) {
      return false;
    }
    return true;
  }
}
