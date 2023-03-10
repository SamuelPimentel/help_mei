import 'package:flutter/material.dart';

class CadastroContaPage extends StatelessWidget {
  const CadastroContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Nova Conta')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("Informações do fornecedor"),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Nome do fornecedor',
                                  icon: Icon(Icons.conveyor_belt)),
                            )),
                            const SizedBox(width: 16.0),
                            Expanded(
                                child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Tipo de fornecimento',
                                  icon: Icon(Icons.inventory)),
                            )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Text('Informações da conta'),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Descrição da conta',
                          icon: Icon(Icons.receipt_long)),
                    )
                  ],
                )),
              ),
            ),
          ),
        ));
  }
}
