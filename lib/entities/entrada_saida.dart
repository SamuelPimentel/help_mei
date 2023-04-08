import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_movimentacao.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class EntradaSaidaTable {
  EntradaSaidaTable._();

  static const tableName = 'entrada_saida';

  static const columnIdProduto = 'id_produto';
  static const columnDataIdEntradaSaida = 'data_id_entrada_saida';
  static const columnIdEntradaSaida = 'id__entrada_saida';
  static const columnDataMovimentacao = 'data_movimentacao';
  static const columnIdMovimentacao = 'id_tipo_movimentacao';
  static const columnQuantidade = 'quantidade_entrada_saida';
  static const columnValorUnitario = 'valor_unitario_entrada_saida';
  static const columnTotal = 'total_entrada_saida';

  static const createString = '''
    CREATE TABLE $tableName(
      $columnIdProduto ${SqliteTipos.integer},
      $columnDataIdEntradaSaida ${SqliteTipos.integer},
      $columnIdEntradaSaida ${SqliteTipos.integer},
      $columnDataMovimentacao ${SqliteTipos.text} ${SqlitePropriedades.notNull},
      $columnIdMovimentacao ${SqliteTipos.integer},
      $columnQuantidade ${SqliteTipos.real},
      $columnValorUnitario ${SqliteTipos.real},
      $columnTotal ${SqliteTipos.real},
      FOREIGN KEY($columnIdProduto) REFERENCES ${ProdutoTable.tableName}(${ProdutoTable.columnIdProduto}),
      FOREIGN KEY($columnIdMovimentacao) REFERENCES ${TipoMovimentacaoTable.tableName}(${TipoMovimentacaoTable.columnId}),
      PRIMARY KEY($columnIdProduto,$columnDataIdEntradaSaida,$columnIdEntradaSaida)
    );
  ''';
}

class EntradaSaida extends Entity implements IForeignKey {
  int idProduto;
  int idData;
  int idEntradaSaida;
  DateTime dataMovimentacao;
  int idTipoMovimentacao;
  double quantidade;
  double valorUnitario;
  double total;

  Produto? _produto;
  Produto? get produto => _produto;
  set produto(Produto? value) {
    _produto = value;
    if (value != null) {
      idProduto = value.idProduto;
    }
  }

  TipoMovimentacao? _tipoMovimentacao;
  TipoMovimentacao? get tipoMovimentacao => _tipoMovimentacao;
  set tipoMovimentacao(TipoMovimentacao? value) {
    _tipoMovimentacao = value;
    if (value != null) {
      idTipoMovimentacao = value.id;
    }
  }

  EntradaSaida({
    required this.idProduto,
    required this.idData,
    required this.idEntradaSaida,
    required this.dataMovimentacao,
    required this.idTipoMovimentacao,
    required this.quantidade,
    required this.valorUnitario,
    required this.total,
    Produto? produto,
    TipoMovimentacao? tipoMovimentacao,
  })  : _produto = produto,
        _tipoMovimentacao = tipoMovimentacao,
        super(tableName: EntradaSaidaTable.tableName);

  EntradaSaida.fromMap(Map map)
      : this(
          idProduto: map[EntradaSaidaTable.columnIdProduto],
          idData: map[EntradaSaidaTable.columnDataIdEntradaSaida],
          idEntradaSaida: map[EntradaSaidaTable.columnIdEntradaSaida],
          dataMovimentacao:
              DateTime.parse(map[EntradaSaidaTable.columnDataMovimentacao]),
          idTipoMovimentacao: map[EntradaSaidaTable.columnIdMovimentacao],
          quantidade: map[EntradaSaidaTable.columnQuantidade],
          total: map[EntradaSaidaTable.columnTotal],
          valorUnitario: map[EntradaSaidaTable.columnValorUnitario],
        );

  EntradaSaida.empty()
      : this(
          idData: 0,
          dataMovimentacao: DateTime.now(),
          idEntradaSaida: 0,
          idProduto: 0,
          idTipoMovimentacao: 0,
          quantidade: 0,
          total: 0,
          valorUnitario: 0,
        );

  EntradaSaida.noPrimaryKey({
    required Produto produto,
    required TipoMovimentacao tipoMovimentacao,
    required DateTime dataMovimentacao,
    required double quantidade,
    required double total,
    required double valorUnitario,
  }) : this(
          produto: produto,
          idProduto: produto.idProduto,
          dataMovimentacao: dataMovimentacao,
          idData: generateIdData(dataMovimentacao),
          idEntradaSaida: nextPrimaryKey(),
          idTipoMovimentacao: tipoMovimentacao.id,
          tipoMovimentacao: tipoMovimentacao,
          quantidade: quantidade,
          total: total,
          valorUnitario: valorUnitario,
        );

  EntradaSaida.noPrimaryKeyToday({
    required Produto produto,
    required TipoMovimentacao tipoMovimentacao,
    required double quantidade,
    required double total,
    required double valorUnitario,
  }) : this(
          produto: produto,
          idProduto: produto.idProduto,
          dataMovimentacao: DateTime.now(),
          idData: generateTodayIdData(),
          idEntradaSaida: nextPrimaryKey(),
          idTipoMovimentacao: tipoMovimentacao.id,
          tipoMovimentacao: tipoMovimentacao,
          quantidade: quantidade,
          total: total,
          valorUnitario: valorUnitario,
        );

  @override
  Entity fromMap(Map map) {
    return EntradaSaida.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      EntradaSaidaTable.columnIdProduto: idProduto.toString(),
      EntradaSaidaTable.columnDataIdEntradaSaida: idData.toString(),
      EntradaSaidaTable.columnIdEntradaSaida: idEntradaSaida.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys[EntradaSaidaTable.columnIdProduto];
    idData = keys[EntradaSaidaTable.columnDataIdEntradaSaida];
    idEntradaSaida = keys[EntradaSaidaTable.columnIdEntradaSaida];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      EntradaSaidaTable.columnIdProduto: idProduto,
      EntradaSaidaTable.columnDataIdEntradaSaida: idData,
      EntradaSaidaTable.columnIdEntradaSaida: idEntradaSaida,
      EntradaSaidaTable.columnDataMovimentacao:
          dataMovimentacao.toIso8601String(),
      EntradaSaidaTable.columnIdMovimentacao: idTipoMovimentacao,
      EntradaSaidaTable.columnQuantidade: quantidade,
      EntradaSaidaTable.columnValorUnitario: valorUnitario,
      EntradaSaidaTable.columnTotal: total,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! EntradaSaida) {
      return false;
    }
    return idProduto == other.idProduto &&
        idData == other.idData &&
        idEntradaSaida == other.idEntradaSaida &&
        dataMovimentacao == other.dataMovimentacao &&
        idTipoMovimentacao == other.idTipoMovimentacao &&
        quantidade == other.quantidade &&
        valorUnitario == other.valorUnitario &&
        total == other.total;
  }

  @override
  int get hashCode {
    return idProduto.hashCode +
        idData.hashCode +
        idEntradaSaida.hashCode +
        dataMovimentacao.hashCode +
        idTipoMovimentacao.hashCode +
        quantidade.hashCode +
        valorUnitario.hashCode +
        total.hashCode;
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

    foreignKeys.add(
      ForeignKey(
        tableEntity: TipoMovimentacao.empty(),
        keys: {TipoMovimentacaoTable.columnId: idTipoMovimentacao},
      ),
    );
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    produto = values[ProdutoTable.tableName];
    tipoMovimentacao = values[TipoMovimentacaoTable.tableName];
  }
}
