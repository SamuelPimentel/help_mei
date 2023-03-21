import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/fornecedor.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class ContaTable {
  static const tableName = 'conta';
  static const columnIdConta = 'id_conta';
  static const idFornecedorName = 'id_fornecedor';
  static const columnIdTipoConta = 'id_tipo_conta';
  static const columnIdProduto = 'id_produto';
  static const columnDescricaoConta = 'descricao_conta';
  static const columnValorConta = 'valor_conta';
  static const columnTotalParcelas = 'total_parcelas';
  static const columnDataVencimento = 'data_vencimento';
  static const columnQuitadaConta = 'quitada_conta';
  static const columnAtivaConta = 'ativa_conta';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdConta INTEGER PRIMARY KEY,
      $idFornecedorName INTEGER,
      $columnIdProduto INTEGER,
      $columnDescricaoConta TEXT,
      $columnValorConta REAL,
      $columnTotalParcelas INTEGER,
      $columnDataVencimento TEXT NOT NULL,
      $columnQuitadaConta INTEGER,
      $columnAtivaConta INTEGER,
      FOREIGN KEY ($idFornecedorName) REFERENCES ${FornecedorTable.tableName} (${FornecedorTable.idFornecedorName}),
      FOREIGN KEY ($columnIdProduto) REFERENCES ${ProdutoTable.tableName} (${ProdutoTable.columnIdProduto})
    );''';

  static const createStringV2 = '''
    CREATE TABLE $tableName (
      $columnIdConta ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnIdTipoConta ${SqliteTipos.integer},
      $columnIdProduto ${SqliteTipos.integer},
      $columnDescricaoConta TEXT,
      $columnValorConta REAL,
      $columnTotalParcelas INTEGER,
      $columnDataVencimento TEXT NOT NULL,
      $columnQuitadaConta INTEGER,
      $columnAtivaConta INTEGER,
      FOREIGN KEY ($columnIdTipoConta) REFERENCES ${TipoContaTable.tableName} (${TipoContaTable.columnIdTipoConta}),
      FOREIGN KEY ($columnIdProduto) REFERENCES ${ProdutoTable.tableName} (${ProdutoTable.columnIdProduto})
    );''';
  ContaTable._();
}

class Conta extends Entity implements IForeignKey, IRequestNewPrimaryKey {
  int idConta;
  int idTipoConta;
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
      idTipoConta = value.idFornecedor;
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

  TipoConta? _tipoConta;
  TipoConta? get tipoConta => _tipoConta;
  set tipoConta(TipoConta? value) {
    _tipoConta = value;
    if (value != null) {
      idTipoConta = value.idTipoConta;
    }
  }

  Conta({
    required this.idConta,
    required this.idTipoConta,
    required this.idProduto,
    required this.descricaoConta,
    required this.valorConta,
    required this.totalParcelas,
    required this.dataVencimento,
    required this.quitadaConta,
    required this.ativaConta,
  }) : super(tableName: ContaTable.tableName);

  Conta.noPrimaryKey({
    required idTipoConta,
    required idProduto,
    required descricaoConta,
    required valorConta,
    required totalParcelas,
    required dataVencimento,
    required quitadaConta,
    required ativaConta,
  }) : this(
            idConta: nextPrimaryKey(),
            idTipoConta: idTipoConta,
            idProduto: idProduto,
            descricaoConta: descricaoConta,
            valorConta: valorConta,
            totalParcelas: totalParcelas,
            dataVencimento: dataVencimento,
            quitadaConta: quitadaConta,
            ativaConta: ativaConta);

  Conta.fromMap(Map map)
      : this(
          idConta: map[ContaTable.columnIdConta],
          idTipoConta: map[ContaTable.columnIdTipoConta],
          idProduto: map[ContaTable.columnIdProduto],
          descricaoConta: map[ContaTable.columnDescricaoConta],
          valorConta: map[ContaTable.columnValorConta],
          totalParcelas: map[ContaTable.columnTotalParcelas],
          dataVencimento: DateTime.parse(map[ContaTable.columnDataVencimento]),
          quitadaConta: map[ContaTable.columnQuitadaConta] == 1,
          ativaConta: map[ContaTable.columnAtivaConta] == 1,
        );
  Conta.empty()
      : this(
          ativaConta: false,
          dataVencimento: DateTime.now(),
          idConta: 0,
          idTipoConta: 0,
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
      ContaTable.columnIdConta: idConta.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idConta = keys[ContaTable.columnIdConta];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContaTable.columnIdConta: idConta,
      ContaTable.columnIdProduto: idProduto,
      ContaTable.columnDescricaoConta: descricaoConta,
      ContaTable.columnIdTipoConta: idTipoConta,
      ContaTable.columnValorConta: valorConta,
      ContaTable.columnTotalParcelas: totalParcelas,
      ContaTable.columnDataVencimento: dataVencimento.toIso8601String(),
      ContaTable.columnQuitadaConta: quitadaConta == true ? 1 : 0,
      ContaTable.columnAtivaConta: ativaConta == true ? 1 : 0,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: TipoConta.empty(),
        keys: {
          TipoContaTable.columnIdTipoConta: idTipoConta,
        },
      ),
    );
    if (idProduto != null) {
      foreignKeys.add(
        ForeignKey(
          tableEntity: Produto.empty(),
          keys: {
            ProdutoTable.columnIdProduto: idProduto,
          },
        ),
      );
    }

    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    tipoConta = values[TipoContaTable.tableName];
    produto = values[ProdutoTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! Conta) {
      return false;
    }
    return idConta == other.idConta &&
        idTipoConta == other.idTipoConta &&
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
        idTipoConta.hashCode +
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
