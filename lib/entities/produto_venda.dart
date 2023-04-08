import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/venda.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class ProdutoVendaTable {
  ProdutoVendaTable._();

  static const tableName = 'produto_venda';
  static const columnIdVenda = 'id_venda';
  static const columnIdProdutoVenda = 'id_produto_venda';
  static const columnIdProduto = 'id_produto';
  static const columnPrecoProduto = 'preco_produto';
  static const columnQuantidadeProduto = 'quantidade_produto';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnIdVenda ${SqliteTipos.integer},
      $columnIdProdutoVenda ${SqliteTipos.integer},
      $columnIdProduto ${SqliteTipos.integer},
      $columnPrecoProduto ${SqliteTipos.real},
      $columnQuantidadeProduto ${SqliteTipos.integer},
      FOREIGN KEY ($columnIdProduto) REFERENCES ${ProdutoTable.tableName}(${ProdutoTable.columnIdProduto}),
      FOREIGN KEY ($columnIdVenda) REFERENCES ${VendaTable.tableName}(${VendaTable.columnIdVenda}),
      PRIMARY KEY ($columnIdVenda, $columnIdProdutoVenda, $columnIdProduto)
    );
  ''';
}

class ProdutoVenda extends Entity implements IForeignKey {
  int idVenda;
  int idProdutoVenda;
  int idProduto;
  double precoProduto;
  int quantidadeProduto;

  Produto? _produto;
  Produto? get produto => _produto;
  set produto(Produto? value) {
    _produto = value;
    if (value != null) {
      idProduto = value.idProduto;
    }
  }

  ProdutoVenda({
    required this.idVenda,
    required this.idProdutoVenda,
    required this.idProduto,
    required this.precoProduto,
    required this.quantidadeProduto,
    Produto? produto,
  })  : _produto = produto,
        super(tableName: ProdutoVendaTable.tableName);

  ProdutoVenda.fromMap(Map map)
      : this(
          idVenda: map[ProdutoVendaTable.columnIdVenda],
          idProdutoVenda: map[ProdutoVendaTable.columnIdProdutoVenda],
          idProduto: map[ProdutoVendaTable.columnIdProduto],
          precoProduto: map[ProdutoVendaTable.columnPrecoProduto],
          quantidadeProduto: map[ProdutoVendaTable.columnQuantidadeProduto],
        );

  ProdutoVenda.noPrimaryKey(
      {required int idVenda,
      required Produto produto,
      required double precoProduto,
      required int quantidadeProduto})
      : this(
          idVenda: idVenda,
          idProduto: produto.idProduto,
          idProdutoVenda: nextPrimaryKey(),
          precoProduto: precoProduto,
          quantidadeProduto: quantidadeProduto,
        );

  ProdutoVenda.empty()
      : this(
          idProduto: 0,
          idProdutoVenda: 0,
          idVenda: 0,
          precoProduto: 0,
          quantidadeProduto: 0,
        );

  @override
  Entity fromMap(Map map) {
    return ProdutoVenda.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ProdutoVendaTable.columnIdVenda: idVenda.toString(),
      ProdutoVendaTable.columnIdProdutoVenda: idProdutoVenda.toString(),
      ProdutoVendaTable.columnIdProduto: idProduto.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idVenda = keys[ProdutoVendaTable.columnIdVenda];
    idProdutoVenda = keys[ProdutoVendaTable.columnIdProdutoVenda];
    idProduto = keys[ProdutoVendaTable.columnIdProduto];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ProdutoVendaTable.columnIdVenda: idVenda,
      ProdutoVendaTable.columnIdProdutoVenda: idProdutoVenda,
      ProdutoVendaTable.columnIdProduto: idProduto,
      ProdutoVendaTable.columnPrecoProduto: precoProduto,
      ProdutoVendaTable.columnQuantidadeProduto: quantidadeProduto,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];

    foreignKeys.add(
      ForeignKey(
        tableEntity: Produto.empty(),
        keys: {ProdutoTable.columnIdProduto: idProduto},
      ),
    );

    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    produto = values[ProdutoTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! ProdutoVenda) {
      return false;
    }
    return idVenda == other.idVenda &&
        idProdutoVenda == other.idProdutoVenda &&
        idProduto == other.idProduto &&
        precoProduto == other.precoProduto &&
        quantidadeProduto == other.quantidadeProduto;
  }

  @override
  int get hashCode {
    return idVenda.hashCode +
        idProdutoVenda.hashCode +
        idProduto.hashCode +
        precoProduto.hashCode +
        quantidadeProduto.hashCode;
  }
}
