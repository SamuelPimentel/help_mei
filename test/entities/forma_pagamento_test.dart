import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/forma_pagamento.dart';
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
  test('forma pagamento ...', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());
    FormaPagamento notaPromissoria =
        FormaPagamento.noPrimaryKey(nome: 'Nota Promissória');
    await controller.insertEntity(notaPromissoria);

    var res = await controller.getEntity(notaPromissoria);
    expect(notaPromissoria, res as FormaPagamento);
  });
}
