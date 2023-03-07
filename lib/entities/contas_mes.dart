import 'package:help_mei/entities/entity.dart';

class ContasMesTable {
  static const tableName = 'contas_mes';
  static const idContasMesName = 'id_contas_mes';
  static const totalContasMesName = 'total_contas_mes';
  static const mesContasMesName = 'mes_contas_mes';
  static const anoContasMesName = 'ano_contas_mes';
  static const pagamentosAtrasadosName = 'pagamentos_atrasados';
  static const createStringV1 = ''' 
      CREATE TABLE $tableName (
      $idContasMesName INTEGER PRIMARY KEY,
      $totalContasMesName REAL,
      $mesContasMesName INTEGER,
      $anoContasMesName INTEGER,
      $pagamentosAtrasadosName REAL
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
            idContasMes: map[ContasMesTable.idContasMesName],
            mes: map[ContasMesTable.mesContasMesName],
            ano: map[ContasMesTable.anoContasMesName],
            pagamentosAtrasados: map[ContasMesTable.pagamentosAtrasadosName],
            total: map[ContasMesTable.totalContasMesName]);

  ContasMes.empty()
      : this(ano: 0, idContasMes: 0, mes: 0, pagamentosAtrasados: 0, total: 0);

  @override
  Entity fromMap(Map map) {
    return ContasMes.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {ContasMesTable.idContasMesName: idContasMes.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idContasMes = keys[ContasMesTable.idContasMesName];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContasMesTable.idContasMesName: idContasMes,
      ContasMesTable.totalContasMesName: total,
      ContasMesTable.mesContasMesName: mes,
      ContasMesTable.anoContasMesName: ano,
      ContasMesTable.pagamentosAtrasadosName: pagamentosAtrasados,
    };
  }
}
