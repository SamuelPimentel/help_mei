import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/helpers/constantes.dart';

class TipoMovimentacaoTable {
  TipoMovimentacaoTable._();

  static const tableName = 'tipo_movimentacao';
  static const columnId = 'id_tipo_movimentacao';
  static const columnNome = 'nome_tipo_movimentacao';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnId ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNome ${SqliteTipos.text} ${SqlitePropriedades.notNull} ${SqlitePropriedades.unique}
    );
  ''';

  static List<String> initialValues = [
    'INSERT INTO $tableName($columnId, $columnNome) VALUES(1, "compra");',
    'INSERT INTO $tableName($columnId, $columnNome) VALUES(2, "venda");',
  ];
}

class TipoMovimentacao extends Entity {
  int id;
  String nome;

  TipoMovimentacao({
    required this.id,
    required this.nome,
  }) : super(tableName: TipoMovimentacaoTable.tableName);

  TipoMovimentacao.fromMap(Map map)
      : this(
          id: map[TipoMovimentacaoTable.columnId],
          nome: map[TipoMovimentacaoTable.columnNome],
        );

  TipoMovimentacao.empty() : this(id: 0, nome: '');

  @override
  Entity fromMap(Map map) {
    return TipoMovimentacao.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      TipoMovimentacaoTable.columnId: id.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    id = keys[TipoMovimentacaoTable.columnId];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      TipoMovimentacaoTable.columnId: id,
      TipoMovimentacaoTable.columnNome: nome,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! TipoMovimentacao) {
      return false;
    }
    return id == other.id && nome == other.nome;
  }

  @override
  int get hashCode {
    return id.hashCode + nome.hashCode;
  }
}
