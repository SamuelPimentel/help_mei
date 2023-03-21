import 'dart:math';

import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/entities/interfaces/isearch_simple.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class ProdutoCategoriaTable {
  static const tableName = 'produto_categoria';
  static const columnIdProduto = 'id_produto';
  static const columnIdProdutoCategoria = 'id_produto_categoria';
  static const columnIdCategoria = 'id_categoria';

  static const createsStringV1 = '''
    CREATE TABLE $tableName(
      $columnIdProduto ${SqliteTipos.integer},
      $columnIdProdutoCategoria ${SqliteTipos.integer},
      $columnIdCategoria ${SqliteTipos.integer},
      ${SqlitePropriedades.primaryKey}($columnIdCategoria, $columnIdProdutoCategoria, $columnIdProduto),
      FOREIGN KEY($columnIdProduto) REFERENCES ${ProdutoTable.tableName} (${ProdutoTable.columnIdProduto}),
      FOREIGN KEY($columnIdCategoria) REFERENCES ${CategoriaTable.tableName} (${CategoriaTable.columnIdCategoria})

    );
''';

  ProdutoCategoriaTable._();
}

class ProdutoCategoria extends Entity
    implements IRequestNewPrimaryKey, ISearchSimple, IForeignKey {
  int? _idProdutoCategoria;
  int get idProdutoCategoria =>
      _idProdutoCategoria == null ? 0 : _idProdutoCategoria!;
  set idProdutoCategoria(int value) {
    _idProdutoCategoria = value;
  }

  int? _idCategoria;
  int get idCategoria => _idCategoria == null ? 0 : _idCategoria!;
  set idCategoria(int value) {
    _idCategoria = value;
  }

  int? _idProduto;
  int get idProduto => _idProduto == null ? 0 : _idProduto!;
  set idProduto(int value) {
    _idProduto = value;
  }

  Categoria? _categoria;
  Categoria? get categoria => _categoria;
  set categoria(Categoria? value) {
    if (value != null) {
      idCategoria = value.idCategoria;
    }
    _categoria = value;
  }

  ProdutoCategoria(
      {required int idProdutoCategoria,
      required int idCategoria,
      required int idProduto})
      : _idProduto = idProduto,
        _idCategoria = idCategoria,
        _idProdutoCategoria = idProdutoCategoria,
        super(tableName: ProdutoCategoriaTable.tableName);

  ProdutoCategoria.fromMap(Map map)
      : this(
            idProdutoCategoria:
                map[ProdutoCategoriaTable.columnIdProdutoCategoria],
            idProduto: map[ProdutoCategoriaTable.columnIdProduto],
            idCategoria: map[ProdutoCategoriaTable.columnIdCategoria]);

  ProdutoCategoria.noPrimaryKey(
      {required int idProduto, required int idCategoria})
      : this(
            idCategoria: idCategoria,
            idProduto: idProduto,
            idProdutoCategoria: nextPrimaryKey());

  ProdutoCategoria.empty()
      : this(idCategoria: 0, idProdutoCategoria: 0, idProduto: 0);

  ProdutoCategoria.queryParameters({
    int? idProdutoCategoria,
    int? idCategoria,
    int? idProduto,
  }) : super(tableName: ProdutoCategoriaTable.tableName) {
    _idProdutoCategoria = idProdutoCategoria;
    _idProduto = idProduto;
    _idCategoria = idCategoria;
  }

  @override
  Entity fromMap(Map map) {
    return ProdutoCategoria.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ProdutoCategoriaTable.columnIdCategoria: idCategoria.toString(),
      ProdutoCategoriaTable.columnIdProduto: idProduto.toString(),
      ProdutoCategoriaTable.columnIdProdutoCategoria:
          idProdutoCategoria.toString()
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProdutoCategoria = keys[ProdutoCategoriaTable.columnIdProdutoCategoria];
    idCategoria = keys[ProdutoCategoriaTable.columnIdCategoria];
    idProduto = keys[ProdutoCategoriaTable.columnIdProduto];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ProdutoCategoriaTable.columnIdProdutoCategoria: idProdutoCategoria,
      ProdutoCategoriaTable.columnIdCategoria: idCategoria,
      ProdutoCategoriaTable.columnIdProduto: idProduto,
    };
  }

  @override
  bool operator ==(other) {
    if (other is! ProdutoCategoria) {
      return false;
    }

    return idCategoria == other.idCategoria &&
        idProdutoCategoria == other.idProdutoCategoria &&
        idProduto == other.idProduto;
  }

  @override
  int get hashCode {
    return idCategoria.hashCode +
        idProdutoCategoria.hashCode +
        idProduto.hashCode;
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idProdutoCategoria = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, String> parameters() {
    Map<String, String> parameters = {};
    if (_idProdutoCategoria != null) {
      parameters[ProdutoCategoriaTable.columnIdProdutoCategoria] =
          idProdutoCategoria.toString();
    }
    if (_idCategoria != null) {
      parameters[ProdutoCategoriaTable.columnIdCategoria] =
          idCategoria.toString();
    }
    if (_idProduto != null) {
      parameters[ProdutoCategoriaTable.columnIdProduto] = idProduto.toString();
    }
    return parameters;
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Categoria.empty(),
        keys: {CategoriaTable.columnIdCategoria: idCategoria},
      ),
    );
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    categoria = values[CategoriaTable.tableName];
  }
}
