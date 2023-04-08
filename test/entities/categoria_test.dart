import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/categoria.dart';
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
  test('Categoria', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());

    Categoria categoria =
        Categoria.noPrimaryKey(nomeCategoria: 'novaCategoria');

    await controller.insertEntity(categoria);
    var result = await controller.getEntity(categoria) as Categoria?;
    expect(result, categoria);

    categoria.nomeCategoria = 'Bombom';
    await controller.updateEntity(categoria);

    result = await controller.getEntity(categoria) as Categoria?;
    expect(result, categoria);

    await controller.deleteEntity(categoria);
    result = await controller.getEntity(categoria) as Categoria?;
    expect(result, null);
  });
}
