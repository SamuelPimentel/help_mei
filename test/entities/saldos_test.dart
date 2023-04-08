import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/entrada_saida.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/saldos.dart';
import 'package:help_mei/entities/tipo_movimentacao.dart';
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
  test('saldos ...', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());

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

    Saldos saldo = Saldos.empty();
    saldo.produto = ouroNegro;

    var resp = await controller.getEntity(saldo);
    String msg =
        '${(resp as Saldos).produto!.nomeProduto} Quantidade: ${resp.quantidade} Custo Unitário: ${resp.custoUnitario} Total: ${resp.valorTotal}';
    debugPrint(msg);
  });
}
