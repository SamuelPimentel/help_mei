import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/fornecedor.dart';

class ContaTable {
  static const tableName = 'conta';
  static const idContaName = 'id_conta';
  static const idFornecedorName = 'id_fornecedor';
  static const valorContaName = 'valor_conta';
  static const totalParcelasName = 'total_parcelas';
  static const dataVencimentoName = 'data_vencimento';
  static const quitadaContaName = 'quitada_conta';
  static const ativaContaName = 'ativa_conta';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $idContaName INTEGER PRIMARY KEY,
      $idFornecedorName INTEGER,
      $valorContaName REAL,
      $totalParcelasName INTEGER,
      $dataVencimentoName TEXT NOT NULL,
      $quitadaContaName INTEGER,
      $ativaContaName INTEGER,
      FOREIGN KEY ($idFornecedorName) REFERENCES ${FornecedorTable.tableName} (${FornecedorTable.idFornecedorName})
    );''';
  ContaTable._();
}

class Conta extends Entity implements IForeignKey {
  int idConta;
  int idFornecedor;
  double valorConta;
  int totalParcelas;
  DateTime dataVencimento;
  bool quitadaConta;
  bool ativaConta;
  Fornecedor? fornecedor;

  Conta({
    required this.idConta,
    required this.idFornecedor,
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

    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    fornecedor = values[FornecedorTable.tableName];
  }
}
