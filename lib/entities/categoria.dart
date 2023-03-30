import 'dart:io';
import 'dart:math';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class CategoriaTable {
  static const tableName = 'categoria';
  static const columnIdCategoria = 'id_categoria';
  static const columnNomeCategoria = 'nome_categoria';
  static const columnImageName = 'imagem_categoria';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdCategoria ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeCategoria ${SqliteTipos.text} ${SqlitePropriedades.unique},
      $columnImageName ${SqliteTipos.text}
    );''';

  static const List<String> initialValues = [
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (1,"Alimentos básicos", "assets/images/categories/alimentos_basicos.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (2,"Bebidas", "assets/images/categories/bebidas2.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (3,"Limpeza", "assets/images/categories/limpeza.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (4,"Leites e iogurtes", "assets/images/categories/leites_iogurtes.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (5,"Biscoitos e salgadinhos", "assets/images/categories/salgadinhos-com-salgadinhos-biscoitos-e-salgadinhos.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (6,"Frios e laticinios", "assets/images/categories/istockphoto-1160975818-612x612.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (7,"Molhos, condimentos e conservas", "assets/images/categories/legumes-em-conserva-1569611018813_v2_1881x1594.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (8,"Higiene e cuidados pessoais", "assets/images/categories/content_higiene-pessoal-kalinkainv.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (9,"Padaria e matinais", "assets/images/categories/paes2.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (10,"Carnes, aves e peixes", "assets/images/categories/meat-and-poultry.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (11,"Congelados e resfriados", "assets/images/categories/pack-de-produtos.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (12,"Legumes e vegetais", "assets/images/categories/frutas-e-verduras-de-janeiro-capa.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (13,"Utensilios para o lar", "assets/images/categories/sistema-loja-utilidades-e-presentes-compressed.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (14,"Bebidas alcoólicas", "assets/images/categories/BEBIDAS ALCOÓLICAS, TIPOS DE BEBIDAS ALCOÓLICAS.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (15,"Pet-shop", "assets/images/categories/DESCUBRA-OS-MELHORES-PRODUTOS-1024x853.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (16,"Suplementos e vitaminas", "assets/images/categories/suplementos.png");',
    //'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategor, $columnImageNameia) VALUES (17,"Bazar e utilidades");',
    //'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategor, $columnImageNameia) VALUES (18,"Suplementos e vitaminas");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (19,"Bazar e utilidades", "assets/images/categories/Utensilios-de-cozinha.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (20,"Vestuaário", "assets/images/categories/roupas-femininas-na-cor-rosa-pastel-em-cabide-em-fundo-branco-guarda-roupa-domestico-de-limpeza-de-primavera-conceito-de-moda-minimo_479776-4623.png");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (21,"Brinquedos", "assets/images/categories/brinquedos.jpg");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName) VALUES (22,"Outros", "assets/images/categories/random_objetos.png");',
  ];
  CategoriaTable._();
}

class Categoria extends Entity implements IRequestNewPrimaryKey {
  int idCategoria;
  String nomeCategoria;
  File? imageFile;
  String? imageName;

  Categoria({
    required this.idCategoria,
    required this.nomeCategoria,
    required this.imageName,
  }) : super(tableName: CategoriaTable.tableName);

  Categoria.noPrimaryKey({
    required String nomeCategoria,
    required String imageName,
  }) : this(
          idCategoria: nextPrimaryKey(),
          nomeCategoria: nomeCategoria,
          imageName: imageName,
        );

  Categoria.fromMap(Map map)
      : this(
          idCategoria: map[CategoriaTable.columnIdCategoria],
          nomeCategoria: map[CategoriaTable.columnNomeCategoria],
          imageName: map[CategoriaTable.columnImageName],
        );

  Categoria.empty()
      : this(
          idCategoria: 0,
          nomeCategoria: '',
          imageName: null,
        );

  @override
  Entity fromMap(Map map) {
    return Categoria.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {CategoriaTable.columnIdCategoria: idCategoria.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idCategoria = keys[CategoriaTable.columnIdCategoria];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      CategoriaTable.columnIdCategoria: idCategoria,
      CategoriaTable.columnNomeCategoria: nomeCategoria,
      CategoriaTable.columnImageName: imageName,
    };
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idCategoria = rnd.nextInt(maxInt32);
  }

  @override
  bool operator ==(other) {
    if (other is! Categoria) {
      return false;
    }

    return idCategoria == other.idCategoria &&
        nomeCategoria == other.nomeCategoria;
  }

  @override
  int get hashCode {
    return idCategoria.hashCode + nomeCategoria.hashCode;
  }
}
