import 'package:help_mei/entities/entity.dart';

class Marca extends Entity {
  int idMarca;
  String nomeMarca;

  Marca({required this.idMarca, required this.nomeMarca})
      : super(tableName: "marca");

  Marca.fromMap(Map<dynamic, dynamic> map)
      : this(idMarca: map['id_marca'], nomeMarca: map['nome_marca']);

  Marca.empty() : this(idMarca: 0, nomeMarca: "");

  @override
  Map<String, dynamic> toMap() {
    return {'id_marca': idMarca, 'nome_marca': nomeMarca};
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {'id_marca': idMarca.toString()};
  }

  @override
  Entity fromMap(Map map) {
    return Marca.fromMap(map);
  }
}
