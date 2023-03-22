import 'dart:math';

import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/interfaces/irelationship_multiple.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto_categoria.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class ProdutoTable {
  static const tableName = 'produto';
  static const columnIdProduto = 'id_produto';
  static const columnNomeProduto = 'nome_produto';
  static const columnDescricaoProduto = 'descricao_produto';
  static const imagemProdutoName = 'imagem_produto';
  static const columnIdMarca = 'id_marca';
  static const createStringV1 = '''
      CREATE TABLE $tableName (
        $columnIdProduto ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
        $columnNomeProduto ${SqliteTipos.text} ${SqlitePropriedades.notNull},
        $columnDescricaoProduto ${SqliteTipos.text},
        $imagemProdutoName ${SqliteTipos.text},
        $columnIdMarca ${SqliteTipos.integer}, 
        FOREIGN KEY ($columnIdMarca) REFERENCES ${MarcaTable.tableName} (${MarcaTable.columnIdMarca})
      );''';
  ProdutoTable._();
}

class Produto extends Entity
    implements IForeignKey, IRequestNewPrimaryKey, IRelationshipMultiple {
  int? _idProduto;
  int get idProduto => _idProduto == null ? 0 : _idProduto!;
  set idProduto(int value) {
    _idProduto = value;
  }

  String? _nomeProduto;
  String get nomeProduto => _nomeProduto == null ? '' : _nomeProduto!;
  set nomeProduto(String value) {
    _nomeProduto = value;
  }

  String? _descricaoProduto;
  String get descricaoProduto =>
      _descricaoProduto == null ? '' : _descricaoProduto!;
  set descricaoProduto(String value) {
    _descricaoProduto = value;
  }

  String? imagemProduto;

  int? _idMarca;
  int get idMarca => _idMarca == null ? 0 : _idMarca!;
  set idMarca(int value) {
    _idMarca = value;
  }

  Marca? _marca;
  Marca? get marca => _marca;
  set marca(Marca? value) {
    _marca = value;
    if (value != null) {
      idMarca = value.idMarca;
    }
  }

  final List<ProdutoCategoria> _produtoCategorias = [];

  Produto(
      {required int idProduto,
      required String nomeProduto,
      required String descricaoProduto,
      required this.imagemProduto,
      required int idMarca})
      : _idMarca = idMarca,
        _descricaoProduto = descricaoProduto,
        _nomeProduto = nomeProduto,
        _idProduto = idProduto,
        super(tableName: ProdutoTable.tableName);

  Produto.noPrimaryKey({
    required String nomeProduto,
    required String descricaoProduto,
    required String? imagemProduto,
    required int idMarca,
  }) : this(
          idProduto: nextPrimaryKey(),
          nomeProduto: nomeProduto,
          descricaoProduto: descricaoProduto,
          imagemProduto: imagemProduto,
          idMarca: idMarca,
        );

  Produto.fromMap(Map<dynamic, dynamic> map)
      : this(
          idProduto: map[ProdutoTable.columnIdProduto],
          nomeProduto: map[ProdutoTable.columnNomeProduto],
          descricaoProduto: map[ProdutoTable.columnDescricaoProduto],
          imagemProduto: map[ProdutoTable.imagemProdutoName],
          idMarca: map[ProdutoTable.columnIdMarca],
        );
  Produto.empty()
      : this(
          idProduto: 0,
          idMarca: 0,
          descricaoProduto: '',
          nomeProduto: '',
          imagemProduto: null,
        );
  Produto.queryParameters(
      {int? idProduto,
      String? nomeProduto,
      String? descricaoProduto,
      this.imagemProduto,
      int? idMarca})
      : super(tableName: ProdutoTable.tableName) {
    _idProduto = idProduto;
    _nomeProduto = nomeProduto;
    _descricaoProduto = descricaoProduto;
    _idMarca = idMarca;
  }

  void addCategoria(Categoria categoria) {
    var result = _produtoCategorias
        .where((element) => element.idCategoria == categoria.idCategoria);
    if (result.isEmpty) {
      var prodCat = ProdutoCategoria.noPrimaryKey(
          idProduto: idProduto, idCategoria: categoria.idCategoria);
      prodCat.categoria = categoria;
      _produtoCategorias.add(prodCat);
    }
  }

  void removeCategoria(Categoria categoria) {
    var r = _produtoCategorias.where(
      (element) => element.idCategoria == categoria.idCategoria,
    );
    if (r.isNotEmpty) {
      _produtoCategorias.remove(r.first);
    }
  }

  void addProdutoCategoria(ProdutoCategoria produtoCategoria) {
    _produtoCategorias.add(produtoCategoria);
  }

  List<Categoria> get categorias {
    List<Categoria> categorias = [];
    for (var cat in _produtoCategorias) {
      categorias.add(cat.categoria!);
    }
    return categorias;
  }

  @override
  Entity fromMap(Map map) {
    return Produto.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {
      ProdutoTable.columnIdProduto: idProduto.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys[ProdutoTable.columnIdProduto];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idProduto = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ProdutoTable.columnIdProduto: idProduto,
      ProdutoTable.columnNomeProduto: nomeProduto,
      ProdutoTable.columnDescricaoProduto: descricaoProduto,
      ProdutoTable.imagemProdutoName: imagemProduto,
      ProdutoTable.columnIdMarca: idMarca,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Marca.empty(),
        keys: {MarcaTable.columnIdMarca: idMarca},
      ),
    );
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    marca = values[MarcaTable.tableName];
  }

  @override
  bool operator ==(other) {
    if (other is! Produto) {
      return false;
    }
    return idProduto == other.idProduto &&
        nomeProduto == other.nomeProduto &&
        descricaoProduto == other.descricaoProduto &&
        imagemProduto == other.imagemProduto &&
        idMarca == other.idMarca;
  }

  @override
  int get hashCode {
    return idProduto.hashCode +
        nomeProduto.hashCode +
        descricaoProduto.hashCode +
        imagemProduto.hashCode +
        idMarca.hashCode;
  }

  @override
  void addRelationshipValues(Map<String, List<Entity>> values) {
    for (var val in values[ProdutoCategoriaTable.tableName]!) {
      addProdutoCategoria(val as ProdutoCategoria);
    }
  }

  @override
  Map<String, List<Entity>> insertValues() {
    return {ProdutoCategoriaTable.tableName: _produtoCategorias};
  }

  @override
  Map<Entity, Map<String, String>> relationshipSearchCondition() {
    Map<Entity, Map<String, String>> map = {};
    map[ProdutoCategoria.empty()] = {
      ProdutoCategoriaTable.columnIdProduto: idProduto.toString()
    };
    return map;
  }
}
