import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/entities/tipo_fornecimento.dart';
import 'package:help_mei/helpers/constantes.dart';

class FornecedorTable {
  static const tableName = 'fornecedor';
  static const idFornecedorName = 'id_fornecedor';
  static const nomeFornecedorName = 'nome_fornecedor';
  static const idTipoFornecedorName = 'id_tipo_fornecedor';
  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $idFornecedorName INTEGER PRIMARY KEY,
      $nomeFornecedorName TEXT UNIQUE NOT NULL,
      $idTipoFornecedorName INTEGER,
      FOREIGN KEY ($idTipoFornecedorName) REFERENCES ${TipoFornecimentoTable.tableName} (${TipoFornecimentoTable.idTipoFornecimentoName})
    );''';

  FornecedorTable._();
}

class Fornecedor extends Entity implements IForeignKey, IRequestNewPrimaryKey {
  int idFornecedor;
  String nomeFornecedor;
  int idTipoFornecedor;
  TipoFornecimento? _tipoFornecimento;

  TipoFornecimento? get tipoFornecimento => _tipoFornecimento;

  set tipoFornecimento(TipoFornecimento? value) {
    _tipoFornecimento = value;
    if (value != null) {
      idTipoFornecedor = value.idTipoFornecimento;
    }
  }

  Fornecedor({
    required this.idFornecedor,
    required this.nomeFornecedor,
    required this.idTipoFornecedor,
  }) : super(tableName: FornecedorTable.tableName);

  Fornecedor.fromMap(Map map)
      : this(
          idFornecedor: map[FornecedorTable.idFornecedorName],
          nomeFornecedor: map[FornecedorTable.nomeFornecedorName],
          idTipoFornecedor: map[FornecedorTable.idTipoFornecedorName],
        );

  Fornecedor.empty()
      : this(
          idTipoFornecedor: 0,
          idFornecedor: 0,
          nomeFornecedor: '',
        );

  @override
  Entity fromMap(Map map) {
    return Fornecedor.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {FornecedorTable.idFornecedorName: idFornecedor.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idFornecedor = keys[FornecedorTable.idFornecedorName];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idFornecedor = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      FornecedorTable.idFornecedorName: idFornecedor,
      FornecedorTable.nomeFornecedorName: nomeFornecedor,
      FornecedorTable.idTipoFornecedorName: idTipoFornecedor,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(ForeignKey(
      tableEntity: TipoFornecimento.empty(),
      keys: {
        TipoFornecimentoTable.idTipoFornecimentoName: idTipoFornecedor,
      },
    ));
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    tipoFornecimento = values[TipoFornecimentoTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! Fornecedor) {
      return false;
    }
    return idFornecedor == other.idFornecedor &&
        nomeFornecedor == other.nomeFornecedor &&
        idFornecedor == other.idFornecedor;
  }

  @override
  int get hashCode {
    return idFornecedor.hashCode +
        nomeFornecedor.hashCode +
        idTipoFornecedor.hashCode;
  }
}
