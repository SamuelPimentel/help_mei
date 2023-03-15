import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/fornecedor.dart';
import 'package:help_mei/entities/tipo_fornecimento.dart';
import 'package:help_mei/services/i_on_upgrade.dart';
import 'package:help_mei/services/tables/create_tables_current.dart';
import 'package:help_mei/services/tables/v2/create_tables_v2.dart';
import 'package:sqflite/sqflite.dart';

class OnUpgradeCurrent implements IOnUpgrade {
  @override
  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    var tables = CreateTablesCurrent();
    var tablesV2 = CreateTablesV2();
    if (oldVersion == 1) {
      tablesV2.createTableTipoFornecimentoV1(batch);
      tablesV2.createTableFornecedorV1(batch);
      tablesV2.createTableContasMesV1(batch);
      tablesV2.createTableContaV1(batch);
      tablesV2.createTableContasMesItensV1(batch);
    } else if (oldVersion == 2) {
      batch.execute('DROP TABLE ${TipoFornecimentoTable.tableName};');
      batch.execute('DROP TABLE ${FornecedorTable.tableName};');
      batch.execute('DROP TABLE ${ContaTable.tableName};');
      tables.createTableTipoConta(batch);
      tables.createTableContaV2(batch);
    }
    await batch.commit();
  }
}
