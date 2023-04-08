import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';

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

class TipoFornecimento extends Entity implements IRequestNewPrimaryKey {
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
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idTipoFornecimento = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      TipoFornecimentoTable.idTipoFornecimentoName: idTipoFornecimento,
      TipoFornecimentoTable.tipoTipoFornecimentoName: tipoFornecimento,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! TipoFornecimento) {
      return false;
    }
    return idTipoFornecimento == other.idTipoFornecimento &&
        tipoFornecimento == other.tipoFornecimento;
  }

  @override
  int get hashCode {
    return idTipoFornecimento.hashCode + tipoFornecimento.hashCode;
  }
}
