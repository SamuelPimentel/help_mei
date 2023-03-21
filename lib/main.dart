import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/pages/cadastro_conta/cadastro_conta_page.dart';
import 'package:help_mei/pages/cadastro_produto/cadastro_produto_page.dart';
import 'package:help_mei/pages/home_page.dart';
import 'package:help_mei/pages/listar_produtos/listar_produtos_page.dart';
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
  var result = await controller.getEntities(Produto.empty());
  var produtos = result.map(
    (e) {
      return (e as Produto);
    },
  ).toList();

  var result2 = await controller.getEntities(Marca.empty());
  var marcas = result2.map(
    (e) {
      return (e as Marca);
    },
  ).toList();

  runApp(MaterialApp(
    home: ListarProdutosPage(
      produtos: produtos,
      controller: controller,
      marcas: marcas,
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
