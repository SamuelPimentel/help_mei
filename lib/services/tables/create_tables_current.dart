import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/conta_parcelada.dart';
import 'package:help_mei/entities/entrada_saida.dart';
import 'package:help_mei/entities/forma_pagamento.dart';
import 'package:help_mei/entities/produto_categoria.dart';
import 'package:help_mei/entities/saldos.dart';
import 'package:help_mei/entities/tipo_conta.dart';
import 'package:help_mei/entities/tipo_movimentacao.dart';
import 'package:sqflite/sqflite.dart';

import '../../../entities/conta.dart';
import '../../../entities/contas_mes.dart';
import '../../../entities/contas_mes_itens.dart';
import '../../../entities/marca.dart';
import '../../../entities/produto.dart';

class CreateTablesCurrent {
  void createTableFormaPagamento(Batch batch) {
    batch.execute(FormaPagamentoTable.createString);
  }

  void inicializaTableFormaPagamento(Batch batch) {
    for (var v in FormaPagamentoTable.initialValues) {
      batch.execute(v);
    }
  }

  void createTableContaParcelada(Batch batch) {
    batch.execute(ContaParceladaTable.createStringV1);
  }

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
    batch.execute(TipoMovimentacaoTable.createString);
  }

  void createTableEntradaSaidaV1(Batch batch) {
    batch.execute(EntradaSaidaTable.createString);
  }

  void createTableSaldosV1(Batch batch) {
    batch.execute(SaldosTable.createString);
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

  void createTriggersSaldos(Batch batch) {
    for (var value in SaldosTable.createTriggers) {
      batch.execute(value);
    }
  }

  void inicializaTipoMovimentacaoV1(Batch batch) {
    for (var value in TipoMovimentacaoTable.initialValues) {
      batch.execute(value);
    }
  }
}
