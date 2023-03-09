// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/fornecedor.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_fornecimento.dart';

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
    await controller.insertEntity(marca);
    var result = await controller.getEntity(marca);
    expect((result as Marca), marca);

    marca.nomeMarca = 'Lacta';
    await controller.updateEntity(marca);
    result = await controller.getEntity(marca);
    expect((result as Marca), marca);

    await controller.deleteEntity(marca);
    result = await controller.getEntity(marca);
    expect(result, null);
  });

  test('produto', () async {
    EntityControllerGeneric controller = EntityControllerGeneric(
      service: SqliteServiceInMemory(),
    );
    var marca = Marca(idMarca: 1, nomeMarca: 'Lacta');
    controller.insertEntity(marca);
    var produto = Produto(
      idProduto: 1,
      nomeProduto: 'Ouro Branco',
      descricaoProduto: 'Bombom ouro branco',
      imagemProduto: null,
      idMarca: 1,
    );
    produto.marca = marca;

    await controller.insertEntity(produto);
    var result = await controller.getEntity(produto);

    expect((result as Produto), produto);
    expect(result.marca, produto.marca);
  });

  test('tipo fornecimento', () async {
    EntityControllerGeneric controller = EntityControllerGeneric(
      service: SqliteServiceInMemory(),
    );
    var tipoFonecimento = TipoFornecimento(
      idTipoFornecimento: 1,
      tipoFornecimento: 'energia',
    );

    await controller.insertEntity(tipoFonecimento);
    var result = await controller.getEntity(tipoFonecimento);
    expect((result as TipoFornecimento), tipoFonecimento);

    tipoFonecimento.tipoFornecimento = 'Agua';
    await controller.updateEntity(tipoFonecimento);
    result = await controller.getEntity(tipoFonecimento);
    expect((result as TipoFornecimento), tipoFonecimento);
  });

  test('fornecedor', () async {
    EntityControllerGeneric controller = EntityControllerGeneric(
      service: SqliteServiceInMemory(),
    );

    var tipoFonecimento = TipoFornecimento(
      idTipoFornecimento: 1,
      tipoFornecimento: 'energia',
    );
    await controller.insertEntity(tipoFonecimento);

    var fornecedor = Fornecedor(
      idFornecedor: 1,
      nomeFornecedor: 'Enel',
      idTipoFornecedor: 1,
    );
    fornecedor.tipoFornecimento = tipoFonecimento;

    await controller.insertEntity(fornecedor);
    var result = await controller.getEntity(fornecedor);
    expect((result as Fornecedor), fornecedor);
    expect(result.tipoFornecimento, tipoFonecimento);
  });

  test('conta', () async {
    EntityControllerGeneric controller = EntityControllerGeneric(
      service: SqliteServiceInMemory(),
    );

    var conta = Conta(
      idConta: 1,
      idFornecedor: 1,
      idProduto: null,
      descricaoConta: 'conta de luz',
      valorConta: 150,
      totalParcelas: 1,
      dataVencimento: DateTime.now(),
      quitadaConta: false,
      ativaConta: true,
    );

    var tipoFonecimento = TipoFornecimento(
      idTipoFornecimento: 1,
      tipoFornecimento: 'energia',
    );
    await controller.insertEntity(tipoFonecimento);

    var fornecedor = Fornecedor(
      idFornecedor: 1,
      nomeFornecedor: 'Enel',
      idTipoFornecedor: 1,
    );
    fornecedor.tipoFornecimento = tipoFonecimento;

    await controller.insertEntity(fornecedor);
    conta.fornecedor = fornecedor;

    await controller.insertEntity(conta);
    var result = await controller.getEntity(conta);
    expect((result as Conta), conta);
    expect(result.fornecedor, fornecedor);

    var marca = Marca(idMarca: 1, nomeMarca: 'Lacta');
    await controller.insertEntity(marca);

    var produto = Produto(
      idProduto: 1,
      nomeProduto: 'Ouro Branco',
      descricaoProduto: 'Bombom ouro branco',
      imagemProduto: null,
      idMarca: 1,
    );
    produto.marca = marca;

    await controller.insertEntity(produto);

    var tipoFonecimento2 = TipoFornecimento(
      idTipoFornecimento: 2,
      tipoFornecimento: 'mercado',
    );
    await controller.insertEntity(tipoFonecimento2);

    var fornecedor2 = Fornecedor(
      idFornecedor: 1,
      nomeFornecedor: 'Atacadão',
      idTipoFornecedor: 2,
    );
    fornecedor2.tipoFornecimento = tipoFonecimento2;

    await controller.insertEntity(fornecedor2);
    print(
        'Fornecedor: ${fornecedor2.idFornecedor} - ${fornecedor2.nomeFornecedor}');

    var conta2 = Conta(
      idConta: 1,
      idFornecedor: 2,
      idProduto: 1,
      descricaoConta: null,
      valorConta: 49.99,
      totalParcelas: 1,
      dataVencimento: DateTime.now(),
      quitadaConta: false,
      ativaConta: true,
    );
    conta2.fornecedor = fornecedor2;
    conta2.produto = produto;

    await controller.insertEntity(conta2);
    result = await controller.getEntity(conta2);
    expect((result as Conta), conta2);
    print(
        'Conta: ${conta2.idConta} - ${conta2.produto!.descricaoProduto} R\$${conta2.valorConta}');
  });
}
