import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/tipo_fornecimento.dart';

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

class Fornecedor extends Entity implements IForeignKey {
  int idFornecedor;
  String nomeFornecedor;
  int idTipoFornecedor;
  TipoFornecimento? tipoFornecimento;

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
        FornecedorTable.idTipoFornecedorName: idTipoFornecedor,
      },
    ));
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    tipoFornecimento = values[TipoFornecimentoTable.tableName];
  }
}
