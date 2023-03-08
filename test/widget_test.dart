// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/marca.dart';

import 'package:help_mei/main.dart';
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

  test('marca', () async {
    EntityControllerGeneric controller = EntityControllerGeneric(
      service: SqliteServiceInMemory(),
    );

    var marca = Marca(idMarca: 1, nomeMarca: 'Nestle');
    controller.insertEntity(marca);
    var result = await controller.getEntity(marca);
    expect((result as Marca), marca);

    marca.nomeMarca = 'Lacta';
    controller.updateEntity(marca);
    result = await controller.getEntity(marca);
    expect((result as Marca), marca);

    controller.deleteEntity(marca);
    result = await controller.getEntity(marca);
    expect(result, null);
  });
}
