import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class ContaParceladaTable {
  static const tableName = 'conta_parcelada';
  static const columnIdContaParcelada = 'id_conta_parcelada';
  static const columnDescicaoContaParcelada = 'descricao_conta_parcelada';
  static const columnNumeroParcelas = 'numero_parcelas';
  static const columnDataPrimeiraParcela = 'data_primeira_parcela';
  static const columnValorTotal = 'valor_total';
  static const columnValorOriginal = 'valor_original';
  static const columnValorJuros = 'valor_juros';
  static const columnAtiva = 'ativa_conta_parcelada';

  static const createStringV1 = '''
    CREATE TABLE $tableName(
      $columnIdContaParcelada ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnDescicaoContaParcelada ${SqliteTipos.text} ${SqlitePropriedades.notNull},
      $columnNumeroParcelas ${SqliteTipos.integer} ${SqlitePropriedades.notNull},
      $columnDataPrimeiraParcela ${SqliteTipos.text} ${SqlitePropriedades.notNull},
      $columnValorTotal ${SqliteTipos.real} ${SqlitePropriedades.notNull},
      $columnValorOriginal ${SqliteTipos.real},
      $columnValorJuros ${SqliteTipos.real},
      $columnAtiva ${SqliteTipos.integer}
    )
  ''';

  ContaParceladaTable._();
}

class ContaParcelada extends Entity {
  int idContaParcelada;
  String descricaoContaParcelada;
  int numeroParcelas;
  DateTime dataPrimeiraParcela;
  double valorTotal;
  double? valorOriginal;
  double? valorJuros;
  bool ativa;

  ContaParcelada({
    required this.idContaParcelada,
    required this.descricaoContaParcelada,
    required this.numeroParcelas,
    required this.dataPrimeiraParcela,
    required this.valorTotal,
    required this.ativa,
    this.valorOriginal,
    this.valorJuros,
  }) : super(tableName: ContaParceladaTable.tableName);

  ContaParcelada.noPrimaryKey({
    required String descricaoConta,
    required int numeroParcelas,
    required DateTime dataPrimeiraParcela,
    required double valorTotal,
    double? valorOriginal,
    double? valorJuros,
  }) : this(
          idContaParcelada: nextPrimaryKey(),
          descricaoContaParcelada: descricaoConta,
          numeroParcelas: numeroParcelas,
          dataPrimeiraParcela: dataPrimeiraParcela,
          valorTotal: valorTotal,
          valorOriginal: valorOriginal,
          valorJuros: valorJuros,
          ativa: true,
        );

  ContaParcelada.fromMap(Map map)
      : this(
          idContaParcelada: map[ContaParceladaTable.columnIdContaParcelada],
          descricaoContaParcelada:
              map[ContaParceladaTable.columnDescicaoContaParcelada],
          numeroParcelas: map[ContaParceladaTable.columnNumeroParcelas],
          dataPrimeiraParcela: DateTime.parse(
              map[ContaParceladaTable.columnDataPrimeiraParcela]),
          valorTotal: map[ContaParceladaTable.columnValorTotal],
          valorOriginal: map[ContaParceladaTable.columnValorOriginal],
          valorJuros: map[ContaParceladaTable.columnValorJuros],
          ativa: map[ContaParceladaTable.columnAtiva] == 1 ? true : false,
        );
  ContaParcelada.empty()
      : this(
          idContaParcelada: 0,
          dataPrimeiraParcela: DateTime.now(),
          descricaoContaParcelada: '',
          numeroParcelas: 0,
          valorTotal: 0,
          ativa: true,
        );

  @override
  Entity fromMap(Map map) {
    return ContaParcelada.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ContaParceladaTable.columnIdContaParcelada: idContaParcelada.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idContaParcelada = keys[ContaParceladaTable.columnIdContaParcelada];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ContaParceladaTable.columnIdContaParcelada: idContaParcelada,
      ContaParceladaTable.columnDescicaoContaParcelada: descricaoContaParcelada,
      ContaParceladaTable.columnNumeroParcelas: numeroParcelas,
      ContaParceladaTable.columnDataPrimeiraParcela:
          dataPrimeiraParcela.toIso8601String(),
      ContaParceladaTable.columnValorTotal: valorTotal,
      ContaParceladaTable.columnValorOriginal: valorOriginal,
      ContaParceladaTable.columnValorJuros: valorJuros,
      ContaParceladaTable.columnAtiva: ativa ? 1 : 0,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! ContaParcelada) {
      return false;
    }
    return other.idContaParcelada == idContaParcelada &&
        other.descricaoContaParcelada == descricaoContaParcelada &&
        other.dataPrimeiraParcela == dataPrimeiraParcela &&
        other.valorTotal == valorTotal &&
        other.numeroParcelas == numeroParcelas &&
        other.valorOriginal == valorOriginal &&
        other.valorJuros == valorJuros &&
        other.ativa == ativa;
  }

  @override
  int get hashCode =>
      idContaParcelada.hashCode +
      descricaoContaParcelada.hashCode +
      dataPrimeiraParcela.hashCode +
      numeroParcelas.hashCode +
      valorTotal.hashCode +
      valorOriginal.hashCode +
      valorJuros.hashCode +
      ativa.hashCode;
}
