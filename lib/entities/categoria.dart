import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';

class CategoriaTable {
  static const tableName = 'categoria';
  static const columnIdCategoria = 'id_categoria';
  static const columnNomeCategoria = 'nome_categoria';
  static const columnImageName = 'imagem_categoria';
  static const colmunColorCategoria = 'cor_categoria';
  static const columnActive = 'active_categoria';

  static const createStringV1 = '''
    CREATE TABLE $tableName (
      $columnIdCategoria ${SqliteTipos.integer} ${SqlitePropriedades.primaryKey},
      $columnNomeCategoria ${SqliteTipos.text} ${SqlitePropriedades.unique},
      $columnImageName ${SqliteTipos.text},
      $colmunColorCategoria ${SqliteTipos.integer},
      $columnActive ${SqliteTipos.integer} ${SqlitePropriedades.notNull}
    );''';

  static List<String> initialValues = [
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (1,"Alimentos básicos", "assets/images/categories/alimentos_basicos.jpg", ${Colors.amber.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (2,"Bebidas", "assets/images/categories/bebidas2.jpg", ${Colors.green.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (3,"Limpeza", "assets/images/categories/limpeza.jpg", ${Colors.cyan.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (4,"Leites e iogurtes", "assets/images/categories/leites_iogurtes.png", ${Colors.white54.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (5,"Biscoitos e salgadinhos", "assets/images/categories/salgadinhos-com-salgadinhos-biscoitos-e-salgadinhos.png", ${Colors.yellow.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (6,"Frios e laticinios", "assets/images/categories/istockphoto-1160975818-612x612.jpg", ${Colors.amber.shade500.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (7,"Molhos, condimentos e conservas", "assets/images/categories/legumes-em-conserva-1569611018813_v2_1881x1594.jpg", ${Colors.red.shade400.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (8,"Higiene e cuidados pessoais", "assets/images/categories/content_higiene-pessoal-kalinkainv.png", ${Colors.blue.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (9,"Padaria e matinais", "assets/images/categories/paes2.jpg", "${Colors.amber.shade600.value}", 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (10,"Carnes, aves e peixes", "assets/images/categories/meat-and-poultry.jpg", ${Colors.red.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (11,"Congelados e resfriados", "assets/images/categories/pack-de-produtos.png", ${Colors.blue.shade400.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (12,"Legumes e vegetais", "assets/images/categories/frutas-e-verduras-de-janeiro-capa.png", ${Colors.green.shade600.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (13,"Utensilios para o lar", "assets/images/categories/sistema-loja-utilidades-e-presentes-compressed.jpg", ${Colors.indigo.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (14,"Bebidas alcoólicas", "assets/images/categories/BEBIDAS ALCOÓLICAS, TIPOS DE BEBIDAS ALCOÓLICAS.jpg", ${Colors.brown.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (15,"Pet-shop", "assets/images/categories/DESCUBRA-OS-MELHORES-PRODUTOS-1024x853.png", ${Colors.brown.shade400.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (16,"Suplementos e vitaminas", "assets/images/categories/suplementos.png", ${Colors.orange.shade700.value}, 1);',
    //'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategor, $columnImageName, $colmunColorCategoria, $columnActiveia) VALUES (17,"Bazar e utilidades");',
    //'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategor, $columnImageName, $colmunColorCategoria, $columnActiveia) VALUES (18,"Suplementos e vitaminas");',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (19,"Bazar e utilidades", "assets/images/categories/Utensilios-de-cozinha.png", ${Colors.lime.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (20,"Vestuaário", "assets/images/categories/roupas-femininas-na-cor-rosa-pastel-em-cabide-em-fundo-branco-guarda-roupa-domestico-de-limpeza-de-primavera-conceito-de-moda-minimo_479776-4623.png", ${Colors.pink.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (21,"Brinquedos", "assets/images/categories/brinquedos.jpg", ${Colors.purple.shade100.value}, 1);',
    'INSERT INTO $tableName($columnIdCategoria, $columnNomeCategoria, $columnImageName, $colmunColorCategoria, $columnActive) VALUES (22,"Outros", "assets/images/categories/random_objetos.png", ${Colors.black26.value}, 1);',
  ];
  CategoriaTable._();
}

class Categoria extends Entity implements IRequestNewPrimaryKey {
  int idCategoria;
  String nomeCategoria;
  File? imageFile;
  String? imageName;
  Color? colorCategoria;
  bool isActive;

  Categoria(
      {required this.idCategoria,
      required this.nomeCategoria,
      this.imageName,
      this.colorCategoria,
      required this.isActive})
      : super(tableName: CategoriaTable.tableName);

  Categoria.noPrimaryKey({
    required String nomeCategoria,
    String? imageName,
    Color? color,
  }) : this(
          idCategoria: nextPrimaryKey(),
          nomeCategoria: nomeCategoria,
          imageName: imageName,
          colorCategoria: color,
          isActive: true,
        );

  Categoria.fromMap(Map map)
      : this(
          idCategoria: map[CategoriaTable.columnIdCategoria],
          nomeCategoria: map[CategoriaTable.columnNomeCategoria],
          imageName: map[CategoriaTable.columnImageName],
          colorCategoria: Color(map[CategoriaTable.colmunColorCategoria]),
          isActive: map[CategoriaTable.columnActive] == 1 ? true : false,
        );

  Categoria.empty()
      : this(
          idCategoria: 0,
          nomeCategoria: '',
          imageName: null,
          colorCategoria: null,
          isActive: false,
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
      CategoriaTable.colmunColorCategoria: colorCategoria,
      CategoriaTable.columnActive: isActive ? 1 : 0,
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
