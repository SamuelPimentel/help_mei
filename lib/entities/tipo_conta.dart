import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class TipoContaTable {
  static const tableName = 'tipo_conta';
  static const columnIdTipoConta = 'id_tipo_conta';
  static const columnNomeTipoConta = 'nome_tipo_conta';
  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdTipoConta ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeTipoConta ${SqliteTipos.text} ${SqlitePropriedades.notNull} ${SqlitePropriedades.unique}
    );''';
  TipoContaTable._();
}

class TipoConta extends Entity implements IRequestNewPrimaryKey {
  int idTipoConta;
  String nomeTipoConta;

  TipoConta({
    required this.idTipoConta,
    required this.nomeTipoConta,
  }) : super(tableName: TipoContaTable.tableName);

  TipoConta.noPrimaryKey({required nomeTipoConta})
      : this(
          idTipoConta: nextPrimaryKey(),
          nomeTipoConta: nomeTipoConta,
        );

  TipoConta.fromMap(Map map)
      : this(
          idTipoConta: map[TipoContaTable.columnIdTipoConta],
          nomeTipoConta: map[TipoContaTable.columnNomeTipoConta],
        );
  TipoConta.empty() : this(idTipoConta: 0, nomeTipoConta: '');

  @override
  Entity fromMap(Map map) {
    return TipoConta.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      TipoContaTable.columnIdTipoConta: idTipoConta.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idTipoConta = keys[TipoContaTable.columnIdTipoConta];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idTipoConta = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      TipoContaTable.columnIdTipoConta: idTipoConta,
      TipoContaTable.columnNomeTipoConta: nomeTipoConta,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! TipoConta) return false;

    return idTipoConta == other.idTipoConta &&
        nomeTipoConta == other.nomeTipoConta;
  }

  @override
  int get hashCode {
    return idTipoConta.hashCode + nomeTipoConta.hashCode;
  }
}
