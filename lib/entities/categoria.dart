import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
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

  static const initialValues = '''
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (1,"Alimentos básicos");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (2,"Bebidas");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (3,"Limpeza");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (4,"Leites e iogurtes");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (5,"Biscoitos e salgadinhos");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (6,"Frios e laticinios");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (7,"Molhos, condimentos e conservas");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (8,"Higiene e cuidados pessoais");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (9,"Padaria e matinais");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (10,"Carnes, aves e peixes");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (11,"Congelados e resfriados");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (12,"Legumes e vegetais");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (13,"Utensilios para o lar");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (14,"Bebidas alcoólicas");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (15,"Pet-shop");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (16,"Suplementos e vitaminas");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (17,"Bazar e utilidades");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (18,"Suplementos e vitaminas");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (19,"Bazar e utilidades");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (20,"Vestuaário");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (21,"Brinquedos");
      INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria) VALUES (22,"Outros");
''';

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
