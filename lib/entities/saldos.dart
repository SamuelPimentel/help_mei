import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/entrada_saida.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/helpers/constantes.dart';

class SaldosTable {
  SaldosTable._();
  static const tableName = 'saldos';
  static const columnIdProduto = 'id_produto';
  static const columnQuantidadeSaldos = 'quantidade_saldos';
  static const columnCustoUnitarioSaldos = 'custo_unitario_saldos';
  static const columnTotalSaldos = 'total_saldos';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnIdProduto ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnQuantidadeSaldos ${SqliteTipos.integer},
      $columnCustoUnitarioSaldos ${SqliteTipos.real},
      $columnTotalSaldos ${SqliteTipos.real},
      FOREIGN KEY($columnIdProduto) REFERENCES ${ProdutoTable.tableName}(${ProdutoTable.columnIdProduto})
    );
  ''';

  static List<String> createTriggers = [
    '''
    CREATE TRIGGER inicializa_saldo AFTER INSERT ON ${ProdutoTable.tableName}
    BEGIN
      INSERT INTO $tableName($columnIdProduto,$columnQuantidadeSaldos,$columnCustoUnitarioSaldos,$columnTotalSaldos)
      VALUES (NEW.${ProdutoTable.columnIdProduto}, 0, 0, 0);
    END;
    ''',
    '''
    CREATE TRIGGER atualiza_saldo_compra AFTER INSERT ON ${EntradaSaidaTable.tableName}
      WHEN NEW.${EntradaSaidaTable.columnIdMovimentacao} = 1
    BEGIN 
      UPDATE $tableName SET $columnQuantidadeSaldos = ($tableName.$columnQuantidadeSaldos + NEW.${EntradaSaidaTable.columnQuantidade}) WHERE $tableName.$columnIdProduto = NEW.${EntradaSaidaTable.columnIdProduto};
      UPDATE $tableName SET $columnTotalSaldos = ($tableName.$columnTotalSaldos + NEW.${EntradaSaidaTable.columnTotal}) WHERE $tableName.$columnIdProduto = NEW.${EntradaSaidaTable.columnIdProduto};
      UPDATE $tableName SET custo_unitario_saldos = ($tableName.$columnTotalSaldos/$tableName.$columnQuantidadeSaldos) WHERE $tableName.$columnIdProduto = NEW.${EntradaSaidaTable.columnIdProduto};
    END;
    ''',
    '''
    CREATE TRIGGER atualiza_saldo_venda AFTER INSERT ON ${EntradaSaidaTable.tableName}
      WHEN NEW.${EntradaSaidaTable.columnIdMovimentacao} = 2
    BEGIN 
      UPDATE $tableName SET $columnQuantidadeSaldos = ($tableName.$columnQuantidadeSaldos - NEW.${EntradaSaidaTable.columnQuantidade}) WHERE $tableName.$columnIdProduto = NEW.${EntradaSaidaTable.columnIdProduto};
      UPDATE $tableName SET $columnTotalSaldos = ($tableName.$columnTotalSaldos - NEW.${EntradaSaidaTable.columnTotal}) WHERE $tableName.$columnIdProduto = NEW.${EntradaSaidaTable.columnIdProduto};
    END;
    ''',
  ];
}

class Saldos extends Entity implements IForeignKey {
  int idProduto;
  int quantidade;
  double custoUnitario;
  double valorTotal;

  Produto? _produto;
  Produto? get produto => _produto;
  set produto(Produto? value) {
    _produto = value;
    if (value != null) {
      idProduto = value.idProduto;
    }
  }

  Saldos({
    required this.idProduto,
    required this.quantidade,
    required this.custoUnitario,
    required this.valorTotal,
  }) : super(tableName: SaldosTable.tableName);

  Saldos.froMap(Map map)
      : this(
          idProduto: map[SaldosTable.columnIdProduto],
          quantidade: map[SaldosTable.columnQuantidadeSaldos],
          custoUnitario: map[SaldosTable.columnCustoUnitarioSaldos],
          valorTotal: map[SaldosTable.columnTotalSaldos],
        );

  Saldos.empty()
      : this(
          custoUnitario: 0,
          idProduto: 0,
          quantidade: 0,
          valorTotal: 0,
        );

  @override
  Entity fromMap(Map map) {
    return Saldos.froMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      SaldosTable.columnIdProduto: idProduto.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys[SaldosTable.columnIdProduto];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      SaldosTable.columnIdProduto: idProduto,
      SaldosTable.columnQuantidadeSaldos: quantidade,
      SaldosTable.columnCustoUnitarioSaldos: custoUnitario,
      SaldosTable.columnTotalSaldos: valorTotal,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! Saldos) {
      return false;
    }
    return idProduto == other.idProduto &&
        quantidade == other.quantidade &&
        custoUnitario == other.custoUnitario &&
        valorTotal == other.valorTotal;
  }

  @override
  int get hashCode {
    return idProduto.hashCode +
        quantidade.hashCode +
        custoUnitario.hashCode +
        valorTotal.hashCode;
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
}
