import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/contas_mes.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';

class ContaMesItensTable {
  static const tableName = 'contas_mes_itens';
  static const columnIdContasMesItens = 'id_contas_mes_itens';
  static const columnIdContasMes = 'id_contas_mes';
  static const columnIdConta = 'id_conta';
  static const columnDescricaoItem = 'descricao_item';
  static const columnValorParcela = 'valor_parcela';
  static const columnVencimento = 'vencimento';
  static const columnDataPagamento = 'data_pagamento';
  static const columnNumeroParcela = 'numero_parcela';
  static const columnValorPago = 'valor_pago';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdContasMesItens INTEGER,
      $columnIdContasMes INTEGER,
      $columnIdConta INTEGER,
      $columnDescricaoItem TEXT,
      $columnValorParcela REAL,
      $columnVencimento TEXT NOT NULL,
      $columnDataPagamento TEXT,
      $columnNumeroParcela INTEGER,
      $columnValorPago INTEGER,
      PRIMARY KEY ($columnIdContasMesItens, $columnIdContasMes),

      FOREIGN KEY ($columnIdContasMes) REFERENCES ${ContasMesTable.tableName} (${ContasMesTable.columnIdContasMes}),
      FOREIGN KEY ($columnIdConta) REFERENCES ${ContaTable.tableName} (${ContaTable.columnIdConta})
    );''';

  ContaMesItensTable._();
}

class ContaMesItens extends Entity implements IForeignKey {
  int idContasMesItens;
  int idContasMes;
  int idConta;
  String descricaoItem;
  double valorParcela;
  DateTime vencimento;
  DateTime? dataPagamento;
  int numeroParcela;
  bool valorPago;
  Conta? conta;

  ContaMesItens({
    required this.idContasMesItens,
    required this.idContasMes,
    required this.idConta,
    required this.descricaoItem,
    required this.valorParcela,
    required this.vencimento,
    required this.dataPagamento,
    required this.numeroParcela,
    required this.valorPago,
  }) : super(tableName: ContaMesItensTable.tableName);

  ContaMesItens.fromMap(Map map)
      : this(
          idContasMesItens: map[ContaMesItensTable.columnIdContasMesItens],
          idContasMes: map[ContaMesItensTable.columnIdContasMes],
          idConta: map[ContaMesItensTable.columnIdConta],
          descricaoItem: map[ContaMesItensTable.columnDescricaoItem],
          valorParcela: map[ContaMesItensTable.columnValorParcela],
          vencimento: DateTime.parse(map[ContaMesItensTable.columnVencimento]),
          dataPagamento: map[ContaMesItensTable.columnDataPagamento] == null
              ? null
              : DateTime.parse(map[ContaMesItensTable.columnDataPagamento]),
          numeroParcela: map[ContaMesItensTable.columnNumeroParcela],
          valorPago: map[ContaMesItensTable.columnValorPago] == 1,
        );
  ContaMesItens.empty()
      : this(
          dataPagamento: null,
          descricaoItem: '',
          idConta: 0,
          idContasMes: 0,
          idContasMesItens: 0,
          numeroParcela: 0,
          valorPago: false,
          valorParcela: 0,
          vencimento: DateTime.now(),
        );

  @override
  Entity fromMap(Map map) {
    return ContaMesItens.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ContaMesItensTable.columnIdContasMesItens: idContasMesItens.toString(),
      ContaMesItensTable.columnIdContasMes: idContasMes.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idContasMesItens = keys[ContaMesItensTable.columnIdContasMesItens];
    idContasMes = keys[ContaMesItensTable.columnIdContasMes];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContaMesItensTable.columnIdContasMesItens: idContasMesItens,
      ContaMesItensTable.columnIdContasMes: idContasMes,
      ContaMesItensTable.columnIdConta: idConta,
      ContaMesItensTable.columnDescricaoItem: descricaoItem,
      ContaMesItensTable.columnValorParcela: valorParcela,
      ContaMesItensTable.columnVencimento: vencimento.toIso8601String(),
      ContaMesItensTable.columnDataPagamento: dataPagamento,
      ContaMesItensTable.columnNumeroParcela: numeroParcela,
      ContaMesItensTable.columnValorPago: valorPago ? 1 : 0,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Conta.empty(),
        keys: {
          ContaTable.columnIdConta: idConta,
        },
      ),
    );
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    conta = values[ContaTable.tableName];
  }
}
