import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/fornecedor.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/helpers/constantes.dart';

class ContaTable {
  static const tableName = 'conta';
  static const idContaName = 'id_conta';
  static const idFornecedorName = 'id_fornecedor';
  static const idProdutoName = 'id_produto';
  static const descricaoContaName = 'descricao_conta';
  static const valorContaName = 'valor_conta';
  static const totalParcelasName = 'total_parcelas';
  static const dataVencimentoName = 'data_vencimento';
  static const quitadaContaName = 'quitada_conta';
  static const ativaContaName = 'ativa_conta';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $idContaName INTEGER PRIMARY KEY,
      $idFornecedorName INTEGER,
      $idProdutoName INTEGER,
      $descricaoContaName TEXT,
      $valorContaName REAL,
      $totalParcelasName INTEGER,
      $dataVencimentoName TEXT NOT NULL,
      $quitadaContaName INTEGER,
      $ativaContaName INTEGER,
      FOREIGN KEY ($idFornecedorName) REFERENCES ${FornecedorTable.tableName} (${FornecedorTable.idFornecedorName}),
      FOREIGN KEY ($idProdutoName) REFERENCES ${ProdutoTable.tableName} (${ProdutoTable.idProdutoName})
    );''';
  ContaTable._();
}

class Conta extends Entity implements IForeignKey, IRequestNewPrimaryKey {
  int idConta;
  int idFornecedor;
  int? idProduto;
  String? descricaoConta;
  double valorConta;
  int totalParcelas;
  DateTime dataVencimento;
  bool quitadaConta;
  bool ativaConta;
  Fornecedor? _fornecedor;

  Fornecedor? get fornecedor => _fornecedor;

  set fornecedor(Fornecedor? value) {
    _fornecedor = value;
    if (value != null) {
      idFornecedor = value.idFornecedor;
    }
  }

  Produto? _produto;

  Produto? get produto => _produto;

  set produto(Produto? value) {
    _produto = value;
    if (value != null) {
      idProduto = value.idProduto;
    }
  }

  Conta({
    required this.idConta,
    required this.idFornecedor,
    required this.idProduto,
    required this.descricaoConta,
    required this.valorConta,
    required this.totalParcelas,
    required this.dataVencimento,
    required this.quitadaConta,
    required this.ativaConta,
  }) : super(tableName: ContaTable.tableName);

  Conta.fromMap(Map map)
      : this(
          idConta: map[ContaTable.idContaName],
          idFornecedor: map[ContaTable.idFornecedorName],
          idProduto: map[ContaTable.idProdutoName],
          descricaoConta: map[ContaTable.descricaoContaName],
          valorConta: map[ContaTable.valorContaName],
          totalParcelas: map[ContaTable.totalParcelasName],
          dataVencimento: DateTime.parse(map[ContaTable.dataVencimentoName]),
          quitadaConta: map[ContaTable.quitadaContaName] == 1,
          ativaConta: map[ContaTable.ativaContaName] == 1,
        );
  Conta.empty()
      : this(
          ativaConta: false,
          dataVencimento: DateTime.now(),
          idConta: 0,
          idFornecedor: 0,
          quitadaConta: false,
          totalParcelas: 0,
          valorConta: 0,
          descricaoConta: null,
          idProduto: null,
        );

  @override
  Entity fromMap(Map map) {
    return Conta.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ContaTable.idContaName: idConta.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idConta = keys[ContaTable.idContaName];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContaTable.idContaName: idConta,
      ContaTable.idProdutoName: idProduto,
      ContaTable.descricaoContaName: descricaoConta,
      ContaTable.idFornecedorName: idFornecedor,
      ContaTable.valorContaName: valorConta,
      ContaTable.totalParcelasName: totalParcelas,
      ContaTable.dataVencimentoName: dataVencimento.toIso8601String(),
      ContaTable.quitadaContaName: quitadaConta == true ? 1 : 0,
      ContaTable.ativaContaName: ativaConta == true ? 1 : 0,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Fornecedor.empty(),
        keys: {
          FornecedorTable.idFornecedorName: idFornecedor,
        },
      ),
    );
    if (idProduto != null) {
      foreignKeys.add(
        ForeignKey(
          tableEntity: Produto.empty(),
          keys: {
            ProdutoTable.idProdutoName: idProduto,
          },
        ),
      );
    }

    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    fornecedor = values[FornecedorTable.tableName];
    produto = values[ProdutoTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! Conta) {
      return false;
    }
    return idConta == other.idConta &&
        idFornecedor == other.idFornecedor &&
        idProduto == other.idProduto &&
        descricaoConta == other.descricaoConta &&
        valorConta == other.valorConta &&
        totalParcelas == other.totalParcelas &&
        dataVencimento == other.dataVencimento &&
        quitadaConta == other.quitadaConta &&
        ativaConta == other.ativaConta;
  }

  @override
  int get hashCode {
    return idConta.hashCode +
        idFornecedor.hashCode +
        idProduto.hashCode +
        descricaoConta.hashCode +
        valorConta.hashCode +
        totalParcelas.hashCode +
        dataVencimento.hashCode +
        quitadaConta.hashCode +
        ativaConta.hashCode;
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idConta = rnd.nextInt(maxInt32);
  }
}
