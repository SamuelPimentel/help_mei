import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/marca.dart';

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

class Produto extends Entity implements IForeignKey {
  int idProduto;
  String nomeProduto;
  String descricaoProduto;
  String? imagemProduto;
  int idMarca;
  Marca? marca;

  Produto(
      {required this.idProduto,
      required this.nomeProduto,
      required this.descricaoProduto,
      required this.imagemProduto,
      required this.idMarca})
      : super(tableName: ProdutoTable.tableName);
  Produto.fromMap(Map<dynamic, dynamic> map)
      : this(
          idProduto: map['id_produto'],
          nomeProduto: map['nome_produto'],
          descricaoProduto: map['descricao_produto'],
          imagemProduto: map['imagem_produto'],
          idMarca: map['id_marca'],
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
      'id_produto': idProduto.toString(),
    };
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys['id_produto'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_produto': idProduto,
      'nome_produto': nomeProduto,
      'descricao_produto': descricaoProduto,
      'imagem_produto': imagemProduto,
      'id_marca': idMarca,
    };
  }

  @override
  List<ForeignKey> getForeignKeys() {
    List<ForeignKey> foreignKeys = [];
    foreignKeys.add(
      ForeignKey(
        tableEntity: Marca.empty(),
        keys: {'id_marca': idMarca},
      ),
    );
    return foreignKeys;
  }

  @override
  void insertForeignValues(Map<String, dynamic> values) {
    marca = values['marca'];
  }
}
