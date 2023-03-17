import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/cadastro_conta/cadastro_conta_page.dart';
import 'package:help_mei/pages/home_page.dart';
import 'package:help_mei/services/sqlite_service_on_disk.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'colors.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  var controller = EntityControllerGeneric(service: SqliteServiceOnDisk());
  WidgetsFlutterBinding.ensureInitialized();
  var result = await controller.getEntities(TipoConta.empty());
  var tipoContaValues =
      result.map((e) => (e as TipoConta).nomeTipoConta).toList();

  runApp(MaterialApp(
    home: CadastroContaPage(
      dropDownItens: tipoContaValues,
      controller: controller,
    ),
    theme: buildTheme(),
  ));
}

ThemeData buildTheme() {
  ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: periwinle,
      secondary: maize,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: periwinle,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: vanDykePaper,
    primaryColor: periwinle,
  );
}
