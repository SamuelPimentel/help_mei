import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/produto_categoria.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:sqflite/sqflite.dart';

import '../../../entities/conta.dart';
import '../../../entities/contas_mes.dart';
import '../../../entities/contas_mes_itens.dart';
import '../../../entities/marca.dart';
import '../../../entities/produto.dart';

class CreateTablesCurrent {
  void inicializaTableCategoria(Batch batch) {
    for (var v in CategoriaTable.initialValues) {
      batch.execute(v);
    }
  }

  void createTableCategoria(Batch batch) {
    batch.execute(CategoriaTable.createStringV1);
  }

  void createTableProdutoCategoria(Batch batch) {
    batch.execute(ProdutoCategoriaTable.createsStringV1);
  }

  void createTableTipoConta(Batch batch) {
    batch.execute(TipoContaTable.createStringV1);
  }

  void initializaTipoConta(Batch batch) {
    for (var v in TipoContaTable.initialValues) {
      batch.execute(v);
    }
  }

  void createTableContasMesItensV1(Batch batch) {
    batch.execute(ContaMesItensTable.createStringV1);
  }

  void createTableContaV2(Batch batch) {
    batch.execute(ContaTable.createStringV2);
  }

  void createTableContasMesV1(Batch batch) {
    batch.execute(ContasMesTable.createStringV1);
  }

  void createTableMarcaV1(Batch batch) {
    batch.execute(MarcaTable.createStringV1);
  }

  void createTableProdutoV1(Batch batch) {
    batch.execute(ProdutoTable.createStringV1);
  }

  void createTableTipoMovimentacaoV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS tipo_movimentacao;');
    batch.execute('''
      CREATE TABLE tipo_movimentacao (
        id_tipo_movimentacao INTEGER PRIMARY KEY,
        nome_tipo_movimentacao TEXT UNIQUE NOT NULL
      );''');
  }

  void createTableEntradaSaidaV1(Batch batch) {
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

  void createTableSaldosV1(Batch batch) {
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

  void createTableHistoricoSaldoV1(Batch batch) {
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

  void createTableTotais(Batch batch) {
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

  void createTriggerInicializaSaldoV1(Batch batch) {
    batch.execute('DROP TRIGGER IF EXISTS inicializa_saldo;');
    batch.execute('''
      CREATE TRIGGER inicializa_saldo AFTER INSERT ON produto
      BEGIN 
        INSERT INTO saldos (id_produto, quantidade_saldos, custo_unitario_saldos, total_saldos)
        VALUES (NEW.id_produto, 0, 0, 0);
      END;
      ''');
  }

  void createTriggerAtualizaSaldoCompraV1(Batch batch) {
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

  void createTriggerAtualizaSaldoVendaV1(Batch batch) {
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

  void inicializaTipoMovimentacaoV1(Batch batch) {
    batch.execute(
        'INSERT INTO tipo_movimentacao (id_tipo_movimentacao, nome_tipo_movimentacao) VALUES(1, "compra");');
    batch.execute(
        'INSERT INTO tipo_movimentacao (id_tipo_movimentacao, nome_tipo_movimentacao) VALUES (2, "venda");');
  }
}
