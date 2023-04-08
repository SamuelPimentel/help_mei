import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/entrada_saida.dart';
import 'package:help_mei/entities/forma_pagamento.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_movimentacao.dart';
import 'package:help_mei/entities/venda.dart';
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
  test('venda ...', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());
    FormaPagamento notaPromissoria =
        FormaPagamento.noPrimaryKey(nome: 'Nota Promissória');
    await controller.insertEntity(notaPromissoria);

    var res = await controller.getEntitiesWhere(
        TipoMovimentacao.empty(), {TipoMovimentacaoTable.columnId: '1'});
    var tipoMovimentacao = res.first as TipoMovimentacao;
    var lacta = Marca.noPrimaryKey(nomeMarca: 'Lacta');
    await controller.insertEntity(lacta);

    var ouroNegro = Produto.noPrimaryKey(
        nomeProduto: 'Ouro Negro',
        descricaoProduto: 'Bombom ouro negro',
        imagemProduto: null,
        idMarca: lacta.idMarca);
    ouroNegro.marca = lacta;
    await controller.insertEntity(ouroNegro);
    var compraOuroNegro = EntradaSaida.noPrimaryKeyToday(
      produto: ouroNegro,
      tipoMovimentacao: tipoMovimentacao,
      quantidade: 50,
      total: 49.99,
      valorUnitario: (50 / 49.99),
    );
    await controller.insertEntity(compraOuroNegro);

    Venda venda = Venda.noPrimaryKey(
      total: 150,
      quantidadeProdutos: 10,
      dataVenda: DateTime.now(),
      formaPagamento: notaPromissoria,
    );

    venda.addProduto(ouroNegro, 2, 2);

    await controller.insertEntity(venda);

    var res2 = await controller.getEntity(venda);
    expect(venda, res2 as Venda);

    debugPrint('${res2.produtos.length}');
  });
}
