import 'dart:math';

import 'package:flutter/material.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class TipoContaTable {
  static const tableName = 'tipo_conta';
  static const columnIdTipoConta = 'id_tipo_conta';
  static const columnNomeTipoConta = 'nome_tipo_conta';
  static const columnIconTipoConta = 'icon_tipo_conta';
  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdTipoConta ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeTipoConta ${SqliteTipos.text} ${SqlitePropriedades.notNull} ${SqlitePropriedades.unique},
      $columnIconTipoConta ${SqliteTipos.integer}
    );''';

  static List<String> initialValues = [
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (1, "Conta de Luz", ${Icons.electric_bolt.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (2, "Conta de Água", ${Icons.water_drop.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (3, "Conta de Gás", ${Icons.propane_tank.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (4, "Conta de Telefone", ${Icons.call.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (5, "Conta de Celular", ${Icons.phone_iphone.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (6, "Conta de Internet", ${Icons.cloud.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (7, "Conta de TV por assinatura", ${Icons.cloud.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (8, "Mercado", ${Icons.storefront.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (9, "Atacado", ${Icons.store.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (10, "Matéria prima", ${Icons.local_shipping.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (11, "Mercadoria", ${Icons.barcode_reader.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (12, "Cartão de crédito", ${Icons.credit_card.codePoint});
    ''',
    '''
    INSERT INTO $tableName
      ($columnIdTipoConta, $columnNomeTipoConta, $columnIconTipoConta) 
    VALUES
    (13, "Parcela", ${Icons.real_estate_agent.codePoint});
    ''',
  ];
  TipoContaTable._();
}

class TipoConta extends Entity implements IRequestNewPrimaryKey {
  int idTipoConta;
  String nomeTipoConta;
  Icon? iconTipoConta;

  TipoConta({
    required this.idTipoConta,
    required this.nomeTipoConta,
    this.iconTipoConta,
  }) : super(tableName: TipoContaTable.tableName);

  TipoConta.noPrimaryKey({required nomeTipoConta, Icon? icon})
      : this(
          idTipoConta: nextPrimaryKey(),
          nomeTipoConta: nomeTipoConta,
          iconTipoConta: icon,
        );

  TipoConta.fromMap(Map map)
      : this(
          idTipoConta: map[TipoContaTable.columnIdTipoConta],
          nomeTipoConta: map[TipoContaTable.columnNomeTipoConta],
          iconTipoConta: map[TipoContaTable.columnIconTipoConta] == null
              ? null
              : Icon(
                  IconData(map[TipoContaTable.columnIconTipoConta],
                      fontFamily: 'MaterialIcons'),
                ),
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
      TipoContaTable.columnIconTipoConta:
          iconTipoConta == null ? null : iconTipoConta!.icon!.codePoint
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
