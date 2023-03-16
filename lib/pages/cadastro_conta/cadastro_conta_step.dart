import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/cadastro_conta/widgets/dropdown_cadastro.dart';
import 'package:help_mei/services/database_service.dart';
import 'package:help_mei/services/sqlite_service_on_disk.dart';
import 'package:help_mei/widgets/step_cadastro.dart';

class CadastroContaStep extends StatefulWidget {
  const CadastroContaStep({Key? key, required this.dropDownItens})
      : super(key: key);
  final List<String> dropDownItens;
  @override
  State<CadastroContaStep> createState() => _CadastroContaStepState();
}

class _CadastroContaStepState extends State<CadastroContaStep> {
  int _index = 0;
  String dropdownValue = '';

  EntityControllerGeneric? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EntityControllerGeneric(service: SqliteServiceOnDisk());
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
      Step(
          state: _index > 1 ? StepState.complete : StepState.indexed,
          isActive: _index >= 1,
          title: Text(
            'Passo 2',
          ),
          content: Container()),
      Step(
        state: _index > 2 ? StepState.complete : StepState.indexed,
        isActive: _index >= 2,
        title: Text(
          'Passo 3',
        ),
        content: Container(),
      ),
      Step(
        state: _index > 2 ? StepState.complete : StepState.indexed,
        isActive: _index >= 2,
        title: Text(
          'Passo 4',
        ),
        content: Container(),
      ),
      Step(
        state: _index > 2 ? StepState.complete : StepState.indexed,
        isActive: _index >= 2,
        title: Text(
          'Passo 3',
        ),
        content: Container(),
      ),
    ];
  }
}
