import 'package:flutter_test/flutter_test.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/services/sqite_service_in_memory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();
  test('produto categoria ...', () async {
    EntityControllerGeneric controller =
        EntityControllerGeneric(service: SqliteServiceInMemory());

    Categoria bombom = Categoria.noPrimaryKey(nomeCategoria: 'Bombom');
    await controller.insertEntity(bombom);

    Categoria doce = Categoria.noPrimaryKey(nomeCategoria: 'Doce');
    await controller.insertEntity(doce);

    Categoria chocolate = Categoria.noPrimaryKey(nomeCategoria: 'Chocolate');
    await controller.insertEntity(chocolate);

    Categoria chocolateBranco =
        Categoria.noPrimaryKey(nomeCategoria: 'Chocolate Branco');
    await controller.insertEntity(chocolateBranco);

    Marca marca = Marca.noPrimaryKey(nomeMarca: 'Lacta');
    await controller.insertEntity(marca);

    Produto produto = Produto.noPrimaryKey(
      nomeProduto: 'Ouro Branco',
      descricaoProduto: 'Bombom Ouro Branco',
      imagemProduto: null,
      idMarca: marca.idMarca,
    );
    produto.marca = marca;
    produto.addCategoria(bombom);
    produto.addCategoria(doce);
    produto.addCategoria(chocolate);

    await controller.insertEntity(produto);

    var res = await controller.getEntity(produto);
    String p =
        '${(res as Produto).nomeProduto} ${res.marca!.nomeMarca}, categorias: ';
    for (var cat in res.categorias) {
      p = '$p ${cat.nomeCategoria}';
    }
    print(p);

    Categoria salgado = Categoria.noPrimaryKey(nomeCategoria: 'Salgado');
    await controller.insertEntity(salgado);

    produto.addCategoria(salgado);
    await controller.updateEntity(produto);

    res = await controller.getEntity(produto);
    p = '${(res as Produto).nomeProduto} ${res.marca!.nomeMarca}, categorias: ';
    for (var cat in res.categorias) {
      p = '$p ${cat.nomeCategoria}';
    }
    print(p);

    produto.removeCategoria(salgado);
    await controller.updateEntity(produto);

    res = await controller.getEntity(produto);
    p = '${(res as Produto).nomeProduto} ${res.marca!.nomeMarca}, categorias: ';
    for (var cat in res.categorias) {
      p = '$p ${cat.nomeCategoria}';
    }
    print(p);
  });
}
