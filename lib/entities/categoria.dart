import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class CategoriaTable {
  static const tableName = 'categoria';
  static const columnIdCategoria = 'id_categoria';
  static const columnNomeCategoria = 'nome_categoria';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdCategoria ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeCategoria ${SqliteTipos.text} ${SqlitePropriedades.unique}
    );''';

  CategoriaTable._();
}

class Categoria extends Entity implements IRequestNewPrimaryKey {
  int idCategoria;
  String nomeCategoria;

  Categoria({required this.idCategoria, required this.nomeCategoria})
      : super(tableName: CategoriaTable.tableName);

  Categoria.noPrimaryKey({required String nomeCategoria})
      : this(
          idCategoria: nextPrimaryKey(),
          nomeCategoria: nomeCategoria,
        );

  Categoria.fromMap(Map map)
      : this(
          idCategoria: map[CategoriaTable.columnIdCategoria],
          nomeCategoria: map[CategoriaTable.columnNomeCategoria],
        );

  Categoria.empty() : this(idCategoria: 0, nomeCategoria: '');

  @override
  Entity fromMap(Map map) {
    return Categoria.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {CategoriaTable.columnIdCategoria: idCategoria.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idCategoria = keys[CategoriaTable.columnIdCategoria];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      CategoriaTable.columnIdCategoria: idCategoria,
      CategoriaTable.columnNomeCategoria: nomeCategoria,
    };
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idCategoria = rnd.nextInt(maxInt32);
  }

  @override
  bool operator ==(other) {
    if (other is! Categoria) {
      return false;
    }

    return idCategoria == other.idCategoria &&
        nomeCategoria == other.nomeCategoria;
  }

  @override
  int get hashCode {
    return idCategoria.hashCode + nomeCategoria.hashCode;
  }
}
