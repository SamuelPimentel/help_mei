import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/forma_pagamento.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class VendaTable {
  VendaTable._();

  static const tableName = 'venda';
  static const columnIdVenda = 'id_venda';
  static const columnValorVenda = 'valor_venda';
  static const columnQuantidadeProdutos = 'quantidade_produtos';
  static const columnDataVenda = 'data_venda';
  static const columnIdFormaPagamento = 'id_forma_pagamento';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnIdVenda ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnValorVenda ${SqliteTipos.real},
      $columnQuantidadeProdutos ${SqliteTipos.integer},
      $columnDataVenda ${SqliteTipos.text},
      $columnIdFormaPagamento ${SqliteTipos.integer},
      FOREIGN KEY ($columnIdFormaPagamento) REFERENCES ${FormaPagamentoTable.tableName}(${FormaPagamentoTable.columnIdFormaPagamento})
    );
  ''';
}

class Venda extends Entity implements IForeignKey {
  int id;
  double total;
  int quantidadeProdutos;
  DateTime dataVenda;
  int idFormaPagamento;

  FormaPagamento? _formaPagamento;

  FormaPagamento? get formaPagamento => _formaPagamento;
  set formaPagamento(FormaPagamento? value) {
    _formaPagamento = value;
    if (value != null) {
      idFormaPagamento = value.id;
    }
  }

  Venda({
    required this.id,
    required this.total,
    required this.quantidadeProdutos,
    required this.dataVenda,
    required this.idFormaPagamento,
    FormaPagamento? formaPagamento,
  })  : _formaPagamento = formaPagamento,
        super(tableName: VendaTable.tableName);

  Venda.fromMap(Map map)
      : this(
          id: map[VendaTable.columnIdVenda],
          total: map[VendaTable.columnValorVenda],
          quantidadeProdutos: map[VendaTable.columnQuantidadeProdutos],
          dataVenda: DateTime.parse(map[VendaTable.columnDataVenda]),
          idFormaPagamento: map[VendaTable.columnIdFormaPagamento],
        );
  Venda.noPrimaryKey({
    required double total,
    required int quantidadeProdutos,
    required DateTime dataVenda,
    required FormaPagamento formaPagamento,
  }) : this(
          id: nextPrimaryKey(),
          total: total,
          quantidadeProdutos: quantidadeProdutos,
          dataVenda: dataVenda,
          idFormaPagamento: formaPagamento.id,
          formaPagamento: formaPagamento,
        );

  Venda.empty()
      : this(
          id: 0,
          dataVenda: DateTime.now(),
          idFormaPagamento: 0,
          quantidadeProdutos: 0,
          total: 0,
        );

  @override
  Entity fromMap(Map map) {
    return Venda.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      VendaTable.columnIdVenda: id.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    id = keys[VendaTable.columnIdVenda];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      VendaTable.columnIdVenda: id,
      VendaTable.columnValorVenda: total,
      VendaTable.columnQuantidadeProdutos: quantidadeProdutos,
      VendaTable.columnDataVenda: dataVenda.toIso8601String(),
      VendaTable.columnIdFormaPagamento: idFormaPagamento,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];

    foreignKeys.add(
      ForeignKey(
        tableEntity: FormaPagamento.empty(),
        keys: {
          FormaPagamentoTable.columnIdFormaPagamento: idFormaPagamento,
        },
      ),
    );

    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    formaPagamento = values[FormaPagamentoTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! Venda) {
      return false;
    }
    return id == other.id &&
        total == other.total &&
        quantidadeProdutos == other.quantidadeProdutos &&
        dataVenda == other.dataVenda &&
        idFormaPagamento == other.idFormaPagamento;
  }

  @override
  int get hashCode {
    return id.hashCode +
        quantidadeProdutos.hashCode +
        dataVenda.hashCode +
        idFormaPagamento.hashCode +
        total.hashCode;
  }
}
