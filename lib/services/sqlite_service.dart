import 'dart:ffi';
import 'dart:io';

import 'package:help_mei/entities/conta.dart';
import 'package:help_mei/entities/contas_mes.dart';
import 'package:help_mei/entities/contas_mes_itens.dart';
import 'package:help_mei/entities/fornecedor.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/tipo_fornecimento.dart';

class SqliteService {
  static const _databaseName = 'HelpMeiData.db';
  static const _databaseVersion = 1;
  static Database? _database;

  SqliteService._privateConstructor();
  static final SqliteService instance = SqliteService._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    _createTableMarcaV1(batch);
    _createTableCategoriaV1(batch);
    _createTableProdutoV1(batch);
    _createTableProdutoCategoriaV1(batch);
    _createTableTipoMovimentacaoV1(batch);
    _createTableEntradaSaidaV1(batch);
    _createTableSaldosV1(batch);
    _createTableHistoricoSaldoV1(batch);
    _createTableTotais(batch);
    _createTriggerInicializaSaldoV1(batch);
    _createTriggerAtualizaSaldoCompraV1(batch);
    _createTriggerAtualizaSaldoVendaV1(batch);
    _inicializaTipoMovimentacaoV1(batch);
    _createTableTipoFornecimentoV1(batch);
    _createTableFornecedorV1(batch);
    _createTableContasMesV1(batch);
    _createTableContaV1(batch);
    _createTableContasMesItensV1(batch);
    await batch.commit();
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    if (oldVersion == 1) {
      _createTableTipoFornecimentoV1(batch);
      _createTableFornecedorV1(batch);
      _createTableContasMesV1(batch);
      _createTableContaV1(batch);
      _createTableContasMesItensV1(batch);
    }
    await batch.commit();
  }

  void _createTableContasMesItensV1(Batch batch) {
    batch.execute(ContaMesItensTable.createStringV1);
  }

  void _createTableContaV1(Batch batch) {
    batch.execute(ContaTable.createStringV1);
  }

  void _createTableContasMesV1(Batch batch) {
    batch.execute(ContasMesTable.createStringV1);
  }

  void _createTableTipoFornecimentoV1(Batch batch) {
    batch.execute(TipoFornecimentoTable.createStringV1);
  }

  void _createTableFornecedorV1(Batch batch) {
    batch.execute(FornecedorTable.createStringV1);
  }

  void _createTableMarcaV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS ${MarcaTable.tableName};');
    batch.execute(MarcaTable.createStringV1);
  }

  void _createTableCategoriaV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS categoria;');
    batch.execute('''
    CREATE TABLE categoria (
      id_categoria INTEGER PRIMARY KEY,
      nome_categoria TEXT NOT NULL UNIQUE
    );''');
  }

  void _createTableProdutoV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS ${ProdutoTable.tableName};');
    batch.execute(ProdutoTable.createStringV1);
  }

  void _createTableProdutoCategoriaV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS produto_categoria;');
    batch.execute('''
      CREATE TABLE produto_categoria (
        id_produto INTEGER,
        id_produto_categoria INTEGER,
        id_categoria INTEGER,

        FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
        FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),

        PRIMARY KEY (id_produto, id_produto_categoria)
      );''');
  }

  void _createTableTipoMovimentacaoV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS tipo_movimentacao;');
    batch.execute('''
      CREATE TABLE tipo_movimentacao (
        id_tipo_movimentacao INTEGER PRIMARY KEY,
        nome_tipo_movimentacao TEXT UNIQUE NOT NULL
      );''');
  }

  void _createTableEntradaSaidaV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS entrada_saida;');
    batch.execute('''
      CREATE TABLE entrada_saida (
        id_produto INTEGER,
        data_id INTEGER,
        id_entrada_saida INTEGER,
        data_entrada_saida TEXT NOT NULL,
        id_movimentacao INTEGER,
        quantidade_entrada_saida INTEGER,
        valor_unitario_entrada_saida REAL,
        total_entrada_saida REAL,
        FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
        PRIMARY KEY (id_entrada_saida, data_id, id_produto)
      );''');
  }

  void _createTableSaldosV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS saldos;');
    batch.execute('''
      CREATE TABLE saldos (
        id_produto INTEGER PRIMARY KEY,
        quantidade_saldos INTEGER,
        custo_unitario_saldos REAL,
        total_saldos REAL,
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
      );''');
  }

  void _createTableHistoricoSaldoV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS historico_saldo;');
    batch.execute('''
      CREATE TABLE historico_saldo (
        id_produto INTEGER,
        data_id INTEGER,
        id_entrada_saida INTEGER,
        saldo_quantidade INTEGER,
        saldo_custo_unit REAL,
        saldo_total REAL,
        data TEXT,
        FOREIGN KEY (id_produto, data_id, id_entrada_saida) REFERENCES entrada_saida (id_produto, data_id, id_entrada_saida),
        PRIMARY KEY (id_produto, data_id, id_entrada_saida)
      );''');
  }

  void _createTableTotais(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS totais;');
    batch.execute('''
      CREATE TABLE totais (
        id_produto INTEGER,
        data_id_totais INTEGER,
        quantidade_entradas INTEGER,
        quantidade_saidas INTEGER,
        total_entrada REAL,
        total_saidas REAL,
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
        PRIMARY KEY (id_produto, data_id_totais)
      );''');
  }

  void _createTriggerInicializaSaldoV1(Batch batch) {
    batch.execute('DROP TRIGGER IF EXISTS inicializa_saldo;');
    batch.execute('''
      CREATE TRIGGER inicializa_saldo AFTER INSERT ON produto
      BEGIN 
        INSERT INTO saldos (id_produto, quantidade_saldos, custo_unitario_saldos, total_saldos)
        VALUES (NEW.id_produto, 0, 0, 0);
      END;
      ''');
  }

  void _createTriggerAtualizaSaldoCompraV1(Batch batch) {
    batch.execute('DROP TRIGGER IF EXISTS atualiza_saldo_compra;');
    batch.execute('''
      CREATE TRIGGER atualiza_saldo_compra AFTER INSERT ON entrada_saida
        WHEN NEW.id_movimentacao = 1
      BEGIN 
        UPDATE saldos SET quantidade_saldos = (saldos.quantidade_saldos + NEW.quantidade_entrada_saida) WHERE saldos.id_produto = NEW.id_produto;
        UPDATE saldos SET total_saldos = (saldos.total_saldos + NEW.total_entrada_saida) WHERE saldos.id_produto = NEW.id_produto;
        UPDATE saldos SET custo_unitario_saldos = (saldos.total_saldos/saldos.quantidade_saldos) WHERE saldos.id_produto = NEW.id_produto;
      END;
      ''');
  }

  void _createTriggerAtualizaSaldoVendaV1(Batch batch) {
    batch.execute('DROP TRIGGER IF EXISTS atualiza_saldo_venda;');
    batch.execute('''
      CREATE TRIGGER atualiza_saldo_venda AFTER INSERT ON entrada_saida
        WHEN NEW.id_movimentacao = 2
      BEGIN 
        UPDATE saldos SET quantidade_saldos = (saldos.quantidade_saldos - NEW.quantidade_entrada_saida) WHERE saldos.id_produto = NEW.id_produto;
        UPDATE saldos SET total_saldos = (saldos.total_saldos - NEW.total_entrada_saida) WHERE saldos.id_produto = NEW.id_produto;
      END;
      ''');
  }

  void _inicializaTipoMovimentacaoV1(Batch batch) {
    batch.execute(
        'INSERT INTO tipo_movimentacao (id_tipo_movimentacao, nome_tipo_movimentacao) VALUES(1, "compra");');
    batch.execute(
        'INSERT INTO tipo_movimentacao (id_tipo_movimentacao, nome_tipo_movimentacao) VALUES (2, "venda");');
  }
}
