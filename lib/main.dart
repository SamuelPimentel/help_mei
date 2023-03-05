import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/saldos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'controller/entity_controller.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  EntityController controller = EntityController();
  await controller.deleteEntity(Saldos(
    idProduto: 1,
    quantidadeSaldos: 0,
    custoUnitarioSaldos: 0,
    totalSaldos: 0,
  ));
  await controller.deleteEntity(Produto(
      idProduto: 1,
      nomeProduto: '',
      descricaoProduto: '',
      imagemProduto: '',
      idMarca: 1));
  await controller.deleteEntity(Marca(idMarca: 1, nomeMarca: ''));

  var marca = Marca(idMarca: 1, nomeMarca: 'Nestle');
  await controller.insertEntity(marca);
  var result = await controller.getEntity(marca);
  debugPrint('${(result as Marca).idMarca}: ${result.nomeMarca}');
  marca.nomeMarca = 'Lacta';
  await controller.updateEntity(marca);
  result = await controller.getEntity(marca);
  debugPrint('${(result as Marca).idMarca}: ${result.nomeMarca}');
  await controller.deleteEntity(Produto(
    idProduto: 1,
    nomeProduto: '',
    descricaoProduto: '',
    imagemProduto: '',
    idMarca: 0,
  ));
  var produto = Produto(
    idProduto: 1,
    nomeProduto: 'Ouro Branco',
    descricaoProduto: 'Bombom ouro brando',
    imagemProduto: null,
    idMarca: 1,
  );
  await controller.insertEntity(produto);
  var prodResult = await controller.getEntity(produto);
  debugPrint(
      '${(prodResult as Produto).idProduto}: ${prodResult.nomeProduto}, ${prodResult.descricaoProduto}, ${prodResult.marca!.nomeMarca} ');
}
