import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/helpers/constantes.dart';

class ProdutoTable {
  static const tableName = 'produto';
  static const idProdutoName = 'id_produto';
  static const nomeProdutoName = 'nome_produto';
  static const descricaoProdutoName = 'descricao_produto';
  static const imagemProdutoName = 'imagem_produto';
  static const idMarcaName = 'id_marca';
  static const createStringV1 = '''
      CREATE TABLE $tableName (
        $idProdutoName INTEGER PRIMARY KEY,
        $nomeProdutoName TEXT NOT NULL,
        $descricaoProdutoName TEXT,
        $imagemProdutoName TEXT,
        $idMarcaName INTEGER, 
        FOREIGN KEY ($idMarcaName) REFERENCES ${MarcaTable.tableName} (${MarcaTable.idMarcaName})
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
  Produto.fromMap(Map<dynamic, dynamic> map)
      : this(
          idProduto: map[ProdutoTable.idProdutoName],
          nomeProduto: map[ProdutoTable.nomeProdutoName],
          descricaoProduto: map[ProdutoTable.descricaoProdutoName],
          imagemProduto: map[ProdutoTable.imagemProdutoName],
          idMarca: map[ProdutoTable.idMarcaName],
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
      ProdutoTable.idProdutoName: idProduto.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys[ProdutoTable.idProdutoName];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idProduto = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ProdutoTable.idProdutoName: idProduto,
      ProdutoTable.nomeProdutoName: nomeProduto,
      ProdutoTable.descricaoProdutoName: descricaoProduto,
      ProdutoTable.imagemProdutoName: imagemProduto,
      ProdutoTable.idMarcaName: idMarca,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Marca.empty(),
        keys: {MarcaTable.idMarcaName: idMarca},
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
