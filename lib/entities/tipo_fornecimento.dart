import 'package:help_mei/entities/entity.dart';

class TipoFornecimentoTable {
  static const tableName = 'tipo_fornecimento';
  static const idTipoFornecimentoName = 'id_tipo_fornecimento';
  static const tipoTipoFornecimentoName = 'tipo_tipo_fornecimento';
  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $idTipoFornecimentoName INTEGER PRIMARY KEY,
      $tipoTipoFornecimentoName TEXT NOT NULL UNIQUE
    );''';

  TipoFornecimentoTable._();
}

class TipoFornecimento extends Entity {
  int idTipoFornecimento;
  String tipoFornecimento;

  TipoFornecimento({
    required this.idTipoFornecimento,
    required this.tipoFornecimento,
  }) : super(tableName: TipoFornecimentoTable.tableName);

  TipoFornecimento.fromMap(Map map)
      : this(
          idTipoFornecimento: map[TipoFornecimentoTable.idTipoFornecimentoName],
          tipoFornecimento: map[TipoFornecimentoTable.tipoTipoFornecimentoName],
        );

  TipoFornecimento.empty()
      : this(
          idTipoFornecimento: 0,
          tipoFornecimento: '',
        );

  @override
  Entity fromMap(Map map) {
    return TipoFornecimento.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      TipoFornecimentoTable.idTipoFornecimentoName:
          idTipoFornecimento.toString()
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idTipoFornecimento = keys[TipoFornecimentoTable.idTipoFornecimentoName];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      TipoFornecimentoTable.idTipoFornecimentoName: idTipoFornecimento,
      TipoFornecimentoTable.tipoTipoFornecimentoName: tipoFornecimento,
    };
  }
}
