import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class FormaPagamentoTable {
  FormaPagamentoTable._();

  static const tableName = 'forma_pagamento';
  static const columnIdFormaPagamento = 'id_forma_pagamento';
  static const columnNomeFormaPagamento = 'nome_forma_pagamento';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnIdFormaPagamento ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeFormaPagamento ${SqliteTipos.text} ${SqlitePropriedades.unique} ${SqlitePropriedades.notNull}
    );
  ''';

  static List<String> initialValues = [
    'INSERT INTO $tableName($columnIdFormaPagamento, $columnNomeFormaPagamento) VALUES(1,"Dinheiro");',
    'INSERT INTO $tableName($columnIdFormaPagamento, $columnNomeFormaPagamento) VALUES(2,"Cartão Débito");',
    'INSERT INTO $tableName($columnIdFormaPagamento, $columnNomeFormaPagamento) VALUES(3,"Cartão Crédito");',
    'INSERT INTO $tableName($columnIdFormaPagamento, $columnNomeFormaPagamento) VALUES(4,"Pix");',
    'INSERT INTO $tableName($columnIdFormaPagamento, $columnNomeFormaPagamento) VALUES(5,"Cheque");',
  ];
}

class FormaPagamento extends Entity {
  int id;
  String nome;

  FormaPagamento({required this.id, required this.nome})
      : super(tableName: FormaPagamentoTable.tableName);

  FormaPagamento.fromMap(Map map)
      : this(
          id: map[FormaPagamentoTable.columnIdFormaPagamento],
          nome: map[FormaPagamentoTable.columnNomeFormaPagamento],
        );

  FormaPagamento.noPrimaryKey({required String nome})
      : this(id: nextPrimaryKey(), nome: nome);

  FormaPagamento.empty() : this(id: 0, nome: '');

  @override
  Entity fromMap(Map map) {
    return FormaPagamento.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      FormaPagamentoTable.columnIdFormaPagamento: id.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    id = keys[FormaPagamentoTable.columnIdFormaPagamento];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      FormaPagamentoTable.columnIdFormaPagamento: id,
      FormaPagamentoTable.columnNomeFormaPagamento: nome,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! FormaPagamento) return false;

    return id == other.id && nome == other.nome;
  }

  @override
  int get hashCode {
    return id.hashCode + nome.hashCode;
  }
}
