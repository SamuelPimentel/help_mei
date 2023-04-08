import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/helpers/constantes.dart';

class ContasMesTable {
  static const tableName = 'contas_mes';
  static const columnIdContasMes = 'id_contas_mes';
  static const columnTotalContasMes = 'total_contas_mes';
  static const columnMesContasMes = 'mes_contas_mes';
  static const columnAnoContasMes = 'ano_contas_mes';
  static const columnPagamentosAtrasados = 'pagamentos_atrasados';

  static const createStringV1 = ''' 
      CREATE TABLE $tableName (
      $columnIdContasMes ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnTotalContasMes ${SqliteTipos.real},
      $columnMesContasMes ${SqliteTipos.integer},
      $columnAnoContasMes ${SqliteTipos.integer},
      $columnPagamentosAtrasados ${SqliteTipos.real}
);''';

  ContasMesTable._();
}

class ContasMes extends Entity {
  int idContasMes;
  double total;
  int mes;
  int ano;
  double pagamentosAtrasados;

  ContasMes({
    required this.idContasMes,
    required this.total,
    required this.mes,
    required this.ano,
    required this.pagamentosAtrasados,
  }) : super(tableName: ContasMesTable.tableName);

  ContasMes.fromMap(Map map)
      : this(
            idContasMes: map[ContasMesTable.columnIdContasMes],
            mes: map[ContasMesTable.columnMesContasMes],
            ano: map[ContasMesTable.columnAnoContasMes],
            pagamentosAtrasados: map[ContasMesTable.columnPagamentosAtrasados],
            total: map[ContasMesTable.columnTotalContasMes]);

  ContasMes.empty()
      : this(ano: 0, idContasMes: 0, mes: 0, pagamentosAtrasados: 0, total: 0);

  @override
  Entity fromMap(Map map) {
    return ContasMes.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {ContasMesTable.columnIdContasMes: idContasMes.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idContasMes = keys[ContasMesTable.columnIdContasMes];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContasMesTable.columnIdContasMes: idContasMes,
      ContasMesTable.columnTotalContasMes: total,
      ContasMesTable.columnMesContasMes: mes,
      ContasMesTable.columnAnoContasMes: ano,
      ContasMesTable.columnPagamentosAtrasados: pagamentosAtrasados,
    };
  }
}
