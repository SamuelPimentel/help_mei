import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/entities/marca.dart';
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

class Produto extends Entity implements IForeignKey, IRequestNewPrimaryKey {
  int idProduto;
  String nomeProduto;
  String descricaoProduto;
  String? imagemProduto;
  int idMarca;
  Marca? _marca;

  Marca? get marca => _marca;

  set marca(Marca? value) {
    _marca = value;
    if (value != null) {
      idMarca = value.idMarca;
    }
  }

  Produto(
      {required this.idProduto,
      required this.nomeProduto,
      required this.descricaoProduto,
      required this.imagemProduto,
      required this.idMarca})
      : super(tableName: ProdutoTable.tableName);

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
}
