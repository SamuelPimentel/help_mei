import 'package:help_mei/services/i_on_upgrade.dart';
import 'package:help_mei/services/tables/v2/create_tables_v2.dart';
import 'package:sqflite/sqflite.dart';

class OnUpgradeV2 implements IOnUpgrade {
  @override
  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    var tables = CreateTablesV2();
    if (oldVersion == 1) {
      tables.createTableTipoFornecimentoV1(batch);
      tables.createTableFornecedorV1(batch);
      tables.createTableContasMesV1(batch);
      tables.createTableContaV1(batch);
      tables.createTableContasMesItensV1(batch);
    }
    await batch.commit();
  }
}
