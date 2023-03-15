import 'package:help_mei/services/i_on_create.dart';

import 'package:help_mei/services/tables/v2/create_tables_v2.dart';
import 'package:sqflite/sqflite.dart';

class OnCreateV2 implements IOnCreate {
  @override
  Future onCreate(Database db, int version) async {
    Batch batch = db.batch();
    var tables = CreateTablesV2();
    tables.createTableMarcaV1(batch);
    tables.createTableCategoriaV1(batch);
    tables.createTableProdutoV1(batch);
    tables.createTableProdutoCategoriaV1(batch);
    tables.createTableTipoMovimentacaoV1(batch);
    tables.createTableEntradaSaidaV1(batch);
    tables.createTableSaldosV1(batch);
    tables.createTableHistoricoSaldoV1(batch);
    tables.createTableTotais(batch);
    tables.createTriggerInicializaSaldoV1(batch);
    tables.createTriggerAtualizaSaldoCompraV1(batch);
    tables.createTriggerAtualizaSaldoVendaV1(batch);
    tables.inicializaTipoMovimentacaoV1(batch);
    tables.createTableTipoFornecimentoV1(batch);
    tables.createTableFornecedorV1(batch);
    tables.createTableContasMesV1(batch);
    tables.createTableContaV1(batch);
    tables.createTableContasMesItensV1(batch);
    await batch.commit();
  }
}
