import 'package:help_mei/services/i_on_create.dart';
import 'package:help_mei/services/tables/create_tables_current.dart';
import 'package:sqflite/sqflite.dart';

class OnCreateCurrent implements IOnCreate {
  @override
  Future onCreate(Database db, int version) async {
    Batch batch = db.batch();
    var tables = CreateTablesCurrent();
    tables.createTableMarcaV1(batch);
    tables.createTableProdutoV1(batch);
    tables.createTableTipoMovimentacaoV1(batch);
    tables.createTableEntradaSaidaV1(batch);
    tables.createTableSaldosV1(batch);
    //tables.createTableHistoricoSaldoV1(batch);
    tables.createTableTotais(batch);
    tables.createTriggerInicializaSaldoV1(batch);
    tables.createTriggerAtualizaSaldoCompraV1(batch);
    tables.createTriggerAtualizaSaldoVendaV1(batch);
    tables.inicializaTipoMovimentacaoV1(batch);
    tables.createTableTipoConta(batch);
    tables.initializaTipoConta(batch);
    tables.createTableContasMesV1(batch);
    tables.createTableContaV2(batch);
    tables.createTableContasMesItensV1(batch);
    tables.createTableCategoria(batch);
    tables.createTableProdutoCategoria(batch);
    tables.inicializaTableCategoria(batch);
    tables.createTableContaParcelada(batch);
    await batch.commit();
  }
}
