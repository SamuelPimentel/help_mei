import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class MarcaTable {
  static const tableName = 'marca';
  static const columnIdMarca = 'id_marca';
  static const columnNomeMarca = 'nome_marca';
  static const createStringV1 = '''
      CREATE TABLE $tableName (
        $columnIdMarca ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
        $columnNomeMarca ${SqliteTipos.text} ${SqlitePropriedades.notNull} ${SqlitePropriedades.unique}
      );''';
  MarcaTable._();
}

class Marca extends Entity implements IRequestNewPrimaryKey {
  int idMarca;
  String nomeMarca;

  Marca({required this.idMarca, required this.nomeMarca})
      : super(tableName: MarcaTable.tableName);

  Marca.noPrimaryKey({required String nomeMarca})
      : this(
          idMarca: nextPrimaryKey(),
          nomeMarca: nomeMarca,
        );

  Marca.fromMap(Map<dynamic, dynamic> map)
      : this(
            idMarca: map[MarcaTable.columnIdMarca],
            nomeMarca: map[MarcaTable.columnNomeMarca]);

  Marca.empty() : this(idMarca: 0, nomeMarca: "");

  @override
  Map<String, dynamic> toMap() {
    return {
      MarcaTable.columnIdMarca: idMarca,
      MarcaTable.columnNomeMarca: nomeMarca
    };
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {MarcaTable.columnIdMarca: idMarca.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idMarca = keys[MarcaTable.columnIdMarca];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idMarca = rnd.nextInt(maxInt32);
  }

  @override
  Entity fromMap(Map map) {
    return Marca.fromMap(map);
  }

  @override
  bool operator ==(other) {
    if (other is! Marca) {
      return false;
    }
    return idMarca == (other).idMarca && nomeMarca == other.nomeMarca;
  }

  @override
  int get hashCode {
    return idMarca.hashCode + nomeMarca.hashCode;
  }
}
