import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/contas_mes.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';

class ContaMesItensTable {
  static const tableName = 'contas_mes_itens';
  static const idContasMesItensName = 'id_contas_mes_itens';
  static const idContasMesName = 'id_contas_mes';
  static const idContaName = 'id_conta';
  static const descricaoItemName = 'descricao_item';
  static const valorParcelaName = 'valor_parcela';
  static const vencimentoName = 'vencimento';
  static const dataPagamentoName = 'data_pagamento';
  static const numeroParcelaName = 'numero_parcela';
  static const valorPagoName = 'valor_pago';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $idContasMesItensName INTEGER,
      $idContasMesName INTEGER,
      $idContaName INTEGER,
      $descricaoItemName TEXT,
      $valorParcelaName REAL,
      $vencimentoName TEXT NOT NULL,
      $dataPagamentoName TEXT,
      $numeroParcelaName INTEGER,
      $valorPagoName INTEGER,
      PRIMARY KEY ($idContasMesItensName, $idContasMesName),

      FOREIGN KEY ($idContasMesName) REFERENCES ${ContasMesTable.tableName} (${ContasMesTable.idContasMesName}),
      FOREIGN KEY ($idContaName) REFERENCES ${ContaTable.tableName} (${ContaTable.idContaName})
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
          idContasMesItens: map[ContaMesItensTable.idContasMesItensName],
          idContasMes: map[ContaMesItensTable.idContasMesName],
          idConta: map[ContaMesItensTable.idContaName],
          descricaoItem: map[ContaMesItensTable.descricaoItemName],
          valorParcela: map[ContaMesItensTable.valorParcelaName],
          vencimento: DateTime.parse(map[ContaMesItensTable.vencimentoName]),
          dataPagamento: map[ContaMesItensTable.dataPagamentoName] == null
              ? null
              : DateTime.parse(map[ContaMesItensTable.dataPagamentoName]),
          numeroParcela: map[ContaMesItensTable.numeroParcelaName],
          valorPago: map[ContaMesItensTable.valorPagoName] == 1,
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
      ContaMesItensTable.idContasMesItensName: idContasMesItens.toString(),
      ContaMesItensTable.idContasMesName: idContasMes.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idContasMesItens = keys[ContaMesItensTable.idContasMesItensName];
    idContasMes = keys[ContaMesItensTable.idContasMesName];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContaMesItensTable.idContasMesItensName: idContasMesItens,
      ContaMesItensTable.idContasMesName: idContasMes,
      ContaMesItensTable.idContaName: idConta,
      ContaMesItensTable.descricaoItemName: descricaoItem,
      ContaMesItensTable.valorParcelaName: valorParcela,
      ContaMesItensTable.vencimentoName: vencimento.toIso8601String(),
      ContaMesItensTable.dataPagamentoName: dataPagamento,
      ContaMesItensTable.numeroParcelaName: numeroParcela,
      ContaMesItensTable.valorPagoName: valorPago ? 1 : 0,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Conta.empty(),
        keys: {
          ContaTable.idContaName: idConta,
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
