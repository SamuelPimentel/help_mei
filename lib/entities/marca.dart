import 'package:help_mei/entities/entity.dart';

class MarcaTable {
  static const tableName = 'marca';
  static const idMarcaName = 'id_marca';
  static const nomeMarcaName = 'nome_marca';
  static const createStringV1 = '''
      CREATE TABLE $tableName (
        $idMarcaName INTEGER PRIMARY KEY,
        $nomeMarcaName TEXT NOT NULL UNIQUE
      );''';
  MarcaTable._();
}

class Marca extends Entity {
  int idMarca;
  String nomeMarca;

  Marca({required this.idMarca, required this.nomeMarca})
      : super(tableName: MarcaTable.tableName);

  Marca.fromMap(Map<dynamic, dynamic> map)
      : this(
            idMarca: map[MarcaTable.idMarcaName],
            nomeMarca: map[MarcaTable.nomeMarcaName]);

  Marca.empty() : this(idMarca: 0, nomeMarca: "");

  @override
  Map<String, dynamic> toMap() {
    return {
      MarcaTable.idMarcaName: idMarca,
      MarcaTable.nomeMarcaName: nomeMarca
    };
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {MarcaTable.nomeMarcaName: idMarca.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idMarca = keys[MarcaTable.idMarcaName];
  }

  @override
  Entity fromMap(Map map) {
    return Marca.fromMap(map);
  }
}
