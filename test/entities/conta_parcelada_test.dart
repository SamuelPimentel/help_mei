import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/conta_parcelada.dart';
import 'package:help_mei/services/sqite_service_in_memory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();
  WidgetsFlutterBinding.ensureInitialized();
  test('test conta_parcelada', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());
    var contaParcelada = ContaParcelada.noPrimaryKey(
      descricaoConta: 'tv nova',
      numeroParcelas: 5,
      dataPrimeiraParcela: DateTime.now(),
      valorTotal: 1500.00,
    );
    await controller.insertEntity(contaParcelada);
    var result = await controller.getEntity(contaParcelada);
    expect(result as ContaParcelada, contaParcelada);

    for (var i = 0; i < contaParcelada.numeroParcelas; i++) {
      var conta = Conta.noPrimaryKey(
        idTipoConta: 13,
        descricaoConta: 'parcela',
        valorConta: 1500 / contaParcelada.numeroParcelas,
        totalParcelas: (i + 1),
        dataVencimento: DateTime(
            contaParcelada.dataPrimeiraParcela.day,
            contaParcelada.dataPrimeiraParcela.month + i,
            contaParcelada.dataPrimeiraParcela.year),
        quitadaConta: false,
        ativaConta: true,
      );
      await controller.insertEntity(conta);
    }
  });
}
